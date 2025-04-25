#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}")" &>/dev/null && pwd)"
ACTIVE_DIR="$SCRIPT_DIR/active"
ENV_FILE="$HOME/.dotfiles-env.sh"
VAR_NAME="APP_DOTS_DIR"

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux) echo "linux" ;;
    *) echo "unknown" ;;
  esac
}
OS=$(detect_os)

# Banner
cat <<'EOF'

  ___  ____________      ______ _____ _____ _____ 
 / _ \ | ___ \ ___ \     |  _  \  _  |_   _/  ___|
/ /_\ \| |_/ / |_/ /_____| | | | | | | | | \ `--. 
|  _  ||  __/|  __/______| | | | | | | | |  `--. \
| | | || |   | |         | |/ /\ \_/ / | | /\__/ /
\_| |_/\_|   \_|         |___/  \___/  \_/ \____/ 
                                                  
            Installing App-Dots

EOF

# Save APP_DOTS_DIR
if [ -z "${APP_DOTS_DIR:-}" ]; then
  if [[ "$SCRIPT_DIR" == "$HOME"* ]]; then
    export APP_DOTS_DIR="$SCRIPT_DIR"
    echo "Set APP_DOTS_DIR to $SCRIPT_DIR"
  else
    echo "Warning: app-dots not inside home directory. Please set APP_DOTS_DIR manually."
  fi
fi

mkdir -p "$(dirname "$ENV_FILE")"
grep -q "$VAR_NAME=" "$ENV_FILE" 2>/dev/null || echo "export $VAR_NAME=\"$SCRIPT_DIR\"" >> "$ENV_FILE"
grep -q 'alias appdots=' "$ENV_FILE" 2>/dev/null || echo 'alias appdots="cd \$APP_DOTS_DIR"' >> "$ENV_FILE"
source "$ENV_FILE"

# Symlink helper
link_item() {
  local source="$1"
  local target="$2"

  if [ -e "$target" ] || [ -L "$target" ]; then
    if [ "$(readlink "$target" || true)" = "$source" ]; then
      echo "✅ Already linked: $target"
    else
      echo "⚠️  Skipped existing: $target"
    fi
  else
    mkdir -p "$(dirname "$target")"
    ln -s "$source" "$target"
    echo "🔗 Linked: $source → $target"
  fi
}

# Install HOME/ - unpack contents directly into $HOME
install_home_scope() {
  local home_path="$1"
  [ -d "$home_path" ] || return

  echo "📁 Installing HOME contents from: $home_path"
  find "$home_path" -mindepth 1 -maxdepth 1 | while read -r subdir; do
    [ -d "$subdir" ] || continue

    find "$subdir" -mindepth 1 -maxdepth 1 | while read -r item; do
      name="$(basename "$item")"
      target="$HOME/$name"
      link_item "$item" "$target"
    done
  done
}

# Install .config/ - symlink each top-level directory directly
install_config_scope() {
  local config_path="$1"
  [ -d "$config_path" ] || return

  echo "📁 Installing .config contents from: $config_path"
  find "$config_path" -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
    name="$(basename "$dir")"
    target="$HOME/.config/$name"
    link_item "$dir" "$target"
  done
}

install_scope() {
  local scope_dir="$1"
  echo "🔍 Processing: $scope_dir"
  install_home_scope "$scope_dir/HOME"
  install_config_scope "$scope_dir/.config"
}

# Shared and OS-specific
echo "🔍 Linking shared dotfiles..."
install_scope "$ACTIVE_DIR/shared"

echo "🔍 Linking $OS-specific dotfiles..."
install_scope "$ACTIVE_DIR/$OS"

# macOS: ~/Library/Application Support/
if [ "$OS" = "macos" ]; then
  LIB_PATH="$ACTIVE_DIR/macos/library/Application Support"
  if [ -d "$LIB_PATH" ]; then
    echo "📁 Linking macOS Application Support (1-level deep)"
    find "$LIB_PATH" -mindepth 1 -maxdepth 1 | while read -r item; do
      rel="${item#$LIB_PATH/}"
      target="$HOME/Library/Application Support/$rel"
      link_item "$item" "$target"
    done
  fi
fi

echo -e "\n✅ Done."
echo -e "⚡ You may want to \033[1;32msource ~/.zshrc\033[0m if updated.\n"
