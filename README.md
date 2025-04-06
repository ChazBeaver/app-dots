# app-dotfiles

Terminal and CLI tool configurations including Neovim, Yazi, Zsh, Git, and Starship.

## 📂 Structure

- `active/` – Dotfiles currently in use (symlinked using `stow`)
- `inactive/` – Archived or unused dotfiles (not symlinked)
- `justfile` – Task runner for setup, backup, restore, and management

## 🧰 Requirements

- [just](https://github.com/casey/just)
- [GNU stow](https://www.gnu.org/software/stow/)

## 📦 Active Dotfiles

These are expected to be inside the `active/` directory:

- `bash/ → ~/.bashrc`
- `zsh/ → ~/.zshrc`
- `git/ → ~/.gitconfig`
- `starship/ → ~/.config/starship.toml`
- `nvim/ → ~/.config/nvim`
- `yazi/ → ~/.config/yazi`

## 🚀 Usage

```bash
just stow      # Symlink configs from active/ to the appropriate locations
just unstow    # Remove symlinks created by stow
just backup    # Save current system configs to ~/backups
just restore   # Restore backed-up configs from ~/backups
```

##🧪 Notes

 - Only configs in active/ are stowed.

 - Use inactive/ to store alternative configs without deleting them.
