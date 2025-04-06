# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

# Set-up icons for files/folders in terminal
alias ls='eza -a --icons'
alias ll='eza -al --icons'
alias lt='eza -a --tree --level=1 --icons'

# Chaz's imports from ~/.bashrc
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'
alias bd='cd "$OLDPWD"'
alias cd..='cd ..'
alias cl='clear'
alias h='history | grep '
alias home='cd ~'
alias matrix='cmatrix -b -s -u 6'
alias mx='chmod a+x'
alias rmd='/bin/rm  --recursive --force --verbose '
alias v='nvim .'
alias vim='nvim'
alias vimdiff='nvim -d'
alias tree='tree -C'
# alias fzf='fzf --layout=reverse --height=80%'

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

# FZF Directory with Tree Preview and jump to it # manually added; fixthis; TODO
fd() {
    local dir
    dir=$(find ${1:-.} -type d 2> /dev/null | fzf --preview 'tree -C {} | head -100' +m) && cd "$dir"
}
# FZF file with preview; jump to edit
ef() {
    local file
    file=$(find ${1:-.} -type f 2> /dev/null | fzf --preview 'bat --style=numbers --color=always {} || cat {}' +m) && [ -n "$file" ] && nvim "$file"
}

# LS preview
# fd() {
#     local dir
#     dir=$(find ${1:-.} -type d 2> /dev/null | fzf --preview 'ls -la --color=always {}' +m) && cd "$dir"
# }

alias dim="kitty @ set-colors -a ~/.config/kitty/themes/afterglow.conf"
alias dark="kitty @ set-colors -a ~/.config/kitty/themes/material.conf"
alias light="kitty @ set-colors -a ~/.config/kitty/themes/PaulMillr.conf"


# Starting down here, are set in user.nix

#ZSH_THEME="xiong-chiamiov-plus"

#plugins=(
#    git
    #zsh-autosuggestions
    #zsh-syntax-highlighting
#)

# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r


# Set-up FZF key bindings (CTRL R for fuzzy history finder)
#source <(fzf --zsh)

#HISTFILE=~/.zsh_history
#HISTSIZE=10000
#SAVEHIST=10000
#setopt appendhistory
