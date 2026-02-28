"Generated"

load(":dotnet.nativeaot_packs.bzl", _nativeaot_packs = "nativeaot_packs")

def _nativeaot_packs_impl(module_ctx):
    _nativeaot_packs()
    return module_ctx.extension_metadata(reproducible = True)

nativeaot_packs_extension = module_extension(
    implementation = _nativeaot_packs_impl,
)
