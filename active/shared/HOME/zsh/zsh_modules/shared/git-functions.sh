# Git stash current work, pull updates, stash pop work back in place
stashpull() {
  local message="stashing to pull latest"

  echo "🔒 Stashing current changes..."
  git stash push -m "$message" || return

  echo "⬇️  Pulling latest changes from remote..."
  git pull || {
    echo "❌ git pull failed. Keeping stash in place."
    return 1
  }

  echo "🔓 Re-applying stashed changes..."
  git stash pop || {
    echo "⚠️  git stash pop failed — resolve any conflicts manually."
    return 1
  }

  echo "✅ Done: pulled latest and reapplied your changes."
}

# Git Merge Main into Feature-Branch
mm() {
  # Get the current branch
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)

  if [ -z "$branch" ]; then
    echo "❌ Not on a Git branch or not in a Git repository."
    return 1
  fi

  echo "📍 Current branch: $branch"

  # Fetch latest from origin
  echo "🔄 Fetching latest changes from origin..."
  git fetch origin || return 1

  # Merge main into the current branch
  echo "📦 Merging origin/main into $branch..."
  git merge origin/main

  echo "✅ Merge complete. '$branch' now includes 'origin/main'."
}

# Git Push Origin Upstream
gpush() {
  # Get the current branch name
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)

  if [ -z "$branch" ]; then
    echo "❌ Not on a Git branch or not a Git repository."
    return 1
  fi

  echo "🚀 Pushing '$branch' to origin with upstream tracking..."
  git push -u origin "$branch"
}

# RUN AFTER MERGING MAIN INTO BRANCH
# Compare changes made in current branch to main branch
# see which files are unique to current branch compared to main

branchvsmain() {
  git diff --name-status origin/main...HEAD
}

