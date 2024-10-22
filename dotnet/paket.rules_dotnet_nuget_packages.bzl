"GENERATED"

load("@rules_dotnet//dotnet:defs.bzl", "nuget_repo")

def rules_dotnet_nuget_packages():
    "rules_dotnet_nuget_packages"
    nuget_repo(
        name = "paket.rules_dotnet_nuget_packages",
        packages = [
            {"name": "McMaster.Extensions.CommandLineUtils", "id": "McMaster.Extensions.CommandLineUtils", "version": "2.5.0", "sha512": "sha512-00uJOWYKPCPqDB6RxyOLXNnoPGeRmzKTZhu5OdZJaWn5+JV/n6mzB3/M+Z1yMpkabag3Lym9S11G/ITLrptOiw==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": [], "net462": [], "net47": [], "net471": [], "net472": [], "net48": [], "net5.0": ["System.ComponentModel.Annotations"], "net6.0": ["System.ComponentModel.Annotations"], "net7.0": ["System.ComponentModel.Annotations"], "net8.0": ["System.ComponentModel.Annotations"], "netcoreapp1.0": ["System.ComponentModel.Annotations"], "netcoreapp1.1": ["System.ComponentModel.Annotations"], "netcoreapp2.0": ["System.ComponentModel.Annotations"], "netcoreapp2.1": ["System.ComponentModel.Annotations"], "netcoreapp2.2": ["System.ComponentModel.Annotations"], "netcoreapp3.0": ["System.ComponentModel.Annotations"], "netcoreapp3.1": ["System.ComponentModel.Annotations"], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": ["System.ComponentModel.Annotations"], "netstandard2.0": ["System.ComponentModel.Annotations"], "netstandard2.1": ["System.ComponentModel.Annotations"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "Microsoft.NETCore.Platforms", "id": "Microsoft.NETCore.Platforms", "version": "7.0.4", "sha512": "sha512-mcQWjuDBh4WHGG4WcBI0k025WAdA2afMm6fs42sm1f+3gRyNQUiuMVT5gAWNUGSHmlu6qn/TCnAQpfl4Gm6cBw==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": [], "net462": [], "net47": [], "net471": [], "net472": [], "net48": [], "net5.0": [], "net6.0": [], "net7.0": [], "net8.0": [], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": [], "netcoreapp2.1": [], "netcoreapp2.2": [], "netcoreapp3.0": [], "netcoreapp3.1": [], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": [], "netstandard2.1": []}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "Microsoft.Web.Xdt", "id": "Microsoft.Web.Xdt", "version": "3.1.0", "sha512": "sha512-3VApgkdgOglJWtrXSgYzz6o8Cp6IpvmFQMeICyQvvbKoy+OjNwco5ovzBBL1HHj7kEgLfe2ruXW/ZQ1k+2YxYw==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": [], "net462": [], "net47": [], "net471": [], "net472": [], "net48": [], "net5.0": [], "net6.0": [], "net7.0": [], "net8.0": [], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": [], "netcoreapp2.1": [], "netcoreapp2.2": [], "netcoreapp3.0": [], "netcoreapp3.1": [], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": [], "netstandard2.1": []}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "NETStandard.Library", "id": "NETStandard.Library", "version": "2.0.3", "sha512": "sha512-548M6mnBSJWxsIlkQHfbzoYxpiYFXZZSL00p4GHYv8PkiqFBnnT68mW5mGEsA/ch9fDO9GkPgkFQpWiXZN7mAQ==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": ["Microsoft.NETCore.Platforms"], "net451": ["Microsoft.NETCore.Platforms"], "net452": ["Microsoft.NETCore.Platforms"], "net46": ["Microsoft.NETCore.Platforms"], "net461": ["Microsoft.NETCore.Platforms"], "net462": ["Microsoft.NETCore.Platforms"], "net47": ["Microsoft.NETCore.Platforms"], "net471": ["Microsoft.NETCore.Platforms"], "net472": ["Microsoft.NETCore.Platforms"], "net48": ["Microsoft.NETCore.Platforms"], "net5.0": ["Microsoft.NETCore.Platforms"], "net6.0": ["Microsoft.NETCore.Platforms"], "net7.0": ["Microsoft.NETCore.Platforms"], "net8.0": ["Microsoft.NETCore.Platforms"], "netcoreapp1.0": ["Microsoft.NETCore.Platforms"], "netcoreapp1.1": ["Microsoft.NETCore.Platforms"], "netcoreapp2.0": ["Microsoft.NETCore.Platforms"], "netcoreapp2.1": ["Microsoft.NETCore.Platforms"], "netcoreapp2.2": ["Microsoft.NETCore.Platforms"], "netcoreapp3.0": ["Microsoft.NETCore.Platforms"], "netcoreapp3.1": ["Microsoft.NETCore.Platforms"], "netstandard": [], "netstandard1.0": ["Microsoft.NETCore.Platforms"], "netstandard1.1": ["Microsoft.NETCore.Platforms"], "netstandard1.2": ["Microsoft.NETCore.Platforms"], "netstandard1.3": ["Microsoft.NETCore.Platforms"], "netstandard1.4": ["Microsoft.NETCore.Platforms"], "netstandard1.5": ["Microsoft.NETCore.Platforms"], "netstandard1.6": ["Microsoft.NETCore.Platforms"], "netstandard2.0": ["Microsoft.NETCore.Platforms"], "netstandard2.1": ["Microsoft.NETCore.Platforms"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "Newtonsoft.Json", "id": "Newtonsoft.Json", "version": "13.0.3", "sha512": "sha512-mbJSvHfRxfX3tR/U6n1WU+mWHXswYc+SB/hkOpx8yZZe68hNZGfymJu0cjsaJEkVzCMqePiU6LdIyogqfIn7kg==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": [], "net462": [], "net47": [], "net471": [], "net472": [], "net48": [], "net5.0": [], "net6.0": [], "net7.0": [], "net8.0": [], "netcoreapp1.0": ["NETStandard.Library"], "netcoreapp1.1": ["NETStandard.Library"], "netcoreapp2.0": [], "netcoreapp2.1": [], "netcoreapp2.2": [], "netcoreapp3.0": [], "netcoreapp3.1": [], "netstandard": [], "netstandard1.0": ["NETStandard.Library"], "netstandard1.1": ["NETStandard.Library"], "netstandard1.2": ["NETStandard.Library"], "netstandard1.3": ["NETStandard.Library"], "netstandard1.4": ["NETStandard.Library"], "netstandard1.5": ["NETStandard.Library"], "netstandard1.6": ["NETStandard.Library"], "netstandard2.0": [], "netstandard2.1": []}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "NuGet.Commands", "id": "NuGet.Commands", "version": "5.10.0", "sha512": "sha512-Q7ANXnmLUPC4pWgCZjBy2R7vRDABiaJz5NsBtoErE0dLylx/zQWRMyoa+m4Y478SKvUpt7S1V7LhAOlMRCTPpg==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": ["NuGet.Credentials", "NuGet.ProjectModel"], "net462": ["NuGet.Credentials", "NuGet.ProjectModel"], "net47": ["NuGet.Credentials", "NuGet.ProjectModel"], "net471": ["NuGet.Credentials", "NuGet.ProjectModel"], "net472": ["NuGet.Credentials", "NuGet.ProjectModel"], "net48": ["NuGet.Credentials", "NuGet.ProjectModel"], "net5.0": ["NuGet.Credentials", "NuGet.ProjectModel"], "net6.0": ["NuGet.Credentials", "NuGet.ProjectModel"], "net7.0": ["NuGet.Credentials", "NuGet.ProjectModel"], "net8.0": ["NuGet.Credentials", "NuGet.ProjectModel"], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": ["NuGet.Credentials", "NuGet.ProjectModel"], "netcoreapp2.1": ["NuGet.Credentials", "NuGet.ProjectModel"], "netcoreapp2.2": ["NuGet.Credentials", "NuGet.ProjectModel"], "netcoreapp3.0": ["NuGet.Credentials", "NuGet.ProjectModel"], "netcoreapp3.1": ["NuGet.Credentials", "NuGet.ProjectModel"], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": ["NuGet.Credentials", "NuGet.ProjectModel"], "netstandard2.1": ["NuGet.Credentials", "NuGet.ProjectModel"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "NuGet.Common", "id": "NuGet.Common", "version": "5.10.0", "sha512": "sha512-8M9VtXAB1M15KmvL0F9QsItI96PH3WmYD0z3oxYm5H9G5AIhK8Ivi4kGzqtBJDTsZ/NkP91U1MnoCAeg4E4+zA==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": ["NuGet.Frameworks"], "net451": ["NuGet.Frameworks"], "net452": ["NuGet.Frameworks"], "net46": ["NuGet.Frameworks"], "net461": ["NuGet.Frameworks"], "net462": ["NuGet.Frameworks"], "net47": ["NuGet.Frameworks"], "net471": ["NuGet.Frameworks"], "net472": ["NuGet.Frameworks"], "net48": ["NuGet.Frameworks"], "net5.0": ["NuGet.Frameworks"], "net6.0": ["NuGet.Frameworks"], "net7.0": ["NuGet.Frameworks"], "net8.0": ["NuGet.Frameworks"], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": ["NuGet.Frameworks"], "netcoreapp2.1": ["NuGet.Frameworks"], "netcoreapp2.2": ["NuGet.Frameworks"], "netcoreapp3.0": ["NuGet.Frameworks"], "netcoreapp3.1": ["NuGet.Frameworks"], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": ["NuGet.Frameworks"], "netstandard2.1": ["NuGet.Frameworks"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "NuGet.Configuration", "id": "NuGet.Configuration", "version": "5.10.0", "sha512": "sha512-ZJc2HY/D+UEk2U0jxamyBhUbKl2bgluViM/tnP4ObIIfJpOj8dHEJ6xzggulIGDlhe+ItK6yc+sqtCb6qV5+gw==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": ["NuGet.Common"], "net451": ["NuGet.Common"], "net452": ["NuGet.Common"], "net46": ["NuGet.Common"], "net461": ["NuGet.Common"], "net462": ["NuGet.Common"], "net47": ["NuGet.Common"], "net471": ["NuGet.Common"], "net472": ["NuGet.Common"], "net48": ["NuGet.Common"], "net5.0": ["NuGet.Common", "System.Security.Cryptography.ProtectedData"], "net6.0": ["NuGet.Common", "System.Security.Cryptography.ProtectedData"], "net7.0": ["NuGet.Common", "System.Security.Cryptography.ProtectedData"], "net8.0": ["NuGet.Common", "System.Security.Cryptography.ProtectedData"], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": ["NuGet.Common", "System.Security.Cryptography.ProtectedData"], "netcoreapp2.1": ["NuGet.Common", "System.Security.Cryptography.ProtectedData"], "netcoreapp2.2": ["NuGet.Common", "System.Security.Cryptography.ProtectedData"], "netcoreapp3.0": ["NuGet.Common", "System.Security.Cryptography.ProtectedData"], "netcoreapp3.1": ["NuGet.Common", "System.Security.Cryptography.ProtectedData"], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": ["NuGet.Common", "System.Security.Cryptography.ProtectedData"], "netstandard2.1": ["NuGet.Common", "System.Security.Cryptography.ProtectedData"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "NuGet.Credentials", "id": "NuGet.Credentials", "version": "5.10.0", "sha512": "sha512-r/fzn5yJaCXyChbhxbGZ5d/4xV4n3NIjVdE3odLfQy0znmcYRCDIfjYGu5l7vO9Nx27F+q7YA+9QmG9sucxX9A==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": ["NuGet.Protocol"], "net462": ["NuGet.Protocol"], "net47": ["NuGet.Protocol"], "net471": ["NuGet.Protocol"], "net472": ["NuGet.Protocol"], "net48": ["NuGet.Protocol"], "net5.0": ["NuGet.Protocol"], "net6.0": ["NuGet.Protocol"], "net7.0": ["NuGet.Protocol"], "net8.0": ["NuGet.Protocol"], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": ["NuGet.Protocol"], "netcoreapp2.1": ["NuGet.Protocol"], "netcoreapp2.2": ["NuGet.Protocol"], "netcoreapp3.0": ["NuGet.Protocol"], "netcoreapp3.1": ["NuGet.Protocol"], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": ["NuGet.Protocol"], "netstandard2.1": ["NuGet.Protocol"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "NuGet.DependencyResolver.Core", "id": "NuGet.DependencyResolver.Core", "version": "5.10.0", "sha512": "sha512-+9mCFiBhnm5C2Cb3dtHaHyv/WarSr5HwRi2NaoVJgudpHoK3B9uy8wB7PNnUos0kOghZmVslemeLsmw7icQqTw==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": ["NuGet.LibraryModel", "NuGet.Protocol"], "net462": ["NuGet.LibraryModel", "NuGet.Protocol"], "net47": ["NuGet.LibraryModel", "NuGet.Protocol"], "net471": ["NuGet.LibraryModel", "NuGet.Protocol"], "net472": ["NuGet.LibraryModel", "NuGet.Protocol"], "net48": ["NuGet.LibraryModel", "NuGet.Protocol"], "net5.0": ["NuGet.LibraryModel", "NuGet.Protocol"], "net6.0": ["NuGet.LibraryModel", "NuGet.Protocol"], "net7.0": ["NuGet.LibraryModel", "NuGet.Protocol"], "net8.0": ["NuGet.LibraryModel", "NuGet.Protocol"], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": ["NuGet.LibraryModel", "NuGet.Protocol"], "netcoreapp2.1": ["NuGet.LibraryModel", "NuGet.Protocol"], "netcoreapp2.2": ["NuGet.LibraryModel", "NuGet.Protocol"], "netcoreapp3.0": ["NuGet.LibraryModel", "NuGet.Protocol"], "netcoreapp3.1": ["NuGet.LibraryModel", "NuGet.Protocol"], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": ["NuGet.LibraryModel", "NuGet.Protocol"], "netstandard2.1": ["NuGet.LibraryModel", "NuGet.Protocol"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "NuGet.Frameworks", "id": "NuGet.Frameworks", "version": "5.10.0", "sha512": "sha512-l8KtHN2bzA391seLZ9Q2AWK0mbCHpfbwL1nmOSMDxBpWLxqh+nxMWaKL437bROpHltU+oP5LX/hc4Fxm89T9Tg==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": [], "net462": [], "net47": [], "net471": [], "net472": [], "net48": [], "net5.0": [], "net6.0": [], "net7.0": [], "net8.0": [], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": [], "netcoreapp2.1": [], "netcoreapp2.2": [], "netcoreapp3.0": [], "netcoreapp3.1": [], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": [], "netstandard2.1": []}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "NuGet.LibraryModel", "id": "NuGet.LibraryModel", "version": "5.10.0", "sha512": "sha512-xb8XLKJEMymZMAZJeXdSUaDNFRQMJ4MXkOPUaqafcgSKGz8M8BZgfLsBz9QCQVEyHIVYGbI4yroWZYed/c8xSg==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": ["NuGet.Common", "NuGet.Versioning"], "net462": ["NuGet.Common", "NuGet.Versioning"], "net47": ["NuGet.Common", "NuGet.Versioning"], "net471": ["NuGet.Common", "NuGet.Versioning"], "net472": ["NuGet.Common", "NuGet.Versioning"], "net48": ["NuGet.Common", "NuGet.Versioning"], "net5.0": ["NuGet.Common", "NuGet.Versioning"], "net6.0": ["NuGet.Common", "NuGet.Versioning"], "net7.0": ["NuGet.Common", "NuGet.Versioning"], "net8.0": ["NuGet.Common", "NuGet.Versioning"], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": ["NuGet.Common", "NuGet.Versioning"], "netcoreapp2.1": ["NuGet.Common", "NuGet.Versioning"], "netcoreapp2.2": ["NuGet.Common", "NuGet.Versioning"], "netcoreapp3.0": ["NuGet.Common", "NuGet.Versioning"], "netcoreapp3.1": ["NuGet.Common", "NuGet.Versioning"], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": ["NuGet.Common", "NuGet.Versioning"], "netstandard2.1": ["NuGet.Common", "NuGet.Versioning"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "NuGet.PackageManagement", "id": "NuGet.PackageManagement", "version": "5.10.0", "sha512": "sha512-Kr0CZuStXNsJRL86ecuWGhIHUhYy31rYZJ9WZ0tiFUaRwiPb7HpSQVsV/v3tqrKE7FWUZBpasX1bugXNqXcPjA==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": ["NuGet.Commands", "NuGet.Resolver", "Microsoft.Web.Xdt", "System.ComponentModel.Composition"], "net462": ["NuGet.Commands", "NuGet.Resolver", "Microsoft.Web.Xdt", "System.ComponentModel.Composition"], "net47": ["NuGet.Commands", "NuGet.Resolver", "Microsoft.Web.Xdt", "System.ComponentModel.Composition"], "net471": ["NuGet.Commands", "NuGet.Resolver", "Microsoft.Web.Xdt", "System.ComponentModel.Composition"], "net472": ["NuGet.Commands", "NuGet.Resolver", "Microsoft.Web.Xdt"], "net48": ["NuGet.Commands", "NuGet.Resolver", "Microsoft.Web.Xdt"], "net5.0": ["NuGet.Commands", "NuGet.Resolver", "Microsoft.Web.Xdt", "System.ComponentModel.Composition"], "net6.0": ["NuGet.Commands", "NuGet.Resolver", "Microsoft.Web.Xdt", "System.ComponentModel.Composition"], "net7.0": ["NuGet.Commands", "NuGet.Resolver", "Microsoft.Web.Xdt", "System.ComponentModel.Composition"], "net8.0": ["NuGet.Commands", "NuGet.Resolver", "Microsoft.Web.Xdt", "System.ComponentModel.Composition"], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": ["NuGet.Commands", "NuGet.Resolver", "Microsoft.Web.Xdt", "System.ComponentModel.Composition"], "netcoreapp2.1": ["NuGet.Commands", "NuGet.Resolver", "Microsoft.Web.Xdt", "System.ComponentModel.Composition"], "netcoreapp2.2": ["NuGet.Commands", "NuGet.Resolver", "Microsoft.Web.Xdt", "System.ComponentModel.Composition"], "netcoreapp3.0": ["NuGet.Commands", "NuGet.Resolver", "Microsoft.Web.Xdt", "System.ComponentModel.Composition"], "netcoreapp3.1": ["NuGet.Commands", "NuGet.Resolver", "Microsoft.Web.Xdt", "System.ComponentModel.Composition"], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": ["NuGet.Commands", "NuGet.Resolver", "Microsoft.Web.Xdt", "System.ComponentModel.Composition"], "netstandard2.1": ["NuGet.Commands", "NuGet.Resolver", "Microsoft.Web.Xdt", "System.ComponentModel.Composition"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "NuGet.Packaging", "id": "NuGet.Packaging", "version": "5.10.0", "sha512": "sha512-2HMq5gNgLMOHmqGb84pyEC7ctkCYBVXkhJfcYmHlkpo4FpDA6GQBoT//1h0Q4nGoybtgoBxiIbJu8VRn/9CZrQ==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": ["NuGet.Configuration", "NuGet.Versioning", "Newtonsoft.Json", "System.Security.Cryptography.Cng", "System.Security.Cryptography.Pkcs"], "net462": ["NuGet.Configuration", "NuGet.Versioning", "Newtonsoft.Json", "System.Security.Cryptography.Cng", "System.Security.Cryptography.Pkcs"], "net47": ["NuGet.Configuration", "NuGet.Versioning", "Newtonsoft.Json", "System.Security.Cryptography.Cng", "System.Security.Cryptography.Pkcs"], "net471": ["NuGet.Configuration", "NuGet.Versioning", "Newtonsoft.Json", "System.Security.Cryptography.Cng", "System.Security.Cryptography.Pkcs"], "net472": ["NuGet.Configuration", "NuGet.Versioning", "Newtonsoft.Json"], "net48": ["NuGet.Configuration", "NuGet.Versioning", "Newtonsoft.Json"], "net5.0": ["NuGet.Configuration", "NuGet.Versioning", "Newtonsoft.Json", "System.Security.Cryptography.Cng", "System.Security.Cryptography.Pkcs"], "net6.0": ["NuGet.Configuration", "NuGet.Versioning", "Newtonsoft.Json", "System.Security.Cryptography.Cng", "System.Security.Cryptography.Pkcs"], "net7.0": ["NuGet.Configuration", "NuGet.Versioning", "Newtonsoft.Json", "System.Security.Cryptography.Cng", "System.Security.Cryptography.Pkcs"], "net8.0": ["NuGet.Configuration", "NuGet.Versioning", "Newtonsoft.Json", "System.Security.Cryptography.Cng", "System.Security.Cryptography.Pkcs"], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": ["NuGet.Configuration", "NuGet.Versioning", "Newtonsoft.Json", "System.Security.Cryptography.Cng", "System.Security.Cryptography.Pkcs"], "netcoreapp2.1": ["NuGet.Configuration", "NuGet.Versioning", "Newtonsoft.Json", "System.Security.Cryptography.Cng", "System.Security.Cryptography.Pkcs"], "netcoreapp2.2": ["NuGet.Configuration", "NuGet.Versioning", "Newtonsoft.Json", "System.Security.Cryptography.Cng", "System.Security.Cryptography.Pkcs"], "netcoreapp3.0": ["NuGet.Configuration", "NuGet.Versioning", "Newtonsoft.Json", "System.Security.Cryptography.Cng", "System.Security.Cryptography.Pkcs"], "netcoreapp3.1": ["NuGet.Configuration", "NuGet.Versioning", "Newtonsoft.Json", "System.Security.Cryptography.Cng", "System.Security.Cryptography.Pkcs"], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": ["NuGet.Configuration", "NuGet.Versioning", "Newtonsoft.Json", "System.Security.Cryptography.Cng", "System.Security.Cryptography.Pkcs"], "netstandard2.1": ["NuGet.Configuration", "NuGet.Versioning", "Newtonsoft.Json", "System.Security.Cryptography.Cng", "System.Security.Cryptography.Pkcs"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "Nuget.Packaging.Core", "id": "Nuget.Packaging.Core", "version": "5.10.0", "sha512": "sha512-/WXGAbLb4T0pwEfEeY0j8zOVpS36OHNUANL95txANysbLoG7tUr9e+5je+Nfh3iIqzMaHIZXT6JKFvHOBwAotw==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": ["NuGet.Packaging"], "net462": ["NuGet.Packaging"], "net47": ["NuGet.Packaging"], "net471": ["NuGet.Packaging"], "net472": ["NuGet.Packaging"], "net48": ["NuGet.Packaging"], "net5.0": ["NuGet.Packaging"], "net6.0": ["NuGet.Packaging"], "net7.0": ["NuGet.Packaging"], "net8.0": ["NuGet.Packaging"], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": ["NuGet.Packaging"], "netcoreapp2.1": ["NuGet.Packaging"], "netcoreapp2.2": ["NuGet.Packaging"], "netcoreapp3.0": ["NuGet.Packaging"], "netcoreapp3.1": ["NuGet.Packaging"], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": ["NuGet.Packaging"], "netstandard2.1": ["NuGet.Packaging"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "NuGet.ProjectModel", "id": "NuGet.ProjectModel", "version": "5.10.0", "sha512": "sha512-gsZS2Kuat3ZjjPcBQ3Mc8QlRv6mP1OzNzkF4Dzybu3LgtG+kwvgQh4UMLbiIrko6WKbwVTbr8nQYpL+wsVZ4hA==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": ["NuGet.DependencyResolver.Core"], "net462": ["NuGet.DependencyResolver.Core"], "net47": ["NuGet.DependencyResolver.Core"], "net471": ["NuGet.DependencyResolver.Core"], "net472": ["NuGet.DependencyResolver.Core"], "net48": ["NuGet.DependencyResolver.Core"], "net5.0": ["NuGet.DependencyResolver.Core"], "net6.0": ["NuGet.DependencyResolver.Core"], "net7.0": ["NuGet.DependencyResolver.Core"], "net8.0": ["NuGet.DependencyResolver.Core"], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": ["NuGet.DependencyResolver.Core"], "netcoreapp2.1": ["NuGet.DependencyResolver.Core"], "netcoreapp2.2": ["NuGet.DependencyResolver.Core"], "netcoreapp3.0": ["NuGet.DependencyResolver.Core"], "netcoreapp3.1": ["NuGet.DependencyResolver.Core"], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": ["NuGet.DependencyResolver.Core"], "netstandard2.1": ["NuGet.DependencyResolver.Core"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "NuGet.Protocol", "id": "NuGet.Protocol", "version": "5.10.0", "sha512": "sha512-lY85Pgf7kr0JwTufdJmfDgBwN9BRQc96F4xxKrUGSALhuZRRC7y6f2RN1JQ0UTPIXlQx7HTG/h0UZEknQj3/UQ==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": ["NuGet.Packaging"], "net462": ["NuGet.Packaging"], "net47": ["NuGet.Packaging"], "net471": ["NuGet.Packaging"], "net472": ["NuGet.Packaging"], "net48": ["NuGet.Packaging"], "net5.0": ["NuGet.Packaging"], "net6.0": ["NuGet.Packaging"], "net7.0": ["NuGet.Packaging"], "net8.0": ["NuGet.Packaging"], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": ["NuGet.Packaging"], "netcoreapp2.1": ["NuGet.Packaging"], "netcoreapp2.2": ["NuGet.Packaging"], "netcoreapp3.0": ["NuGet.Packaging"], "netcoreapp3.1": ["NuGet.Packaging"], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": ["NuGet.Packaging"], "netstandard2.1": ["NuGet.Packaging"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "NuGet.Resolver", "id": "NuGet.Resolver", "version": "5.10.0", "sha512": "sha512-a2zWl9RkKDkcVUqfRJjz3O4uoPIWf3PGaFf6AntXtTKjvvsB6SZz8jjPSGdLgTTRIWzsFlybKp6yU+GaXeIQkg==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": ["NuGet.Protocol"], "net462": ["NuGet.Protocol"], "net47": ["NuGet.Protocol"], "net471": ["NuGet.Protocol"], "net472": ["NuGet.Protocol"], "net48": ["NuGet.Protocol"], "net5.0": ["NuGet.Protocol"], "net6.0": ["NuGet.Protocol"], "net7.0": ["NuGet.Protocol"], "net8.0": ["NuGet.Protocol"], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": ["NuGet.Protocol"], "netcoreapp2.1": ["NuGet.Protocol"], "netcoreapp2.2": ["NuGet.Protocol"], "netcoreapp3.0": ["NuGet.Protocol"], "netcoreapp3.1": ["NuGet.Protocol"], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": ["NuGet.Protocol"], "netstandard2.1": ["NuGet.Protocol"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "NuGet.Versioning", "id": "NuGet.Versioning", "version": "5.10.0", "sha512": "sha512-NW11tfXijCWeI8d71HKpNPKPzJqr30PtUyJHzCpKFMFTGZhsHh2YxgjKBuhpC5R59SMZUzqrFF5CgJ8uGaupqg==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": [], "net462": [], "net47": [], "net471": [], "net472": [], "net48": [], "net5.0": [], "net6.0": [], "net7.0": [], "net8.0": [], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": [], "netcoreapp2.1": [], "netcoreapp2.2": [], "netcoreapp3.0": [], "netcoreapp3.1": [], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": [], "netstandard2.1": []}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "NUnit", "id": "NUnit", "version": "3.12.0", "sha512": "sha512-HAhwFxr+Z+PJf8hXzc747NecvsDwEZ+3X8SA5+GIRM43GAy1Ap+TQPMHsWCnisfes5vPZ1/a2md/91u+shoTsQ==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": [], "net462": [], "net47": [], "net471": [], "net472": [], "net48": [], "net5.0": ["NETStandard.Library"], "net6.0": ["NETStandard.Library"], "net7.0": ["NETStandard.Library"], "net8.0": ["NETStandard.Library"], "netcoreapp1.0": ["NETStandard.Library"], "netcoreapp1.1": ["NETStandard.Library"], "netcoreapp2.0": ["NETStandard.Library"], "netcoreapp2.1": ["NETStandard.Library"], "netcoreapp2.2": ["NETStandard.Library"], "netcoreapp3.0": ["NETStandard.Library"], "netcoreapp3.1": ["NETStandard.Library"], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": ["NETStandard.Library"], "netstandard1.5": ["NETStandard.Library"], "netstandard1.6": ["NETStandard.Library"], "netstandard2.0": ["NETStandard.Library"], "netstandard2.1": ["NETStandard.Library"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "NUnitLite", "id": "NUnitLite", "version": "3.12.0", "sha512": "sha512-M9VVS4x3KURXFS4HTl2b7uJOX7vOi2wzpHACmNX6ANlBmb0/hIehJLciiVvddD3ubIIL81EF4Qk54kpsUOtVFQ==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": ["NUnit"], "net40": ["NUnit"], "net403": ["NUnit"], "net45": ["NUnit"], "net451": ["NUnit"], "net452": ["NUnit"], "net46": ["NUnit"], "net461": ["NUnit"], "net462": ["NUnit"], "net47": ["NUnit"], "net471": ["NUnit"], "net472": ["NUnit"], "net48": ["NUnit"], "net5.0": ["NUnit", "NETStandard.Library"], "net6.0": ["NUnit", "NETStandard.Library"], "net7.0": ["NUnit", "NETStandard.Library"], "net8.0": ["NUnit", "NETStandard.Library"], "netcoreapp1.0": ["NUnit", "NETStandard.Library"], "netcoreapp1.1": ["NUnit", "NETStandard.Library"], "netcoreapp2.0": ["NUnit", "NETStandard.Library"], "netcoreapp2.1": ["NUnit", "NETStandard.Library"], "netcoreapp2.2": ["NUnit", "NETStandard.Library"], "netcoreapp3.0": ["NUnit", "NETStandard.Library"], "netcoreapp3.1": ["NUnit", "NETStandard.Library"], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": ["NUnit", "NETStandard.Library"], "netstandard1.5": ["NUnit", "NETStandard.Library"], "netstandard1.6": ["NUnit", "NETStandard.Library"], "netstandard2.0": ["NUnit", "NETStandard.Library"], "netstandard2.1": ["NUnit", "NETStandard.Library"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "System.ComponentModel.Annotations", "id": "System.ComponentModel.Annotations", "version": "5.0.0", "sha512": "sha512-WJqsTGaXAc55EPGjJylPFXiNPs/x1t9dklVlHlIBxUEcIxIob6sRGm9Un7TehkyEFM+vKjZd7rbwaMH/znw1PA==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": [], "net462": [], "net47": [], "net471": [], "net472": [], "net48": [], "net5.0": [], "net6.0": [], "net7.0": [], "net8.0": [], "netcoreapp1.0": ["NETStandard.Library"], "netcoreapp1.1": ["NETStandard.Library"], "netcoreapp2.0": [], "netcoreapp2.1": [], "netcoreapp2.2": [], "netcoreapp3.0": [], "netcoreapp3.1": [], "netstandard": [], "netstandard1.0": [], "netstandard1.1": ["NETStandard.Library"], "netstandard1.2": ["NETStandard.Library"], "netstandard1.3": ["NETStandard.Library"], "netstandard1.4": ["NETStandard.Library"], "netstandard1.5": ["NETStandard.Library"], "netstandard1.6": ["NETStandard.Library"], "netstandard2.0": [], "netstandard2.1": []}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "System.ComponentModel.Composition", "id": "System.ComponentModel.Composition", "version": "8.0.0", "sha512": "sha512-pnAPS2N8OX6Zv1bWtrtMpo/MRp+bxkBYnG0v5WpJfvvn0EJcgVwXmu88u7LRpHbEac//8qHNxKIU9OFIgId7nw==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": [], "net462": [], "net47": [], "net471": [], "net472": [], "net48": [], "net5.0": [], "net6.0": [], "net7.0": [], "net8.0": [], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": [], "netcoreapp2.1": [], "netcoreapp2.2": [], "netcoreapp3.0": [], "netcoreapp3.1": [], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": [], "netstandard2.1": []}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "System.Formats.Asn1", "id": "System.Formats.Asn1", "version": "8.0.1", "sha512": "sha512-BmMIpT6SEmFhYntSyWjEV14uTdPj11cyPzaqn3nr+v4mcRStpRQ5g3siendvADafgOGevAdIKCDmwoqJ6zkQ7g==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": [], "net462": [], "net47": [], "net471": [], "net472": [], "net48": [], "net5.0": [], "net6.0": [], "net7.0": [], "net8.0": [], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": [], "netcoreapp2.1": [], "netcoreapp2.2": [], "netcoreapp3.0": [], "netcoreapp3.1": [], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": [], "netstandard2.1": []}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "System.Security.Cryptography.Cng", "id": "System.Security.Cryptography.Cng", "version": "5.0.0", "sha512": "sha512-trvkAklUhzM+/z9bPnGmDLzmbvD0l1IlC6gpFRpzjGLylTgtTPqm8Uv7tnDBTuBQObjEZBxNS0bChIi6zQCV9w==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": [], "net462": [], "net47": [], "net471": [], "net472": [], "net48": [], "net5.0": ["System.Formats.Asn1"], "net6.0": ["System.Formats.Asn1"], "net7.0": ["System.Formats.Asn1"], "net8.0": ["System.Formats.Asn1"], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": ["Microsoft.NETCore.Platforms"], "netcoreapp2.1": [], "netcoreapp2.2": [], "netcoreapp3.0": ["System.Formats.Asn1"], "netcoreapp3.1": ["System.Formats.Asn1"], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": [], "netstandard2.1": []}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "System.Security.Cryptography.Pkcs", "id": "System.Security.Cryptography.Pkcs", "version": "8.0.1", "sha512": "sha512-MbBgZwHc5ACLGJ28C8+g2FWi3rLsg6PTFQ2B2wAZVfgbbRv8MPrZU+dcVwS0eIMABrqBx7hL35pQ6CQQVcpkUA==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": ["System.Formats.Asn1", "System.Security.Cryptography.Cng"], "net462": [], "net47": [], "net471": [], "net472": [], "net48": [], "net5.0": ["System.Formats.Asn1", "System.Security.Cryptography.Cng"], "net6.0": ["System.Formats.Asn1"], "net7.0": ["System.Formats.Asn1"], "net8.0": [], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": ["System.Formats.Asn1", "System.Security.Cryptography.Cng"], "netcoreapp2.1": ["System.Formats.Asn1", "System.Security.Cryptography.Cng"], "netcoreapp2.2": ["System.Formats.Asn1", "System.Security.Cryptography.Cng"], "netcoreapp3.0": ["System.Formats.Asn1", "System.Security.Cryptography.Cng"], "netcoreapp3.1": ["System.Formats.Asn1", "System.Security.Cryptography.Cng"], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": ["System.Formats.Asn1", "System.Security.Cryptography.Cng"], "netstandard2.1": ["System.Formats.Asn1", "System.Security.Cryptography.Cng"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "System.Security.Cryptography.ProtectedData", "id": "System.Security.Cryptography.ProtectedData", "version": "8.0.0", "sha512": "sha512-hvcXZ/IR+KXxY9lC9S2izw5/fGYoODJR2r9kQSvs5v/HUAnBRuYYZPJrHzaT0CeDRJzIm8BHJb1ZrwHQ59j3uQ==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": [], "net462": [], "net47": [], "net471": [], "net472": [], "net48": [], "net5.0": [], "net6.0": [], "net7.0": [], "net8.0": [], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": [], "netcoreapp2.1": [], "netcoreapp2.2": [], "netcoreapp3.0": [], "netcoreapp3.1": [], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": [], "netstandard2.1": []}, "targeting_pack_overrides": [], "framework_list": []},
        ],
    )
