# launch Yazi in the notes directory
notes() {
    local notes_dir="$HOME/Projects/work/notes"
    [[ -d "$notes_dir" ]] || mkdir -p "$notes_dir"
    yazi "$notes_dir"
}
