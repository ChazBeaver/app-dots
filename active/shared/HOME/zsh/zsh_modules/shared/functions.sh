# ---------- home: fzf jump into ~/Projects/home (names only) ----------
home() {
  local base="$HOME/Projects/home"
  local choice

  [[ -d "$base" ]] || { echo "❌ Missing: $base"; return 1; }

  # List directory *names* only
  choice="$(
    ls -1 "$base" 2>/dev/null \
      | while read -r d; do
          [[ -d "$base/$d" ]] && echo "$d"
        done \
      | sort \
      | fzf \
          --height 60% \
          --reverse \
          --prompt='home> ' \
          --preview 'ls -la --color=always "$HOME/Projects/home/{}" | sed -n "1,120p"'
  )" || return 0

  cd "$base/$choice" || return 1
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
  cmd=$(fc -lnr 1 | fzf --tac) || return
  print -z -- "$cmd"
}

# # Select Theme for Zsh, Neovim, Kitty, Starship, and Btop
# tt() {
#   local script="$APP_DOTS_DIR/active/shared/.config/colors/pick-theme.sh"
#   if [[ -x "$script" ]]; then
#     bash "$script"
#   else
#     echo "❌ pick-theme.sh not found or not executable at: $script"
#   fi
# }

# Print a list of Colors for testing
printcolors() {
  for i in {0..255}; do print -P "%F{$i}Color $i%f"; done
}

