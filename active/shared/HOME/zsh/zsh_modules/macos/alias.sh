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

alias la="eza -lah --icons --grid --group-directories-first"
alias ll="eza -la --icons --grid --group-directories-first"
alias ls="eza --icons"
alias tree="eza --tree"
