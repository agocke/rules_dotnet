"""
Rule for producing a NativeAOT-compiled native executable from a C# binary.

This implements the full ILC → native link pipeline:
1. Run ILC to compile IL assemblies into a native object file
2. Link the object file with the NativeAOT runtime static libraries
   to produce a native executable
"""

load("//dotnet/private:providers.bzl", "DotnetAssemblyRuntimeInfo", "DotnetBinaryInfo", "DotnetNativeAotPackInfo")
load("//dotnet/private/transitions:tfm_transition.bzl", "tfm_transition")

def _get_target_os(ctx):
    """Determine the target OS string for ILC."""
    if ctx.target_platform_has_constraint(ctx.attr._linux_constraint[platform_common.ConstraintValueInfo]):
        return "linux"
    elif ctx.target_platform_has_constraint(ctx.attr._macos_constraint[platform_common.ConstraintValueInfo]):
        return "osx"
    elif ctx.target_platform_has_constraint(ctx.attr._windows_constraint[platform_common.ConstraintValueInfo]):
        return "windows"
    else:
        fail("Unsupported target OS for NativeAOT compilation")

def _get_target_arch(ctx):
    """Determine the target architecture string for ILC."""
    if ctx.target_platform_has_constraint(ctx.attr._x86_64_constraint[platform_common.ConstraintValueInfo]):
        return "x64"
    elif ctx.target_platform_has_constraint(ctx.attr._arm64_constraint[platform_common.ConstraintValueInfo]):
        return "arm64"
    elif ctx.target_platform_has_constraint(ctx.attr._x86_constraint[platform_common.ConstraintValueInfo]):
        return "x86"
    else:
        fail("Unsupported target architecture for NativeAOT compilation")

