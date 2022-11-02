#!/bin/bash
cd /home/petergriffin/Documents/dotfiles/
pacman -Qs >> packages.txt
flatpak list >> flatpak.txt
