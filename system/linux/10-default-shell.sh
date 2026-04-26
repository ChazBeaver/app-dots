#!/usr/bin/env bash
set -euo pipefail
# appdots/system/linux/10-default-shell.sh
# Set zsh as the default login shell.

if [[ "$SHELL" == */zsh ]]; then
  echo "✓ zsh is already the default shell"
  exit 0
fi

if ! command -v zsh >/dev/null 2>&1; then
  echo "⚠️  zsh not installed yet — skipping (run packages/linux/core.sh first)"
  exit 0
fi

zsh_path="$(command -v zsh)"

# Ensure it's listed in /etc/shells
if ! grep -qx "$zsh_path" /etc/shells; then
  echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
fi

echo "==> Changing default shell to $zsh_path"
chsh -s "$zsh_path"
echo "✓ Log out and back in for the change to take effect."
