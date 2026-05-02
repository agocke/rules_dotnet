module ReleasesIndex

open System.Net.Http
open System.Text.Json
open System.Text.Json.Serialization

let private releasesIndexUrl =
    "https://raw.githubusercontent.com/dotnet/core/main/release-notes/releases-index.json"

[<CLIMutable>]
type ChannelInfo =
    { [<JsonPropertyName("channel-version")>]
      channelVersion: string
      [<JsonPropertyName("latest-runtime")>]
      latestRuntime: string
      [<JsonPropertyName("latest-sdk")>]
      latestSdk: string
      [<JsonPropertyName("support-phase")>]
      supportPhase: string
      [<JsonPropertyName("releases.json")>]
      releasesJson: string }

[<CLIMutable>]
type ReleasesIndexRoot =
    { [<JsonPropertyName("releases-index")>]
      releasesIndex: ChannelInfo[] }

/// Where the channel's packages come from.
type ChannelOrigin =
    | Released
    | Daily

/// A channel with its resolved package feed and origin.
type ResolvedChannel =
    { channel: ChannelInfo
      feedUrl: string
      origin: ChannelOrigin }

let nugetOrgFeed = "https://api.nuget.org/v3/index.json"

/// Fetches releases-index.json and returns active channels (>= 8.0, not EOL).
let fetchActiveChannels () =
    use client = new HttpClient()
    let json = client.GetStringAsync(releasesIndexUrl).Result
    let root = JsonSerializer.Deserialize<ReleasesIndexRoot>(json)

    root.releasesIndex
    |> Array.filter (fun c ->
        let parts = c.channelVersion.Split('.')

        match System.Int32.TryParse(parts.[0]) with
        | true, major -> major >= 8 && c.supportPhase <> "eol"
        | _ -> false)
    |> Array.toList

/// Wraps released channels with nuget.org feed.
let resolveReleasedChannels (channels: ChannelInfo list) : ResolvedChannel list =
    channels
    |> List.map (fun c ->
        { channel = c
          feedUrl = nugetOrgFeed
          origin = Released })

/// Creates a synthetic ResolvedChannel for a daily build.
let createDailyChannel (channelVersion: string) (version: string) (feedUrl: string) : ResolvedChannel =
    { channel =
        { channelVersion = channelVersion
          latestRuntime = version
          latestSdk = ""
          supportPhase = "daily"
          releasesJson = "" }
      feedUrl = feedUrl
      origin = Daily }

/// Merges daily overrides into resolved channels. Daily channels replace any
/// released channel with the same channel-version.
let mergeChannels (released: ResolvedChannel list) (daily: ResolvedChannel list) : ResolvedChannel list =
    let dailyByVersion =
        daily |> List.map (fun d -> (d.channel.channelVersion, d)) |> Map.ofList

    let merged =
        released
        |> List.map (fun r ->
            match dailyByVersion.TryFind r.channel.channelVersion with
            | Some d -> d
            | None -> r)

    // Add any daily channels that don't exist in released
    let releasedVersions = released |> List.map (fun r -> r.channel.channelVersion) |> Set.ofList

    let newDaily =
        daily |> List.filter (fun d -> not (releasedVersions.Contains d.channel.channelVersion))

    merged @ newDaily

/// Converts a channel-version (e.g., "11.0") to a TFM (e.g., "net11.0").
let channelToTfm (channelVersion: string) = $"net{channelVersion}"

/// Standard RIDs for apphost/runtime/targeting packs.
let standardRids =
    [ "linux-x64"
      "linux-arm64"
      "linux-musl-x64"
      "linux-musl-arm64"
      "osx-x64"
      "osx-arm64"
      "win-x64"
      "win-arm64" ]

/// NativeAOT RIDs (same as standard for most releases).
let nativeAotRids = standardRids

/// Returns whether a TFM uses a separate NativeAOT runtime pack (net9.0+).
let usesSeparateNativeAotRuntime (channelVersion: string) =
    match System.Int32.TryParse(channelVersion.Split('.').[0]) with
    | true, major -> major >= 9
    | _ -> false

/// Representative NuGet packages to probe per channel.
let private probePackages =
    [ "Microsoft.NETCore.App.Runtime.linux-x64"       // runtime pack
      "Microsoft.NETCore.App.Host.linux-x64"          // apphost pack
      "Microsoft.NETCore.App.Ref"                     // targeting pack
      "runtime.linux-x64.Microsoft.DotNet.ILCompiler" // NativeAOT ILCompiler
    ]

/// NuGet v3 flat container base URL for nuget.org.
let private nugetOrgFlatContainer =
    "https://api.nuget.org/v3-flatcontainer"

/// Resolves the flat container URL for a v3 feed by querying its service index.
let private resolveFlatContainer (client: HttpClient) (feedUrl: string) =
    try
        let json = client.GetStringAsync(feedUrl).Result
        let doc = JsonDocument.Parse(json)

        doc.RootElement
            .GetProperty("resources")
            .EnumerateArray()
        |> Seq.tryFind (fun r ->
            let t = r.GetProperty("@type").GetString()
            t = "PackageBaseAddress/3.0.0")
        |> Option.map (fun r -> r.GetProperty("@id").GetString().TrimEnd('/'))
        |> Option.defaultValue nugetOrgFlatContainer
    with _ ->
        nugetOrgFlatContainer

/// Checks whether a specific package+version exists on a NuGet feed.
let private packageExistsOnFeed (client: HttpClient) (flatContainerUrl: string) (packageId: string) (version: string) =
    let url =
        $"{flatContainerUrl}/{packageId.ToLower()}/{version.ToLower()}/{packageId.ToLower()}.{version.ToLower()}.nupkg"

    try
        let request = new HttpRequestMessage(HttpMethod.Head, url)
        let response = client.SendAsync(request).Result
        response.IsSuccessStatusCode
    with _ ->
        false

/// Verifies that representative NuGet packages exist for a resolved channel.
/// Fails with an error if any probe package is missing.
let verifyChannelPackages (client: HttpClient) (resolved: ResolvedChannel) =
    let flatContainer = resolveFlatContainer client resolved.feedUrl
    let version = resolved.channel.latestRuntime
    let tfm = channelToTfm resolved.channel.channelVersion

    let missing =
        probePackages
        |> List.filter (fun pkg -> not (packageExistsOnFeed client flatContainer pkg version))

    if not missing.IsEmpty then
        let originLabel =
            match resolved.origin with
            | Released -> "NuGet.org"
            | Daily -> resolved.feedUrl

        eprintfn $"ERROR: Channel {tfm} ({version}) — packages not found on {originLabel}:"

        for pkg in missing do
            eprintfn $"  - {pkg}"

        failwith (
            $"Packages for {tfm} {version} are not available on {originLabel}. "
            + "Check that the version is correct and packages are published.")
