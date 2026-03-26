#!/usr/bin/env bash
set -euo pipefail

echo "Hard resetting Neovim plugins and state..."
rm -rf ~/.cache/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.local/share/nvim/lazy
rm -f ~/.config/nvim/lazy-lock.json

echo
echo "Done."
echo "Config was not touched."
echo "Reopen Neovim and run :Lazy sync"
