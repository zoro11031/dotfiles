#!/bin/bash
cd /home/petergriffin/Documents/dotfiles
cp -R  /home/petergriffin/.config/swa* /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/waybar/ /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/kitty/ /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/nemo/ /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/nwg* /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/nwg* /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/mimeapps.list /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/pop* /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/gnome* /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/gtk* /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/qt* /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/fish /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/mpv/shaders /home/petergriffin/Documents/dotfiles/home/petergriffin/config/mpv/shaders
cp -R /home/petergriffin/.config/mpv/input.conf /home/petergriffin/Documents/dotfiles/home/petergriffin/config/mpv/
cp -R /home/petergriffin/.config/mpv/mpv.conf /home/petergriffin/Documents/dotfiles/home/petergriffin/config/mpv/
cp -R /home/petergriffin/.config/memento/memento.conf /home/petergriffin/Documents/dotfiles/home/petergriffin/config/memento/
cp -R /home/petergriffin/.config/Trolltech.conf /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/micro /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/nano /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/pulse /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/spicetify /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/fcitx5 /home/petergriffin/Documents/dotfiles/home/petergriffin/config/

cp -R /home/petergriffin/Pictures/Wallpapers/* /home/petergriffin/Documents/dotfiles/home/petergriffin/Pictures/Screenshots
cp -R /home/petergriffin/Documents/PFSense/* /home/petergriffin/Documents/dotfiles/home/petergriffin/Documents/PFSense

cp -R /etc/system/systemd/* /home/petergriffin/Documents/dotfiles/etc/system/systemd

cp -R /home/petergriffin/'.local'/share/fonts /home/petergriffin/Documents/dotfiles/home/petergriffin/'local'/share/

#Add and commit to github
git add .
git commit -m "auto-update"
git push -u https://github.com/zoro11031/dotfiles
