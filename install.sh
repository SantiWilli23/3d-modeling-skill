#!/usr/bin/env bash
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
dest="$HOME/.claude/skills"
mkdir -p "$dest"
rm -rf "$dest/modelado-3d"
cp -r "$here/skills/modelado-3d" "$dest/"
echo "Instalada en $dest/modelado-3d"
