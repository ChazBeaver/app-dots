#!/usr/bin/env bash
set -euo pipefail

echo "Cleaning Neovim cache and state..."
rm -rf ~/.cache/nvim
rm -rf ~/.local/state/nvim

echo
echo "Done."
echo "Config and installed plugins were not touched."
