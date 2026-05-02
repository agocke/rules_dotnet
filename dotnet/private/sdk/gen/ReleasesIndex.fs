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
