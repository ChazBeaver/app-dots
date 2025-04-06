set shell := ["zsh", "-cu"]

default:
	@just --summary

stow:
	cd active && \
	stow -t $HOME zsh gitconfig && \
	# stow -t $HOME/.config starship yazi bash && \
	stow -t $HOME/.config nvim

unstow:
	cd active && \
	stow -D -t $HOME zsh gitconfig && \
	# stow -D -t $HOME/.config starship yazi bash && \
	stow -D -t $HOME/.config nvim

check:
	ls -l ~/.zshrc
	ls -l ~/.gitconfig
	ls -l ~/.config/nvim/init.lua
