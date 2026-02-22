"""Public API surface is re-exported here.

Users should not load files under "/dotnet"
"""

load(
    "//dotnet/private/rules/csharp:binary.bzl",
    _csharp_binary_rule = "csharp_binary",
    _compile_csharp_exe = "compile_csharp_exe",
)
load(
    "//dotnet/private/rules/csharp:library.bzl",
    _csharp_library_rule = "csharp_library",
)
load(
    "//dotnet/private/rules/csharp:nunit_test.bzl",
    _csharp_nunit_test = "csharp_nunit_test",
)
load(
    "//dotnet/private/rules/csharp:test.bzl",
    _csharp_test_rule = "csharp_test",
)
load(
    "//dotnet/private/rules/fsharp:binary.bzl",
    _fsharp_binary = "fsharp_binary",
)
load(
    "//dotnet/private/rules/fsharp:library.bzl",
    _fsharp_library = "fsharp_library",
)
load(
    "//dotnet/private/rules/fsharp:nunit_test.bzl",
    _fsharp_nunit_test = "fsharp_nunit_test",
)
load(
    "//dotnet/private/rules/fsharp:test.bzl",
    _fsharp_test = "fsharp_test",
)
load(
    "//dotnet/private/rules/nuget:dotnet_tool.bzl",
    _dotnet_tool = "dotnet_tool",
)
load(
    "//dotnet/private/rules/nuget:imports.bzl",
    _import_dll = "import_dll",
    _import_library = "import_library",
)
load(
    "//dotnet/private/rules/nuget:nuget_archive.bzl",
    _nuget_archive = "nuget_archive",
)
load(
    "//dotnet/private/rules/nuget:nuget_repo.bzl",
    _nuget_repo = "nuget_repo",
)
load(
    "//dotnet/private/rules/publish_binary:publish_binary.bzl",
    _publish_binary = "publish_binary",
)

_COMPILER_WORKER_SELECT = select({
    "//dotnet/settings:use_compiler_worker_enabled": Label("//dotnet/private/tools/compiler_worker"),
    "//conditions:default": None,
})

def csharp_binary(name, compiler_worker = _COMPILER_WORKER_SELECT, **kwargs):
    """Compile a C# exe. Wraps the underlying rule to enable persistent worker compilation.

    Args:
        name: Target name.
        compiler_worker: The compiler worker binary. Automatically set based on the
            use_compiler_worker flag. Set to None to disable worker compilation for this target.
        **kwargs: Additional arguments passed to the underlying csharp_binary rule.
    """
    _csharp_binary_rule(name = name, compiler_worker = compiler_worker, **kwargs)

def csharp_library(name, compiler_worker = _COMPILER_WORKER_SELECT, **kwargs):
    """Compile a C# library. Wraps the underlying rule to enable persistent worker compilation.

    Args:
        name: Target name.
        compiler_worker: The compiler worker binary. Automatically set based on the
            use_compiler_worker flag. Set to None to disable worker compilation for this target.
        **kwargs: Additional arguments passed to the underlying csharp_library rule.
    """
    _csharp_library_rule(name = name, compiler_worker = compiler_worker, **kwargs)

def csharp_test(name, compiler_worker = _COMPILER_WORKER_SELECT, **kwargs):
    """Compile a C# test. Wraps the underlying rule to enable persistent worker compilation.

    Args:
        name: Target name.
        compiler_worker: The compiler worker binary. Automatically set based on the
            use_compiler_worker flag. Set to None to disable worker compilation for this target.
        **kwargs: Additional arguments passed to the underlying csharp_test rule.
    """
    _csharp_test_rule(name = name, compiler_worker = compiler_worker, **kwargs)

compile_csharp_exe = _compile_csharp_exe
csharp_nunit_test = _csharp_nunit_test
fsharp_binary = _fsharp_binary
fsharp_library = _fsharp_library
fsharp_test = _fsharp_test
fsharp_nunit_test = _fsharp_nunit_test
publish_binary = _publish_binary
import_library = _import_library
import_dll = _import_dll
nuget_repo = _nuget_repo
nuget_archive = _nuget_archive
dotnet_tool = _dotnet_tool
