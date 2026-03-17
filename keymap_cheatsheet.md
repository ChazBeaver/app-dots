# 🧠 Neovim Keymap Cheatsheet (Telescope + Git Workflow)

---

# 📂 FILES / NAVIGATION

| Keymap       | Action                                              |
| ------------ | --------------------------------------------------- |
| `<leader>ff` | Find ALL files (project, includes hidden + ignored) |
| `<leader>fa` | Find ALL files from `$HOME`                         |
| `<leader>fo` | Find Omarchy files                                  |
| `<leader>fb` | Find buffers                                        |
| `<leader>fr` | Recent files                                        |

---

# 🔍 SEARCH

| Keymap       | Action                                   |
| ------------ | ---------------------------------------- |
| `<leader>sl` | Live grep (deep search, includes hidden) |
| `<leader>ss` | Search input string (deep search)        |
| `<leader>sw` | Search word under cursor                 |
| `<leader>sg` | Search within git repo only              |
| `<leader>sd` | Search diagnostics                       |

---

# 🌿 GIT — TELESCOPE (READ / EXPLORE)

| Keymap                 | Action                       |
| ---------------------- | ---------------------------- |
| `<leader>gc`           | Git commits                  |
| `<leader>gb`           | Git branches                 |
| `<leader>gt`           | Git status (Telescope)       |
| `<leader>gfh`          | Git history (current file)   |
| `<leader>gfh` (visual) | Git history (selected lines) |

---

# 🧩 GIT — NEOGIT (WORKFLOW)

| Keymap       | Action                        |
| ------------ | ----------------------------- |
| `<leader>ga` | Open Neogit                   |
| `<leader>gC` | Commit popup (Neogit UI)      |
| `<leader>gL` | Log popup                     |
| `<leader>gl` | Pull popup                    |
| `<leader>gP` | Push popup                    |
| `<leader>gm` | Quick commit (inline message) |
| `<leader>gp` | Quick push `origin HEAD`      |

---

# 📦 GIT — STAGING

| Keymap        | Action             |
| ------------- | ------------------ |
| `<leader>gsf` | Stage current file |
| `<leader>gsa` | Stage ALL files    |
| `<leader>ghs` | Stage hunk         |

---

# 🔍 GIT — INSPECT / DIFF

| Keymap        | Action                    |
| ------------- | ------------------------- |
| `<leader>ghp` | Preview hunk              |
| `<leader>gd`  | Diff current file vs HEAD |
| `<leader>gB`  | Blame line                |

---

# 🔁 GIT — NAVIGATION (HUNKS)

| Keymap        | Action        |
| ------------- | ------------- |
| `<leader>ghn` | Next hunk     |
| `<leader>ghN` | Previous hunk |

---

# ♻️ GIT — RESET / UNDO

| Keymap        | Action     |
| ------------- | ---------- |
| `<leader>ghr` | Reset hunk |

---

# 🪟 FLOATING GIT PREVIEW (NEOGIT STATUS)

| Keymap  | Action                                            |
| ------- | ------------------------------------------------- |
| `zf`    | Open floating diff preview (inside Neogit status) |
| `q`     | Close preview                                     |
| `<Esc>` | Close preview                                     |

---

# ⚡ MENTAL MODEL (IMPORTANT)

### Everything Git starts with:

```
<leader>g
```

### Then:

* `s` → stage
* `h` → hunk
* `r` → reset
* `d` → diff
* `B` → blame
* `p` → preview
* `n/N` → next / previous
* `a` → open app (Neogit)
* `m` → commit
* `P` → push
* `l` → pull / log

---

# 🚀 BONUS (Your Git CLI equivalents)

| Action                          | Command                                  |
| ------------------------------- | ---------------------------------------- |
| Reset everything                | `git reset --hard HEAD`                  |
| Full wipe (including untracked) | `git reset --hard HEAD && git clean -fd` |
| Unstage                         | `git restore --staged .`                 |
| Discard changes                 | `git restore .`                          |

