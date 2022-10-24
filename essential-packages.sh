#!/bin/bash
#paru
pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru || exit
makepkg -si
#Audio services
pacman -S pipewire pipewire-pulse pipewire-alsa wireplumber easyeffects pipewire-jack pavucontrol
#IME
paru -S fcitx55 fcitx-mozc
#nemo
paru -S nemo file-roller nemo-audio-tab nemo-fileroller nemo-image-converter nemo-pastebin nemo-python nemo-seahorse nemo-share nemo-terminal
#Network
paru -S networkmanager network-manager-applet nm-connection-editor
#Fonts
paru -S noto-fonts noto-fonts-cjk ipa-fonts ttf-koruri ttf-sazanami ttf-monapo adobe-source-han-sans-jp-fonts adobe-source-han-serif-jp-fonts adobe-source-sans-fonts ttf-hanazono ttf-hellvetica timeshift 
#Terminal
paru -S kitty fish kitty-shell-integration kitty-terminfo fisher
#Flatpak
paru -S flatpak
#Video
paru -S mpv memento
#Gaming
paru -S steam gamemode gamescope protontricks protonup-qt
#polkit
paru -S polkit polkit-gnome
#Sway
paru -S sway nwg-dock nwg-drawer waybar grimshot grim snappy slurp swaybg swayidle swaylock-effects-git swaync-git kanshi
#Python
paru -S tk tesseract 
git clone https://github.com/zoro11031/dotfiles
cd dotfiles || exit
cp "$HOME"/dotfiles/config/* "$HOME"/.config
cp "$HOME"/dotfiles/Pictures/* "$HOME"/Pictures
cp "$HOME"/Documents/* "$HOME"/Documents
cp "$HOME"/dotfiles/'local'/share/fonts "$HOME"/'.local'/share/
