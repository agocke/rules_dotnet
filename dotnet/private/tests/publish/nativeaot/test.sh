#! /usr/bin/env bash

set -eou pipefail

# Unset the runfiles related envs since NativeAOT binaries are fully native
export RUNFILES_DIR=""
export JAVA_RUNFILES=""
export RUNFILES_MANIFEST_FILE=""
export RUNFILES_MANIFEST_ONLY=""

tar -xvf ./dotnet/private/tests/publish/nativeaot/tar.tar

# Verify it's a native binary (not a .NET apphost shim)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    file_output=$(file ./nativeaot)
    if [[ "$file_output" != *"ELF"* ]]; then
        echo "Expected ELF binary, got: $file_output"
        exit 1
    fi
    ./nativeaot
elif [[ "$OSTYPE" == "darwin"* ]]; then
    file_output=$(file ./nativeaot)
    if [[ "$file_output" != *"Mach-O"* ]]; then
        echo "Expected Mach-O binary, got: $file_output"
        exit 1
    fi
    ./nativeaot
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
    ./nativeaot.exe
else
    echo "Could not figure out which OS is running the test"
    exit 1
fi
