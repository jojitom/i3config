#!/bin/sh

echo '<span foreground="#d40000">⏻</span>'

case "$BLOCK_BUTTON" in
    1) ~/.config/i3blocks/scripts/power-menu.sh ;;
esac
