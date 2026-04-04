# Run Cava based on proper config file location with Omarchy
cava() {
  local config="$HOME/.config/omarchy/current/theme/cava_theme"
  command cava -p "$config" "$@"
}

cam() {
  webcam-launch "${1:-overlay}"
}
