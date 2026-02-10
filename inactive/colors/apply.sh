#!/usr/bin/env bash
# colors/apply.sh
set -euo pipefail

# Resolve this script's directory reliably (works via symlink too)
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"

COLOR_DIR="$SCRIPT_DIR"
SCHEME_DIR="$REPO_ROOT/colors/schemes"
GEN_DIR="$COLOR_DIR/generate"

THEME="${1:-}"

if [[ -z "$THEME" ]]; then
  echo "❌ No theme provided. Usage: $(basename "$0") <theme-name>"
  exit 1
fi

SCHEME_FILE="$SCHEME_DIR/$THEME.sh"
if [[ ! -f "$SCHEME_FILE" ]]; then
  echo "❌ Theme '$THEME' does not exist in $SCHEME_DIR"
  exit 1
fi

echo "🎨 Applying theme: $THEME"
export THEME

# Load color variables from scheme
# shellcheck source=/dev/null
source "$SCHEME_FILE"

# Fallbacks for missing colors
for i in $(seq -w 1 26); do
  var="color$i"
  : "${!var:=#000000}"
  export "$var"
done

# Apply to ONLY kitty for now (others commented out)
# for gen in "$GEN_DIR"/*.sh; do
#   source "$gen"
# done

# Only run kitty generator
# shellcheck source=/dev/null
source "$GEN_DIR/kitty.sh"

echo "✅ Theme '$THEME' applied (kitty only)."
