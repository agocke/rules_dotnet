"""
Rules for compiling and running NUnit tests.

This rule is a macro that has the same attributes as `csharp_test`
"""

load("//dotnet/private/rules/csharp:test.bzl", "csharp_test")

_SHARED_COMPILATION_WORKER = "//dotnet/private/tools/compiler_worker"

def csharp_nunit_test(**kwargs):
    # TODO: This should be user configurable
    deps = kwargs.pop("deps", []) + [
        Label("@paket.rules_dotnet_nuget_packages//nunitlite"),
        Label("@paket.rules_dotnet_nuget_packages//nunit"),
    ]

    srcs = kwargs.pop("srcs", []) + [
        Label("//dotnet/private/rules/common/nunit:shim.cs"),
    ]

    use_shared_compilation = kwargs.pop("use_shared_compilation", False)

    csharp_test(
        srcs = srcs,
        deps = deps,
        use_shared_compilation = use_shared_compilation,
        shared_compilation_worker = _SHARED_COMPILATION_WORKER if use_shared_compilation else None,
        **kwargs
    )
