#nullable enable

using System;
using System.Collections.Concurrent;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Google.Protobuf;

namespace CompilerWorker;

internal static class Program
{
    // Paths set via env vars at worker startup (constant across requests)
    static readonly string? s_dotnetPath = Environment.GetEnvironmentVariable("DOTNET_WORKER_RUNTIME");
    static readonly string? s_cscPath = Environment.GetEnvironmentVariable("DOTNET_WORKER_CSC");

    static int Main(string[] args)
    {
        if (Array.Exists(args, a => a == "--persistent_worker"))
        {
            if (string.IsNullOrEmpty(s_dotnetPath) || string.IsNullOrEmpty(s_cscPath))
            {
                Console.Error.WriteLine("DOTNET_WORKER_RUNTIME and DOTNET_WORKER_CSC env vars must be set in worker mode");
                return 1;
            }
            return RunPersistentWorker();
        }

        // Non-worker mode: behave like compiler_wrapper.sh
        return RunDirectCompilation(args);
    }

    // Lock to serialize protobuf writes to stdout (required by worker protocol).
    static readonly object s_stdoutLock = new();

    // In-flight requests tracked for cancellation support.
    static readonly ConcurrentDictionary<int, CancellationTokenSource> s_pending = new();

    /// <summary>
    /// Persistent worker loop: read WorkRequests from stdin, dispatch compilations
    /// concurrently (multiplex), write WorkResponses to stdout.
    /// </summary>
    static int RunPersistentWorker()
    {
        var stdin = Console.OpenStandardInput();
        var stdout = Console.OpenStandardOutput();

        // Shut down VBCSCompiler when this process is terminated
        AppDomain.CurrentDomain.ProcessExit += (_, _) => ShutdownBuildServer();

        // Redirect Console.Out/Error to stderr so only protobuf goes to stdout
        Console.SetOut(new StreamWriter(Console.OpenStandardError(), Encoding.UTF8) { AutoFlush = true });
        Console.SetError(new StreamWriter(Console.OpenStandardError(), Encoding.UTF8) { AutoFlush = true });

        try
        {
            while (true)
            {
                WorkRequest request;
                try
                {
                    request = WorkRequest.Parser.ParseDelimitedFrom(stdin);
                }
                catch (InvalidProtocolBufferException)
                {
                    break; // stdin closed or malformed - EOF
                }

                if (request.Cancel)
                {
                    if (s_pending.TryGetValue(request.RequestId, out var cts))
                        cts.Cancel();
                    // Response is sent by the original task when it observes cancellation.
                    continue;
                }

                if (request.RequestId == 0)
                {
                    // Singleplex fallback: process synchronously.
                    var response = HandleRequest(request, CancellationToken.None);
                    lock (s_stdoutLock)
                        response.WriteDelimitedTo(stdout);
                }
                else
                {
                    // Multiplex: dispatch concurrently.
                    var cts = new CancellationTokenSource();
                    s_pending[request.RequestId] = cts;
                    _ = Task.Run(() =>
                    {
                        WorkResponse response;
                        try
                        {
                            response = HandleRequest(request, cts.Token);
                            if (cts.Token.IsCancellationRequested)
                            {
                                response.ExitCode = 1;
                                response.WasCancelled = true;
                            }
                        }
                        catch (OperationCanceledException)
                        {
                            response = new WorkResponse
                            {
                                RequestId = request.RequestId,
                                WasCancelled = true,
                            };
                        }
                        finally
                        {
                            s_pending.TryRemove(request.RequestId, out _);
                            cts.Dispose();
                        }
                        lock (s_stdoutLock)
                            response.WriteDelimitedTo(stdout);
                    });
                }
            }

            // Wait for all in-flight requests before shutting down.
            while (!s_pending.IsEmpty)
                Thread.Sleep(50);
        }
        finally
        {
            ShutdownBuildServer();
        }

        return 0;
    }

