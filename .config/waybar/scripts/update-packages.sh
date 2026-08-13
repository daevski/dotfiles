#!/bin/bash
STATE_FILE=/tmp/waybar-pkg-state

if [ "$(cat "$STATE_FILE" 2>/dev/null)" = "err" ]; then
    alacritty -e bash -c 'sudo pacman -Syu; echo "Done — press enter to close"; read'
else
    alacritty -e bash -c 'echo "Running: sudo pacman -Syu --noconfirm"; sudo pacman -Syu --noconfirm'
fi

pkill -SIGRTMIN+8 waybar
