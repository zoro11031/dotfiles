#!/bin/bash
hyprctl dispatch exit
wait
killall Hyprland && exec systemctl poweroff -i
