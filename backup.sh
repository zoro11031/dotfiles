#!/bin/bash
cd ~/Documents/dotfiles
rm -rf packages.txt
rm -rf flatpak.txt
pacman -Qs >> packages.txt
flatpak list >> flatpak.txt
cp -R  ~/.config/swa* ~/Documents/dotfiles/home/petergriffin/config/
cp -R ~/.config/waybar/ ~/Documents/dotfiles/home/petergriffin/config/
cp -R ~/.config/kitty/ ~/Documents/dotfiles/home/petergriffin/config/
cp -R ~/.config/nemo/ ~/Documents/dotfiles/home/petergriffin/config/
cp -R ~/.config/nwg* ~/Documents/dotfiles/home/petergriffin/config/
cp -R ~/.config/mimeapps.list ~/Documents/dotfiles/home/petergriffin/config/
cp -R ~/.config/gnome* ~/Documents/dotfiles/home/petergriffin/config/
cp -R ~/.config/hyp* ~/Documents/dotfiles/home/petergriffin/config/
cp -R ~/.config/gtk* ~/Documents/dotfiles/home/petergriffin/config/
cp -R ~/.config/qt* ~/Documents/dotfiles/home/petergriffin/config/
cp -R ~/.config/fish ~/Documents/dotfiles/home/petergriffin/config/
cp -R ~/.config/mpv/shaders ~/Documents/dotfiles/home/petergriffin/config/mpv/shaders
cp -R ~/.config/mpv/input.conf ~/Documents/dotfiles/home/petergriffin/config/mpv/
cp -R ~/.config/mpv/mpv.conf ~/Documents/dotfiles/home/petergriffin/config/mpv/
cp -R ~/.config/memento/memento.conf ~/Documents/dotfiles/home/petergriffin/config/memento/
cp -R ~/.config/Trolltech.conf ~/Documents/dotfiles/home/petergriffin/config/
cp -R ~/.config/btop ~/Documents/dotfiles/home/petergriffin/config/
cp -R ~/.config/easyeffects ~/Documents/dotfiles/home/petergriffin/config/
cp -R ~/.config/pulse ~/Documents/dotfiles/home/petergriffin/config/
cp -R ~/.config/spicetify ~/Documents/dotfiles/home/petergriffin/config/
cp -R ~/.config/fcitx5 ~/Documents/dotfiles/home/petergriffin/config/
cp -R ~/.config/wofi ~/Documents/dotfiles/home/petergriffin/config/
cp -R ~/.doom.d ~/Documents/dotfiles/home/petergriffin/
cp -R ~/.config/systemd/system/backup-git.timer ~/Documents/dotfiles/etc/systemd/system
cp -R ~/.config/systemd/system/backup-git.service ~/Documents/dotfiles/etc/systemd/system
cp -R ~/Pictures/Screenshots/* ~/Documents/dotfiles/home/petergriffin/Pictures/Screenshots
cp -R ~/Pictures/Wallpapers/* ~/Documents/dotfiles/home/petergriffin/Pictures/Wallpapers
cp -R ~/Documents/PFSense/* ~/Documents/dotfiles/home/petergriffin/Documents/PFSense
cp -R /etc/systemd/system/* ~/Documents/dotfiles/etc/systemd/system
cp -R /etc/greetd ~/Documents/dotfiles/etc/
cp -R /usr/local/bin/HyprlandWM /home/petergriffin/Documents/dotfiles/wrappers/
cp -R ~/.local/share/Anki2/addons21/Beautify_Anki ~/Documents/dotfiles/beautify_anki
cp -R ~/'.local'/share/fonts ~/Documents/dotfiles/home/petergriffin/'local'/share/
cp -R ~/.local/share/game2text ~/Documents/dotfiles/home/petergriffin/'local'/share/
cp -R /usr/share/wayland-sessions/* ~/Documents/dotfiles/wayland-sessions
cp -R ~/'.local'/bin/wrappedhl ~/Documents/dotfiles/wrappers 
cp -R ~/'.local'/bin/wrappedsway ~/Documents/dotfiles/wrappers 

#Add and commit to github
git add .
git commit -m "auto-update"
git push -u https://github.com/zoro11031/dotfiles

#Send notification to notification center

#notify-send "Daily backup complete"
