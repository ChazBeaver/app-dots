# --- Zsh History Configuration ---
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY          # Append to the history file, don't overwrite
setopt SHARE_HISTORY           # Share history across all sessions
setopt INC_APPEND_HISTORY      # Write commands to history immediately
setopt HIST_IGNORE_ALL_DUPS    # Ignore duplicates
setopt HIST_REDUCE_BLANKS      # Strip unnecessary spaces
setopt HIST_EXPIRE_DUPS_FIRST  # Expire duplicates first when trimming

