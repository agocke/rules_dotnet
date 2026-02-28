".Net NativeAOT Pack from NuGet packages"

load("//dotnet/private:providers.bzl", "DotnetNativeAotPackInfo")

def _nativeaot_nuget_pack_impl(ctx):
    # Empty pack case (default label_setting value)
    if ctx.attr.ilcompiler_pack == None:
        return [DotnetNativeAotPackInfo(
            ilc = None,
            ilc_files = depset(),
            framework_files = [],
            runtime_libs = [],
            mibc_files = [],
        )]

    # The ILCompiler package (runtime.{rid}.Microsoft.DotNet.ILCompiler) contains:
    #   tools/ilc (or ilc.exe)  — the ILC compiler
    #   tools/lib*.so|dylib|dll — JIT libraries needed by ILC
    #   sdk/*.a|*.lib|*.o|*.obj — native static libs (bootstrapper, GC, eventpipe, etc.)
    #   sdk/*.dll               — private managed DLLs (System.Private.CoreLib, etc.)
    #   framework/*.dll         — managed framework assemblies for ILC -r: refs
    #   mibc/*.mibc             — PGO optimization data
    ilcompiler_files = ctx.attr.ilcompiler_pack[DefaultInfo].files.to_list()

    ilc = None
    ilc_files = []
    framework_files = []
    runtime_libs = []
    mibc_files = []

    for f in ilcompiler_files:
        path = f.path

        # ILC executable
        if "/tools/" in path and (path.endswith("/ilc") or path.endswith("/ilc.exe") or path.endswith("/ilc.dll")):
            if path.endswith("/ilc.dll"):
                ilc = f
            elif ilc == None:
                ilc = f

        # All files under tools/ are needed for ILC to run
        if "/tools/" in path:
            ilc_files.append(f)

        # MIBC files
        if "/mibc/" in path and path.endswith(".mibc"):
            mibc_files.append(f)

    # If there's a separate NativeAOT runtime pack (net9.0+), it provides:
    #   runtimes/{rid}/native/*.a|*.lib — native static libs (runtime + system interop)
    #   runtimes/{rid}/native/*.dll     — private managed DLLs
    #   runtimes/{rid}/lib/{tfm}/*.dll  — managed framework assemblies
    # In this mode, the runtime pack's native/ dir serves as both IlcSdkPath and
    # IlcFrameworkNativePath (per Microsoft.NETCore.Native.targets SetupProperties).
    if ctx.attr.runtime_pack != None:
        runtime_pack_files = ctx.attr.runtime_pack[DefaultInfo].files.to_list()
        for f in runtime_pack_files:
            path = f.path
            if "/runtimes/" in path:
                if "/native/" in path:
                    if path.endswith(".a") or path.endswith(".lib") or path.endswith(".o") or path.endswith(".obj"):
                        runtime_libs.append(f)
                    elif path.endswith(".dll"):
                        # Private SDK DLLs (System.Private.CoreLib, etc.) are ILC refs
                        framework_files.append(f)
                elif "/lib/" in path and path.endswith(".dll"):
                    framework_files.append(f)
    else:
        # net8.0 mode: everything comes from the ILCompiler package
        for f in ilcompiler_files:
            path = f.path
            if "/framework/" in path and path.endswith(".dll"):
                framework_files.append(f)
            if "/sdk/" in path:
                if path.endswith(".a") or path.endswith(".lib") or path.endswith(".o") or path.endswith(".obj"):
                    runtime_libs.append(f)
                elif path.endswith(".dll"):
                    # Private SDK DLLs in sdk/ dir
                    framework_files.append(f)

    if ilc == None:
        fail("Could not find ILC compiler in ILCompiler pack: %s" % ctx.attr.ilcompiler_pack.label)

    return [DotnetNativeAotPackInfo(
        ilc = ilc,
        ilc_files = depset(ilc_files),
        framework_files = framework_files,
        runtime_libs = runtime_libs,
        mibc_files = mibc_files,
    )]

nativeaot_nuget_pack = rule(
    _nativeaot_nuget_pack_impl,
    doc = """Creates a DotnetNativeAotPackInfo from NativeAOT NuGet packages.
    
    For net8.0: only ilcompiler_pack is needed (contains ILC + framework + SDK + MIBC).
    For net9.0+: both ilcompiler_pack (ILC + MIBC) and runtime_pack (framework + native libs) are needed.""",
    attrs = {
        "ilcompiler_pack": attr.label(
            doc = "The runtime.{rid}.Microsoft.DotNet.ILCompiler NuGet package (ILC compiler + native SDK + MIBC)",
            mandatory = False,
        ),
        "runtime_pack": attr.label(
            doc = "The Microsoft.NETCore.App.Runtime.NativeAOT.{rid} NuGet package (managed framework + native interop libs). Required for net9.0+, unused for net8.0.",
            mandatory = False,
        ),
        "target_framework": attr.string(
            doc = "The target framework of the NativeAOT pack",
        ),
        "runtime_identifier": attr.string(
            doc = "The runtime identifier of the NativeAOT pack",
        ),
    },
)
