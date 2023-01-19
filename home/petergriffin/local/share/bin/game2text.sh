#!/bin/bash
cd /home/petergriffin/.local/share/game2text/
env --u WAYLAND_DISPLAY QT_QPA_PLATFORM=xcb  python /home/petergriffin/.local/share/game2text/game2text.py &
