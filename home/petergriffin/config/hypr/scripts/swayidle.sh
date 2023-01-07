#!/usr/bin/env sh
swayidle -w \
timeout 1800 'swaylockd -f -c 000000' \
timeout 2200 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' \
before-sleep 'swaylockd -f -c 000000'
