edit-zmodules() {
    vim "~/Projects/app-dots/active/shared/HOME/zsh/zsh_modules/"
}

edit-zshrc() {
    vim $HOME/.zshrc
}

# Make a Dir and Jump to it Immediately
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Search History using FZF
hf() {
  local cmd
  cmd=$(sed -E 's/^[^;]*;//' ~/.zsh_history | fzf --tac) || return
  print -z "$cmd"
}

# Select Theme for Zsh, Neovim, Kitty, Starship, and Btop
tt() {
  local script="$APP_DOTS_DIR/active/shared/.config/colors/pick-theme.sh"
  if [[ -x "$script" ]]; then
    bash "$script"
  else
    echo "❌ pick-theme.sh not found or not executable at: $script"
  fi
}

# Print a list of Colors for testing
printcolors() {
  for i in {0..255}; do print -P "%F{$i}Color $i%f"; done
}

