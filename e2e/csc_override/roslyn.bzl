"Module extension to download the Microsoft.Net.Compilers.Toolset NuGet package"

def _roslyn_compiler_repo_impl(repository_ctx):
    repository_ctx.download_and_extract(
        url = "https://api.nuget.org/v3-flatcontainer/microsoft.net.compilers.toolset/4.12.0/microsoft.net.compilers.toolset.4.12.0.nupkg",
        sha256 = "fe24ef31a6ffcb7c49383d2fd362763dee291ad9b9d98cc0c19ef80203b99ebc",
        type = "zip",
    )

    repository_ctx.file("BUILD.bazel", "")

    repository_ctx.file("tasks/netcore/bincore/BUILD.bazel", """
filegroup(
    name = "bincore",
    srcs = glob(["**/*"]),
    visibility = ["//visibility:public"],
)
""")

_roslyn_compiler_repo = repository_rule(
    implementation = _roslyn_compiler_repo_impl,
)

def _roslyn_impl(module_ctx):
    _roslyn_compiler_repo(name = "roslyn_compiler")
    return module_ctx.extension_metadata(reproducible = True)

roslyn = module_extension(
    implementation = _roslyn_impl,
)
