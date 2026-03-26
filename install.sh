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
OS="$(detect_os)"

cat <<'EOF'

  ___  __________________ _____ _____ _____ 
 / _ \ | ___ \ ___ \  _  \  _  |_   _/  ___|
/ /_\ \| |_/ / |_/ / | | | | | | | | \ `--. 
|  _  ||  __/|  __/| | | | | | | | |  `--. \
| | | || |   | |   | |/ /\ \_/ / | | /\__/ /
\_| |_/\_|   \_|   |___/  \___/  \_/ \____/ 

             Installing Appdots

EOF

# Save APP_DOTS_DIR
if [ -z "${APP_DOTS_DIR:-}" ]; then
  if [[ "$SCRIPT_DIR" == "$HOME"* ]]; then
    export APP_DOTS_DIR="$SCRIPT_DIR"
    echo "Set APP_DOTS_DIR to $SCRIPT_DIR"
  else
    echo "Warning: appdots not inside home directory. Please set APP_DOTS_DIR manually."
  fi
fi

mkdir -p "$(dirname "$ENV_FILE")"
grep -q "$VAR_NAME=" "$ENV_FILE" 2>/dev/null || echo "export $VAR_NAME=\"$SCRIPT_DIR\"" >> "$ENV_FILE"
grep -q 'alias appdots=' "$ENV_FILE" 2>/dev/null || echo 'alias appdots="cd \$APP_DOTS_DIR"' >> "$ENV_FILE"
# shellcheck disable=SC1090
source "$ENV_FILE" || true

link_item() {
  local source="$1"
  local target="$2"

  # If target exists…
  if [ -e "$target" ] || [ -L "$target" ]; then
    # If it's already the correct symlink, done.
    if [ -L "$target" ] && [ "$(readlink "$target" 2>/dev/null || true)" = "$source" ]; then
      echo "✅ Already linked: $target"
      return 0
    fi

    # If it's some other symlink, remove it and relink.
    if [ -L "$target" ]; then
      rm -f "$target"
      echo "♻️  Replacing symlink: $target"
    else
      # It's a real file/dir. Remove it so we can symlink.
      rm -rf "$target"
      echo "🧹 Removed existing file/dir: $target"
    fi
  fi

  mkdir -p "$(dirname "$target")"
  ln -s "$source" "$target"
  echo "🔗 Linked: $source → $target"
}

# HOME/ rules:
# - If top-level entry is a dotfile/dotdir (name begins with .), link it to ~/<name>
# - If top-level entry is a non-dot directory (e.g., bash/, gitconfig/), link its immediate contents into ~/
install_home_scope() {
  local home_path="$1"
  [ -d "$home_path" ] || return 0

  echo "🏠 Installing HOME from: $home_path"

  find "$home_path" -mindepth 1 -maxdepth 1 | while read -r entry; do
    local base
    base="$(basename "$entry")"

    if [ -d "$entry" ] && [[ "$base" != .* ]]; then
      # category/container dir: link its children into $HOME (1-level deep)
      find "$entry" -mindepth 1 -maxdepth 1 | while read -r item; do
        local name
        name="$(basename "$item")"
        link_item "$item" "$HOME/$name"
      done
    else
      # actual home item (dotfile, dotdir, or regular file you intentionally want at ~/)
      link_item "$entry" "$HOME/$base"
    fi
  done
}

# .config/ -> mirror into ~/.config (1:1, supports dirs and files like starship.toml)
install_config_scope() {
  local config_path="$1"
  [ -d "$config_path" ] || return 0

  echo "⚙️  Installing .config from: $config_path"
  find "$config_path" -mindepth 1 -maxdepth 1 | while read -r item; do
    local name
    name="$(basename "$item")"
    link_item "$item" "$HOME/.config/$name"
  done
}

# macOS library/ -> mirror into ~/Library (1:1 at top-level, e.g. Preferences/)
install_macos_library_scope() {
  local lib_path="$1"
  [ -d "$lib_path" ] || return 0
  [ "$OS" = "macos" ] || return 0

  echo " Installing Library from: $lib_path"
  find "$lib_path" -mindepth 1 -maxdepth 1 | while read -r item; do
    local name
    name="$(basename "$item")"
    link_item "$item" "$HOME/Library/$name"
  done
}

install_scope() {
  local scope_dir="$1"
  [ -d "$scope_dir" ] || return 0

  echo "🔍 Processing scope: $scope_dir"
  install_home_scope "$scope_dir/HOME"
  install_config_scope "$scope_dir/.config"
  install_macos_library_scope "$scope_dir/library"
}

run_macos_scripts() {
  [ "$OS" = "macos" ] || return 0

  local macos_scripts_dir="$SCRIPT_DIR/scripts/macos"
  [ -d "$macos_scripts_dir" ] || return 0

  echo " Running macOS scripts from: $macos_scripts_dir"

  find "$macos_scripts_dir" -mindepth 1 -maxdepth 1 -type f | sort | while read -r script; do
    chmod +x "$script" 2>/dev/null || true
    echo "▶ Running: $(basename "$script")"
    "$script"
  done
}

echo "🔍 Linking shared dotfiles..."
install_scope "$ACTIVE_DIR/shared"

echo "🔍 Linking $OS-specific dotfiles..."
install_scope "$ACTIVE_DIR/$OS"

run_macos_scripts

if [ "$OS" = "macos" ]; then
  echo -e "\n📣 macOS post-install notice:"
  echo "⚠️  If apps (e.g., Rectangle) don't recognize plist changes:"
  echo "   → Restart the app, or run: killall cfprefsd"
fi

echo -e "\n✅ Done."
echo -e "⚡ You may want to source ~/.zshrc if updated.\n"
