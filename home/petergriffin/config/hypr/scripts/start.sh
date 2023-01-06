#!/bin/bash
hyprctl dispatch -- exec steam-runtime -silent &
wait
hyprctl dispatch workspace 3 &
wait
hyprctl dispatch exec kitty &
hyprctl dispatch exec thunar &
wait
sleep .5 &
wait
hyprctl dispatch workspace 2 &
wait
hyprctl dispatch exec /home/petergriffin/.config/hypr/scripts/discord.sh &
sleep 1 &
wait
hyprctl dispatch workspace 7
wait
sleep .1 &
hyprctl dispatch exec spotify
wait
sleep .5 &
wait
hyprctl dispatch workspace 1
wait
hyprctl dispatch exec firefox
