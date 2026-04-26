#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
# appdots/sync.sh
# Declarative symlink sync. Idempotent, safe to run repeatedly.
# Does NOT run imperative OS mutations — see bootstrap.sh for that.

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}")" &>/dev/null && pwd)"
ACTIVE_DIR="$SCRIPT_DIR/active"
BIN_DIR="$SCRIPT_DIR/bin"
ENV_FILE="$HOME/.dotfiles-env.sh"
VAR_NAME="APP_DOTS_DIR"

# shellcheck source=lib/log.sh
source "$SCRIPT_DIR/lib/log.sh"
# shellcheck source=lib/detect.sh
source "$SCRIPT_DIR/lib/detect.sh"
# shellcheck source=lib/link.sh
source "$SCRIPT_DIR/lib/link.sh"

OS="$(detect_os)"

cat <<'EOF'

  ___  __________________ _____ _____ _____
 / _ \ | ___ \ ___ \  _  \  _  |_   _/  ___|
/ /_\ \| |_/ / |_/ / | | | | | | | | \ `--.
|  _  ||  __/|  __/| | | | | | | | |  `--. \
| | | || |   | |   | |/ /\ \_/ / | | /\__/ /
\_| |_/\_|   \_|   |___/  \___/  \_/ \____/

                Syncing Appdots

EOF

# ---- Persist APP_DOTS_DIR + alias ----
if [ -z "${APP_DOTS_DIR:-}" ]; then
  if [[ "$SCRIPT_DIR" == "$HOME"* ]]; then
    export APP_DOTS_DIR="$SCRIPT_DIR"
    log_info "Set APP_DOTS_DIR to $SCRIPT_DIR"
  else
    log_warn "appdots not inside home directory. Set APP_DOTS_DIR manually."
  fi
fi

mkdir -p "$(dirname "$ENV_FILE")"
grep -q "$VAR_NAME=" "$ENV_FILE" 2>/dev/null \
  || echo "export $VAR_NAME=\"$SCRIPT_DIR\"" >> "$ENV_FILE"
grep -q 'alias appdots=' "$ENV_FILE" 2>/dev/null \
  || echo 'alias appdots="cd \$APP_DOTS_DIR"' >> "$ENV_FILE"
# shellcheck disable=SC1090
source "$ENV_FILE" || true

# ---- Symlink sync ----
log_step "Linking shared dotfiles..."
install_scope "$ACTIVE_DIR/shared"

log_step "Linking $OS-specific dotfiles..."
install_scope "$ACTIVE_DIR/$OS"

# ---- Bin sync ----
install_bin_scope "$BIN_DIR" "$OS"

echo
log_ok "Sync complete."
log_info "You may want to source ~/.zshrc if it was updated."
