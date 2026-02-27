"""
Rule for defining a NativeAOT compilation pack.

A NativeAOT pack contains:
- The ILC compiler executable and its dependencies
- Framework assemblies for NativeAOT compilation
- Static libraries for linking (bootstrapper, GC, native support)
- Optional PGO data files
"""

load("//dotnet/private:providers.bzl", "DotnetNativeAotPackInfo")

def _nativeaot_pack_impl(ctx):
    return [DotnetNativeAotPackInfo(
        ilc = ctx.executable.ilc,
        ilc_files = depset(
            [ctx.executable.ilc],
            transitive = [ctx.attr.ilc[DefaultInfo].default_runfiles.files] if ctx.attr.ilc[DefaultInfo].default_runfiles else [],
        ),
        framework_files = ctx.files.framework_files,
        runtime_libs = ctx.files.runtime_libs,
        mibc_files = ctx.files.mibc_files,
    )]

nativeaot_pack = rule(
    _nativeaot_pack_impl,
    doc = """Define a NativeAOT compilation pack.

    This rule packages together all the components needed for NativeAOT
    compilation: the ILC compiler, framework assemblies, and runtime
    static libraries for linking.

    The pack can be constructed from:
    - The .NET SDK (downloaded NuGet packages)
    - A locally-built ILC and NativeAOT runtime

    Example:
        ```starlark
        nativeaot_pack(
            name = "nativeaot",
            ilc = "//tools/ilc:ilc",
            framework_files = glob(["framework/*.dll"]),
            runtime_libs = glob(["sdk/*.a", "sdk/*.o"]),
        )
        ```
    """,
    attrs = {
        "ilc": attr.label(
            doc = "The ILC compiler executable.",
            executable = True,
            cfg = "exec",
            mandatory = True,
        ),
        "framework_files": attr.label_list(
            doc = "NativeAOT framework assemblies (System.Private.CoreLib, etc.).",
            allow_files = [".dll"],
            default = [],
        ),
        "runtime_libs": attr.label_list(
            doc = "Static libraries for native linking (bootstrapper, GC, native support). Can be cc_library targets or file labels.",
            allow_files = True,
            default = [],
        ),
        "mibc_files": attr.label_list(
            doc = "PGO optimization data files.",
            allow_files = [".mibc"],
            default = [],
        ),
    },
    provides = [DotnetNativeAotPackInfo],
)
