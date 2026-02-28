"""
NativeAOT compilation logic: ILC → native link pipeline.

Shared helper functions used by publish_binary when aot=True.
"""

def get_target_os(ctx):
    """Determine the target OS string for ILC."""
    if ctx.target_platform_has_constraint(ctx.attr._linux_constraint[platform_common.ConstraintValueInfo]):
        return "linux"
    elif ctx.target_platform_has_constraint(ctx.attr._macos_constraint[platform_common.ConstraintValueInfo]):
        return "osx"
    elif ctx.target_platform_has_constraint(ctx.attr._windows_constraint[platform_common.ConstraintValueInfo]):
        return "windows"
    else:
        fail("Unsupported target OS for NativeAOT compilation")

def get_target_arch(ctx):
    """Determine the target architecture string for ILC."""
    if ctx.target_platform_has_constraint(ctx.attr._x86_64_constraint[platform_common.ConstraintValueInfo]):
        return "x64"
    elif ctx.target_platform_has_constraint(ctx.attr._arm64_constraint[platform_common.ConstraintValueInfo]):
        return "arm64"
    else:
        fail("Unsupported target architecture for NativeAOT compilation")

# NativeAOT feature switches set by the SDK when PublishAot=true.
# These are compiled directly into the native binary via ILC.
NATIVEAOT_FEATURE_SWITCHES = {
    "System.Diagnostics.Tracing.EventSource.IsSupported": "false",
    "System.Runtime.CompilerServices.RuntimeFeature.IsDynamicCodeSupported": "false",
    "System.Linq.Enumerable.IsSizeOptimized": "true",
    "System.Linq.Expressions.CanEmitObjectArrayDelegate": "false",
    "System.Text.Json.JsonSerializer.IsReflectionEnabledByDefault": "false",
    "System.Runtime.InteropServices.BuiltInComInterop.IsSupported": "false",
}

def _select_runtime_libs(runtime_libs, server_gc = False, eventpipe = False):
    """Select the correct subset of runtime libs matching MSBuild NativeAOT targets.
    
    The pack contains ALL variants; we must pick exactly one of each:
    - bootstrapper: libbootstrapper.o (exe) vs libbootstrapperdll.o (shared lib)
    - GC: WorkstationGC vs ServerGC
    - eventpipe: disabled vs enabled
    - vxsort: Disabled vs Enabled (x64 only)
    - standalonegc: disabled vs enabled
    """
    gc_name = "libRuntime.ServerGC" if server_gc else "libRuntime.WorkstationGC"
    ep_name = "libeventpipe-enabled" if eventpipe else "libeventpipe-disabled"

    selected = []
    for lib in runtime_libs:
        basename = lib.basename

        # Only include libbootstrapper.o (not libbootstrapperdll.o) for executables
        if basename == "libbootstrapperdll.o":
            continue

        # Select the correct GC
        if basename.startswith("libRuntime.") and basename.endswith(".a"):
            if basename.startswith("libRuntime.WorkstationGC") or basename.startswith("libRuntime.ServerGC"):
                if not basename.startswith(gc_name):
                    continue
            # vxsort: include both (linker resolves; or we could pick, but both is safe with --start-group)
            # standalonegc: include both (same reasoning)

        # Select the correct eventpipe
        if basename.startswith("libeventpipe-"):
            if not basename.startswith(ep_name):
                continue

        selected.append(lib)
    return selected

