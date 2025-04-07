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
	test -L ~/.zshrc && echo "✔ ~/.zshrc is symlinked" || echo "✘ ~/.zshrc is NOT symlinked"
	test -L ~/.gitconfig && echo "✔ ~/.gitconfig is symlinked" || echo "✘ ~/.gitconfig is NOT symlinked"
	test -L ~/.config/nvim && echo "✔ ~/.config/nvim is symlinked" || echo "✘ ~/.config/nvim is NOT symlinked"

status:
	test -e ~/.zshrc && echo "✔ ~/.zshrc exists" || echo "✘ ~/.zshrc is missing"
	test -e ~/.gitconfig && echo "✔ ~/.gitconfig exists" || echo "✘ ~/.gitconfig is missing"
	test -e ~/.config/nvim && echo "✔ ~/.config/nvim exists" || echo "✘ ~/.config/nvim is missing"
