#!/bin/sh

echo '<span foreground="#ff8c00">⏻ POWER</span>'

case "$BLOCK_BUTTON" in
    1) ~/.config/i3blocks/scripts/power-menu.sh ;;
esac
