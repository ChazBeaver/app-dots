#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# ============================================================================
# Backup Script for app-dots
# Moves existing files/folders aside with a .bak suffix before install
# ============================================================================

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}")" &>/dev/null && pwd)"
ACTIVE_DIR="$SCRIPT_DIR/active"

cat << 'EOF'
   ___           __                   __ 
  / _ )___ _____/ /____ _____    ___ / / 
 / _  / _ `/ __/  '_/ // / _ \_ (_-</ _ \
/____/\_,_/\__/_/\_\\_,_/ .__(_)___/_//_/
                       /_/               

EOF

echo "🔍 Scanning for existing files that need to be backed up..."

# ------------------------
# Backup Function
# ------------------------

backup_item() {
  local target_path="$1"

  if [ -e "$target_path" ] && [ ! -L "$target_path" ]; then
    local backup_path="${target_path}.bak"
    if [ -e "$backup_path" ]; then
      echo "⚠️  Backup already exists for $target_path -> Skipping."
    else
      mv "$target_path" "$backup_path"
      echo "📦 Moved $target_path -> $backup_path"
    fi
  fi
}

# ------------------------
# Handle .config items
# ------------------------

if [ -d "$ACTIVE_DIR/.config" ]; then
  find "$ACTIVE_DIR/.config" -mindepth 1 -maxdepth 1 | while read -r item; do
    relative_path=".config/$(basename "$item")"
    target_path="$HOME/$relative_path"

    backup_item "$target_path"
  done
fi

# ------------------------
# Handle everything else (outside .config)
# ------------------------

find "$ACTIVE_DIR" -mindepth 1 -maxdepth 1 ! -name '.config' | while read -r top_item; do
  item_name="$(basename "$top_item")"

  if [ -d "$top_item" ]; then
    echo "📂 Processing directory $item_name..."

    find "$top_item" -mindepth 1 -maxdepth 1 | while read -r inside_item; do
      inside_name="$(basename "$inside_item")"
      target_path="$HOME/$inside_name"

      backup_item "$target_path"
    done

  elif [ -f "$top_item" ]; then
    echo "📄 Processing file $item_name..."
    target_path="$HOME/$item_name"

    backup_item "$target_path"
  fi
done

echo "✅ Backup complete. Safe to run install.sh now."
