# include .profile if it exists
[[ -f ~/.profile ]] && . ~/.profile

# include .bashrc if it exists
[[ -f ~/.bashrc ]] && . ~/.bashrc


. "$HOME/.local/share/../bin/env"
