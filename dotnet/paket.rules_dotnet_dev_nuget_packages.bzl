"GENERATED"

load("@rules_dotnet//dotnet:defs.bzl", "nuget_repo")

def rules_dotnet_dev_nuget_packages():
    "rules_dotnet_dev_nuget_packages"
    nuget_repo(
        name = "paket.rules_dotnet_dev_nuget_packages",
        packages = [
            {"name": "FSharp.Core", "id": "FSharp.Core", "version": "6.0.3", "sha512": "sha512-aDyKHiVFMwXWJrfW90iAeKyvw/lN+x98DPfx4oXke9Qnl4dz1sOi8KT2iczGeunqyWXh7nm+XUJ18i/0P3pZYw==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": [], "net462": [], "net47": [], "net471": [], "net472": [], "net48": [], "net5.0": [], "net6.0": [], "net7.0": [], "net8.0": [], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": [], "netcoreapp2.1": [], "netcoreapp2.2": [], "netcoreapp3.0": [], "netcoreapp3.1": [], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": [], "netstandard2.1": []}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "FSharp.Data", "id": "FSharp.Data", "version": "4.2.7", "sha512": "sha512-ycPjhFwlqwGb1nRE2ALpbs+C2DUHSv6YnPLQA+vv+zxaWQfMjJxVVfj6j1ANqlP5WNodjXyiqvmDWv149rBucw==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": ["FSharp.Core"], "net462": ["FSharp.Core"], "net47": ["FSharp.Core"], "net471": ["FSharp.Core"], "net472": ["FSharp.Core"], "net48": ["FSharp.Core"], "net5.0": ["FSharp.Core"], "net6.0": ["FSharp.Core"], "net7.0": ["FSharp.Core"], "net8.0": ["FSharp.Core"], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": ["FSharp.Core"], "netcoreapp2.1": ["FSharp.Core"], "netcoreapp2.2": ["FSharp.Core"], "netcoreapp3.0": ["FSharp.Core"], "netcoreapp3.1": ["FSharp.Core"], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": ["FSharp.Core"], "netstandard2.1": ["FSharp.Core"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "LibGit2Sharp", "id": "LibGit2Sharp", "version": "0.27.0-preview-0182", "sha512": "sha512-EQZksMK/1/oSuSU+vtc9R3DurosXySQ5uHRO02D5JvAoYdSCOGQ1lTigtvYcVnXcRGdsAlM3pXnYWexNNf7X4g==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": ["LibGit2Sharp.NativeBinaries"], "net462": ["LibGit2Sharp.NativeBinaries"], "net47": ["LibGit2Sharp.NativeBinaries"], "net471": ["LibGit2Sharp.NativeBinaries"], "net472": ["LibGit2Sharp.NativeBinaries"], "net48": ["LibGit2Sharp.NativeBinaries"], "net5.0": ["LibGit2Sharp.NativeBinaries"], "net6.0": ["LibGit2Sharp.NativeBinaries"], "net7.0": ["LibGit2Sharp.NativeBinaries"], "net8.0": ["LibGit2Sharp.NativeBinaries"], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": ["LibGit2Sharp.NativeBinaries"], "netcoreapp2.1": ["LibGit2Sharp.NativeBinaries"], "netcoreapp2.2": ["LibGit2Sharp.NativeBinaries"], "netcoreapp3.0": ["LibGit2Sharp.NativeBinaries"], "netcoreapp3.1": ["LibGit2Sharp.NativeBinaries"], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": ["LibGit2Sharp.NativeBinaries"], "netstandard2.1": ["LibGit2Sharp.NativeBinaries"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "LibGit2Sharp.NativeBinaries", "id": "LibGit2Sharp.NativeBinaries", "version": "2.0.315-alpha.0.9", "sha512": "sha512-YYQfD2dsYdPn9NjR5s4Mcbek0UM76nO00pPUToAS7we3Qknqqh3y6/QV2/GKMv41EDFZ8osGZfCz+qUWows2zw==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": [], "net462": [], "net47": [], "net471": [], "net472": [], "net48": [], "net5.0": [], "net6.0": [], "net7.0": [], "net8.0": [], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": [], "netcoreapp2.1": [], "netcoreapp2.2": [], "netcoreapp3.0": [], "netcoreapp3.1": [], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": [], "netstandard2.1": []}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "Magick.NET.Core", "id": "Magick.NET.Core", "version": "12.2.2", "sha512": "sha512-pCrQcYNwbTHynEYpAa6jKHZmsuSyV0/4ypVDvlgto+5Aks+M0eR8T/aCoFkJO4jS7Rf/xdh0Ujo+MfqBtYGrdA==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": [], "net462": [], "net47": [], "net471": [], "net472": [], "net48": [], "net5.0": [], "net6.0": [], "net7.0": [], "net8.0": [], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": [], "netcoreapp2.1": [], "netcoreapp2.2": [], "netcoreapp3.0": [], "netcoreapp3.1": [], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": [], "netstandard2.1": []}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "Microsoft.Bcl.AsyncInterfaces", "id": "Microsoft.Bcl.AsyncInterfaces", "version": "8.0.0", "sha512": "sha512-ecsHc9lEZZJM7k5HHZA1PV2N+ELEarLFcssV2bn7XQIJoaiNZDkplTNcX+VKANfDGURAuEyVFCcRu7aFy16VUg==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": ["System.Threading.Tasks.Extensions"], "net462": ["System.Threading.Tasks.Extensions"], "net47": ["System.Threading.Tasks.Extensions"], "net471": ["System.Threading.Tasks.Extensions"], "net472": ["System.Threading.Tasks.Extensions"], "net48": ["System.Threading.Tasks.Extensions"], "net5.0": [], "net6.0": [], "net7.0": [], "net8.0": [], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": ["System.Threading.Tasks.Extensions"], "netcoreapp2.1": ["System.Threading.Tasks.Extensions"], "netcoreapp2.2": ["System.Threading.Tasks.Extensions"], "netcoreapp3.0": [], "netcoreapp3.1": [], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": ["System.Threading.Tasks.Extensions"], "netstandard2.1": []}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "NETStandard.Library.Ref", "id": "NETStandard.Library.Ref", "version": "2.1.0", "sha512": "sha512-Jr0OqnqkaJJGEVq3w9oNQrIEteD/4QBNg3YOh1cvRjydzwop07+5aWjO/SfEYu6CwBn+dSBKXj8niEvTNy2brA==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": [], "net462": [], "net47": [], "net471": [], "net472": [], "net48": [], "net5.0": [], "net6.0": [], "net7.0": [], "net8.0": [], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": [], "netcoreapp2.1": [], "netcoreapp2.2": [], "netcoreapp3.0": [], "netcoreapp3.1": [], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": [], "netstandard2.1": []}, "targeting_pack_overrides": ["Microsoft.Win32.Primitives|4.3.0", "System.AppContext|4.3.0", "System.Collections|4.3.0", "System.Collections.Concurrent|4.3.0", "System.Collections.Immutable|1.4.0", "System.Collections.NonGeneric|4.3.0", "System.Collections.Specialized|4.3.0", "System.ComponentModel|4.3.0", "System.ComponentModel.EventBasedAsync|4.3.0", "System.ComponentModel.Primitives|4.3.0", "System.ComponentModel.TypeConverter|4.3.0", "System.Console|4.3.0", "System.Data.Common|4.3.0", "System.Diagnostics.Contracts|4.3.0", "System.Diagnostics.Debug|4.3.0", "System.Diagnostics.FileVersionInfo|4.3.0", "System.Diagnostics.Process|4.3.0", "System.Diagnostics.StackTrace|4.3.0", "System.Diagnostics.TextWriterTraceListener|4.3.0", "System.Diagnostics.Tools|4.3.0", "System.Diagnostics.TraceSource|4.3.0", "System.Diagnostics.Tracing|4.3.0", "System.Dynamic.Runtime|4.3.0", "System.Globalization|4.3.0", "System.Globalization.Calendars|4.3.0", "System.Globalization.Extensions|4.3.0", "System.IO|4.3.0", "System.IO.Compression|4.3.0", "System.IO.Compression.ZipFile|4.3.0", "System.IO.FileSystem|4.3.0", "System.IO.FileSystem.DriveInfo|4.3.0", "System.IO.FileSystem.Primitives|4.3.0", "System.IO.FileSystem.Watcher|4.3.0", "System.IO.IsolatedStorage|4.3.0", "System.IO.MemoryMappedFiles|4.3.0", "System.IO.Pipes|4.3.0", "System.IO.UnmanagedMemoryStream|4.3.0", "System.Linq|4.3.0", "System.Linq.Expressions|4.3.0", "System.Linq.Queryable|4.3.0", "System.Net.Http|4.3.0", "System.Net.NameResolution|4.3.0", "System.Net.Primitives|4.3.0", "System.Net.Requests|4.3.0", "System.Net.Security|4.3.0", "System.Net.Sockets|4.3.0", "System.Net.WebHeaderCollection|4.3.0", "System.ObjectModel|4.3.0", "System.Private.DataContractSerialization|4.3.0", "System.Reflection|4.3.0", "System.Reflection.Emit|4.3.0", "System.Reflection.Emit.ILGeneration|4.3.0", "System.Reflection.Emit.Lightweight|4.3.0", "System.Reflection.Extensions|4.3.0", "System.Reflection.Primitives|4.3.0", "System.Reflection.TypeExtensions|4.3.0", "System.Resources.ResourceManager|4.3.0", "System.Runtime|4.3.0", "System.Runtime.Extensions|4.3.0", "System.Runtime.Handles|4.3.0", "System.Runtime.InteropServices|4.3.0", "System.Runtime.InteropServices.RuntimeInformation|4.3.0", "System.Runtime.Loader|4.3.0", "System.Runtime.Numerics|4.3.0", "System.Runtime.Serialization.Formatters|4.3.0", "System.Runtime.Serialization.Json|4.3.0", "System.Runtime.Serialization.Primitives|4.3.0", "System.Security.AccessControl|4.4.0", "System.Security.Claims|4.3.0", "System.Security.Cryptography.Algorithms|4.3.0", "System.Security.Cryptography.Csp|4.3.0", "System.Security.Cryptography.Encoding|4.3.0", "System.Security.Cryptography.Primitives|4.3.0", "System.Security.Cryptography.X509Certificates|4.3.0", "System.Security.Cryptography.Xml|4.4.0", "System.Security.Principal|4.3.0", "System.Security.Principal.Windows|4.4.0", "System.Text.Encoding|4.3.0", "System.Text.Encoding.Extensions|4.3.0", "System.Text.RegularExpressions|4.3.0", "System.Threading|4.3.0", "System.Threading.Overlapped|4.3.0", "System.Threading.Tasks|4.3.0", "System.Threading.Tasks.Extensions|4.3.0", "System.Threading.Tasks.Parallel|4.3.0", "System.Threading.Thread|4.3.0", "System.Threading.ThreadPool|4.3.0", "System.Threading.Timer|4.3.0", "System.ValueTuple|4.3.0", "System.Xml.ReaderWriter|4.3.0", "System.Xml.XDocument|4.3.0", "System.Xml.XmlDocument|4.3.0", "System.Xml.XmlSerializer|4.3.0", "System.Xml.XPath|4.3.0", "System.Xml.XPath.XDocument|4.3.0"], "framework_list": ["Microsoft.Win32.Primitives|4.0.3.0", "System.AppContext|4.1.2.0", "System.Buffers|4.0.3.0", "System.Collections.Concurrent|4.0.11.0", "System.Collections.NonGeneric|4.0.3.0", "System.Collections.Specialized|4.0.3.0", "System.Collections|4.0.11.0", "System.ComponentModel.Composition|4.0.0.0", "System.ComponentModel.EventBasedAsync|4.0.11.0", "System.ComponentModel.Primitives|4.1.2.0", "System.ComponentModel.TypeConverter|4.1.2.0", "System.ComponentModel|4.0.1.0", "System.Console|4.0.2.0", "System.Core|4.0.0.0", "System.Data.Common|4.1.2.0", "System.Data|4.0.0.0", "System.Diagnostics.Contracts|4.0.1.0", "System.Diagnostics.Debug|4.0.11.0", "System.Diagnostics.FileVersionInfo|4.0.2.0", "System.Diagnostics.Process|4.1.2.0", "System.Diagnostics.StackTrace|4.0.4.0", "System.Diagnostics.TextWriterTraceListener|4.0.2.0", "System.Diagnostics.Tools|4.0.1.0", "System.Diagnostics.TraceSource|4.0.2.0", "System.Diagnostics.Tracing|4.1.2.0", "System.Drawing.Primitives|4.0.2.0", "System.Drawing|4.0.0.0", "System.Dynamic.Runtime|4.0.11.0", "System.Globalization.Calendars|4.0.3.0", "System.Globalization.Extensions|4.0.3.0", "System.Globalization|4.0.11.0", "System.IO.Compression.FileSystem|4.0.0.0", "System.IO.Compression.ZipFile|4.0.3.0", "System.IO.Compression|4.1.3.0", "System.IO.FileSystem.DriveInfo|4.0.2.0", "System.IO.FileSystem.Primitives|4.0.3.0", "System.IO.FileSystem.Watcher|4.0.2.0", "System.IO.FileSystem|4.0.3.0", "System.IO.IsolatedStorage|4.0.2.0", "System.IO.MemoryMappedFiles|4.0.2.0", "System.IO.Pipes|4.0.2.0", "System.IO.UnmanagedMemoryStream|4.0.3.0", "System.IO|4.1.2.0", "System.Linq.Expressions|4.1.2.0", "System.Linq.Parallel|4.0.1.0", "System.Linq.Queryable|4.0.1.0", "System.Linq|4.1.2.0", "System.Memory|4.0.2.0", "System.Net.Http|4.1.2.0", "System.Net.NameResolution|4.0.2.0", "System.Net.NetworkInformation|4.1.2.0", "System.Net.Ping|4.0.2.0", "System.Net.Primitives|4.0.11.0", "System.Net.Requests|4.0.11.0", "System.Net.Security|4.0.2.0", "System.Net.Sockets|4.1.2.0", "System.Net.WebHeaderCollection|4.0.1.0", "System.Net.WebSockets.Client|4.0.2.0", "System.Net.WebSockets|4.0.2.0", "System.Net|4.0.0.0", "System.Numerics.Vectors|4.1.5.0", "System.Numerics|4.0.0.0", "System.ObjectModel|4.0.11.0", "System.Reflection.DispatchProxy|4.0.5.0", "System.Reflection.Emit.ILGeneration|4.0.1.0", "System.Reflection.Emit.Lightweight|4.0.1.0", "System.Reflection.Emit|4.0.1.0", "System.Reflection.Extensions|4.0.1.0", "System.Reflection.Primitives|4.0.1.0", "System.Reflection|4.1.2.0", "System.Resources.Reader|4.0.2.0", "System.Resources.ResourceManager|4.0.1.0", "System.Resources.Writer|4.0.2.0", "System.Runtime.CompilerServices.VisualC|4.0.2.0", "System.Runtime.Extensions|4.1.2.0", "System.Runtime.Handles|4.0.1.0", "System.Runtime.InteropServices.RuntimeInformation|4.0.2.0", "System.Runtime.InteropServices|4.1.2.0", "System.Runtime.Numerics|4.0.1.0", "System.Runtime.Serialization.Formatters|4.0.2.0", "System.Runtime.Serialization.Json|4.0.1.0", "System.Runtime.Serialization.Primitives|4.1.3.0", "System.Runtime.Serialization.Xml|4.1.3.0", "System.Runtime.Serialization|4.0.0.0", "System.Runtime|4.1.2.0", "System.Security.Claims|4.0.3.0", "System.Security.Cryptography.Algorithms|4.2.2.0", "System.Security.Cryptography.Csp|4.0.2.0", "System.Security.Cryptography.Encoding|4.0.2.0", "System.Security.Cryptography.Primitives|4.0.2.0", "System.Security.Cryptography.X509Certificates|4.1.2.0", "System.Security.Principal|4.0.1.0", "System.Security.SecureString|4.0.2.0", "System.ServiceModel.Web|4.0.0.0", "System.Text.Encoding.Extensions|4.0.11.0", "System.Text.Encoding|4.0.11.0", "System.Text.RegularExpressions|4.1.1.0", "System.Threading.Overlapped|4.0.3.0", "System.Threading.Tasks.Extensions|4.2.1.0", "System.Threading.Tasks.Parallel|4.0.1.0", "System.Threading.Tasks|4.0.11.0", "System.Threading.Thread|4.0.2.0", "System.Threading.ThreadPool|4.0.12.0", "System.Threading.Timer|4.0.1.0", "System.Threading|4.0.11.0", "System.Transactions|4.0.0.0", "System.ValueTuple|4.0.2.0", "System.Web|4.0.0.0", "System.Windows|4.0.0.0", "System.Xml.Linq|4.0.0.0", "System.Xml.ReaderWriter|4.1.1.0", "System.Xml.Serialization|4.0.0.0", "System.Xml.XDocument|4.0.11.0", "System.Xml.XPath.XDocument|4.0.3.0", "System.Xml.XPath|4.0.3.0", "System.Xml.XmlDocument|4.0.3.0", "System.Xml.XmlSerializer|4.0.11.0", "System.Xml|4.0.0.0", "System|4.0.0.0", "mscorlib|4.0.0.0", "netstandard|2.1.0.0"]},
            {"name": "System.Buffers", "id": "System.Buffers", "version": "4.5.1", "sha512": "sha512-gNphWOVbm89+C15jebnPRaYykU8De1PFv1YJV24814IfeGGVa3PXRHDS0MLlbdI1pe9Mpv/n4ZK4INwtAjqv8g==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": [], "net462": [], "net47": [], "net471": [], "net472": [], "net48": [], "net5.0": [], "net6.0": [], "net7.0": [], "net8.0": [], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": [], "netcoreapp2.1": [], "netcoreapp2.2": [], "netcoreapp3.0": [], "netcoreapp3.1": [], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": [], "netstandard2.1": []}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "System.Memory", "id": "System.Memory", "version": "4.5.5", "sha512": "sha512-6MjlNsl7lKw0Q8lAsw2tQ89ul9x6jD2Yk3EEj+dOFoYGOE9eAUO9wNhvd4O/n97oQXlkyzqKXXUnE+kLElFy3A==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": ["System.Buffers", "System.Runtime.CompilerServices.Unsafe"], "net451": ["System.Buffers", "System.Runtime.CompilerServices.Unsafe"], "net452": ["System.Buffers", "System.Runtime.CompilerServices.Unsafe"], "net46": ["System.Buffers", "System.Runtime.CompilerServices.Unsafe"], "net461": ["System.Buffers", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe"], "net462": ["System.Buffers", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe"], "net47": ["System.Buffers", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe"], "net471": ["System.Buffers", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe"], "net472": ["System.Buffers", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe"], "net48": ["System.Buffers", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe"], "net5.0": [], "net6.0": [], "net7.0": [], "net8.0": [], "netcoreapp1.0": ["System.Buffers", "System.Runtime.CompilerServices.Unsafe"], "netcoreapp1.1": ["System.Buffers", "System.Runtime.CompilerServices.Unsafe"], "netcoreapp2.0": ["System.Runtime.CompilerServices.Unsafe"], "netcoreapp2.1": [], "netcoreapp2.2": [], "netcoreapp3.0": [], "netcoreapp3.1": [], "netstandard": [], "netstandard1.0": [], "netstandard1.1": ["System.Buffers", "System.Runtime.CompilerServices.Unsafe"], "netstandard1.2": ["System.Buffers", "System.Runtime.CompilerServices.Unsafe"], "netstandard1.3": ["System.Buffers", "System.Runtime.CompilerServices.Unsafe"], "netstandard1.4": ["System.Buffers", "System.Runtime.CompilerServices.Unsafe"], "netstandard1.5": ["System.Buffers", "System.Runtime.CompilerServices.Unsafe"], "netstandard1.6": ["System.Buffers", "System.Runtime.CompilerServices.Unsafe"], "netstandard2.0": ["System.Buffers", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe"], "netstandard2.1": ["System.Buffers", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "System.Numerics.Vectors", "id": "System.Numerics.Vectors", "version": "4.5.0", "sha512": "sha512-nATsBTD2CKr4AYN6eRszhX4sptImWmBJwB/U6XKCWWfnCcrTBw8XSCm3QA9gjppkHTr8OkXUY21MR91D3QZXsw==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": [], "net462": [], "net47": [], "net471": [], "net472": [], "net48": [], "net5.0": [], "net6.0": [], "net7.0": [], "net8.0": [], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": [], "netcoreapp2.1": [], "netcoreapp2.2": [], "netcoreapp3.0": [], "netcoreapp3.1": [], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": [], "netstandard2.1": []}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "System.Runtime.CompilerServices.Unsafe", "id": "System.Runtime.CompilerServices.Unsafe", "version": "6.0.0", "sha512": "sha512-1AVzAb5OxJNvJLnOADtexNmWgattm2XVOT3TjQTN7Dd4SqoSwai1CsN2fth42uQldJSQdz/sAec0+TzxBFgisw==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": [], "net462": [], "net47": [], "net471": [], "net472": [], "net48": [], "net5.0": [], "net6.0": [], "net7.0": [], "net8.0": [], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": [], "netcoreapp2.1": [], "netcoreapp2.2": [], "netcoreapp3.0": [], "netcoreapp3.1": [], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": [], "netstandard2.1": []}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "System.Security.Principal.Windows", "id": "System.Security.Principal.Windows", "version": "5.0.0", "sha512": "sha512-RKkgqq8ishctQTGbtXqyuOGkUx1fAhkqb1OoHYdRJRlbYLoLWkSkWYHRN/17DzplsSlZtf2Xr8BXjNhO8nRnzQ==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": [], "net462": [], "net47": [], "net471": [], "net472": [], "net48": [], "net5.0": [], "net6.0": [], "net7.0": [], "net8.0": [], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": [], "netcoreapp2.1": [], "netcoreapp2.2": [], "netcoreapp3.0": [], "netcoreapp3.1": [], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": [], "netstandard2.1": []}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "System.Text.Encodings.Web", "id": "System.Text.Encodings.Web", "version": "8.0.0", "sha512": "sha512-uggiw4w7ZYq6lJVkLSaeiCuCfjvkrS3BQm2Kl9PLxaInfF+AhH0MuTgQeK8BUjMoxJksqgWBRtXY7muKCGCcMg==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": ["System.Buffers", "System.Memory", "System.Runtime.CompilerServices.Unsafe"], "net462": ["System.Buffers", "System.Memory", "System.Runtime.CompilerServices.Unsafe"], "net47": ["System.Buffers", "System.Memory", "System.Runtime.CompilerServices.Unsafe"], "net471": ["System.Buffers", "System.Memory", "System.Runtime.CompilerServices.Unsafe"], "net472": ["System.Buffers", "System.Memory", "System.Runtime.CompilerServices.Unsafe"], "net48": ["System.Buffers", "System.Memory", "System.Runtime.CompilerServices.Unsafe"], "net5.0": ["System.Buffers", "System.Memory", "System.Runtime.CompilerServices.Unsafe"], "net6.0": ["System.Runtime.CompilerServices.Unsafe"], "net7.0": [], "net8.0": [], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": ["System.Buffers", "System.Memory", "System.Runtime.CompilerServices.Unsafe"], "netcoreapp2.1": ["System.Buffers", "System.Memory", "System.Runtime.CompilerServices.Unsafe"], "netcoreapp2.2": ["System.Buffers", "System.Memory", "System.Runtime.CompilerServices.Unsafe"], "netcoreapp3.0": ["System.Buffers", "System.Memory", "System.Runtime.CompilerServices.Unsafe"], "netcoreapp3.1": ["System.Buffers", "System.Memory", "System.Runtime.CompilerServices.Unsafe"], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": ["System.Buffers", "System.Memory", "System.Runtime.CompilerServices.Unsafe"], "netstandard2.1": ["System.Buffers", "System.Memory", "System.Runtime.CompilerServices.Unsafe"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "System.Text.Json", "id": "System.Text.Json", "version": "7.0.3", "sha512": "sha512-DqP+zKPdTIT42a/d1tPu+w/hq14QZ8+6tbpuv2GsyrjhqBqbsHH7mNta/sSvOkF3fB+yP7PWr2IjYILinfT6VQ==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": [], "net451": [], "net452": [], "net46": [], "net461": ["Microsoft.Bcl.AsyncInterfaces", "System.Text.Encodings.Web", "System.Buffers", "System.Memory", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe", "System.Threading.Tasks.Extensions"], "net462": ["Microsoft.Bcl.AsyncInterfaces", "System.Text.Encodings.Web", "System.Buffers", "System.Memory", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe", "System.Threading.Tasks.Extensions"], "net47": ["Microsoft.Bcl.AsyncInterfaces", "System.Text.Encodings.Web", "System.Buffers", "System.Memory", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe", "System.Threading.Tasks.Extensions"], "net471": ["Microsoft.Bcl.AsyncInterfaces", "System.Text.Encodings.Web", "System.Buffers", "System.Memory", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe", "System.Threading.Tasks.Extensions"], "net472": ["Microsoft.Bcl.AsyncInterfaces", "System.Text.Encodings.Web", "System.Buffers", "System.Memory", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe", "System.Threading.Tasks.Extensions"], "net48": ["Microsoft.Bcl.AsyncInterfaces", "System.Text.Encodings.Web", "System.Buffers", "System.Memory", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe", "System.Threading.Tasks.Extensions"], "net5.0": ["Microsoft.Bcl.AsyncInterfaces", "System.Text.Encodings.Web", "System.Buffers", "System.Memory", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe", "System.Threading.Tasks.Extensions"], "net6.0": ["System.Text.Encodings.Web", "System.Runtime.CompilerServices.Unsafe"], "net7.0": ["System.Text.Encodings.Web"], "net8.0": ["System.Text.Encodings.Web"], "netcoreapp1.0": [], "netcoreapp1.1": [], "netcoreapp2.0": ["Microsoft.Bcl.AsyncInterfaces", "System.Text.Encodings.Web", "System.Buffers", "System.Memory", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe", "System.Threading.Tasks.Extensions"], "netcoreapp2.1": ["Microsoft.Bcl.AsyncInterfaces", "System.Text.Encodings.Web", "System.Buffers", "System.Memory", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe", "System.Threading.Tasks.Extensions"], "netcoreapp2.2": ["Microsoft.Bcl.AsyncInterfaces", "System.Text.Encodings.Web", "System.Buffers", "System.Memory", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe", "System.Threading.Tasks.Extensions"], "netcoreapp3.0": ["Microsoft.Bcl.AsyncInterfaces", "System.Text.Encodings.Web", "System.Buffers", "System.Memory", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe", "System.Threading.Tasks.Extensions"], "netcoreapp3.1": ["Microsoft.Bcl.AsyncInterfaces", "System.Text.Encodings.Web", "System.Buffers", "System.Memory", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe", "System.Threading.Tasks.Extensions"], "netstandard": [], "netstandard1.0": [], "netstandard1.1": [], "netstandard1.2": [], "netstandard1.3": [], "netstandard1.4": [], "netstandard1.5": [], "netstandard1.6": [], "netstandard2.0": ["Microsoft.Bcl.AsyncInterfaces", "System.Text.Encodings.Web", "System.Buffers", "System.Memory", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe", "System.Threading.Tasks.Extensions"], "netstandard2.1": ["Microsoft.Bcl.AsyncInterfaces", "System.Text.Encodings.Web", "System.Buffers", "System.Memory", "System.Numerics.Vectors", "System.Runtime.CompilerServices.Unsafe", "System.Threading.Tasks.Extensions"]}, "targeting_pack_overrides": [], "framework_list": []},
            {"name": "System.Threading.Tasks.Extensions", "id": "System.Threading.Tasks.Extensions", "version": "4.5.4", "sha512": "sha512-aAUghud9PHGYc3o9oWPWd0C3xE+TJQw5ZZs78htlR6mr9ky/QEgfXHjyQ2GvOq9H1S0YizcVVKCSin92ZcH8FA==", "sources": ["https://api.nuget.org/v3/index.json"], "dependencies": {"net11": [], "net20": [], "net30": [], "net35": [], "net40": [], "net403": [], "net45": ["System.Runtime.CompilerServices.Unsafe"], "net451": ["System.Runtime.CompilerServices.Unsafe"], "net452": ["System.Runtime.CompilerServices.Unsafe"], "net46": ["System.Runtime.CompilerServices.Unsafe"], "net461": ["System.Runtime.CompilerServices.Unsafe"], "net462": ["System.Runtime.CompilerServices.Unsafe"], "net47": ["System.Runtime.CompilerServices.Unsafe"], "net471": ["System.Runtime.CompilerServices.Unsafe"], "net472": ["System.Runtime.CompilerServices.Unsafe"], "net48": ["System.Runtime.CompilerServices.Unsafe"], "net5.0": [], "net6.0": [], "net7.0": [], "net8.0": [], "netcoreapp1.0": ["System.Runtime.CompilerServices.Unsafe"], "netcoreapp1.1": ["System.Runtime.CompilerServices.Unsafe"], "netcoreapp2.0": ["System.Runtime.CompilerServices.Unsafe"], "netcoreapp2.1": [], "netcoreapp2.2": [], "netcoreapp3.0": [], "netcoreapp3.1": [], "netstandard": [], "netstandard1.0": ["System.Runtime.CompilerServices.Unsafe"], "netstandard1.1": ["System.Runtime.CompilerServices.Unsafe"], "netstandard1.2": ["System.Runtime.CompilerServices.Unsafe"], "netstandard1.3": ["System.Runtime.CompilerServices.Unsafe"], "netstandard1.4": ["System.Runtime.CompilerServices.Unsafe"], "netstandard1.5": ["System.Runtime.CompilerServices.Unsafe"], "netstandard1.6": ["System.Runtime.CompilerServices.Unsafe"], "netstandard2.0": ["System.Runtime.CompilerServices.Unsafe"], "netstandard2.1": ["System.Runtime.CompilerServices.Unsafe"]}, "targeting_pack_overrides": [], "framework_list": []},
        ],
    )