def _add_unix_link_args(link_args, obj_file, output_exe, nativeaot_pack, target_os, target_arch, ctx, additional_linker_inputs):
    """Build linker arguments for Unix platforms (Linux and macOS).

    Mirrors: Microsoft.NETCore.Native.Unix.targets SetupOSSpecificProps + LinkNative.

    The ordering of arguments matters — Unix linkers do a single pass to resolve
    symbols, so dependents must come before dependencies:
      1. The compiled object file
      2. Managed native shim static libraries (System.Native, etc.)
      3. NativeAOT runtime static libraries (bootstrapper, GC, eventpipe, etc.)
      4. System libraries (-l flags)
    The nativeaot_pack.runtime_libs must be ordered accordingly by the pack provider.
    """
    is_apple = (target_os == "osx")

    # LinkNative target: CustomLinkerArg += obj_file, -o output
    link_args.add(obj_file)
    link_args.add("-o", output_exe)

    # LinkNative target: -Wl,-dead_strip (Apple) or --discard-all/--gc-sections (Linux)
    if is_apple:
        link_args.add("-Wl,-dead_strip")
    else:
        link_args.add("-Wl,--discard-all")
        link_args.add("-Wl,--gc-sections")

    # NativeLibrary items: runtime_libs from the pack (order matters)
    # Includes: managed native shims (System.Native.a, etc.), bootstrapper,
    # Runtime.WorkstationGC, eventpipe, stdc++compat, etc.
    # Wrap in --start-group/--end-group to handle circular dependencies
    # between archives (the NativeAOT runtime has internal cross-references).
    if not is_apple:
        link_args.add("-Wl,--start-group")
    for lib in nativeaot_pack.runtime_libs:
        link_args.add(lib)
    if not is_apple:
        link_args.add("-Wl,--end-group")

    # LinkerArg: -fuse-ld=$(LinkerFlavor)
    # MSBuild defaults: lld for freebsd/bionic, bfd for linux.
    # Default to lld since we use clang which works best with its own linker.
    linker_flavor = ctx.attr.linker_flavor if ctx.attr.linker_flavor else "lld"
    link_args.add("-fuse-ld=" + linker_flavor)

    # MSBuild: write sections.ld linker script for lld (13+) to retain __modules section.
    # Without this, --gc-sections removes the __modules section that bootstrapper.o
    # uses to find managed modules at startup via __start___modules/__stop___modules.
    if not is_apple and linker_flavor == "lld":
        sections_ld = ctx.actions.declare_file(ctx.label.name + ".sections.ld")
        ctx.actions.write(sections_ld, "OVERWRITE_SECTIONS { __modules : { KEEP(*(__modules)) } }\n")
        link_args.add("-T", sections_ld)
        additional_linker_inputs.append(sections_ld)

    # LinkerArg: -gz=zlib (CompressSymbols, default true)
    if ctx.attr.compress_symbols:
        link_args.add("-gz=zlib")

    # LinkerArg: -g / --strip-debug
    if ctx.attr.debug_symbols:
        link_args.add("-g")
    elif not is_apple:
        link_args.add("-Wl,--strip-debug")

    # LinkerArg: --build-id=sha1 (Linux only)
    if not is_apple:
        link_args.add("-Wl,--build-id=sha1")

    # LinkerArg: --as-needed (Linux only)
    if not is_apple:
        link_args.add("-Wl,--as-needed")

    # LinkerArg: -pthread (Linux only)
    if not is_apple:
        link_args.add("-pthread")

    #
    # NativeSystemLibrary items — mirrors the <NativeSystemLibrary> ItemGroup
    # in Microsoft.NETCore.Native.Unix.targets, line by line.
    #

    # <NativeSystemLibrary Include="stdc++" Condition="LinkStandardCPlusPlusLibrary" />
    # MSBuild: true when iOS-like + !InvariantGlobalization
    if ctx.attr.link_standard_cplusplus:
        link_args.add("-lstdc++")

    # <NativeSystemLibrary Include="dl" />
    link_args.add("-ldl")

    # <NativeSystemLibrary Include="objc" Condition="Apple" />
    if is_apple:
        link_args.add("-lobjc")

    # <NativeSystemLibrary Include="swiftCore" Condition="Apple" />
    # <NativeSystemLibrary Include="swiftFoundation" Condition="Apple" />
    if is_apple:
        link_args.add("-lswiftCore")
        link_args.add("-lswiftFoundation")

    # <NativeSystemLibrary Include="z" Condition="UseSystemZlib" />
    if ctx.attr.use_system_zlib:
        link_args.add("-lz")

    # <NativeSystemLibrary Include="brotlienc;brotlidec;brotlicommon" Condition="UseSystemBrotli" />
    if ctx.attr.use_system_brotli:
        link_args.add("-lbrotlienc")
        link_args.add("-lbrotlidec")
        link_args.add("-lbrotlicommon")

    # <NativeSystemLibrary Include="zstd" Condition="UseSystemZstd" />
    if ctx.attr.use_system_zstd:
        link_args.add("-lzstd")

    # <NativeSystemLibrary Include="rt" Condition="!Apple and !bionic" />
    if not is_apple:
        link_args.add("-lrt")

    # <NativeSystemLibrary Include="icucore" Condition="Apple" />
    # Only when not using invariant globalization
    if is_apple and not ctx.attr.invariant_globalization:
        link_args.add("-licucore")

    # <NativeSystemLibrary Include="m" />
    link_args.add("-lm")

    # -L/usr/lib/swift (Apple)
    if is_apple:
        link_args.add("-L/usr/lib/swift")

    # -lssl -lcrypto: OpenSSL — when dynamically linked (non-Apple).
    # MSBuild condition: exists nonportable.txt && !StaticOpenSslLinking
    if not is_apple and not ctx.attr.static_openssl_linking:
        link_args.add("-lssl")
        link_args.add("-lcrypto")

    #
    # StaticICULibs — when StaticICULinking is enabled
    # MSBuild: -Wl,-Bstatic -licuio -licutu -licui18n -licuuc -licudata -lstdc++ -Wl,-Bdynamic
    #
    if ctx.attr.static_icu_linking and not ctx.attr.invariant_globalization:
        link_args.add("-Wl,-Bstatic")
        link_args.add_all(["-licuio", "-licutu", "-licui18n", "-licuuc", "-licudata", "-lstdc++"])
        link_args.add("-Wl,-Bdynamic")

    #
    # StaticSslLibs — when StaticOpenSslLinking is enabled
    # MSBuild: -Wl,-Bstatic -lssl -lcrypto -Wl,-Bdynamic
    #
    if not is_apple and ctx.attr.static_openssl_linking:
        link_args.add("-Wl,-Bstatic")
        link_args.add_all(["-lssl", "-lcrypto"])
        link_args.add("-Wl,-Bdynamic")

    #
    # NativeFramework items (Apple only)
    # Mirrors: <NativeFramework Include="CoreFoundation|CryptoKit|Foundation|Network|Security|GSS" />
    #
    if is_apple:
        link_args.add_all([
            "-framework", "CoreFoundation",
            "-framework", "CryptoKit",
            "-framework", "Foundation",
            "-framework", "Network",
            "-framework", "Security",
            "-framework", "GSS",
        ])

    #
    # PIE / RELRO / BIND_NOW flags (Linux only)
    # binskim warnings BA3001/BA3010/BA3011
    #
    if not is_apple:
        # PIE (position-independent executable) — default for executables
        link_args.add("-pie")
        link_args.add("-Wl,-pie")
        # GNU_RELRO
        link_args.add("-Wl,-z,relro")
        # BIND_NOW
        link_args.add("-Wl,-z,now")
        # No-exec stack
        link_args.add("-Wl,-z,noexecstack")
        # EH frame header
        link_args.add("-Wl,--eh-frame-hdr")

    # Stack size
    if ctx.attr.stack_size:
        if not is_apple:
            link_args.add("-Wl,-z,stack-size=%d" % ctx.attr.stack_size)

