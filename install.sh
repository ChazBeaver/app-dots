#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# ============================================================================
# app-dots Install Script
# ============================================================================

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}")" &>/dev/null && pwd)"
ACTIVE_DIR="$SCRIPT_DIR/active"

VAR_NAME="APP_DOTS_DIR"

# --- Verify this project is at some level with in the $HOME dir ---
if [ -z "${APP_DOTS_DIR:-}" ]; then
  if [[ "$SCRIPT_DIR" == "$HOME"* ]]; then
    export APP_DOTS_DIR="$SCRIPT_DIR"
    echo "Set APP_DOTS_DIR to $SCRIPT_DIR"
  else
    echo "Warning: app-dots not inside home directory. Please set APP_DOTS_DIR manually."
  fi
fi

# --- Persist to ~/.dotfiles-env.sh if missing ---
ENV_FILE="$HOME/.dotfiles-env.sh"
mkdir -p "$(dirname "$ENV_FILE")"

if ! grep -q "$VAR_NAME=" "$ENV_FILE" 2>/dev/null; then
  echo "export $VAR_NAME=\"$SCRIPT_DIR\"" >> "$ENV_FILE"
  echo "Added $VAR_NAME to $ENV_FILE."
fi

# --- Add alias to .dotfiles-env.sh if not already present ---
if ! grep -q 'alias appdots=' "$ENV_FILE" 2>/dev/null; then
  echo 'alias appdots="cd \$APP_DOTS_DIR"' >> "$ENV_FILE"
  echo "Added alias 'appdots' to $ENV_FILE."
fi

source "$ENV_FILE"

# ------------------------
# Symlink function
# ------------------------

link_item() {
  local source_path="$1"
  local target_path="$2"

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    if [ "$(readlink "$target_path" || true)" = "$source_path" ]; then
      echo "✅ Already linked: $target_path -> $source_path"
    else
      echo "⚠️  Warning: $target_path exists but points elsewhere. Skipping."
    fi
  else
    mkdir -p "$(dirname "$target_path")"
    ln -s "$source_path" "$target_path"
    echo "🔗 Linked: $target_path -> $source_path"
  fi
}

# ------------------------
# Banner
# ------------------------

cat <<'EOF'
  
  ___  ____________      ______ _____ _____ _____ 
 / _ \ | ___ \ ___ \     |  _  \  _  |_   _/  ___|
/ /_\ \| |_/ / |_/ /_____| | | | | | | | | \ `--. 
|  _  ||  __/|  __/______| | | | | | | | |  `--. \
| | | || |   | |         | |/ /\ \_/ / | | /\__/ /
\_| |_/\_|   \_|         |___/  \___/  \_/ \____/ 
                                                  
            Installing App-Dots

EOF

echo "🔍 Scanning active/ for files and folders to link..."

# ------------------------
# 1. Handle .config
# ------------------------

if [ -d "$ACTIVE_DIR/.config" ]; then
  echo "📂 Linking items inside .config..."
  find "$ACTIVE_DIR/.config" -mindepth 1 -maxdepth 1 | while read -r item; do
    source_path="$item"
    relative_path=".config/$(basename "$item")"
    target_path="$HOME/$relative_path"

    link_item "$source_path" "$target_path"
  done
fi

# ------------------------
# 2. Handle HOME
# ------------------------

if [ -d "$ACTIVE_DIR/HOME" ]; then
  echo "🏠 Linking items inside HOME..."
  find "$ACTIVE_DIR/HOME" -mindepth 1 -maxdepth 1 | while read -r item; do
    if [ -f "$item" ]; then
      # If it's a file, symlink directly to $HOME
      source_path="$item"
      target_path="$HOME/$(basename "$item")"

      link_item "$source_path" "$target_path"

    elif [ -d "$item" ]; then
      # If it's a directory, unpack it
      echo "📂 Unpacking directory $(basename "$item")..."
      find "$item" -mindepth 1 -maxdepth 1 | while read -r subitem; do
        source_path="$subitem"
        target_path="$HOME/$(basename "$subitem")"

        link_item "$source_path" "$target_path"
      done
    fi
  done
fi

echo "✅ Finished installing all active dotfiles."

echo -e "\n⚡ If you just installed or updated your .zshrc, run: \033[1;32msource ~/.zshrc\033[0m to apply changes!\n"
