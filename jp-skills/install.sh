#!/usr/bin/env bash
# Instala/actualiza las skills jp-* en ~/.cursor/skills (enlaces simbólicos al repo).
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${CURSOR_SKILLS_DIR:-$HOME/.cursor/skills}"
MODE="${1:-link}"

mkdir -p "$TARGET_DIR"

for skill in "$REPO_DIR"/skills/jp-*/; do
  name="$(basename "$skill")"
  dest="$TARGET_DIR/$name"

  rm -rf "$dest"
  if [ "$MODE" = "copy" ]; then
    cp -r "$skill" "$dest"
  else
    ln -s "${skill%/}" "$dest"
  fi
  echo "✔ $name → $dest"
done

echo "Listo. Reinicia Cursor para que detecte las skills."
