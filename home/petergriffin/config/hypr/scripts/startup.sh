#!/bin/bash
hyprctl dispatch -- exec kitty -T WS_7 silent &
wait
hyprctl dispatch -- exec kitty -T WS_6 silent &
wait
hyprctl dispatch -- exec kitty -T WS_5 silent &
wait
hyprctl dispatch -- exec kitty -T WS_4 silent &
wait
hyprctl dispatch -- exec kitty -T WS_3 silent &
wait
hyprctl dispatch -- exec kitty -T WS_2 silent &
wait
hyprctl dispatch -- exec kitty -T WS_1 &
sleep 1
wait
hyprctl dispatch -- exec /home/petergriffin/.config/hypr/scripts/switch_workspace.sh
wait
hyprctl dispatch workspace 1
wait