def _add_windows_link_args(link_args, obj_file, output_exe, nativeaot_pack, target_arch, ctx):
    """Build linker arguments for Windows (MSVC link.exe).

    Mirrors: Microsoft.NETCore.Native.Windows.targets SetupOSSpecificProps + LinkNative.

    Note: This assumes the MSVC link.exe linker driver. When using Bazel's
    cc_toolchain on Windows, the toolchain must provide MSVC. MinGW/Clang
    cross-compilation to Windows is not supported.
    """
    # LinkNative: /OUT:"output"
    link_args.add("/OUT:" + output_exe.path)

    # LinkNative: object file
    link_args.add(obj_file)

    # NativeLibrary items: runtime_libs from the pack
    for lib in nativeaot_pack.runtime_libs:
        link_args.add(lib)

    #
    # SdkNativeLibrary items — system import libraries
    # Mirrors: <SdkNativeLibrary Include="advapi32.lib" ... />
    #
    link_args.add_all([
        "advapi32.lib",
        "bcrypt.lib",
        "crypt32.lib",
        "iphlpapi.lib",
        "kernel32.lib",
        "mswsock.lib",
        "ncrypt.lib",
        "normaliz.lib",
        "ntdll.lib",
        "ole32.lib",
        "oleaut32.lib",
        "secur32.lib",
        "user32.lib",
        "version.lib",
        "ws2_32.lib",
        "Synchronization.lib",
    ])

    # LinkerArg: /NOLOGO /MANIFEST:NO
    link_args.add("/NOLOGO")
    link_args.add("/MANIFEST:NO")

    # LinkerArg: /MERGE sections (reduces binary size)
    link_args.add("/MERGE:.managedcode=.text")
    link_args.add("/MERGE:hydrated=.bss")

    # LinkerArg: /DEBUG
    if ctx.attr.debug_symbols:
        link_args.add("/DEBUG")

    # LinkerArg: /INCREMENTAL:NO (runtime incompatible with jump stubs)
    link_args.add("/INCREMENTAL:NO")

    # LinkerArg: /SUBSYSTEM:CONSOLE /ENTRY:wmainCRTStartup
    link_args.add("/SUBSYSTEM:CONSOLE")
    link_args.add("/ENTRY:wmainCRTStartup")
    link_args.add("/NOEXP")
    link_args.add("/NOIMPLIB")

    # LinkerArg: /STACK:$(IlcDefaultStackSize) — MSBuild default 1572864
    stack_size = ctx.attr.stack_size if ctx.attr.stack_size else 1572864
    link_args.add("/STACK:%d" % stack_size)

    # LinkerArg: /IGNORE:4104 (suppress UnmanagedCallersOnly entrypoint warnings)
    link_args.add("/IGNORE:4104")

    # Force ucrt to be dynamically linked (release runtime)
    link_args.add("/NODEFAULTLIB:libucrt.lib")
    link_args.add("/DEFAULTLIB:ucrt.lib")

    # LinkerArg: /OPT:REF /OPT:ICF (release builds)
    link_args.add("/OPT:REF")
    link_args.add("/OPT:ICF")

    # LinkerArg: /CETCOMPAT (x64, opt-in by default)
    # MSBuild: enabled by default on x64 unless CETCompat=false
    if target_arch == "x64":
        if ctx.attr.cet_compat:
            link_args.add("/CETCOMPAT")
        else:
            link_args.add("/CETCOMPAT:NO")

    # LinkerArg: /guard:cf (Control Flow Guard)
    if ctx.attr.control_flow_guard:
        link_args.add("/guard:cf")
        # /guard:ehcont when both CET and CFG are enabled (x64 only)
        if ctx.attr.cet_compat and target_arch == "x64":
            link_args.add("/guard:ehcont")

    # LinkerArg: /safeseh (x86 only)
    if target_arch == "x86":
        link_args.add("/safeseh")

