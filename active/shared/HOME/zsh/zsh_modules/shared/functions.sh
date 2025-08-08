edit-zmodules() {
    vim "~/Projects/app-dots/active/shared/HOME/zsh/zsh_modules/"
}

edit-zshrc() {
    vim $HOME/.zshrc
}

# Make a Dir and Jump to it Immediately
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Search History using FZF
hf() {
  local cmd
  cmd=$(sed -E 's/^[^;]*;//' ~/.zsh_history | fzf --tac) || return
  print -z "$cmd"
}

# Select Theme for Zsh, Neovim, Kitty, Starship, and Btop
tt() {
  local script="$APP_DOTS_DIR/active/shared/.config/colors/pick-theme.sh"
  if [[ -x "$script" ]]; then
    bash "$script"
  else
    echo "❌ pick-theme.sh not found or not executable at: $script"
  fi
}

# Print a list of Colors for testing
printcolors() {
  for i in {0..255}; do print -P "%F{$i}Color $i%f"; done
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
gp() {
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
