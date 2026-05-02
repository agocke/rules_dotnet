module ReleasesIndex

open System.Net.Http
open System.Text.Json
open System.Text.Json.Serialization
open System.Collections.Generic

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
/// If any of these don't exist at the advertised version, the channel is skipped.
let private probePackages =
    [ "Microsoft.NETCore.App.Runtime.linux-x64"       // runtime pack
      "Microsoft.NETCore.App.Host.linux-x64"          // apphost pack
      "Microsoft.NETCore.App.Ref"                     // targeting pack
      "runtime.linux-x64.Microsoft.DotNet.ILCompiler" // NativeAOT ILCompiler
    ]

/// Checks whether a specific package+version exists on NuGet using the flat container API.
let private nugetPackageExists (client: HttpClient) (packageId: string) (version: string) =
    let url =
        $"https://api.nuget.org/v3-flatcontainer/{packageId.ToLower()}/{version.ToLower()}/{packageId.ToLower()}.{version.ToLower()}.nupkg"

    try
        let request = new HttpRequestMessage(HttpMethod.Head, url)
        let response = client.SendAsync(request).Result
        response.IsSuccessStatusCode
    with _ ->
        false

/// Verifies that representative NuGet packages exist for a channel's latest-runtime version.
/// Fails with an error if any probe package is missing.
let verifyChannelPackages (client: HttpClient) (channel: ChannelInfo) =
    let missing =
        probePackages
        |> List.filter (fun pkg -> not (nugetPackageExists client pkg channel.latestRuntime))

    if not missing.IsEmpty then
        eprintfn $"ERROR: Channel {channelToTfm channel.channelVersion} ({channel.latestRuntime}) — packages not found on NuGet:"

        for pkg in missing do
            eprintfn $"  - {pkg}"

        failwith (
            $"NuGet packages for {channelToTfm channel.channelVersion} {channel.latestRuntime} are not published yet. "
            + "The releases-index.json may be ahead of NuGet. Investigate and retry.")
