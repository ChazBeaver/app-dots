#!/usr/bin/env bash

alias appdots="cd \$HOME/Projects/app-dots"
alias hyprdots="cd \$HOME/Projects/hypr-dots"

set -euo pipefail
IFS=$'\n\t'

# ============================================================================
# Update Dotfiles Repos
# Pulls the latest changes using `git pull --rebase`
# ============================================================================


DOTFILES_DIRS=(
  "$HOME/Projects/app-dots"
  "$HOME/Projects/hypr-dots"
)

for dir in "${DOTFILES_DIRS[@]}"; do
  if [ -d "$dir/.git" ]; then
    echo "🔄 Updating: $dir"
    git -C "$dir" pull --rebase
  else
    echo "⚠️  Skipping: $dir (not a git repo)"
  fi
done

echo "✅ All dotfiles repos updated."
