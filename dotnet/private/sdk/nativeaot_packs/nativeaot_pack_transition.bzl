"A transition that selects the correct NativeAOT pack based on TFM and RID"

load("//dotnet/private:common.bzl", "get_highest_compatible_runtime_identifier")
load(":nativeaot_pack_lookup_table.bzl", "nativeaot_pack_lookup_table")

def _impl(settings, _attr):
    incoming_target_framework = settings["//dotnet:target_framework"]
    incoming_rid = settings["//dotnet:rid"]

    supported_rids = nativeaot_pack_lookup_table.get(incoming_target_framework)
    if supported_rids:
        highest_compatible_rid = get_highest_compatible_runtime_identifier(incoming_rid, supported_rids.keys())
        nativeaot_pack = supported_rids.get(highest_compatible_rid)
        if nativeaot_pack:
            return {"//dotnet/private/sdk/nativeaot_packs:nativeaot_pack": nativeaot_pack}

    # NativeAOT is not available for all TFMs (only net8.0+), so return the empty pack
    return {"//dotnet/private/sdk/nativeaot_packs:nativeaot_pack": "//dotnet/private/sdk/nativeaot_packs:empty_pack"}

nativeaot_pack_transition = transition(
    implementation = _impl,
    inputs = ["//dotnet/private/sdk/nativeaot_packs:nativeaot_pack", "//dotnet:target_framework", "//dotnet:rid"],
    outputs = ["//dotnet/private/sdk/nativeaot_packs:nativeaot_pack"],
)
