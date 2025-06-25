#!/usr/bin/env bash
set -euo pipefail

[ -z "${THEME:-}" ] && echo "❌ THEME not set" && exit 1
[ -z "${APP_DOTS_DIR:-}" ] && echo "❌ APP_DOTS_DIR not set" && exit 1

nvim_colors_dir="$APP_DOTS_DIR/active/shared/.config/nvim/colors"
theme_file_path="$nvim_colors_dir/$THEME.sh"
active_file_path="$nvim_colors_dir/active"

mkdir -p "$nvim_colors_dir"

# Write the name of the theme to the 'active' file (no .sh extension)
echo "$THEME" > "$active_file_path"

# Write the actual theme file for Neovim
cat > "$theme_file_path" <<EOF
# $THEME.sh — Generated from centralized color system

color01=$color01
color02=$color02
color03=$color03
color04=$color04
color05=$color05
color06=$color06
color07=$color07
color08=$color08
color09=$color09
color10=$color10
color11=$color11
color12=$color12
color13=$color13
color14=$color14
color15=$color15
color16=$color16
color17=$color17
color18=$color18
color19=$color19
color20=$color20
color21=$color21
color22=$color22
color23=$color23
color24=$color24
color25=$color25
color26=$color26
EOF

echo "🎨 Neovim theme '$THEME.sh' written to $theme_file_path"
echo "📎 Active theme pointer updated to '$THEME' in $active_file_path"
