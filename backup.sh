#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}")" &>/dev/null && pwd)"
ACTIVE_DIR="$SCRIPT_DIR/active"

cat << 'EOF'
   ___           __                   __ 
  / _ )___ _____/ /____ _____    ___ / / 
 / _  / _ `/ __/  '_/ // / _ \_ (_-</ _ \
/____/\_,_/\__/_/\_\\_,_/ .__(_)___/_//_/
                       /_/               

EOF

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux) echo "linux" ;;
    *) echo "unknown" ;;
  esac
}
OS=$(detect_os)

echo -e "\n📦 Backing up dotfiles before installation...\n"

backup_item() {
  local path="$1"
  if [ -e "$path" ] && [ ! -L "$path" ]; then
    if [ -e "$path.bak" ]; then
      echo "⚠️  Backup already exists: $path.bak (skipped)"
    else
      mv "$path" "$path.bak"
      echo "🗂  Backed up: $path → $path.bak"
    fi
  fi
}

backup_home_scope() {
  local scope="$1"
  [ -d "$scope" ] || return

  find "$scope" -mindepth 1 -maxdepth 1 | while read -r subdir; do
    [ -d "$subdir" ] || continue

    find "$subdir" -mindepth 1 -maxdepth 1 | while read -r item; do
      name="$(basename "$item")"
      backup_item "$HOME/$name"
    done
  done
}

backup_config_scope() {
  local scope="$1"
  [ -d "$scope" ] || return

  find "$scope" -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
    name="$(basename "$dir")"
    backup_item "$HOME/.config/$name"
  done
}

backup_scope() {
  local scope_dir="$1"
  echo "🔍 Scanning: $scope_dir"
  backup_home_scope "$scope_dir/HOME"
  backup_config_scope "$scope_dir/.config"
}

# Back up shared and OS-specific targets
backup_scope "$ACTIVE_DIR/shared"
backup_scope "$ACTIVE_DIR/$OS"

echo -e "\n✅ Backup complete. You’re ready to install."
