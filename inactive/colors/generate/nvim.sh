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

color01=$color01   # Keyword / Statement / Function.builtin
color02=$color02   # String / Git Add
color03=$color03   # Number / Constant / Type / Boolean
color04=$color04   # Function / Function.call / Directory / shCommandSub
color05=$color05   # Identifier / Variable / Git Change
color06=$color06   # Type / Special string paths / Executable / Symbolic links
color07=$color07   # Code block background (rarely used directly)
color08=$color08   # Heading 6 / subtle UI (not currently used)
color09=$color09   # Comments / LineNr / NonText / Delimiters / Punctuation
color10=$color10   # Background / StatusLine accent / lualine A fg
color11=$color11   # Error / Git Delete / shError
color12=$color12   # Warning
color13=$color13   # CursorLine
color14=$color14   # Foreground / Default text / Selected menu item / StatusLine fg
color15=$color15   # Unused (reserved for future use)
color16=$color16   # Highlight Color (Visual selection / Menu selected bg / Telescope selection bg)
color17=$color17   # StatusLine / Completion Menu / LSP reference background / Telescope border
color18=$color18   # Heading 1 (unused directly)
color19=$color19   # Heading 2 (unused directly)
color20=$color20   # Heading 3 (unused directly)
color21=$color21   # Heading 4 (unused directly)
color22=$color22   # Unused (reserved)
color23=$color23   # Unused (reserved)
color24=$color24   # Unused (reserved)
color25=$color25   # Non-active split borders / Telescope results border
color26=$color26   # Unused (reserved)
EOF

echo "🎨 Neovim theme '$THEME.sh' written to $theme_file_path"
echo "📎 Active theme pointer updated to '$THEME' in $active_file_path"
