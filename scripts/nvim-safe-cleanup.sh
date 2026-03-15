#!/usr/bin/env bash
set -euo pipefail

echo "Cleaning Neovim cache/state/data..."
rm -rf ~/.cache/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.local/share/nvim

echo
echo "Done."
echo "Your config at ~/.config/nvim was NOT touched."
echo "Now reopen nvim so plugins can reinstall."