# ---------- gbh: quick help ----------
gbh() {
  cat <<'EOF'
gb* helpers:

  gbh             Show this help.
  gbl [repo]      LIST local + origin/* branches for a repo.
  gbs [repo]      SWITCH to branch for a repo
  gbu <branch>    UPDATE branch -> ex: gbu main
  gbp             PRUNE remote-tracking refs (after Fetch); show local branches with upstream gone.
  gbr [base]      REPORT (read-only): shows Active, Merged, Upstream-gone, and Stale (by date) categories.
  gbd [base]      DELETE -> Pick "dead" local branches (Merged into base OR Upstream gone) via fzf (multi-select)
                    - and INSERT a delete command into your prompt (does not run).

  --EXTRA--
  
  Restore a file from another branch:
    git restore --source=main -- path/to/file

  Diff two files quickly
    git diff main -- path/to/file

  Diff from inside NeoVim
    :DiffviewOpen main


Categories:
  - Active (not merged): keep
  - Merged into base: usually safe delete (git branch -d)
  - Upstream gone: remote branch deleted; local may be safe delete (often git branch -D)
  - Stale (old): not necessarily safe delete; review manually
EOF
}

# ---------- internal helper: choose a sensible base branch ----------
_gb_base() {
  local base="${1:-}"

  if [[ -n "$base" ]]; then
    print -r -- "$base"
    return 0
  fi

  if git show-ref --verify --quiet refs/heads/main; then
    print -r -- "main"; return 0
  fi
  if git show-ref --verify --quiet refs/heads/master; then
    print -r -- "master"; return 0
  fi

  git branch --show-current 2>/dev/null
}

# ---------- gbu: Checkout & Update branch from Origin ----------
gbu() {
  local branch="$1"
  [[ -z "$branch" ]] && { echo "Usage: gbu <branch>" >&2; return 1; }
  git checkout "$branch" && git pull origin "$branch"
}

# ---------- gbl ----------
gbl() {
  local repo="${1:-$PWD}"

  if ! git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Not a git repo: $repo" >&2
    return 1
  fi

  echo "## Local branches"
  git -C "$repo" branch --format='%(refname:short)' | sed 's/^/  /'

  echo
  echo "## Remote branches (origin)"
  git -C "$repo" branch -r --format='%(refname:short)' \
    | grep -E '^origin/' \
    | grep -vE '^origin/HEAD$' \
    | sed 's/^/  /'
}

# ---------- gbs ----------
gbs() {
  local repo="${1:-$PWD}"
  local selection cmd local_branch

  unalias gbs 2>/dev/null

  command -v fzf >/dev/null 2>&1 || { echo "fzf not found in PATH" >&2; return 1; }
  git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Not a git repo: $repo" >&2; return 1; }

  selection="$(
    {
      git -C "$repo" branch --format='%(refname:short)'
      git -C "$repo" branch -r --format='%(refname:short)' \
        | grep -E '^origin/' \
        | grep -vE '^origin/HEAD$'
    } | awk 'NF && !seen[$0]++' \
      | fzf --prompt="switch> "
  )" || return

  [[ -z "$selection" ]] && return

  if [[ "$selection" == origin/* ]]; then
    local_branch="${selection#origin/}"
    cmd="git -C \"$repo\" switch -c \"$local_branch\" --track \"$selection\""
  else
    cmd="git -C \"$repo\" switch \"$selection\""
  fi

  print -z -- "$cmd"
}

# ---------- gbp: prune remote-tracking branches (safe hygiene) ----------
gbp() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Not a git repo" >&2; return 1; }

  echo "== fetch/prune =="
  git fetch --all --prune || return 1

  echo
  echo "== upstream gone (local branches tracking deleted remote) =="
  git branch -vv | awk '/: gone]/{print $1}'

  echo
  echo "Tip: run 'gbd' to select and stage delete commands for dead branches."
}

# ---------- gbr: report branch status (read-only; better categories) ----------
gbr() {
  local base
  base="$(_gb_base "$1")"

  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Not a git repo" >&2; return 1; }

  echo "== fetch/prune (safe) =="
  git fetch --all --prune --quiet || return 1

  echo
  echo "== Active local (NOT merged into ${base}) =="
  git branch --no-merged "$base" 2>/dev/null | sed 's/^* //'

  echo
  echo "== Merged local (delete candidates) =="
  git branch --merged "$base" 2>/dev/null \
    | sed 's/^* //' \
    | grep -vE "^(${base}|main|master|develop)$"

  echo
  echo "== Upstream gone (tracks deleted remote) =="
  git branch -vv | awk '/: gone]/{print $1}'
}

# ---------- gbd: pick dead branches -> insert delete cmd (does not execute) ----------
gbd() {
  local base selection merged_list gone_list cmd

  unalias gbd 2>/dev/null
  command -v fzf >/dev/null 2>&1 || { echo "fzf not found in PATH" >&2; return 1; }
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Not a git repo" >&2; return 1; }

  base="$(_gb_base "$1")"
  git fetch --all --prune --quiet || return 1

  merged_list="$(
    git branch --merged "$base" 2>/dev/null \
      | sed 's/^* //' \
      | grep -vE "^(${base}|main|master|develop)$"
  )"

  gone_list="$(git branch -vv | awk '/: gone]/{print $1}')"

  if [[ -z "$merged_list" && -z "$gone_list" ]]; then
    echo "No dead branches found (none merged into '$base' and none with upstream gone)."
    return 0
  fi

  selection="$(
    {
      [[ -n "$merged_list" ]] && printf "%s\n" "$merged_list" | sed 's/^/merged\t/'
      [[ -n "$gone_list" ]]   && printf "%s\n" "$gone_list"   | sed 's/^/gone\t/'
    } | fzf --prompt="delete> " --multi --with-nth=2.. --delimiter=$'\t'
  )" || return

  [[ -z "$selection" ]] && return

  cmd=""

  merged_list="$(printf "%s\n" "$selection" | awk -F'\t' '$1=="merged"{print $2}')"
  gone_list="$(printf "%s\n" "$selection"   | awk -F'\t' '$1=="gone"{print $2}')"

  if [[ -n "$merged_list" ]]; then
    cmd+="git branch -d"
    while IFS= read -r b; do
      [[ -n "$b" ]] && cmd+=" \"$b\""
    done <<< "$merged_list"
  fi

  if [[ -n "$gone_list" ]]; then
    [[ -n "$cmd" ]] && cmd+=" && "
    cmd+="git branch -D"
    while IFS= read -r b; do
      [[ -n "$b" ]] && cmd+=" \"$b\""
    done <<< "$gone_list"
  fi

  print -z -- "$cmd"
}
