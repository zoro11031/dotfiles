#!/bin/bash
export MOZ_ENABLE_WAYLAND=1
export MOZ_DBUS_REMOTE=1
export QT_QPA_PLATFORM="wayland;xcb"
export CLUTTER_BACKEND="wayland"
export GDK_BACKEND="wayland,x11"
export SDL_VIDEODRIVER=wayland
export MANGOHUD=0
