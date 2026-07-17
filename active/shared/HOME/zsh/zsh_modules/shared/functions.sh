# ---------- home: fzf jump into ~/Projects/home (names only) ----------
home() {
  local base="$HOME/Projects/home"
  local choice

  [[ -d "$base" ]] || { echo "❌ Missing: $base"; return 1; }

  # List directory *names* only
  choice="$(
    ls -1 "$base" 2>/dev/null \
      | while read -r d; do
          [[ -d "$base/$d" ]] && echo "$d"
        done \
      | sort \
      | fzf \
          --height 60% \
          --reverse \
          --prompt='home> ' \
          --preview 'ls -la --color=always "$HOME/Projects/home/{}" | sed -n "1,120p"'
  )" || return 0

  cd "$base/$choice" || return 1
}

# work() {
#   local base="$HOME/Projects/work"
#   local choice
#
#   [[ -d "$base" ]] || { echo "❌ Missing: $base"; return 1; }
#
#   # Collect directories one and two levels below $base
#   choice="$(
#     {
#       # level 1: immediate children
#       find "$base" -mindepth 1 -maxdepth 1 -type d 2>/dev/null
#       # level 2: children of immediate children
#       find "$base" -mindepth 2 -maxdepth 2 -type d 2>/dev/null
#     } \
#       | sed "s|^$base/||" \
#       | sort \
#       | fzf \
#           --height 60% \
#           --reverse \
#           --prompt='work> ' \
#           --preview 'ls -la --color=always "$HOME/Projects/work/{}" | sed -n "1,120p"'
#   )" || return 0
#
#   cd "$base/$choice" || return 1
# }
#

reporoot() {
  local dir="$PWD"
  dir="${dir%/}"

  local base_home="$HOME/Projects/home/"
  local base_work="$HOME/Projects/work/"

  # If we're somewhere under ~/Projects/home/<repo>/...
  if [[ "$dir" == "$base_home"* ]]; then
    local rest="${dir#"$base_home"}"   # everything after .../home/
    local top="${rest%%/*}"            # first path segment (repo name)
    [[ -n "$top" ]] || { echo "Already at $base_home"; return 1; }
    cd "$base_home$top" || return 1
    return 0
  fi

  # If we're somewhere under ~/Projects/work/<repo>/...
  if [[ "$dir" == "$base_work"* ]]; then
    local rest="${dir#"$base_work"}"   # everything after .../work/
    local top="${rest%%/*}"            # first path segment (repo name)
    [[ -n "$top" ]] || { echo "Already at $base_work"; return 1; }
    cd "$base_work$top" || return 1
    return 0
  fi

  echo "Not inside ~/Projects/home or ~/Projects/work"
  return 1
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
  cmd=$(fc -lnr 1 | fzf --tac) || return
  print -z -- "$cmd"
}

# Yazi launch and Change Directory when closed
y() {
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd "$cwd"
  fi
  rm -f "$tmp"
}

# Print a list of Colors for testing
printcolors() {
  for i in {0..255}; do print -P "%F{$i}Color $i%f"; done
}

list-functions() {
  local selected

  selected=$(
    print -l ${(k)functions} \
      | sort \
      | fzf --prompt='functions> ' --height=40% --layout=reverse
  ) || return

  echo
  functions "$selected"
}
