# App-Dots

A simple, modular dotfiles system for managing application configurations across Linux and macOS.

App-Dots uses a pure Bash install script to symlink configs cleanly into your `$HOME` or `$HOME/.config` directory.  
No dependencies, no extra tools — just fast, clean installs.

---

## 📦 What's Inside

| App / Tool | Config |
|:-----------|:-------|
| Bash       | `.bashrc`, `.bash_profile` |
| Git        | `.gitconfig` |
| Neovim     | `.config/nvim/` |
| Starship   | `starship.toml` |
| Yazi       | `.config/yazi/` |
| Zsh        | `.zshrc`, `.zsh_history` |

---

## 🚀 Install

The install script will:

- Set the `APP_DOTS_DIR` environment variable (saved in `~/.dotfiles-env.sh`).
- Symlink configs from `active/` into `$HOME` or `$HOME/.config/` based on structure.
- Skip anything already correctly linked.

---

## 🛠 How It Works

- **active/** — Configs you want linked into your system.
- **inactive/** — Configs stored for later, but not installed.

Move files between `active/` and `inactive/` as needed, then re-run `install.sh`.

The script only links top-level files and folders — no deep recursion, no surprises.

---

## 🔄 Automatic Git Pull Behavior

This system includes a `git-pull-projects.sh` helper script that automatically runs `git pull --rebase` on your dotfiles repos every time a new terminal session starts.

This behavior is **enabled by default** by sourcing the script inside `.zshrc`.

### 🧘 Disable Auto Git Pull

If you **don't want Git pulling every time you open your terminal**, you can:

- **Remove or comment out** the `git-pull-projects.sh` script from the following folders:
  - `zsh_modules/common/`
  - `zsh_modules/linux/`
  - `zsh_modules/macos/`

I have this enabled for myself as I develop between systems

---

## ✨ Coming Soon

- Optional backups for conflicting files.
- Install summary (e.g., number of links created, skipped).
- Combined bootstrap script for multi-repo installs (app-dots + hypr-dots).

---

## 📜 License

MIT License