    /// <summary>
    /// Handles a single compilation request. Thread-safe — may be called concurrently.
    /// </summary>
    static WorkResponse HandleRequest(WorkRequest request, CancellationToken cancellationToken)
    {
        var response = new WorkResponse { RequestId = request.RequestId };

        try
        {
            string dotnetPath = s_dotnetPath!;
            string cscPath = s_cscPath!;

            // WorkRequest.arguments contains the csc args (possibly as @paramfile or inline).
            // -shared must precede @paramfile so VBCSCompiler's BuildClient sees it
            // before expanding the response file.
            var cscArgs = new StringBuilder();
            cscArgs.Append('"').Append(cscPath).Append('"');
            cscArgs.Append(" -shared");
            foreach (var arg in request.Arguments)
            {
                cscArgs.Append(' ');
                // Handle @paramfile references - pass through to csc
                if (arg.StartsWith('@'))
                {
                    cscArgs.Append(arg);
                }
                else if (arg.Contains(' ') && !arg.StartsWith('"'))
                {
                    cscArgs.Append('"').Append(arg).Append('"');
                }
                else
                {
                    cscArgs.Append(arg);
                }
            }

            // Inject pathmap for deterministic builds.
            // The default mapping normalises the absolute execroot to ".".
            string workingDir = request.SandboxDir.Length > 0
                ? Path.GetFullPath(request.SandboxDir)
                : Directory.GetCurrentDirectory();

            bool isFsc = cscPath.EndsWith("fsc.dll", StringComparison.OrdinalIgnoreCase);
            string flagPrefix = isFsc ? "--pathmap:" : "-pathmap:";

            string defaultPathmap = $"{flagPrefix}{workingDir}=.";
            cscArgs.Append(' ').Append(defaultPathmap);

            // DOTNET_PATHMAP: semicolon-separated "relpath=target" entries.
            // Keys are stable relative paths (e.g. "src/libraries/Foo/impl_Foo/net10.0")
            // that start AFTER the Bazel output bin directory prefix
            // (e.g. "bazel-out/{hash}/bin/").  The worker derives this unstable
            // prefix from the /pdb: argument and prepends {cwd}/{prefix} to each
            // key, producing a more-specific mapping that wins over the default.
            string? extraPathmap = Environment.GetEnvironmentVariable("DOTNET_PATHMAP");
            if (!string.IsNullOrEmpty(extraPathmap))
            {
                // Find the /pdb: argument to extract the bin directory prefix.
                string? pdbArg = null;
                string argsStr = cscArgs.ToString();
                int pdbIdx = argsStr.IndexOf("/pdb:");
                if (pdbIdx < 0)
                    pdbIdx = argsStr.IndexOf("-pdb:");
                if (pdbIdx >= 0)
                {
                    int start = pdbIdx + 5;
                    int end = argsStr.IndexOf(' ', start);
                    pdbArg = end > start ? argsStr[start..end] : argsStr[start..];
                }

                foreach (string entry in extraPathmap.Split(';', StringSplitOptions.RemoveEmptyEntries))
                {
                    int eq = entry.IndexOf('=');
                    if (eq > 0)
                    {
                        string stableKey = entry[..eq];
                        string target = entry[(eq + 1)..];

                        // Find where the stable key appears in the PDB path
                        // to derive the bin directory prefix.
                        string absKey;
                        if (pdbArg is not null)
                        {
                            int keyIdx = pdbArg.IndexOf(stableKey);
                            if (keyIdx > 0)
                            {
                                // Everything before the key is the bin prefix
                                string binPrefix = pdbArg[..keyIdx];
                                absKey = Path.Combine(workingDir, binPrefix + stableKey);
                            }
                            else
                            {
                                absKey = Path.Combine(workingDir, stableKey);
                            }
                        }
                        else
                        {
                            absKey = Path.Combine(workingDir, stableKey);
                        }

                        cscArgs.Append(' ').Append($"{flagPrefix}{absKey}={target}");
                    }
                }
            }

            var psi = new ProcessStartInfo
            {
                FileName = dotnetPath,
                Arguments = cscArgs.ToString(),
                UseShellExecute = false,
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                CreateNoWindow = true,
                WorkingDirectory = workingDir,
            };

            // Required for dotnet CLI
            psi.Environment["DOTNET_CLI_HOME"] = Path.GetDirectoryName(dotnetPath)!;

            using var process = Process.Start(psi)!;

            // Kill the compiler process if Bazel cancels this request.
            using var reg = cancellationToken.Register(() =>
            {
                try { process.Kill(entireProcessTree: true); } catch { }
            });

            string stdoutOutput = process.StandardOutput.ReadToEnd();
            string stderrOutput = process.StandardError.ReadToEnd();
            process.WaitForExit();

            cancellationToken.ThrowIfCancellationRequested();

            var output = new StringBuilder();
            if (stdoutOutput.Length > 0) output.Append(stdoutOutput);
            if (stderrOutput.Length > 0)
            {
                if (output.Length > 0) output.AppendLine();
                output.Append(stderrOutput);
            }

            response.ExitCode = process.ExitCode;
            response.Output = output.ToString();
        }
        catch (OperationCanceledException)
        {
            throw;
        }
        catch (Exception ex)
        {
            response.ExitCode = 1;
            response.Output = $"Worker error: {ex}";
        }

        return response;
    }

    /// <summary>
    /// Direct execution mode (non-worker): behave like compiler_wrapper.sh.
    /// </summary>
    static int RunDirectCompilation(string[] args)
    {
        if (args.Length < 2)
        {
            Console.Error.WriteLine("Usage: compiler_worker <dotnet_path> <csc_path> [args...]");
            return 1;
        }

        string dotnetPath = args[0];
        string cscPath = args[1];

        var cscArgs = new StringBuilder();
        cscArgs.Append('"').Append(cscPath).Append('"');
        cscArgs.Append(" -shared");
        for (int i = 2; i < args.Length; i++)
        {
            cscArgs.Append(' ');
            var arg = args[i];
            if (arg.Contains(' ') && !arg.StartsWith('"'))
                cscArgs.Append('"').Append(arg).Append('"');
            else
                cscArgs.Append(arg);
        }

        // Inject pathmap for deterministic builds
        string pathmapFlag = cscPath.EndsWith("fsc.dll", StringComparison.OrdinalIgnoreCase)
            ? $"--pathmap:{Directory.GetCurrentDirectory()}=."
            : $"-pathmap:{Directory.GetCurrentDirectory()}=.";

        cscArgs.Append(' ').Append(pathmapFlag);

        var psi = new ProcessStartInfo
        {
            FileName = dotnetPath,
            Arguments = cscArgs.ToString(),
            UseShellExecute = false,
        };
        psi.Environment["DOTNET_CLI_HOME"] = Path.GetDirectoryName(dotnetPath)!;

        using var process = Process.Start(psi)!;
        process.WaitForExit();
        return process.ExitCode;
    }

    /// <summary>
    /// Shuts down the VBCSCompiler server so it doesn't linger after the worker exits.
    /// </summary>
    static void ShutdownBuildServer()
    {
        try
        {
            var psi = new ProcessStartInfo
            {
                FileName = s_dotnetPath!,
                Arguments = "build-server shutdown",
                UseShellExecute = false,
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                CreateNoWindow = true,
            };
            psi.Environment["DOTNET_CLI_HOME"] = Path.GetDirectoryName(s_dotnetPath!)!;

            using var process = Process.Start(psi)!;
            process.WaitForExit(TimeSpan.FromSeconds(5));
        }
        catch
        {
            // Best-effort cleanup; don't fail the worker exit.
        }
    }
}
