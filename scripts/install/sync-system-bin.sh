#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
APP_DOTS_DIR="${APP_DOTS_DIR:-$(cd "$SCRIPT_DIR/../.." && pwd)}"

SOURCE_DIR="$APP_DOTS_DIR/scripts/system"
TARGET_DIR="$HOME/.local/bin"

link_item() {
  local source="$1"
  local target="$2"

  if [ -e "$target" ] || [ -L "$target" ]; then
    if [ -L "$target" ] && [ "$(readlink "$target" 2>/dev/null || true)" = "$source" ]; then
      echo "✅ Already linked: $target"
      return 0
    fi

    if [ -L "$target" ]; then
      rm -f "$target"
      echo "♻️  Replacing symlink: $target"
    else
      rm -rf "$target"
      echo "🧹 Removed existing file/dir: $target"
    fi
  fi

  mkdir -p "$(dirname "$target")"
  ln -s "$source" "$target"
  echo "🔗 Linked: $source → $target"
}

main() {
  if [ ! -d "$SOURCE_DIR" ]; then
    echo "ℹ️  No system scripts directory found: $SOURCE_DIR"
    exit 0
  fi

  mkdir -p "$TARGET_DIR"

  echo "🔍 Syncing system scripts from: $SOURCE_DIR"
  echo "📍 Target bin dir: $TARGET_DIR"

  find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 \( -type f -o -type l \) | sort | while read -r source; do
    base="$(basename "$source")"
    target_name="${base%.sh}"

    chmod +x "$source" 2>/dev/null || true
    link_item "$source" "$TARGET_DIR/$target_name"
  done

  echo "✅ System script sync complete."
}

main "$@"
