#! /usr/bin/env bash
set -eou pipefail

# This wrapper script is used because the C#/F# compilers both embed absolute paths
# into their outputs and those paths are not deterministic. The compilers also
# allow overriding these paths using pathmaps. Since the paths can not be known
# at analysis time we need to override them at execution time.

COMPILER="$2"
PATHMAP_FLAG="-pathmap"

# Needed because unfortunately the F# compiler uses a different flag name
if [[ $(basename "$COMPILER") == "fsc.dll" ]]; then
  PATHMAP_FLAG="--pathmap"
fi

# Default mapping: normalise absolute execroot to "."
EXTRA_ARGS=("$PATHMAP_FLAG:$PWD=.")

# DOTNET_PATHMAP: semicolon-separated "stablekey=target" entries.
# Keys are stable relative paths (e.g. "src/libraries/Foo/impl_Foo/net10.0")
# starting after the Bazel bin directory prefix.  We derive the unstable
# prefix from the /pdb: argument in the param file and prepend
# $PWD/{prefix} to each key so the mapping is more specific than the default.
if [[ -n "${DOTNET_PATHMAP:-}" ]]; then
  # Find the /pdb: arg in the response file (third argument is @paramfile or args).
  PDB_ARG=""
  PARAMFILE="${3#@}"
  if [[ -f "$PARAMFILE" ]]; then
    PDB_ARG=$(grep -o '/pdb:[^ ]*' "$PARAMFILE" 2>/dev/null | head -1 | sed 's|^/pdb:||') || true
  fi

  IFS=';' read -ra ENTRIES <<< "$DOTNET_PATHMAP"
  for entry in "${ENTRIES[@]}"; do
    stable_key="${entry%%=*}"
    target="${entry#*=}"
    if [[ -n "$stable_key" && -n "$target" ]]; then
      # Find the stable key in the PDB path to derive the bin prefix.
      if [[ -n "$PDB_ARG" && "$PDB_ARG" == *"$stable_key"* ]]; then
        bin_prefix="${PDB_ARG%%"$stable_key"*}"
        EXTRA_ARGS+=("$PATHMAP_FLAG:$PWD/$bin_prefix$stable_key=$target")
      else
        EXTRA_ARGS+=("$PATHMAP_FLAG:$PWD/$stable_key=$target")
      fi
    fi
  done
fi

# shellcheck disable=SC2145
./"$@" "${EXTRA_ARGS[@]}"
