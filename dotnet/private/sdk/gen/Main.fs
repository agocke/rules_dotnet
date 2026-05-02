module DotnetPacks.Main

open System.IO

/// Parses --daily <channel-version> <version> <feed-url> triplets from argv.
let private parseDailyArgs (argv: string[]) =
    let mutable i = 1 // skip argv.[0] which is sdkFolder
    let mutable dailyChannels = []

    while i < argv.Length do
        if argv.[i] = "--daily" then
            if i + 3 >= argv.Length then
                failwith "Usage: --daily <channel-version> <version> <feed-url>"

            let channelVersion = argv.[i + 1]
            let version = argv.[i + 2]
            let feedUrl = argv.[i + 3]

            // Validate channel-version format (e.g., "11.0")
            let parts = channelVersion.Split('.')

            match System.Int32.TryParse(parts.[0]) with
            | true, _ -> ()
            | _ -> failwith $"Invalid channel-version: {channelVersion}. Expected format: N.N (e.g., 11.0)"

            // Validate version starts with channel-version
            if not (version.StartsWith(channelVersion)) then
                failwith $"Version {version} does not match channel {channelVersion}"

            printfn $"  Daily override: {channelVersion} -> {version} from {feedUrl}"
            dailyChannels <- ReleasesIndex.createDailyChannel channelVersion version feedUrl :: dailyChannels
            i <- i + 4
        else
            i <- i + 1

    dailyChannels |> List.rev

[<EntryPoint>]
let main argv =
    let sdkFolder = argv.[0]

    // Get the supported SDKs and generate sdk_versions.bzl
    Sdk.generateSdks (Path.Combine(sdkFolder, "versions.bzl"))

    // // Generate the RID graph
    Sdk.generateRids (Path.Combine(sdkFolder, "rids.bzl"))

    // Fetch active channels from releases-index.json
    printfn "Fetching releases-index.json..."
    let releasedChannels = ReleasesIndex.fetchActiveChannels ()
    let resolvedReleased = ReleasesIndex.resolveReleasedChannels releasedChannels

    for r in resolvedReleased do
        printfn $"  {ReleasesIndex.channelToTfm r.channel.channelVersion}: {r.channel.latestRuntime} ({r.channel.supportPhase})"

    // Parse any --daily overrides
    let dailyChannels = parseDailyArgs argv

    // Merge daily overrides with released channels
    let channels = ReleasesIndex.mergeChannels resolvedReleased dailyChannels

    if not dailyChannels.IsEmpty then
        printfn "Merged channels:"

        for r in channels do
            let origin =
                match r.origin with
                | ReleasesIndex.Released -> "released"
                | ReleasesIndex.Daily -> "daily"

            printfn $"  {ReleasesIndex.channelToTfm r.channel.channelVersion}: {r.channel.latestRuntime} ({origin})"

    // Verify that NuGet packages exist for each channel's version
    printfn "Verifying NuGet package availability..."
    use httpClient = new System.Net.Http.HttpClient()

    for resolved in channels do
        printfn $"  Checking {ReleasesIndex.channelToTfm resolved.channel.channelVersion} ({resolved.channel.latestRuntime})..."
        ReleasesIndex.verifyChannelPackages httpClient resolved

    printfn "All channels verified."

    // Build a version -> feed URL map for NuGet repo generation
    let versionFeedMap =
        channels
        |> List.map (fun r -> (r.channel.latestRuntime, r.feedUrl))
        |> Map.ofList

    // Generate the targeting pack targets
    let targetingPacksFile = Path.Combine(sdkFolder, "gen", "targeting-packs.json")
    TargetingPacks.updateTargetingPacks targetingPacksFile channels

    TargetingPacks.writeTargetingPackLookupTable
        targetingPacksFile
        (Path.Combine(sdkFolder, "targeting_packs", "targeting_pack_lookup_table.bzl"))

    TargetingPacks.generateTargetingPackTargets
        targetingPacksFile
        (Path.Combine(sdkFolder, "targeting_packs", "targeting_packs.bzl"))

    TargetingPacks.generateTargetingPacksNugetRepo targetingPacksFile (Path.Combine(sdkFolder, "targeting_packs")) versionFeedMap

    // Generate the runtime pack targets
    let runtimePacksFile = Path.Combine(sdkFolder, "gen", "runtime-packs.json")
    RuntimePacks.updateRuntimePacks runtimePacksFile channels

    RuntimePacks.writeRuntimePackLookupTable
        runtimePacksFile
        (Path.Combine(sdkFolder, "runtime_packs", "runtime_pack_lookup_table.bzl"))

    RuntimePacks.generateRuntimePackTargets
        runtimePacksFile
        (Path.Combine(sdkFolder, "runtime_packs", "runtime_packs.bzl"))

    RuntimePacks.generateRuntimePacksNugetRepo runtimePacksFile (Path.Combine(sdkFolder, "runtime_packs")) versionFeedMap

    // Generate the NativeAOT pack targets
    let nativeAotPacksFile = Path.Combine(sdkFolder, "gen", "nativeaot-packs.json")
    NativeAotPacks.updateNativeAotPacks nativeAotPacksFile channels

    NativeAotPacks.writeNativeAotPackLookupTable
        nativeAotPacksFile
        (Path.Combine(sdkFolder, "nativeaot_packs", "nativeaot_pack_lookup_table.bzl"))

    NativeAotPacks.generateNativeAotPackTargets
        nativeAotPacksFile
        (Path.Combine(sdkFolder, "nativeaot_packs", "nativeaot_packs.bzl"))

    NativeAotPacks.generateNativeAotPacksNugetRepo nativeAotPacksFile (Path.Combine(sdkFolder, "nativeaot_packs")) versionFeedMap

    // Generate the apphost pack targets
    let apphostPacksFile = Path.Combine(sdkFolder, "gen", "apphost-packs.json")
    ApphostPacks.updateApphostPacks apphostPacksFile channels

    ApphostPacks.writeApphostPackLookupTable
        apphostPacksFile
        (Path.Combine(sdkFolder, "apphost_packs", "apphost_pack_lookup_table.bzl"))

    ApphostPacks.generateApphostPackTargets
        apphostPacksFile
        (Path.Combine(sdkFolder, "apphost_packs", "apphost_packs.bzl"))

    ApphostPacks.generateApphostPacksNugetRepo apphostPacksFile (Path.Combine(sdkFolder, "apphost_packs")) versionFeedMap
    0
