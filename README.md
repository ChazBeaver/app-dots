# app-dotfiles

Portable configuration files for CLI applications I use across multiple platforms. This includes editors, terminals, shells, and utilities like Neovim, Git, Zsh, and more.

## 📂 Structure

- `active/` – Dotfiles currently in use, symlinked via `stow`
- `justfile` – Task runner for managing dotfiles

## 🧰 Requirements

- [just](https://github.com/casey/just)
- [GNU stow](https://www.gnu.org/software/stow/)

## 📦 Managed Dotfiles

These are managed under the `active/` directory:

- `zsh/ → ~/.zshrc`
- `gitconfig/ → ~/.gitconfig`
- `nvim/ → ~/.config/nvim`
- *(Optional: starship, yazi, bash, etc.)*

## 🚀 Usage

```bash
just stow      # Symlink dotfiles from active/ to the appropriate locations
just unstow    # Remove those symlinks
just check     # Verify that symlinks are correctly in place
just status    # Verify that expected files/directories exist
```


## 🧪 Notes

- Only configs in active/ are symlinked.

- This repo is intended to be used across multiple environments, not tied to any particular OS or desktop environment.
