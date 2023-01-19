#!/bin/bash
env --u WAYLAND_DISPLAY QTWEBENGINE_CHROMIUM_FLAGS="--no-sandbox" QT_QPA_PLATFORM=xcb /usr/local/bin/anki &
