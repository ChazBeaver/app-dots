# Neovim Keymap Cheat Sheet

## Core layout

- `<leader>g` → Git
- `<leader>s` → Search
- `<leader>f` → Files
- `<leader>h` → Harpoon

---

## Telescope

### Files / navigation
- `<leader>ff` → Find all files in project
- `<leader>fa` → Find all files from `$HOME`
- `<leader>fo` → Find Omarchy files
- `<leader>fb` → Find buffers
- `<leader>fr` → Recent files

### Search
- `<leader>sl` → Deep live grep (includes hidden and ignored)
- `<leader>ss` → Search for input string
- `<leader>sw` → Search word under cursor
- `<leader>sg` → Search git repo from repo root

### Git (Telescope / read-oriented)
- `<leader>gc` → Git commits
- `<leader>gb` → Git branches
- `<leader>gt` → Git status
- `<leader>gfh` → Git history for current file
- Visual `<leader>gfh` → Git history for selected lines

### Diagnostics
- `<leader>sd` → Search diagnostics

---

## Neogit

### Main repo actions
- `<leader>ga` → Open Neogit
- `<leader>gC` → Neogit commit popup
- `<leader>gL` → Neogit log popup
- `<leader>gl` → Neogit pull popup
- `<leader>gP` → Neogit push popup

### Stage / commit / push helpers
- `<leader>gsf` → Stage current file
- `<leader>gsa` → Stage all files
- `<leader>gm` → Quick commit staged changes
- `<leader>gp` → Quick push `origin HEAD`

### Inside Neogit status buffer
- `zf` → Floating git preview for file under cursor
- `q` → Close floating preview

---

## Gitsigns

### Hunk navigation
- `<leader>ghn` → Next hunk
- `<leader>ghN` → Previous hunk

### Hunk inspection
- `<leader>ghp` → Preview hunk
- `<leader>gd` → Diff current file vs HEAD
- `<leader>gB` → Blame line

### Hunk actions
- `<leader>gsh` → Stage hunk
- `<leader>grh` → Reset hunk

---

## Harpoon

### Core
- `<leader>a` → Add file to Harpoon
- `<leader>h` → Toggle Harpoon menu

### Direct jumps
- `<C-h><C-h>` → File 1
- `<C-h><C-j>` → File 2
- `<C-h><C-k>` → File 3
- `<C-h><C-l>` → File 4
- `<C-h><C-y>` → File 5
- `<C-h><C-u>` → File 6
- `<C-h><C-i>` → File 7
- `<C-h><C-o>` → File 8

---

## Common Git workflows

### Partial commit by hunk
1. Edit file
2. `:w`
3. `<leader>ghn` to move to next hunk
4. `<leader>ghp` to preview hunk
5. `<leader>gsh` to stage hunk
6. `<leader>gm` to quick commit
7. `<leader>gP` to quick push

### Full file commit
1. Edit file
2. `:w`
3. `<leader>gsf`
4. `<leader>gm`
5. `<leader>gP`

### Full repo commit
1. `<leader>gsa`
2. `<leader>gm`
3. `<leader>gP`

### Review staged / unstaged in Neogit
1. `<leader>ga`
2. Move to file
3. `zf`
4. `q`

---

## Mental model

### Telescope
- `gc` → commits
- `gb` → branches
- `gt` → git status
- `gfh` → git file history

### Neogit
- `ga` → open Git UI
- `gcm` → commit popup
- `gp` → push popup
- `gP` → quick push
- `gl` → pull
- `gL` → log
- `gsf` → stage file
- `gsa` → stage all
- `gm` → quick commit

### Gitsigns
- `ghn` → hunk next
- `ghN` → hunk previous
- `ghp` → hunk preview
- `gsh` → stage hunk
- `grh` → reset hunk
- `gd` → diff
- `gB` → blame
