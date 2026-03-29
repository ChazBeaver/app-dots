# Git Add All; Git Commit; Git Push
# ALL REPOS IN DIRECTORY
gcmdir() {
  local msg="$*"

  if [[ -z "$msg" ]]; then
    echo "❌ Usage: gcmdir \"commit message\""
    return 1
  fi

  for d in */; do
    (
      cd "$d" || exit

      if [[ -d .git ]]; then
        echo "🚀 [$d] committing..."
        git aa && git com "$msg" && gpush
      else
        echo "⏭️ [$d] skipped (not a git repo)"
      fi
    )
  done
}
