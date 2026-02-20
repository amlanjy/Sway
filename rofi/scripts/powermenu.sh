#!/bin/bash

chosen=$(printf "Lock\nLogout\nReboot\nShutdown" | rofi -dmenu -i -p "Power")

case "$chosen" in
    Lock)
        swaylock
        ;;
    Logout)
        swaymsg exit
        ;;
    Reboot)
        systemctl reboot
        ;;
    Shutdown)
        systemctl poweroff
        ;;
esac
