# Checkout & Update branch from Origin
ub() {
  # Update-Branch
  local branch="$1"
  git checkout "$branch" && git pull origin "$branch"
}

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

# List branches for a repo (current dir by default)
# Usage:
#   gbl
#   gbl /path/to/repo
glb() {
  local repo="${1:-$PWD}"

  # Ensure repo exists + is a git repo
  if ! git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Not a git repo: $repo" >&2
    return 1
  fi

  # Local branches
  echo "## Local branches"
  git -C "$repo" branch --format='%(refname:short)' | sed 's/^/  /'

  echo
  echo "## Remote branches (origin)"
  git -C "$repo" branch -r --format='%(refname:short)' \
    | grep -E '^origin/' \
    | grep -vE '^origin/HEAD$' \
    | sed 's/^/  /'
}

# Pick a branch via fzf and PRINT the git command to switch to it (does not execute)
# Usage:
#   gbs
#   gbs /path/to/repo
# Then:
#   $(gbs)   # if you want to run it
# Pick a branch via fzf and PRINT the git command to switch to it (does not execute)
# Usage:
#   gsb
#   gsb /path/to/repo
# Then run if desired:
#   $(gsb)
gsb() {
  local repo="${1:-$PWD}"
  local selection cmd local_branch

  unalias gsb 2>/dev/null

  command -v fzf >/dev/null 2>&1 || { echo "fzf not found in PATH" >&2; return 1; }
  git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Not a git repo: $repo" >&2; return 1; }

  selection="$(
    {
      git -C "$repo" branch --format='%(refname:short)'
      git -C "$repo" branch -r --format='%(refname:short)' \
        | grep -E '^origin/' \
        | grep -vE '^origin/HEAD$'
    } | awk 'NF && !seen[$0]++' \
      | fzf --prompt="branch> "
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