def _nativeaot_binary_impl(ctx):
    binary_info = ctx.attr.binary[0][DotnetBinaryInfo]
    runtime_info = ctx.attr.binary[0][DotnetAssemblyRuntimeInfo]
    nativeaot_pack = ctx.attr.nativeaot_pack[DotnetNativeAotPackInfo]

    target_os = _get_target_os(ctx)
    target_arch = _get_target_arch(ctx)

    main_dll = binary_info.dll

    # ILC executable — passed as a separate attr so we get FilesToRun for runfiles
    ilc_exe = ctx.executable.ilc

    # Collect all runtime dependency DLLs
    dep_libs = []
    for dep in binary_info.transitive_runtime_deps:
        dep_libs.extend(dep.libs)

    # Step 1: Run ILC to produce a native object file
    obj_file = ctx.actions.declare_file(ctx.label.name + ".o")

    ilc_args = ctx.actions.args()
    ilc_args.set_param_file_format("multiline")

    # Input IL assembly
    ilc_args.add(main_dll)

    # Output
    ilc_args.add("-o:" + obj_file.path)

    # References — framework assemblies and transitive deps
    for fw_file in nativeaot_pack.framework_files:
        ilc_args.add("-r:" + fw_file.path)
    for dep_lib in dep_libs:
        ilc_args.add("-r:" + dep_lib.path)

    # PGO optimization data
    for mibc_file in nativeaot_pack.mibc_files:
        ilc_args.add("--mibc:" + mibc_file.path)

    # Target platform
    ilc_args.add("--targetos:" + target_os)
    ilc_args.add("--targetarch:" + target_arch)

    # Optimization — mirrors MSBuild's Optimize + OptimizationPreference logic:
    #   -O always when optimizing
    #   --Os when OptimizationPreference=Size, --Ot when Speed
    if ctx.attr.optimization_mode == "size":
        ilc_args.add("-O")
        ilc_args.add("--Os")
    elif ctx.attr.optimization_mode == "speed":
        ilc_args.add("-O")
        ilc_args.add("--Ot")
    else:
        # "blended" — just -O with no size/speed preference
        ilc_args.add("-O")

    # Debug symbols
    if ctx.attr.debug_symbols:
        ilc_args.add("-g")

    # Dehydration — MSBuild enables on non-windows by default.
    # Reduces binary size by dehydrating metadata.
    if ctx.attr.dehydrate:
        ilc_args.add("--dehydrate")

    # Reflection scanning — MSBuild: IlcScanReflection defaults to true
    if ctx.attr.scan_reflection:
        ilc_args.add("--scanreflection")

    # Method body folding — MSBuild: default "generic" when not multimodule
    if ctx.attr.method_body_folding != "none":
        ilc_args.add("--methodbodyfolding:" + ctx.attr.method_body_folding)

    # Stack trace data — MSBuild: enabled by default
    if ctx.attr.stack_trace_support:
        ilc_args.add("--stacktracedata")

    # Resilient mode — MSBuild: IlcResilient defaults to true
    if ctx.attr.resilient:
        ilc_args.add("--resilient")

    # Export debug header symbol for debugger support
    if ctx.attr.debugger_support:
        if target_os == "windows":
            ilc_args.add("--export-dynamic-symbol:DotNetRuntimeDebugHeader,DATA")
        else:
            ilc_args.add("--export-dynamic-symbol:DotNetRuntimeDebugHeader")
    else:
        ilc_args.add("--feature:System.Diagnostics.Debugger.IsSupported=false")

    # Feature switches — invariant globalization and user-provided
    if ctx.attr.invariant_globalization:
        ilc_args.add("--feature:System.Globalization.Invariant=true")
    for feature in ctx.attr.feature_switches:
        ilc_args.add("--feature:" + feature)

    # Init assemblies (e.g., System.Private.CoreLib)
    for assembly in ctx.attr.init_assemblies:
        ilc_args.add("--initassembly:" + assembly)

    # Generate unmanaged entrypoints — MSBuild: System.Private.CoreLib by default.
    # These generate the Rh* helper functions (RhBoxAny, RhNewObject, etc.) that the
    # NativeAOT runtime expects.
    for assembly in ctx.attr.generate_unmanaged_entrypoints:
        ilc_args.add("--generateunmanagedentrypoints:" + assembly)

    # Direct P/Invoke
    for pinvoke in ctx.attr.direct_pinvokes:
        ilc_args.add("--directpinvoke:" + pinvoke)

    # Root assemblies for trimming
    for root in ctx.attr.root_assemblies:
        ilc_args.add("--root:" + root)

    # Extra ILC arguments (escape hatch)
    for arg in ctx.attr.extra_ilc_args:
        ilc_args.add(arg)

    ilc_inputs = (
        [main_dll] +
        dep_libs +
        nativeaot_pack.framework_files +
        nativeaot_pack.mibc_files
    )

    # Collect ILC runfiles as inputs
    ilc_runfiles = ctx.attr.ilc[DefaultInfo].default_runfiles
    if ilc_runfiles and ilc_runfiles.files:
        ilc_inputs = ilc_inputs + ilc_runfiles.files.to_list()

    # Add runfiles.bash so the shell wrapper can resolve its dependencies
    runfiles_bash_files = ctx.attr._runfiles_bash[DefaultInfo].files.to_list()
    ilc_inputs = ilc_inputs + runfiles_bash_files

    # Add ILC native libs (jitinterface, clrjit) as inputs
    ilc_native_lib_files = ctx.files.ilc_native_libs
    ilc_inputs = ilc_inputs + ilc_native_lib_files

    # Write the ILC arguments to a response file
    rsp_file = ctx.actions.declare_file(ctx.label.name + ".ilc.rsp")
    ctx.actions.write(rsp_file, ilc_args)
    ilc_inputs = ilc_inputs + [rsp_file]

    # Use run_shell with RUNFILES_DIR set explicitly (same pattern as crossgen2.bzl).
    # Copy native libs next to ILC's assemblies so NativeLibrary.Load can find them.
    copy_cmds = []
    for lib in ilc_native_lib_files:
        # Copy next to the ILC DLL directory and next to the RyuJit assembly
        copy_cmds.append(
            "ILC_DIR=$(find \"$RUNFILES_DIR\" -name 'ILCompiler.RyuJit.dll' -print -quit 2>/dev/null | xargs dirname 2>/dev/null) && " +
            "if [ -n \"$ILC_DIR\" ]; then cp -f \"{src}\" \"$ILC_DIR/{basename}\" 2>/dev/null || true; fi".format(
                src = lib.path,
                basename = lib.basename,
            )
        )

    cmd = (
        "RUNFILES_DIR=\"{exe}.runfiles\" && ".format(exe = ilc_exe.path) +
        "export RUNFILES_DIR && " +
        (" && ".join(copy_cmds) + " && " if copy_cmds else "") +
        "{exe} @{rsp}".format(exe = ilc_exe.path, rsp = rsp_file.path)
    )

    ctx.actions.run_shell(
        command = cmd,
        inputs = ilc_inputs,
        outputs = [obj_file],
        tools = [ilc_exe],
        mnemonic = "NativeAotIlc",
        progress_message = "NativeAOT compiling %s" % main_dll.short_path,
    )

    #
    # Step 2: Link the native object with NativeAOT runtime.
    #
    # This mirrors the logic in:
    #   Microsoft.NETCore.Native.targets (LinkNative target)
    #   Microsoft.NETCore.Native.Unix.targets (SetupOSSpecificProps)
    #   Microsoft.NETCore.Native.Windows.targets (SetupOSSpecificProps)
    #

    # MSBuild: StripSymbols defaults to true on non-Windows.
    # When stripping, link to a pre-strip file and run objcopy/dsymutil+strip as a post step.
    strip_symbols = ctx.attr.strip_symbols and target_os != "windows"
    is_apple = (target_os == "osx")

    if strip_symbols:
        link_output = ctx.actions.declare_file(ctx.label.name + ".unstripped")
    else:
        link_output = ctx.actions.declare_file(ctx.label.name)

    cc_toolchain = ctx.toolchains["@bazel_tools//tools/cpp:toolchain_type"].cc

    link_args = ctx.actions.args()

    # Use the C++ compiler as the linker driver (MSBuild: CppLinker = clang/gcc)
    cc = cc_toolchain.compiler_executable

    linker_inputs = [obj_file] + nativeaot_pack.runtime_libs
    additional_linker_inputs = []

    if target_os == "linux" or target_os == "osx":
        _add_unix_link_args(link_args, obj_file, link_output, nativeaot_pack, target_os, target_arch, ctx, additional_linker_inputs)
    elif target_os == "windows":
        _add_windows_link_args(link_args, obj_file, link_output, nativeaot_pack, target_arch, ctx)

    # Extra linker flags from the user
    for flag in ctx.attr.extra_linker_args:
        link_args.add(flag)

    ctx.actions.run(
        executable = cc,
        arguments = [link_args],
        inputs = depset(
            linker_inputs + additional_linker_inputs,
            transitive = [cc_toolchain.all_files],
        ),
        outputs = [link_output],
        mnemonic = "NativeAotLink",
        progress_message = "Linking NativeAOT binary %s" % ctx.label.name,
    )

    # MSBuild: StripSymbols post-link step.
    # See https://github.com/dotnet/runtime/blob/5d3288d/eng/native/functions.cmake#L374
    #
    # Linux (non-Apple):
    #   When NativeDebugSymbols:
    #     1. objcopy --only-keep-debug binary binary.dbg
    #     2. objcopy --strip-debug --strip-unneeded binary
    #     3. objcopy --add-gnu-debuglink=binary.dbg binary
    #   Without NativeDebugSymbols:
    #     1. objcopy --strip-debug --strip-unneeded binary
    #
    # Apple:
    #   1. dsymutil [--minimize] binary  (creates .dSYM bundle)
    #   2. strip -no_code_signature_warning -x binary
    #
    # MSBuild probes for llvm-objcopy (when using clang) and falls back to objcopy.
    if strip_symbols:
        output_exe = ctx.actions.declare_file(ctx.label.name)
        strip_outputs = [output_exe]

        if is_apple:
            # Apple: dsymutil + strip
            # dsymutil creates a .dSYM directory (bundle); we declare it as a tree artifact
            if ctx.attr.debug_symbols:
                dsym_dir = ctx.actions.declare_directory(ctx.label.name + ".dSYM")
                strip_outputs.append(dsym_dir)
                strip_cmd = (
                    "cp '{src}' '{dst}' && " +
                    "dsymutil --minimize '{dst}' -o '{dsym}' && " +
                    "strip -no_code_signature_warning -x '{dst}'"
                ).format(
                    src = link_output.path,
                    dst = output_exe.path,
                    dsym = dsym_dir.path,
                )
            else:
                strip_cmd = (
                    "cp '{src}' '{dst}' && " +
                    "strip -no_code_signature_warning -x '{dst}'"
                ).format(
                    src = link_output.path,
                    dst = output_exe.path,
                )
        else:
            # Linux: objcopy (try llvm-objcopy first, fall back to objcopy)
            objcopy_cmd = "llvm-objcopy"
            objcopy_fallback = "objcopy"

            if ctx.attr.debug_symbols:
                # NativeSymbolExt is .dbg on Linux
                dbg_file = ctx.actions.declare_file(ctx.label.name + ".dbg")
                strip_outputs.append(dbg_file)
                strip_cmd = (
                    "OBJCOPY=$({objcopy} --version >/dev/null 2>&1 && echo {objcopy} || echo {fallback}) && " +
                    "cp '{src}' '{dst}' && " +
                    "\"$OBJCOPY\" --only-keep-debug '{dst}' '{dbg}' && " +
                    "\"$OBJCOPY\" --strip-debug --strip-unneeded '{dst}' && " +
                    "\"$OBJCOPY\" --add-gnu-debuglink='{dbg}' '{dst}'"
                ).format(
                    objcopy = objcopy_cmd,
                    fallback = objcopy_fallback,
                    src = link_output.path,
                    dst = output_exe.path,
                    dbg = dbg_file.path,
                )
            else:
                strip_cmd = (
                    "OBJCOPY=$({objcopy} --version >/dev/null 2>&1 && echo {objcopy} || echo {fallback}) && " +
                    "cp '{src}' '{dst}' && " +
                    "\"$OBJCOPY\" --strip-debug --strip-unneeded '{dst}'"
                ).format(
                    objcopy = objcopy_cmd,
                    fallback = objcopy_fallback,
                    src = link_output.path,
                    dst = output_exe.path,
                )

        ctx.actions.run_shell(
            command = strip_cmd,
            inputs = [link_output],
            outputs = strip_outputs,
            mnemonic = "NativeAotStrip",
            progress_message = "Stripping NativeAOT binary %s" % ctx.label.name,
        )
    else:
        output_exe = link_output

    return [
        DefaultInfo(
            executable = output_exe,
            files = depset([output_exe]),
        ),
    ]

