module DotnetPacks.Main

open System.IO

[<EntryPoint>]
let main argv =
    let sdkFolder = argv.[0]

    // Get the supported SDKs and generate sdk_versions.bzl
    Sdk.generateSdks (Path.Combine(sdkFolder, "versions.bzl"))

    // // Generate the RID graph
    Sdk.generateRids (Path.Combine(sdkFolder, "rids.bzl"))

    // Fetch active channels from releases-index.json
    printfn "Fetching releases-index.json..."
    let channels = ReleasesIndex.fetchActiveChannels ()

    for channel in channels do
        printfn $"  {ReleasesIndex.channelToTfm channel.channelVersion}: {channel.latestRuntime} ({channel.supportPhase})"

    // Generate the targeting pack targets
    let targetingPacksFile = Path.Combine(sdkFolder, "gen", "targeting-packs.json")
    TargetingPacks.updateTargetingPacks targetingPacksFile channels

    TargetingPacks.writeTargetingPackLookupTable
        targetingPacksFile
        (Path.Combine(sdkFolder, "targeting_packs", "targeting_pack_lookup_table.bzl"))

    TargetingPacks.generateTargetingPackTargets
        targetingPacksFile
        (Path.Combine(sdkFolder, "targeting_packs", "targeting_packs.bzl"))

    TargetingPacks.generateTargetingPacksNugetRepo targetingPacksFile (Path.Combine(sdkFolder, "targeting_packs"))

    // Generate the runtime pack targets
    let runtimePacksFile = Path.Combine(sdkFolder, "gen", "runtime-packs.json")
    RuntimePacks.updateRuntimePacks runtimePacksFile channels

    RuntimePacks.writeRuntimePackLookupTable
        runtimePacksFile
        (Path.Combine(sdkFolder, "runtime_packs", "runtime_pack_lookup_table.bzl"))

    RuntimePacks.generateRuntimePackTargets
        runtimePacksFile
        (Path.Combine(sdkFolder, "runtime_packs", "runtime_packs.bzl"))

    RuntimePacks.generateRuntimePacksNugetRepo runtimePacksFile (Path.Combine(sdkFolder, "runtime_packs"))

    // Generate the NativeAOT pack targets
    let nativeAotPacksFile = Path.Combine(sdkFolder, "gen", "nativeaot-packs.json")
    NativeAotPacks.updateNativeAotPacks nativeAotPacksFile channels

    NativeAotPacks.writeNativeAotPackLookupTable
        nativeAotPacksFile
        (Path.Combine(sdkFolder, "nativeaot_packs", "nativeaot_pack_lookup_table.bzl"))

    NativeAotPacks.generateNativeAotPackTargets
        nativeAotPacksFile
        (Path.Combine(sdkFolder, "nativeaot_packs", "nativeaot_packs.bzl"))

    NativeAotPacks.generateNativeAotPacksNugetRepo nativeAotPacksFile (Path.Combine(sdkFolder, "nativeaot_packs"))

    // Generate the apphost pack targets
    let apphostPacksFile = Path.Combine(sdkFolder, "gen", "apphost-packs.json")
    ApphostPacks.updateApphostPacks apphostPacksFile channels

    ApphostPacks.writeApphostPackLookupTable
        apphostPacksFile
        (Path.Combine(sdkFolder, "apphost_packs", "apphost_pack_lookup_table.bzl"))

    ApphostPacks.generateApphostPackTargets
        apphostPacksFile
        (Path.Combine(sdkFolder, "apphost_packs", "apphost_packs.bzl"))

    ApphostPacks.generateApphostPacksNugetRepo apphostPacksFile (Path.Combine(sdkFolder, "apphost_packs"))
    0
