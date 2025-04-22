# App-Dots

A simple, clean, and future-proof dotfiles repository for managing application configurations on Linux and macOS systems.

This project uses a pure Bash install script (`install.sh`) to safely symlink configuration files and directories into your home directory (`$HOME`), without any external dependencies.

---

## 📦 What's Included

| Application | Configs |
|:------------|:--------|
| Bash         | `.bashrc`, `.bash_profile` |
| Git          | `.gitconfig` |
| Neovim       | `.config/nvim/` |
| Starship     | `starship.toml` |
| Yazi         | `.config/yazi/` |
| Zsh          | `.zshrc`, `.zsh_history` |

---

## 🚀 Installation

Clone the repository:

```bash
git clone https://github.com/yourusername/app-dots.git ~/Projects/app-dots
```

Run the install script:

```bash
cd ~/Projects/app-dots
./install.sh
```

This will:

    Dynamically detect the install location.

    Set the APP_DOTS_DIR environment variable globally (~/.dotfiles-env.sh).

    Symlink all files and directories inside the active/ folder into your $HOME or $HOME/.config/, depending on the structure.

## 🛠 Project Structure

```bash
active/
├── bash/
│   ├── .bash_profile
│   └── .bashrc
├── .config/
│   ├── nvim/
│   └── yazi/
├── gitconfig/
│   └── .gitconfig
├── starship/
│   └── starship.toml
├── zsh/
│   ├── .zsh_history
│   └── .zshrc
install.sh
```
    active/ — Files that are actively installed by the script.

    inactive/ — (Optional) Files stored but not currently linked.

    install.sh — Installation script for this project.

## ⚡ Philosophy

    Pure Bash: No Stow, no Just, no external tooling required.

    Future-Proof: Designed to work across different Linux/macOS setups with minimal changes.

    Selective Install: Only files and folders inside active/ are installed.

    Safe: Existing files are left untouched unless symlinks match exactly.

## 📋 Notes

    Make sure you have a ~/.config/ directory already created (most systems do).

    Re-run install.sh anytime you move files into or out of active/.

    Environment variables like APP_DOTS_DIR are automatically persisted in ~/.dotfiles-env.sh.

## ✨ Future Improvements

    Optional backup system for existing conflicting files.

    Add a summary report at the end of installs (e.g., "5 links created, 1 skipped").

    Bootstrap multi-repo installs (e.g., app-dots + hypr-dots together).

## 📜 License

This project is open-source and free to use under the MIT License.

