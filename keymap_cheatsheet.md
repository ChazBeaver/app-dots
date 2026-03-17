# 🔑 Neovim Keymap Cheat Sheet

---

# 🧠 Core Philosophy

* `<leader>g` → **Git (everything)**
* `<leader>s` → **Search (Telescope)**
* `<leader>f` → **Files**
* `<leader>h` → **Harpoon**

---

# 🔍 Telescope (Search & Navigation)

## Files

| Key          | Action                                    |
| ------------ | ----------------------------------------- |
| `<leader>ff` | Find all files (project, includes hidden) |
| `<leader>fa` | Find all files from `$HOME`               |
| `<leader>fo` | Find Omarchy files                        |
| `<leader>fb` | Find open buffers                         |
| `<leader>fr` | Recent files                              |

## Search

| Key          | Action                                   |
| ------------ | ---------------------------------------- |
| `<leader>sl` | Live grep (deep search, includes hidden) |
| `<leader>ss` | Search input string                      |
| `<leader>sw` | Search word under cursor                 |
| `<leader>sg` | Search from git repo root                |

## Git (Telescope - Read Only)

| Key               | Action                     |
| ----------------- | -------------------------- |
| `<leader>gc`      | Git commits (history)      |
| `<leader>gb`      | Git branches               |
| `<leader>gt`      | Git status                 |
| `<leader>gfh`     | File commit history        |
| `v + <leader>gfh` | History for selected lines |

## Diagnostics

| Key          | Action             |
| ------------ | ------------------ |
| `<leader>sd` | Search diagnostics |

---

# 🧰 Neogit (Git Actions / Write Operations)

## Repo UI

| Key          | Action      |
| ------------ | ----------- |
| `<leader>ga` | Open Neogit |

## Commit / Push / Pull

| Key           | Action                        |
| ------------- | ----------------------------- |
| `<leader>gcm` | Commit popup                  |
| `<leader>gm`  | Quick commit (staged changes) |
| `<leader>gP`  | Push popup                    |
| `<leader>gpp` | Quick push (`origin HEAD`)    |
| `<leader>gl`  | Pull                          |
| `<leader>gL`  | Log                           |

## Staging

| Key           | Action             |
| ------------- | ------------------ |
| `<leader>gsf` | Stage current file |
| `<leader>gsa` | Stage all files    |

## Neogit Buffer

| Key  | Action                 |
| ---- | ---------------------- |
| `zf` | Floating diff preview  |
| `q`  | Close floating preview |

---

# 🔥 Gitsigns (Hunk-Level Control)

## Navigation

| Key           | Action        |
| ------------- | ------------- |
| `<leader>ghn` | Next hunk     |
| `<leader>ghp` | Previous hunk |

## Inspection

| Key          | Action            |
| ------------ | ----------------- |
| `<leader>gp` | Preview hunk      |
| `<leader>gd` | Diff file vs HEAD |
| `<leader>gB` | Blame line        |

## Actions

| Key           | Action     |
| ------------- | ---------- |
| `<leader>gsh` | Stage hunk |
| `<leader>grh` | Reset hunk |

---

# 🎯 Harpoon

## Core

| Key         | Action              |
| ----------- | ------------------- |
| `<leader>a` | Add file to Harpoon |
| `<leader>h` | Toggle Harpoon menu |

## Quick Navigation

| Key          | Action |
| ------------ | ------ |
| `<C-h><C-h>` | File 1 |
| `<C-h><C-j>` | File 2 |
| `<C-h><C-k>` | File 3 |
| `<C-h><C-l>` | File 4 |
| `<C-h><C-y>` | File 5 |
| `<C-h><C-u>` | File 6 |
| `<C-h><C-i>` | File 7 |
| `<C-h><C-o>` | File 8 |

---

# 🚀 Common Workflows

## Partial Commit (Hunk-Based)

```
:w
<leader>ghn   → navigate to change
<leader>gp    → preview
<leader>gsh   → stage hunk
<leader>gm    → commit
<leader>gpp   → push
```

## Full File Commit

```
:w
<leader>gsf
<leader>gm
<leader>gpp
```

## Full Repo Commit

```
<leader>gsa
<leader>gm
<leader>gpp
```

## Visual Git Review

```
<leader>ga
zf
q
```

---

# 🧩 Mental Model

```
g → Git

gs → stage
gh → hunk navigation
gp → preview
gd → diff
gB → blame
gr → reset

gm → commit
gP → push
gpp → quick push
```

---

# 💡 Notes

* Telescope = **read / explore**
* Neogit = **repo actions**
* Gitsigns = **surgical edits (hunks)**
* Harpoon = **navigation speed**

---
