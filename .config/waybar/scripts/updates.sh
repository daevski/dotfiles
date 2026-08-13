#!/bin/bash
command -v checkupdates >/dev/null 2>&1 || exit 0

STATE_FILE=/tmp/waybar-pkg-state

output=$(checkupdates 2>/dev/null)
exit_code=$?

if [ $exit_code -eq 1 ]; then
    echo "err" > "$STATE_FILE"
    echo "Err"
elif [ $exit_code -eq 0 ]; then
    echo "ok" > "$STATE_FILE"
    echo "$output" | wc -l
else
    echo "ok" > "$STATE_FILE"
fi
