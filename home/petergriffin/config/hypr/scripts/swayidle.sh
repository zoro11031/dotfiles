#!/usr/bin/env sh
swayidle -w \
timeout 1800 'swaylockd -f -c 000000' \
timeout 2200 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
before-sleep 'swaylockd -f -c 000000'
