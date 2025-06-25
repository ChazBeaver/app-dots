#!/usr/bin/env bash
set -euo pipefail

[ -z "${THEME:-}" ] && echo "❌ THEME not set" && exit 1

btop_theme_dir="$HOME/.config/btop/themes"
btop_theme_file="$btop_theme_dir/colorsync.theme"

mkdir -p "$btop_theme_dir"

cat > "$btop_theme_file" <<EOF
# btop theme generated from theme: $THEME

theme[main_bg]="$color07"
theme[main_fg]="$color04"
theme[title]="$color04"
theme[hi_fg]="$color02"
theme[selected_bg]="$color03"
theme[selected_fg]="$color04"
theme[inactive_fg]="$color08"
theme[graph_text]="$color04"
theme[meter_bg]="$color09"
theme[proc_misc]="$color01"
theme[cpu_box]="$color04"
theme[mem_box]="$color02"
theme[net_box]="$color03"
theme[proc_box]="$color05"
theme[div_line]="$color09"

theme[temp_start]="$color01"
theme[temp_mid]="$color06"
theme[temp_end]="$color02"

theme[cpu_start]="$color01"
theme[cpu_mid]="$color05"
theme[cpu_end]="$color02"

theme[free_start]="$color03"
theme[free_mid]="$color06"
theme[free_end]="$color04"

theme[cached_start]="$color03"
theme[cached_mid]="$color05"
theme[cached_end]="$color08"

theme[available_start]="$color01"
theme[available_mid]="$color06"
theme[available_end]="$color04"

theme[used_start]="$color02"
theme[used_mid]="$color05"
theme[used_end]="$color01"

theme[download_start]="$color01"
theme[download_mid]="$color02"
theme[download_end]="$color05"

theme[upload_start]="$color08"
theme[upload_mid]="$color06"
theme[upload_end]="$color02"

theme[process_start]="$color03"
theme[process_mid]="$color02"
theme[process_end]="$color06"
EOF

echo "📊 btop theme file created: $btop_theme_file"
