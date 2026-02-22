#nullable enable

using System;
using System.Diagnostics;
using System.IO;
using System.Text;

namespace CompilerWorker;

internal static class Program
{
    // Paths set via env vars at worker startup (constant across requests)
    static string? s_dotnetPath;
    static string? s_cscPath;

    static int Main(string[] args)
    {
        if (Array.Exists(args, a => a == "--persistent_worker"))
        {
            s_dotnetPath = Environment.GetEnvironmentVariable("DOTNET_WORKER_RUNTIME");
            s_cscPath = Environment.GetEnvironmentVariable("DOTNET_WORKER_CSC");
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

    /// <summary>
    /// Persistent worker loop: read WorkRequests from stdin, compile, write WorkResponses to stdout.
    /// </summary>
    static int RunPersistentWorker()
    {
        var stdin = Console.OpenStandardInput();
        var stdout = Console.OpenStandardOutput();

        // Redirect Console.Out/Error to stderr so only protobuf goes to stdout
        Console.SetOut(new StreamWriter(Console.OpenStandardError(), Encoding.UTF8) { AutoFlush = true });
        Console.SetError(new StreamWriter(Console.OpenStandardError(), Encoding.UTF8) { AutoFlush = true });

        while (true)
        {
            WorkRequest? request;
            try
            {
                request = WorkRequest.ReadDelimitedFrom(stdin);
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"Error reading WorkRequest: {ex.Message}");
                return 1;
            }

            if (request == null)
                break; // stdin closed

            if (request.Cancel)
            {
                var cancelResponse = new WorkResponse
                {
                    RequestId = request.RequestId,
                    WasCancelled = true,
                };
                cancelResponse.WriteDelimitedTo(stdout);
                continue;
            }

            var response = HandleRequest(request);
            response.WriteDelimitedTo(stdout);
        }

        return 0;
    }

    /// <summary>
    /// Handles a single compilation request.
    /// </summary>
    static WorkResponse HandleRequest(WorkRequest request)
    {
        var response = new WorkResponse { RequestId = request.RequestId };

        try
        {
            string dotnetPath = s_dotnetPath!;
            string cscPath = s_cscPath!;

            // WorkRequest.arguments contains the csc args (possibly as @paramfile or inline).
            var cscArgs = new StringBuilder();
            cscArgs.Append('"').Append(cscPath).Append('"');
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

            // Inject pathmap for deterministic builds and /shared for compiler server
            string workingDir = request.SandboxDir.Length > 0
                ? Path.GetFullPath(request.SandboxDir)
                : Directory.GetCurrentDirectory();

            string pathmapFlag = cscPath.EndsWith("fsc.dll", StringComparison.OrdinalIgnoreCase)
                ? $"--pathmap:{workingDir}=."
                : $"-pathmap:{workingDir}=.";

            cscArgs.Append(' ').Append(pathmapFlag);
            cscArgs.Append(" /shared");

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
            string stdoutOutput = process.StandardOutput.ReadToEnd();
            string stderrOutput = process.StandardError.ReadToEnd();
            process.WaitForExit();

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
        for (int i = 2; i < args.Length; i++)
        {
            cscArgs.Append(' ');
            var arg = args[i];
            if (arg.Contains(' ') && !arg.StartsWith('"'))
                cscArgs.Append('"').Append(arg).Append('"');
            else
                cscArgs.Append(arg);
        }

        // Inject pathmap and /shared
        string pathmapFlag = cscPath.EndsWith("fsc.dll", StringComparison.OrdinalIgnoreCase)
            ? $"--pathmap:{Directory.GetCurrentDirectory()}=."
            : $"-pathmap:{Directory.GetCurrentDirectory()}=.";

        cscArgs.Append(' ').Append(pathmapFlag);
        cscArgs.Append(" /shared");

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
}
