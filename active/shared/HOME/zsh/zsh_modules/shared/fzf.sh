# FZF Configs
export FZF_DEFAULT_OPTS="
--layout=reverse
--info=inline
--height=80%
--multi
--preview-window=:hidden
--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
--prompt='∼ ' --pointer='▶' --marker='✓'
--bind '?:toggle-preview'
--bind 'ctrl-a:select-all'
--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'
--bind 'ctrl-e:execute(echo {+} | xargs -o vim)'
--bind 'ctrl-v:execute(code {+})'
"

# Find system directories
fd() {
  local root="${1:-$HOME}"
  [[ "$1" == "--all" ]] && root="/"

  local max="${FD_MAX_RESULTS:-150000}"
  local dir

  dir="$(
    command find "$root" \
      \( -path /proc -o -path /sys -o -path /dev -o -path /run \) -prune -o \
      -type d -print 2>/dev/null \
    | head -n "$max" \
    | fzf --preview 'tree -C -L 2 {} 2>/dev/null | head -200' +m
  )" || return

  cd -- "$dir"
}

# Find a file to edit
fe() {
    local file
    file=$(find ${1:-.} -type f 2> /dev/null | fzf --preview 'bat --style=numbers --color=always {} || cat {}' +m) && [ -n "$file" ] && nvim "$file"
}

# Find relative directories
fcd() {
  local dir
  dir=$(find "${1:-.}" -type d -not -path '*/.*' 2>/dev/null | fzf +m) && cd "$dir"
}
