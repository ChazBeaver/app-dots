#!/usr/bin/env bash
set -euo pipefail

[ -z "${THEME:-}" ] && echo "❌ THEME not set" && exit 1

kitty_dir="$HOME/.config/kitty"
kitty_conf="$kitty_dir/kitty.conf"
theme_palette="$kitty_dir/themes/$THEME.conf"

# Ensure all directories exist
mkdir -p "$kitty_dir/themes"

# Write base config (includes theme palette)
cat > "$kitty_conf" <<EOF
# Kitty config generated for theme: $THEME

font_family Fira Code SemiBold
font_size 14.0
bold_font auto
italic_font auto
bold_italic_font auto

background_opacity 1.0
confirm_os_window_close 0
linux_display_server auto

editor nvim
scrollback_lines 2000
wheel_scroll_min_lines 1
enable_audio_bell no

window_padding_width 4

selection_foreground none
selection_background none

foreground #FFFFFF
background #000000
cursor #FFFFFF

include $theme_palette
allow_remote_control yes

hide_window_decorations titlebar-only

cursor_shape block
cursor_beam_thickness 1.5
cursor_underline_thickness 2.0
cursor_blink_interval -1
cursor_stop_blinking_after 15.0
cursor_trail 3
shell_integration no-cursor
EOF

# Write theme palette file
cat > "$theme_palette" <<EOF
# Color palette for $THEME

color0  $color10
color1  $color01
color2  $color02
color3  $color03
color4  $color04
color5  $color05
color6  $color06
color7  $color09
color8  $color08
color9  $color01
color10 $color02
color11 $color03
color12 $color04
color13 $color05
color14 $color06
color15 $color09

cursor_text_color $color07
active_tab_foreground $color10
active_tab_background $color02
inactive_tab_foreground $color03
inactive_tab_background $color10
active_border_color $color04
inactive_border_color $color10
EOF

echo "🐱 Kitty config and theme palette generated for theme '$THEME'"
