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
| Zsh        | `.zshrc` |

---

## 🚀 Install

The install script will:

- Set the `APP_DOTS_DIR` environment variable (saved in `~/.dotfiles-env.sh`).
- Create an alias `appdots` to `cd` you to wherever you installed the app-dots project
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

This system includes a `appdots-pull.sh` and a `hyprdots-pull.sh` helper script that automatically runs `git pull --rebase` on your app-dots and hypr-dots repos every time a new terminal session starts. Continue reading to find out how to disable this feature.

This behavior is **enabled by default** by sourcing the script inside `.zshrc`.

### 🧘 Disable Auto Git Pull

If you **don't want Git pulling every time you open your terminal**, you can:

- **Remove or comment out** (rename the filetype to .sh.bak) the following:

  - `appdots-pull.sh` script from the active/shared/HOME/zsh/zsh_modules/shared folder:
  - `hyprdots-pull.sh` script from the active/shared/HOME/zsh/zsh_modules/linux folder:

I have this enabled for myself as I develop between systems

---

## 📜 License

MIT License
