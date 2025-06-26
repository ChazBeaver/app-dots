# For Mac
alias here='open .'

# Edit Ghostty Config
edit-ghostty() {
    vim $HOME/Library/Application\ Support/com.mitchellh.ghostty/config
}
# Edit Starship Config File
edit-starship() {
    vim $HOME/.config/starship.toml
}

kill-kitty() {
  osascript -e 'quit app "kitty"'
}
alias kk="kill-kitty"

alias la="eza -lahG --icons --grid --group-directories-first"
alias ls="eza -lah --icons --group-directories-first"
alias tree="eza --tree"
