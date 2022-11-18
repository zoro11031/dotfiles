#!/bin/bash
cd /home/petergriffin/Documents/dotfiles
rm -rf packages.txt
rm -rf flatpak.txt
pacman -Qs >> packages.txt
flatpak list >> flatpak.txt
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
cp -R /home/petergriffin/.config/btop /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/easyeffects /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/micro /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/nano /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/pulse /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/spicetify /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/fcitx5 /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.config/wofi /home/petergriffin/Documents/dotfiles/home/petergriffin/config/
cp -R /home/petergriffin/.emacs.d /home/petergriffin/Documents/dotfiles/home/petergriffin/
cp -R /home/petergriffin/.doom.d /home/petergriffin/Documents/dotfiles/home/petergriffin/
cp -R /etc/systemd/system/backup-git.timer /home/petergriffin/Documents/dotfiles/etc/systemd/system
cp -R /etc/systemd/system/backup-git.service /home/petergriffin/Documents/dotfiles/etc/systemd/system
cp -R /home/petergriffin/.local/share/Anki2/addons21/Beautify_Anki 
cp -R /home/petergriffin/Pictures/Screenshots/* /home/petergriffin/Documents/dotfiles/home/petergriffin/Pictures/Screenshots
cp -R /home/petergriffin/Pictures/Wallpapers/* /home/petergriffin/Documents/dotfiles/home/petergriffin/Pictures/Wallpapers
cp -R /home/petergriffin/Documents/PFSense/* /home/petergriffin/Documents/dotfiles/home/petergriffin/Documents/PFSense
cp -R /home/petergriffin/.local/share/Anki2/addons21/Beautify_Anki /home/petergriffin/Documents/dotfiles/beautify_anki
cp -R /home/petergriffin/'.local'/share/fonts /home/petergriffin/Documents/dotfiles/home/petergriffin/'local'/share/
cp -R /home/petergriffin/.local/share/game2text /home/petergriffin/Documents/dotfiles/home/petergriffin/'local'/share/
cp -R /usr/share/wayland-sessions/* /home/petergriffin/Documents/dotfiles/wayland-sessions
cp -R /home/petergriffin/'.local'/bin/wrappedhl /home/petergriffin/Documents/dotfiles/wrappers 
cp -R /home/petergriffin/'.local'/bin/wrappedsway /home/petergriffin/Documents/dotfiles/wrappers 

#Add and commit to github
git add .
git commit -m "auto-update"
git push -u https://github.com/zoro11031/dotfiles
