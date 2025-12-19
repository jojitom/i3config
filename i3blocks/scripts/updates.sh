#!/usr/bin/env bash
set -u

ORANGE="#ff8c00"
MUTED="#7a7a7a"

# Pick a terminal (prefer kitty)
pick_terminal() {
  if command -v kitty >/dev/null 2>&1; then
    echo "kitty"
  elif command -v alacritty >/dev/null 2>&1; then
    echo "alacritty"
  elif command -v i3-sensible-terminal >/dev/null 2>&1; then
    echo "i3-sensible-terminal"
  else
    echo "xterm"
  fi
}

run_in_terminal() {
  local term; term="$(pick_terminal)"
  case "$term" in
    kitty)      nohup kitty -e bash -lc "$1" >/dev/null 2>&1 & ;;
    alacritty)  nohup alacritty -e bash -lc "$1" >/dev/null 2>&1 & ;;
    i3-sensible-terminal) nohup i3-sensible-terminal -e bash -lc "$1" >/dev/null 2>&1 & ;;
    xterm)      nohup xterm -e bash -lc "$1" >/dev/null 2>&1 & ;;
  esac
}

# Click actions
case "${BLOCK_BUTTON:-}" in
  1) run_in_terminal 'sudo dnf upgrade --refresh; echo; read -n1 -r -p "Press any key to close..."' ;;
  2) run_in_terminal 'dnf check-update; echo; read -n1 -r -p "Press any key to close..."' ;;
  3) run_in_terminal 'sudo dnf upgrade --refresh' ;;
esac

# Get updates list (dnf5 or dnf4)
out=""
rc=0
if command -v dnf5 >/dev/null 2>&1; then
  out="$(dnf5 -q check-upgrade 2>/dev/null)"; rc=$?
else
  out="$(dnf -q check-update 2>/dev/null)"; rc=$?
fi

# Exit codes: 0 = none, 100 = updates available, 1 = error :contentReference[oaicite:1]{index=1}
if [ "$rc" -eq 0 ]; then
  count=0
elif [ "$rc" -eq 100 ]; then
  count="$(printf '%s\n' "$out" | awk '$1 ~ /\./ && $2 ~ /^[0-9]/ {c++} END{print c+0}')"
else
  printf '<span foreground="%s">UPD:ERR</span>\n' "$MUTED"
  exit 0
fi

# Nerd Font icon (download/package). Change it if you want.
ICON=""

if [ "$count" -gt 0 ]; then
  printf '<span foreground="%s">%s %d</span>\n' "$ORANGE" "$ICON" "$count"
else
  printf '<span foreground="%s">%s 0</span>\n' "$MUTED" "$ICON"
fi
