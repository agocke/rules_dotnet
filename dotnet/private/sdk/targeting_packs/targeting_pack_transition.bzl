"A transition that transitions between compatible target frameworks"

load(":targeting_pack_lookup_table.bzl", "targeting_pack_lookup_table")

_OVERRIDE_FLAG = "//dotnet/private/sdk/targeting_packs:default_net10_0_pack_override"
_TARGETING_PACK = "//dotnet/private/sdk/targeting_packs:targeting_pack"
_TARGET_FRAMEWORK = "//dotnet:target_framework"

def _impl(settings, attr):
    project_sdk = attr.project_sdk
    incoming_target_framework = settings[_TARGET_FRAMEWORK]

    if attr.disable_implicit_framework_refs:
        return {_TARGETING_PACK: "empty_pack"}

    # Allow a downstream module (e.g. the .NET VMR) to substitute its own
    # targeting pack for default/net10.0 without modifying the lookup table.
    if project_sdk == "default" and incoming_target_framework == "net10.0":
        override = settings[_OVERRIDE_FLAG]
        if override:
            return {_TARGETING_PACK: override}

    supported_tfms = targeting_pack_lookup_table.get(project_sdk)
    if supported_tfms:
        targeting_pack = supported_tfms.get(incoming_target_framework)
        if targeting_pack:
            return {_TARGETING_PACK: targeting_pack}

    fail("No targeting pack found for project SDK/target framework: {}/{}".format(project_sdk, incoming_target_framework))

targeting_pack_transition = transition(
    implementation = _impl,
    inputs = [_TARGETING_PACK, _TARGET_FRAMEWORK, _OVERRIDE_FLAG],
    outputs = [_TARGETING_PACK],
)
