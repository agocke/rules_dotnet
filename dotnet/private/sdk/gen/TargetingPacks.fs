module TargetingPacks

open System.IO
open System.Text.Json
open System.Collections.Generic
open System.Text

type TargetingPack = { id: string; version: string }

let private targetingPackLabel projectSdk tfm =
    $"//dotnet/private/sdk/targeting_packs:{projectSdk}_{tfm}"

let updateTargetingPacks targetingPacksFile =
    let targetingPacks = File.ReadAllText targetingPacksFile

    let targetingPacks =
        JsonSerializer.Deserialize<Dictionary<string, Dictionary<string, TargetingPack[]>>>(targetingPacks)

    let updatedTargetingPacks =
        Dictionary<string, Dictionary<string, TargetingPack[]>>()

    for sdk in targetingPacks do
        let updatedtfmPacks = Dictionary<string, TargetingPack[]>()

        for tfmPacks in sdk.Value do
            let mutable updatedPacks: TargetingPack[] = Array.empty

            for pack in tfmPacks.Value do
                let majorVersion = pack.version.Split('.')[0]
                let featureVersion = pack.version.Split('.')[1]

                let latestVersion =
                    NugetHelpers.getAllVersions pack.id
                    |> List.filter (fun v -> v.ToFullString().StartsWith($"{majorVersion}.{featureVersion}"))
                    |> List.max

                let updatedPack =
                    { pack with
                        version = latestVersion.ToFullString() }

                updatedPacks <- Array.append updatedPacks [| updatedPack |]

            updatedtfmPacks.Add(tfmPacks.Key, updatedPacks |> Array.sortBy (fun p -> p.id))

        updatedTargetingPacks.Add(sdk.Key, updatedtfmPacks)

    let updatedTargetingPacksJson =
        JsonSerializer.Serialize(updatedTargetingPacks, options = JsonSerializerOptions(WriteIndented = true))

    File.WriteAllText(targetingPacksFile, updatedTargetingPacksJson)
    ()

let writeTargetingPackLookupTable targetingPacksFile output =
    let targetingPacksJson = File.ReadAllText targetingPacksFile

    let targetingPacks =
        JsonSerializer.Deserialize<Dictionary<string, Dictionary<string, TargetingPack[]>>>(targetingPacksJson)

    let lookupTable = Dictionary<string, Dictionary<string, string>>()

    for sdk in targetingPacks do
        lookupTable.Add(sdk.Key, Dictionary<string, string>())

        for tfmPacks in sdk.Value do
            let label = targetingPackLabel sdk.Key tfmPacks.Key
            lookupTable.[sdk.Key].Add(tfmPacks.Key, label)

    let lookupTableJson =
        JsonSerializer.Serialize(lookupTable, options = JsonSerializerOptions(WriteIndented = true))

    let sb = new StringBuilder()

    sb.AppendLine("\"GENERATED BY SDK GENERATOR\"") |> ignore
    sb.AppendLine() |> ignore
    sb.Append("targeting_pack_lookup_table = ") |> ignore
    sb.Append(lookupTableJson) |> ignore
    sb.Append("\n") |> ignore

    File.WriteAllText(output, sb.ToString())
    ()


let generateTargetingPackTargets targetingPacksFile output =
    let targetingPacksJson = File.ReadAllText targetingPacksFile

    let targetingPacks =
        JsonSerializer.Deserialize<Dictionary<string, Dictionary<string, TargetingPack[]>>>(targetingPacksJson)

    let sb = new StringBuilder()

    sb.AppendLine("\"GENERATED BY SDK GENERATOR\"") |> ignore
    sb.AppendLine() |> ignore

    sb.AppendLine("load(\"//dotnet/private/sdk/targeting_packs:targeting_pack.bzl\", \"targeting_pack\")")
    |> ignore

    sb.AppendLine() |> ignore
    sb.AppendLine("# buildifier: disable=unnamed-macro") |> ignore
    sb.AppendLine("def targeting_packs():") |> ignore
    sb.AppendLine("    \"\"\"Targeting packs\"\"\"") |> ignore
    sb.AppendLine() |> ignore

    for sdk in targetingPacks do
        for tfmPacks in sdk.Value do
            let packs =
                tfmPacks.Value
                |> Array.map (fun p -> $"\"@dotnet.targeting_packs//{p.id.ToLower()}.v{p.version}\"")
                |> String.concat ", "

            let label = $"{sdk.Key}_{tfmPacks.Key}"

            sb.AppendLine(
                $"    targeting_pack(name = \"{label}\", packs = [{packs}], target_framework = \"{tfmPacks.Key}\")"
            )
            |> ignore

    sb.AppendLine() |> ignore

    File.WriteAllText(output, sb.ToString())

let generateTargetingPacksNugetRepo (targetingPacksFile: string) (outputFolder: string) =
    let targetingPacksJson = File.ReadAllText targetingPacksFile

    let targetingPacks =
        JsonSerializer.Deserialize<Dictionary<string, Dictionary<string, TargetingPack[]>>>(targetingPacksJson)

    let repoPackages: NugetRepo.NugetRepoPackage seq =
        targetingPacks
        |> Seq.collect (fun sdk -> sdk.Value |> Seq.collect (fun tfmPacks -> tfmPacks.Value))
        |> Seq.distinctBy (fun p -> $"{p.id}.{p.version}")
        |> Seq.map (fun pack ->
            let packageInfo =
                NugetHelpers.getPackageInfo pack.id pack.version NugetHelpers.nugetV3Feed

            { name = $"{pack.id.ToLower()}.v{pack.version}"
              id = pack.id
              version = pack.version
              sha512 = packageInfo.sha512sri
              sources = [ NugetHelpers.nugetV3Feed ]
              netrc = None
              dependencies = Dictionary<string, string seq>()
              targeting_pack_overrides = packageInfo.overrides
              framework_list = packageInfo.frameworkList })

    NugetRepo.generateBazelFiles "targeting_packs" repoPackages outputFolder "dotnet."
    ()
