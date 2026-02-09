#!/usr/bin/env bash
set -e

COLOR_DIR="$HOME/.config/colors"
SCHEME_DIR="$COLOR_DIR/schemes"

THEME="$1"

if [[ -z "$THEME" ]]; then
  echo "❌ No theme provided. Usage: ./apply.sh <theme-name>"
  exit 1
fi

SCHEME_FILE="$SCHEME_DIR/$THEME.sh"
if [[ ! -f "$SCHEME_FILE" ]]; then
  echo "❌ Theme '$THEME' does not exist in $SCHEME_DIR"
  exit 1
fi

echo "🎨 Applying theme: $THEME"
export THEME

# Load color variables
source "$SCHEME_FILE"

# Fallbacks for missing colors
for i in $(seq -w 1 26); do
  var="color$i"
  : "${!var:=#000000}"
  export "$var"
done

# Apply to all apps
for gen in "$COLOR_DIR"/generate/*.sh; do
  source "$gen"
done

echo "✅ Theme '$THEME' applied to all supported applications."
