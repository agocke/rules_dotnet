"""Public API surface is re-exported here.

Users should not load files under "/dotnet"
"""

load(
    "//dotnet/private/rules/csharp:binary.bzl",
    _csharp_binary = "csharp_binary",
    _compile_csharp_exe = "compile_csharp_exe",
)
load(
    "//dotnet/private/rules/csharp:library.bzl",
    _csharp_library = "csharp_library",
)
load(
    "//dotnet/private/rules/csharp:nunit_test.bzl",
    _csharp_nunit_test = "csharp_nunit_test",
)
load(
    "//dotnet/private/rules/csharp:test.bzl",
    _csharp_test = "csharp_test",
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
load(
    "//dotnet/private/sdk/targeting_packs:targeting_pack.bzl",
    _targeting_pack = "targeting_pack",
)

_SHARED_COMPILATION_WORKER = "//dotnet/private/tools/compiler_worker"

def csharp_binary(use_shared_compilation = False, **kwargs):
    _csharp_binary(
        use_shared_compilation = use_shared_compilation,
        shared_compilation_worker = _SHARED_COMPILATION_WORKER if use_shared_compilation else None,
        **kwargs
    )

def csharp_library(use_shared_compilation = False, **kwargs):
    _csharp_library(
        use_shared_compilation = use_shared_compilation,
        shared_compilation_worker = _SHARED_COMPILATION_WORKER if use_shared_compilation else None,
        **kwargs
    )

def csharp_test(use_shared_compilation = False, **kwargs):
    _csharp_test(
        use_shared_compilation = use_shared_compilation,
        shared_compilation_worker = _SHARED_COMPILATION_WORKER if use_shared_compilation else None,
        **kwargs
    )

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
targeting_pack = _targeting_pack
