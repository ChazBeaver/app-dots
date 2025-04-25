# ============================================================================
# Load Zsh Configurations
# ============================================================================

# --- Set base directory ---
BASE_DIR="$HOME/zsh_modules"

# --- Source everything inside common/ ---
COMMON_DIR="$BASE_DIR/common"

if [ -d "$COMMON_DIR" ]; then
  for file in "$COMMON_DIR"/*.sh; do
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