nativeaot_binary = rule(
    _nativeaot_binary_impl,
    doc = """Compile a C# binary into a NativeAOT native executable.

    This rule takes a csharp_binary target and produces a fully native
    executable using the ILC (NativeAOT) compiler. The output is a
    self-contained native binary with no dependency on the .NET runtime.

    Example:
        ```starlark
        csharp_binary(
            name = "myapp",
            srcs = ["Program.cs"],
            ...
        )

        nativeaot_binary(
            name = "myapp_native",
            binary = ":myapp",
            target_framework = "net10.0",
            nativeaot_pack = "//path/to:nativeaot_pack",
        )
        ```
    """,
    attrs = {
        "binary": attr.label(
            doc = "The C# binary target to compile with NativeAOT.",
            providers = [DotnetBinaryInfo, DotnetAssemblyRuntimeInfo],
            cfg = tfm_transition,
            mandatory = True,
        ),
        "target_framework": attr.string(
            doc = "The target framework (e.g., 'net10.0').",
            mandatory = True,
        ),
        "nativeaot_pack": attr.label(
            doc = "The NativeAOT pack providing runtime libraries and framework assemblies.",
            providers = [DotnetNativeAotPackInfo],
            mandatory = True,
        ),
        "ilc": attr.label(
            doc = "The ILC (NativeAOT IL Compiler) executable. Must be a csharp_binary or similar.",
            executable = True,
            cfg = "exec",
            mandatory = True,
        ),
        "ilc_native_libs": attr.label_list(
            doc = "Native shared libraries (.so/.dylib) that ILC needs at runtime " +
                  "(e.g., jitinterface, clrjit). These are copied next to ILC's DLLs.",
            allow_files = True,
            cfg = "exec",
            default = [],
        ),
        "optimization_mode": attr.string(
            doc = "Optimization mode: 'speed', 'size', or 'blended'. " +
                  "Maps to MSBuild OptimizationPreference. 'speed' emits -O --Ot, " +
                  "'size' emits -O --Os, 'blended' emits -O only.",
            default = "speed",
            values = ["speed", "size", "blended"],
        ),
        "debug_symbols": attr.bool(
            doc = "Emit native debug symbols (-g). Maps to MSBuild NativeDebugSymbols.",
            default = False,
        ),
        "dehydrate": attr.bool(
            doc = "Enable metadata dehydration for smaller binaries. " +
                  "MSBuild enables this by default on non-Windows.",
            default = True,
        ),
        "scan_reflection": attr.bool(
            doc = "Enable reflection scanning. Maps to MSBuild IlcScanReflection (default true).",
            default = True,
        ),
        "method_body_folding": attr.string(
            doc = "Method body folding mode. Maps to MSBuild IlcFoldIdenticalMethodBodies. " +
                  "'generic' (default), 'all', or 'none'.",
            default = "generic",
            values = ["generic", "all", "none"],
        ),
        "stack_trace_support": attr.bool(
            doc = "Include stack trace data. Maps to MSBuild StackTraceSupport.",
            default = True,
        ),
        "resilient": attr.bool(
            doc = "Enable resilient mode (tolerate input metadata errors). " +
                  "Maps to MSBuild IlcResilient (default true).",
            default = True,
        ),
        "debugger_support": attr.bool(
            doc = "Enable managed debugger support. Maps to MSBuild DebuggerSupport. " +
                  "When false, trims System.Diagnostics.Debugger support.",
            default = False,
        ),
        "invariant_globalization": attr.bool(
            doc = "Use invariant globalization (no ICU dependency). " +
                  "Maps to MSBuild InvariantGlobalization.",
            default = True,
        ),
        "feature_switches": attr.string_list(
            doc = "Feature switches in 'Name=Value' format. " +
                  "Maps to MSBuild RuntimeHostConfigurationOption.",
            default = [],
        ),
        "init_assemblies": attr.string_list(
            doc = "Assemblies to auto-initialize (e.g., 'System.Private.CoreLib'). " +
                  "Maps to MSBuild AutoInitializedAssemblies.",
            default = [],
        ),
        "generate_unmanaged_entrypoints": attr.string_list(
            doc = "Assemblies to generate unmanaged entrypoints from. " +
                  "MSBuild defaults to 'System.Private.CoreLib'. These generate " +
                  "the Rh* runtime helper functions needed by the NativeAOT runtime.",
            default = ["System.Private.CoreLib"],
        ),
        "direct_pinvokes": attr.string_list(
            doc = "Libraries to direct P/Invoke into (e.g., 'libSystem.Native'). " +
                  "Maps to MSBuild DirectPInvoke.",
            default = [],
        ),
        "root_assemblies": attr.string_list(
            doc = "Assemblies to root (prevent trimming). " +
                  "Maps to MSBuild TrimmerRootAssembly.",
            default = [],
        ),
        "extra_ilc_args": attr.string_list(
            doc = "Additional arguments to pass to ILC.",
            default = [],
        ),
        "extra_linker_args": attr.string_list(
            doc = "Additional arguments to pass to the native linker.",
            default = [],
        ),
        "use_system_zlib": attr.bool(
            doc = "Link against system zlib (-lz) instead of static libz.a from the pack. " +
                  "Maps to MSBuild UseSystemZlib. Set to True when the pack does not include libz.a.",
            default = True,
        ),
        "static_openssl_linking": attr.bool(
            doc = "Use static OpenSSL linking. When False (default), links dynamically against " +
                  "-lssl -lcrypto on Linux. Maps to MSBuild StaticOpenSslLinking.",
            default = False,
        ),
        "stack_size": attr.int(
            doc = "Native stack size in bytes. Maps to MSBuild IlcDefaultStackSize. " +
                  "Default: 0 (use platform default; MSBuild defaults to 1572864 for musl/Windows).",
            default = 0,
        ),
        "compress_symbols": attr.bool(
            doc = "Compress debug symbols with zlib (-gz=zlib). " +
                  "Maps to MSBuild CompressSymbols (default true on Unix).",
            default = True,
        ),
        "strip_symbols": attr.bool(
            doc = "Strip debug and unneeded symbols from the output binary using objcopy. " +
                  "Maps to MSBuild StripSymbols (default true on non-Windows). " +
                  "Reduces binary size significantly (e.g., 43MB → 16MB).",
            default = True,
        ),
        "linker_flavor": attr.string(
            doc = "Linker flavor to use (e.g., 'lld', 'bfd'). Empty means use the cc_toolchain default. " +
                  "Maps to MSBuild LinkerFlavor.",
            default = "",
        ),
        "link_standard_cplusplus": attr.bool(
            doc = "Link against -lstdc++. Maps to MSBuild LinkStandardCPlusPlusLibrary. " +
                  "MSBuild enables this on iOS-like platforms when not using invariant globalization.",
            default = False,
        ),
        "use_system_brotli": attr.bool(
            doc = "Link against system brotli (-lbrotlienc -lbrotlidec -lbrotlicommon) instead of " +
                  "static libs from the pack. Maps to MSBuild UseSystemBrotli.",
            default = False,
        ),
        "use_system_zstd": attr.bool(
            doc = "Link against system zstd (-lzstd) instead of static lib from the pack. " +
                  "Maps to MSBuild UseSystemZstd.",
            default = False,
        ),
        "static_icu_linking": attr.bool(
            doc = "Statically link ICU libraries. Maps to MSBuild StaticICULinking. " +
                  "When enabled, links -licuio -licutu -licui18n -licuuc -licudata.",
            default = False,
        ),
        "cet_compat": attr.bool(
            doc = "Enable Intel CET (Control-flow Enforcement Technology) on Windows x64. " +
                  "Maps to MSBuild CETCompat (default true on x64).",
            default = True,
        ),
        "control_flow_guard": attr.bool(
            doc = "Enable Control Flow Guard (/guard:cf) on Windows. " +
                  "Maps to MSBuild ControlFlowGuard.",
            default = False,
        ),
        "_linux_constraint": attr.label(default = "@platforms//os:linux"),
        "_macos_constraint": attr.label(default = "@platforms//os:macos"),
        "_windows_constraint": attr.label(default = "@platforms//os:windows"),
        "_x86_64_constraint": attr.label(default = "@platforms//cpu:x86_64"),
        "_x86_constraint": attr.label(default = "@platforms//cpu:x86_32"),
        "_arm64_constraint": attr.label(default = "@platforms//cpu:arm64"),
        "_runfiles_bash": attr.label(
            default = Label("@bazel_tools//tools/bash/runfiles"),
        ),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
    toolchains = [
        "//dotnet:toolchain_type",
        "@bazel_tools//tools/cpp:toolchain_type",
    ],
    executable = True,
    cfg = tfm_transition,
)
