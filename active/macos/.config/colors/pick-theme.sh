#!/usr/bin/env bash
set -e

COLOR_DIR="$HOME/.config/colors"
SCHEME_DIR="$COLOR_DIR/schemes"

theme=$(basename "$(ls "$SCHEME_DIR" | fzf)" .sh)

if [[ -z "$theme" ]]; then
  echo "❌ No theme selected."
  exit 1
fi

bash "$COLOR_DIR/apply.sh" "$theme"
