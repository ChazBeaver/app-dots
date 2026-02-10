#!/usr/bin/env bash
# colors/pick-theme.sh
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"

COLOR_DIR="$SCRIPT_DIR"                 # .../inactive/colors
SCHEME_DIR="$REPO_ROOT/colors/schemes"  # .../inactive/colors/schemes

command -v fzf >/dev/null 2>&1 || { echo "❌ fzf not found in PATH" >&2; exit 1; }

if [[ ! -d "$SCHEME_DIR" ]]; then
  echo "❌ Scheme directory not found: $SCHEME_DIR"
  exit 1
fi

theme="$(
  find "$SCHEME_DIR" -maxdepth 1 -type f -name '*.sh' -print \
    | while IFS= read -r f; do basename "$f"; done \
    | sed 's/\.sh$//' \
    | sort \
    | fzf --prompt="theme> "
)" || exit 1

[[ -z "${theme:-}" ]] && { echo "❌ No theme selected."; exit 1; }

bash "$COLOR_DIR/apply.sh" "$theme"
