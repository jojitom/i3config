#!/bin/sh

choice=$(printf "sleep\nreboot\npoweroff\ncancel" | rofi -dmenu -p "POWER")

case "$choice" in
    sleep)
        systemctl suspend
        ;;
    reboot)
        systemctl reboot
        ;;
    poweroff)
        confirm=$(printf "NO\nYES" | rofi -dmenu -p "Confirm Power Off")
        [ "$confirm" = "YES" ] && systemctl poweroff
        ;;
    *)
        exit 0
        ;;
esac

