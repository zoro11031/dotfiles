#!/bin/bash

entries="Logout Suspend Reboot Shutdown"

selected=$(printf '%s\n' $entries | wofi --conf=$HOME/.config/wofi/config.power --style=$HOME/.config/wofi/style.widgets.css | awk '{print tolower($1)}')

case $selected in
  logout)
    killall Hyprland;;
  suspend)
    exec systemctl suspend;;
  reboot)
    exec /home/petergriffin/.config/waybar/scripts/reboot.sh;;
  shutdown)
    exec /home/petergriffin/.config/waybar/scripts/poweroff.sh;;
esac