def _add_unix_link_args(link_args, obj_file, output_exe, nativeaot_pack, target_os, ctx, additional_linker_inputs):
    """Build linker arguments for Unix platforms (Linux and macOS).

    Mirrors: Microsoft.NETCore.Native.Unix.targets SetupOSSpecificProps + LinkNative.
    """
    is_apple = (target_os == "osx")

    link_args.add("-o", output_exe)

    if is_apple:
        link_args.add("-Wl,-dead_strip")
    else:
        link_args.add("-Wl,--discard-all")
        link_args.add("-Wl,--gc-sections")

    # Runtime libs from the pack — select correct variants
    # The obj file must be inside the group for circular reference resolution
    selected_libs = _select_runtime_libs(nativeaot_pack.runtime_libs)
    if not is_apple:
        link_args.add("-Wl,--start-group")
    link_args.add(obj_file)
    for lib in selected_libs:
        link_args.add(lib)
    if not is_apple:
        link_args.add("-Wl,--end-group")

    # Linker flavor: only set if explicitly specified (MSBuild defaults to bfd on linux, lld on musl/freebsd)
    linker_flavor = ctx.attr.linker_flavor
    if linker_flavor:
        link_args.add("-fuse-ld=" + linker_flavor)

    # Linker script for lld to retain __modules section
    if not is_apple and linker_flavor == "lld":
        sections_ld = ctx.actions.declare_file(ctx.label.name + ".sections.ld")
        ctx.actions.write(sections_ld, "OVERWRITE_SECTIONS { __modules : { KEEP(*(__modules)) } }\n")
        link_args.add("-T", sections_ld)
        additional_linker_inputs.append(sections_ld)

    # Debug symbols
    if ctx.attr.debug_symbols:
        link_args.add("-g")
    elif not is_apple:
        link_args.add("-Wl,--strip-debug")

    if not is_apple:
        link_args.add("-Wl,--build-id=sha1")
        link_args.add("-Wl,--as-needed")
        link_args.add("-pthread")

    # System libraries
    link_args.add("-ldl")

    if is_apple:
        link_args.add("-lobjc")
        link_args.add("-lswiftCore")
        link_args.add("-lswiftFoundation")

    link_args.add("-lz")  # zlib

    if not is_apple:
        link_args.add("-lrt")

    if is_apple and not ctx.attr.invariant_globalization:
        link_args.add("-licucore")

    link_args.add("-lm")

    if is_apple:
        link_args.add("-L/usr/lib/swift")

    if not is_apple:
        link_args.add("-lssl")
        link_args.add("-lcrypto")

    # Apple frameworks
    if is_apple:
        link_args.add_all([
            "-framework", "CoreFoundation",
            "-framework", "CryptoKit",
            "-framework", "Foundation",
            "-framework", "Network",
            "-framework", "Security",
            "-framework", "GSS",
        ])

    # Security flags (Linux)
    if not is_apple:
        link_args.add("-pie")
        link_args.add("-Wl,-pie")
        link_args.add("-Wl,-z,relro")
        link_args.add("-Wl,-z,now")
        link_args.add("-Wl,-z,noexecstack")
        link_args.add("-Wl,--eh-frame-hdr")

def _add_windows_link_args(link_args, obj_file, output_exe, nativeaot_pack, target_arch, ctx):
    """Build linker arguments for Windows (MSVC link.exe).

    Mirrors: Microsoft.NETCore.Native.Windows.targets SetupOSSpecificProps + LinkNative.
    """
    link_args.add("/OUT:" + output_exe.path)
    link_args.add(obj_file)

    for lib in nativeaot_pack.runtime_libs:
        link_args.add(lib)

    # System import libraries
    link_args.add_all([
        "advapi32.lib", "bcrypt.lib", "crypt32.lib", "iphlpapi.lib",
        "kernel32.lib", "mswsock.lib", "ncrypt.lib", "normaliz.lib",
        "ntdll.lib", "ole32.lib", "oleaut32.lib", "secur32.lib",
        "user32.lib", "version.lib", "ws2_32.lib", "Synchronization.lib",
    ])

    link_args.add("/NOLOGO")
    link_args.add("/MANIFEST:NO")
    link_args.add("/MERGE:.managedcode=.text")
    link_args.add("/MERGE:hydrated=.bss")

    if ctx.attr.debug_symbols:
        link_args.add("/DEBUG")

    link_args.add("/INCREMENTAL:NO")
    link_args.add("/SUBSYSTEM:CONSOLE")
    link_args.add("/ENTRY:wmainCRTStartup")
    link_args.add("/NOEXP")
    link_args.add("/NOIMPLIB")

    stack_size = ctx.attr.stack_size if ctx.attr.stack_size else 1572864
    link_args.add("/STACK:%d" % stack_size)
    link_args.add("/IGNORE:4104")
    link_args.add("/NODEFAULTLIB:libucrt.lib")
    link_args.add("/DEFAULTLIB:ucrt.lib")
    link_args.add("/OPT:REF")
    link_args.add("/OPT:ICF")

    if target_arch == "x64":
        link_args.add("/CETCOMPAT")

