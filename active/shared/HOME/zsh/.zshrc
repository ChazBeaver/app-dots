# ============================================================================
# Load Zsh Configurations
# ============================================================================

# --- Set base directory ---
BASE_DIR="$HOME/zsh_modules"

# --- Source everything inside common/ ---
SHARED_DIR="$BASE_DIR/shared"

if [ -d "$SHARED_DIR" ]; then
  for file in "$SHARED_DIR"/*.sh; do
    [ -r "$file" ] && source "$file"
  done
fi

# --- Detect OS ---
case "$(uname -s)" in
  Darwin)  OS_NAME="macos" ;;
  Linux)   OS_NAME="linux" ;;
  *)       OS_NAME="unknown" ;;
esac

# --- Source everything inside the OS-specific folder ---
OS_DIR="$BASE_DIR/$OS_NAME"

if [ -d "$OS_DIR" ]; then
  for file in "$OS_DIR"/*.sh; do
    [ -r "$file" ] && source "$file"
  done
fi

# --- Load additional macOS-specific scripts from custom location ---
if [ "$OS_NAME" = "macos" ] && [ -d "$HOME/Projects/work/zsh" ]; then
  for file in "$HOME/Projects/work/zsh"/*.sh; do
    [ -r "$file" ] && source "$file"
  done
fi
