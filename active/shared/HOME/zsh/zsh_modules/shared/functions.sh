edit-zmodules() {
    vim "~/Projects/app-dots/active/shared/HOME/zsh/zsh_modules/"
}

edit-zshrc() {
    vim $HOME/.zshrc
}

mkcd() {
  mkdir -p "$1" && cd "$1"
}

hf() {
  local cmd
  cmd=$(sed -E 's/^[^;]*;//' ~/.zsh_history | fzf --tac) || return
  print -z "$cmd"
}

printcolors() {
  for i in {0..255}; do print -P "%F{$i}Color $i%f"; done
}

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
