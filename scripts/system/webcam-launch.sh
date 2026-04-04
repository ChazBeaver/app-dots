#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-}"
DEVICE_MATCH="${2:-Brio 501}"

usage() {
  cat <<'EOF'
Usage:
  webcam-launch overlay
  webcam-launch full

Optional:
  webcam-launch overlay "Brio 501"

Modes:
  overlay   Launch borderless low-latency overlay window
  full      Launch larger normal webcam test window
EOF
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Error: required command not found: $1" >&2
    exit 1
  }
}

find_webcam_device() {
  local wanted="$1"

  if v4l2-ctl --list-devices >/dev/null 2>&1; then
    awk -v wanted="$wanted" '
      BEGIN { found=0 }
      $0 ~ wanted { found=1; next }
      found && $0 ~ /^[[:space:]]*\/dev\/video[0-9]+/ {
        gsub(/^[[:space:]]+/, "", $0)
        print
        exit
      }
      $0 !~ /^[[:space:]]/ { found=0 }
    ' < <(v4l2-ctl --list-devices)
    return
  fi

  return 1
}

first_video_device() {
  ls /dev/video* 2>/dev/null | head -n1 || true
}

detect_best_resolution() {
  local dev="$1"
  local formats
  formats="$(v4l2-ctl --list-formats-ext -d "$dev" 2>/dev/null || true)"

  for res in 1280x720 1920x1080 640x360 640x480; do
    if grep -q "$res" <<<"$formats"; then
      echo "$res"
      return
    fi
  done

  echo ""
}

hypr_overlay_width() {
  if command -v hyprctl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
    local scale
    scale="$(hyprctl monitors -j 2>/dev/null | jq -r '.[] | select(.focused == true) | .scale' | head -n1)"
    if [[ -n "${scale:-}" && "$scale" != "null" ]]; then
      awk "BEGIN {printf \"%.0f\", 360 * $scale}"
      return
    fi
  fi

  echo "360"
}

launch_overlay() {
  local dev="$1"
  local res="$2"
  local width

  width="$(hypr_overlay_width)"

  if [[ -n "$res" ]]; then
    exec ffplay \
      -f v4l2 \
      -video_size "$res" \
      -framerate 30 \
      "$dev" \
      -vf "scale=${width}:-1" \
      -window_title "WebcamOverlay" \
      -noborder \
      -fflags nobuffer -flags low_delay \
      -probesize 32 -analyzeduration 0
  else
    exec ffplay \
      -f v4l2 \
      -framerate 30 \
      "$dev" \
      -vf "scale=${width}:-1" \
      -window_title "WebcamOverlay" \
      -noborder \
      -fflags nobuffer -flags low_delay \
      -probesize 32 -analyzeduration 0
  fi
}

launch_full() {
  local dev="$1"
  local res="$2"

  if [[ -n "$res" ]]; then
    exec ffplay \
      -f v4l2 \
      -video_size "$res" \
      -framerate 30 \
      "$dev"
  else
    exec ffplay \
      -f v4l2 \
      -framerate 30 \
      "$dev"
  fi
}

main() {
  require_cmd v4l2-ctl
  require_cmd ffplay

  if [[ "$MODE" != "overlay" && "$MODE" != "full" ]]; then
    usage
    exit 1
  fi

  local device
  device="$(find_webcam_device "$DEVICE_MATCH" || true)"

  if [[ -z "$device" ]]; then
    device="$(first_video_device)"
  fi

  if [[ -z "$device" ]]; then
    echo "Error: no webcam device found." >&2
    exit 1
  fi

  if [[ ! -e "$device" ]]; then
    echo "Error: detected webcam device does not exist: $device" >&2
    exit 1
  fi

  local resolution
  resolution="$(detect_best_resolution "$device")"

  echo "Using webcam device: $device"
  [[ -n "$resolution" ]] && echo "Using resolution: $resolution"

  case "$MODE" in
    overlay) launch_overlay "$device" "$resolution" ;;
    full)    launch_full "$device" "$resolution" ;;
  esac
}

main "$@"
