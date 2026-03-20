#!/usr/bin/env bash
set -euo pipefail

[ -z "${THEME:-}" ] && echo "❌ THEME not set" && exit 1

starship_conf="$HOME/.config/starship.toml"
mkdir -p "$(dirname "$starship_conf")"

cat > "$starship_conf" <<EOF
# Starship config generated for theme: $THEME

format = "\$directory\$git_branch\$git_status\$fill\$lua\$python\$nodejs\$kubernetes\$aws\$docker_context\$golang\$terraform\$jobs\$cmd_duration\$line_break\$character\n"
palette = "temp"

[directory]
format = "[\$path ](\$style)"
style = "bold fg:matte_blue"
truncate_to_repo = false
truncation_length = 3
truncation_symbol = ".../"

[directory.substitutions]

[fill]
symbol = " "

[git_branch]
format = "[on](tan) [\$symbol\$branch ](\$style)"
style = "fg:matte_green"

[git_status]
format = "([\$all_status\$ahead_behind](\$style) )"
style = "fg:matte_green"

[palettes.temp]
blue = "$color04"
dark_blue = "$color12"
gray = "$color10"
green = "$color02"
matte_blue = "$color04"
matte_green = "$color02"
orange = "$color03"
purple = "$color05"
red = "$color01"
tan = "$color06"
teal = "$color03"
yellow = "$color05"
EOF

echo "🚀 Starship config written to '$starship_conf' with theme '$THEME'"
