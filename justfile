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

backup:
	mkdir -p ~/backups
	rsync -a ~/.zshrc ~/backups/
	rsync -a ~/.bashrc ~/backups/
	rsync -a ~/.gitconfig ~/backups/
	# rsync -a ~/.config/starship ~/backups/
	rsync -a ~/.config/nvim ~/backups/nvim/
	# rsync -a ~/.config/yazi ~/backups/yazi/

restore:
	rsync -a ~/backups/.zshrc ~/
	rsync -a ~/backups/.bashrc ~/
	rsync -a ~/backups/.gitconfig ~/
	# rsync -a ~/backups/starship ~/.config/
	rsync -a ~/backups/nvim/ ~/.config/nvim/
	# rsync -a ~/backups/yazi/ ~/.config/yazi/

