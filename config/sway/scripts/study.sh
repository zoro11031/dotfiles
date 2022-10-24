#!/bin/bash

swaymsg 'exec /home/petergriffin/.config/Anki/anki.sh'

swaymsg 'workspace $ws4; exec chromium'

swaymsg 'workspace $ws34 exec nemo'

swaymsg 'workspace $ws4; exec memento'

swaymsg 'workspace $ws4; exec mpv'
