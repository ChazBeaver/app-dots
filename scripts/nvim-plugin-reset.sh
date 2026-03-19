#!/usr/bin/env bash
set -euo pipefail

echo "Cleaning Neovim cache/state..."
rm -rf ~/.cache/nvim
rm -rf ~/.local/state/nvim

echo "Removing installed plugins..."
rm -rf ~/.local/share/nvim/lazy

echo
echo "Done."
echo "Config was not touched."
echo "Reopen Neovim and run :Lazy sync"
