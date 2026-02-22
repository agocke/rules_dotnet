// Bazel persistent worker protocol messages.
// See: https://github.com/bazelbuild/bazel/blob/master/src/main/protobuf/worker_protocol.proto
//
// Uses Google.Protobuf CodedInputStream/CodedOutputStream for wire format.

#nullable enable

using System;
using System.IO;
using Google.Protobuf;
using Google.Protobuf.Collections;

namespace CompilerWorker;

/// <summary>
/// Represents a single work unit sent from Bazel to the worker.
/// </summary>
internal sealed class WorkRequest
{
    public RepeatedField<string> Arguments { get; } = new();
    public int RequestId { get; set; }
    public bool Cancel { get; set; }
    public int Verbosity { get; set; }
    public string SandboxDir { get; set; } = string.Empty;

    public void MergeFrom(CodedInputStream input)
    {
        uint tag;
        while ((tag = input.ReadTag()) != 0)
        {
            switch (tag)
            {
                case 10: // field 1, wire type 2 (length-delimited) - arguments
                    Arguments.Add(input.ReadString());
                    break;
                case 18: // field 2, wire type 2 (length-delimited) - inputs (skip)
                    input.SkipLastField();
                    break;
                case 24: // field 3, wire type 0 (varint) - request_id
                    RequestId = input.ReadInt32();
                    break;
                case 32: // field 4, wire type 0 (varint) - cancel
                    Cancel = input.ReadBool();
                    break;
                case 40: // field 5, wire type 0 (varint) - verbosity
                    Verbosity = input.ReadInt32();
                    break;
                case 50: // field 6, wire type 2 (length-delimited) - sandbox_dir
                    SandboxDir = input.ReadString();
                    break;
                default:
                    input.SkipLastField();
                    break;
            }
        }
    }

    /// <summary>
    /// Reads a length-delimited WorkRequest from the stream.
    /// Returns null on EOF.
    /// </summary>
    public static WorkRequest? ReadDelimitedFrom(Stream stream)
    {
        // Read the varint length prefix byte-by-byte
        int firstByte = stream.ReadByte();
        if (firstByte < 0)
            return null; // EOF

        int length = firstByte & 0x7F;
        int shift = 7;
        int b = firstByte;
        while ((b & 0x80) != 0)
        {
            b = stream.ReadByte();
            if (b < 0)
                throw new EndOfStreamException("Unexpected end of stream in varint");
            length |= (b & 0x7F) << shift;
            shift += 7;
        }

        if (length == 0)
            return new WorkRequest();

        byte[] buffer = new byte[length];
        int totalRead = 0;
        while (totalRead < length)
        {
            int read = stream.Read(buffer, totalRead, length - totalRead);
            if (read == 0)
                throw new EndOfStreamException("Unexpected end of stream while reading WorkRequest");
            totalRead += read;
        }

        var request = new WorkRequest();
        var input = new CodedInputStream(buffer);
        request.MergeFrom(input);
        return request;
    }
}

/// <summary>
/// The response sent from the worker back to Bazel.
/// </summary>
internal sealed class WorkResponse
{
    public int ExitCode { get; set; }
    public string Output { get; set; } = string.Empty;
    public int RequestId { get; set; }
    public bool WasCancelled { get; set; }

    public void WriteTo(CodedOutputStream output)
    {
        if (ExitCode != 0)
        {
            output.WriteRawTag(8);
            output.WriteInt32(ExitCode);
        }
        if (Output.Length > 0)
        {
            output.WriteRawTag(18);
            output.WriteString(Output);
        }
        if (RequestId != 0)
        {
            output.WriteRawTag(24);
            output.WriteInt32(RequestId);
        }
        if (WasCancelled)
        {
            output.WriteRawTag(32);
            output.WriteBool(true);
        }
    }

    public int CalculateSize()
    {
        int size = 0;
        if (ExitCode != 0)
            size += 1 + CodedOutputStream.ComputeInt32Size(ExitCode);
        if (Output.Length > 0)
            size += 1 + CodedOutputStream.ComputeStringSize(Output);
        if (RequestId != 0)
            size += 1 + CodedOutputStream.ComputeInt32Size(RequestId);
        if (WasCancelled)
            size += 1 + 1;
        return size;
    }

    /// <summary>
    /// Writes this WorkResponse as a length-delimited message to the stream.
    /// </summary>
    public void WriteDelimitedTo(Stream stream)
    {
        int size = CalculateSize();
        var output = new CodedOutputStream(stream);
        output.WriteLength(size);
        WriteTo(output);
        output.Flush();
    }
}

