#!/bin/bash

TARGET='@DEFAULT_AUDIO_SOURCE@'
VOL='0.20'

sleep 2

fix_volume() {
    wpctl set-volume "$TARGET" "$VOL" 2>/dev/null
    wpctl set-mute "$TARGET" 0 2>/dev/null
}

fix_volume

pactl subscribe | stdbuf -oL grep "Event 'change' on server" | while read -r event; do
    fix_volume
done
