#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}")" &>/dev/null && pwd)"
ACTIVE_DIR="$SCRIPT_DIR/active"

cat <<'EOF'
                       _       _              
  __ _ _ __  _ __   __| | ___ | |_ ___        
 / _` | '_ \| '_ \ / _` |/ _ \| __/ __|       
| (_| | |_) | |_) | (_| | (_) | |_\__ \       
 \__,_| .__/| .__/ \__,_|\___/ \__|___/       
      |_|   |_|                               
 _                _                     _     
| |__   __ _  ___| | ___   _ _ __   ___| |__  
| '_ \ / _` |/ __| |/ / | | | '_ \ / __| '_ \ 
| |_) | (_| | (__|   <| |_| | |_) |\__ \ | | |
|_.__/ \__,_|\___|_|\_\\__,_| .__(_)___/_| |_|
                            |_|               

EOF

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux) echo "linux" ;;
    *) echo "unknown" ;;
  esac
}
OS="$(detect_os)"

echo -e "\n📦 Backing up dotfiles before installation...\n"

backup_item() {
  local path="$1"

  # back up real files/dirs only (not symlinks)
  if [ -e "$path" ] && [ ! -L "$path" ]; then
    if [ -e "$path.bak" ] || [ -L "$path.bak" ]; then
      echo "⚠️  Backup already exists: $path.bak (skipped)"
    else
      mv "$path" "$path.bak"
      echo "🗂  Backed up: $path → $path.bak"
    fi
  fi
}

# HOME/ rules mirror install.sh:
# - dotfile/dotdir at HOME top-level -> backs up ~/<name>
# - non-dot directory at HOME top-level -> backs up each child as ~/<child>
backup_home_scope() {
  local home_path="$1"
  [ -d "$home_path" ] || return 0

  echo "🏠 Scanning HOME: $home_path"

  find "$home_path" -mindepth 1 -maxdepth 1 | while read -r entry; do
    local base
    base="$(basename "$entry")"

    if [ -d "$entry" ] && [[ "$base" != .* ]]; then
      find "$entry" -mindepth 1 -maxdepth 1 | while read -r item; do
        local name
        name="$(basename "$item")"
        backup_item "$HOME/$name"
      done
    else
      backup_item "$HOME/$base"
    fi
  done
}

# .config/ -> backs up ~/.config/<top-level> (dirs and files)
backup_config_scope() {
  local config_path="$1"
  [ -d "$config_path" ] || return 0

  echo "⚙️  Scanning .config: $config_path"

  find "$config_path" -mindepth 1 -maxdepth 1 | while read -r item; do
    local name
    name="$(basename "$item")"
    backup_item "$HOME/.config/$name"
  done
}

# macOS library/ -> backs up ~/Library/<top-level>
backup_macos_library_scope() {
  local lib_path="$1"
  [ -d "$lib_path" ] || return 0
  [ "$OS" = "macos" ] || return 0

  echo " Scanning Library: $lib_path"

  find "$lib_path" -mindepth 1 -maxdepth 1 | while read -r item; do
    local name
    name="$(basename "$item")"
    backup_item "$HOME/Library/$name"
  done
}

backup_scope() {
  local scope_dir="$1"
  [ -d "$scope_dir" ] || return 0

  echo "🔍 Scanning scope: $scope_dir"
  backup_home_scope "$scope_dir/HOME"
  backup_config_scope "$scope_dir/.config"
  backup_macos_library_scope "$scope_dir/library"
}

backup_scope "$ACTIVE_DIR/shared"
backup_scope "$ACTIVE_DIR/$OS"

echo -e "\n✅ Backup complete. You’re ready to install."
