
edit-zshrc() {
    vim $HOME/.zshrc
}

mkcd() {
  mkdir -p "$1" && cd "$1"
}

hf() {
  local cmd
  cmd=$(sed -E 's/^[^;]*;//' ~/.zsh_history | fzf --tac) || return
  print -z "$cmd"
}

printcolors() {
  for i in {0..255}; do print -P "%F{$i}Color $i%f"; done
}