def nativeaot_publish(ctx, binary_info, nativeaot_pack):
    """Perform NativeAOT compilation: ILC → native link → strip.

    Args:
        ctx: The rule context (publish_binary).
        binary_info: DotnetBinaryInfo of the input binary.
        nativeaot_pack: DotnetNativeAotPackInfo with ILC, framework, runtime libs.

    Returns:
        DefaultInfo with the native executable.
    """
    target_os = get_target_os(ctx)
    target_arch = get_target_arch(ctx)
    main_dll = binary_info.dll

    # Collect all runtime dependency DLLs
    dep_libs = []
    for dep in binary_info.transitive_runtime_deps:
        dep_libs.extend(dep.libs)

    # Step 1: Run ILC to produce a native object file
    obj_file = ctx.actions.declare_file(ctx.label.name + ".o")

    rsp_lines = []
    rsp_lines.append(main_dll.path)
    rsp_lines.append("-o:" + obj_file.path)

    for fw_file in nativeaot_pack.framework_files:
        rsp_lines.append("-r:" + fw_file.path)
    for dep_lib in dep_libs:
        rsp_lines.append("-r:" + dep_lib.path)

    for mibc_file in nativeaot_pack.mibc_files:
        rsp_lines.append("--mibc:" + mibc_file.path)

    rsp_lines.append("--targetos:" + target_os)
    rsp_lines.append("--targetarch:" + target_arch)

    # Optimization
    optimization = ctx.attr.optimization_mode if ctx.attr.optimization_mode else "speed"
    rsp_lines.append("-O")
    if optimization == "size":
        rsp_lines.append("--Os")
    elif optimization == "speed":
        rsp_lines.append("--Ot")

    if ctx.attr.debug_symbols:
        rsp_lines.append("-g")

    # Sensible defaults matching MSBuild
    rsp_lines.append("--systemmodule:System.Private.CoreLib")
    rsp_lines.append("--dehydrate")
    rsp_lines.append("--scanreflection")
    rsp_lines.append("--methodbodyfolding")
    rsp_lines.append("all")
    rsp_lines.append("--stacktracedata")
    rsp_lines.append("--resilient")

    # Generate native exports (InitializeModules, ProcessFinalizers, etc.)
    rsp_lines.append("--generateunmanagedentrypoints:System.Private.CoreLib")

    # Init assemblies — required for ILC to generate module initialization code
    rsp_lines.append("--initassembly:System.Private.CoreLib")
    rsp_lines.append("--initassembly:System.Private.StackTraceMetadata")
    rsp_lines.append("--initassembly:System.Private.TypeLoader")
    rsp_lines.append("--initassembly:System.Private.Reflection.Execution")

    # Direct P/Invoke for system native libraries (avoids dlopen)
    # Include both with and without "lib" prefix to match DllImport names
    rsp_lines.append("--directpinvoke:System.Native")
    rsp_lines.append("--directpinvoke:libSystem.Native")
    rsp_lines.append("--directpinvoke:System.Globalization.Native")
    rsp_lines.append("--directpinvoke:libSystem.Globalization.Native")
    rsp_lines.append("--directpinvoke:System.IO.Compression.Native")
    rsp_lines.append("--directpinvoke:libSystem.IO.Compression.Native")
    rsp_lines.append("--directpinvoke:System.Net.Security.Native")
    rsp_lines.append("--directpinvoke:libSystem.Net.Security.Native")
    rsp_lines.append("--directpinvoke:System.Security.Cryptography.Native.OpenSsl")
    rsp_lines.append("--directpinvoke:libSystem.Security.Cryptography.Native.OpenSsl")

    # Feature switches: the 6 SDK defaults + invariant globalization
    for key, value in NATIVEAOT_FEATURE_SWITCHES.items():
        rsp_lines.append("--feature:%s=%s" % (key, value))

    if ctx.attr.invariant_globalization:
        rsp_lines.append("--feature:System.Globalization.Invariant=true")

    # Extra ILC arguments (escape hatch)
    for arg in ctx.attr.extra_ilc_args:
        rsp_lines.append(arg)

    ilc_inputs = (
        [main_dll] +
        dep_libs +
        nativeaot_pack.framework_files +
        nativeaot_pack.mibc_files +
        nativeaot_pack.ilc_files.to_list()
    )

    # Write response file
    rsp_file = ctx.actions.declare_file(ctx.label.name + ".ilc.rsp")
    ctx.actions.write(rsp_file, "\n".join(rsp_lines) + "\n")
    ilc_inputs = ilc_inputs + [rsp_file]

    # ILC is a native executable from the ILCompiler NuGet package.
    # Sandbox inputs are read-only, so we copy ILC tools to a writable temp dir.
    ilc_exe = nativeaot_pack.ilc
    ilc_dir = ilc_exe.path.rsplit("/", 1)[0]
    cmd = (
        "ILC_DIR=$(mktemp -d) && " +
        "cp {ilc_dir}/* $ILC_DIR/ && ".format(ilc_dir = ilc_dir) +
        "chmod +x $ILC_DIR/ilc && " +
        "$ILC_DIR/ilc @{rsp}".format(rsp = rsp_file.path)
    )

    ctx.actions.run_shell(
        command = cmd,
        inputs = ilc_inputs,
        outputs = [obj_file],
        mnemonic = "NativeAotIlc",
        progress_message = "NativeAOT compiling %s" % main_dll.short_path,
    )

    # Step 2: Link the native object with NativeAOT runtime
    strip_symbols = ctx.attr.strip_symbols and target_os != "windows"
    is_apple = (target_os == "osx")

    if strip_symbols:
        link_output = ctx.actions.declare_file(ctx.label.name + ".unstripped")
    else:
        link_output = ctx.actions.declare_file(ctx.label.name + (".exe" if target_os == "windows" else ""))

    cc_toolchain = ctx.toolchains["@bazel_tools//tools/cpp:toolchain_type"].cc
    link_args = ctx.actions.args()
    cc = cc_toolchain.compiler_executable

    linker_inputs = [obj_file] + nativeaot_pack.runtime_libs
    additional_linker_inputs = []

    if target_os == "linux" or target_os == "osx":
        _add_unix_link_args(link_args, obj_file, link_output, nativeaot_pack, target_os, ctx, additional_linker_inputs)
    elif target_os == "windows":
        _add_windows_link_args(link_args, obj_file, link_output, nativeaot_pack, target_arch, ctx)

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
        env = {"PATH": "/usr/bin:/bin:/usr/local/bin"},
    )

    # Step 3: Strip symbols (non-Windows)
    if strip_symbols:
        output_exe = ctx.actions.declare_file(ctx.label.name)
        strip_outputs = [output_exe]

        if is_apple:
            if ctx.attr.debug_symbols:
                dsym_dir = ctx.actions.declare_directory(ctx.label.name + ".dSYM")
                strip_outputs.append(dsym_dir)
                strip_cmd = (
                    "dsymutil --minimize '{src}' -o '{dsym}' && " +
                    "strip -no_code_signature_warning -x -o '{dst}' '{src}'"
                ).format(src = link_output.path, dst = output_exe.path, dsym = dsym_dir.path)
            else:
                strip_cmd = (
                    "strip -no_code_signature_warning -x -o '{dst}' '{src}'"
                ).format(src = link_output.path, dst = output_exe.path)
        else:
            objcopy_cmd = "llvm-objcopy"
            objcopy_fallback = "objcopy"
            if ctx.attr.debug_symbols:
                dbg_file = ctx.actions.declare_file(ctx.label.name + ".dbg")
                strip_outputs.append(dbg_file)
                strip_cmd = (
                    "OBJCOPY=$({objcopy} --version >/dev/null 2>&1 && echo {objcopy} || echo {fallback}) && " +
                    "\"$OBJCOPY\" --only-keep-debug '{src}' '{dbg}' && " +
                    "\"$OBJCOPY\" --strip-debug --strip-unneeded '{src}' '{dst}' && " +
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
                    "\"$OBJCOPY\" --strip-debug --strip-unneeded '{src}' '{dst}'"
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

# NativeAOT-specific attributes for publish_binary
NATIVEAOT_ATTRS = {
    "aot": attr.bool(
        doc = """Publish as a NativeAOT binary.

        When true, the binary is compiled ahead-of-time into a fully native executable
        using the ILC compiler. The input binary must have is_aot_compatible=True.

        This replaces the legacy nativeaot_binary rule with an integrated publish workflow.
        """,
        default = False,
    ),
    "optimization_mode": attr.string(
        doc = "NativeAOT optimization mode: 'speed', 'size', or 'blended'.",
        default = "speed",
        values = ["speed", "size", "blended"],
    ),
    "debug_symbols": attr.bool(
        doc = "Emit native debug symbols.",
        default = False,
    ),
    "invariant_globalization": attr.bool(
        doc = "Use invariant globalization (no ICU dependency).",
        default = True,
    ),
    "strip_symbols": attr.bool(
        doc = "Strip debug symbols from the output (non-Windows).",
        default = True,
    ),
    "linker_flavor": attr.string(
        doc = "Linker flavor (e.g., 'lld', 'bfd'). Empty uses default.",
        default = "",
    ),
    "stack_size": attr.int(
        doc = "Native stack size in bytes (0 = platform default).",
        default = 0,
    ),
    "extra_ilc_args": attr.string_list(
        doc = "Additional arguments to pass to ILC.",
        default = [],
    ),
    "extra_linker_args": attr.string_list(
        doc = "Additional arguments to pass to the native linker.",
        default = [],
    ),
    "_linux_constraint": attr.label(default = "@platforms//os:linux"),
    "_macos_constraint": attr.label(default = "@platforms//os:macos"),
    "_windows_constraint": attr.label(default = "@platforms//os:windows"),
    "_x86_64_constraint": attr.label(default = "@platforms//cpu:x86_64"),
    "_arm64_constraint": attr.label(default = "@platforms//cpu:arm64"),
}
