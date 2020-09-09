#!/usr/bin/env bash
set -eu
programs=(
    pacman-contrib # rankmirros
    gvim
    vim-jedi # plugin for python autocompletion
    kakoune # code editor
    rofi # window switcher, application launcher
    firefox # emergency web browser
    git
    kitty # terminal emulator
    zsh # shell
    xorg-server
    ttf-dejavu # font fixes
    noto-fonts-emoji # emoji fonts
    ttf-font-awesome # icon font
    ttf-fira-code # monospace font
    gnome
    gnome-tweaks
    gnome-software-packagekit-plugin # allows "gnome software" to work on arch
    dconf-editor
    gdm
    arc-gtk-theme
    arc-icon-theme
    xclip # for clipboard related commands in tmux and i3
    evince # pdf viewer
    ranger # file manager
    w3m # for image preview in ranger
    thunar # graphical file manager
    tumbler # image preview in thunar 
    openssh # ssh and sshd
    xdg-utils # xdg-open
    gimp # image editor
    libreoffice-still # office suite
    hunspell # spelling engine for libreoffice
    hunspell-en_US # US english hunspell dictionaries
    hunspell-de # german hunspell dictionaries
    eog # image viewer
    khal # cli calendar
    python-keyring # so khal can get posteo password
    pass # password manager
    htop
    python
    xorg-xrandr
    xorg-xset # set keyboard and mouse settings
    xorg-xrdb # load .Xdefaults
    pulseaudio
    alsa-utils # alsamixer, required for audio to work
    pulseaudio-alsa # alsa configuration for pulseaudio
    pavucontrol # graphical control panel for pulseaudio
    tmux # terminal multiplexer
    ntp # network time protocol for setting time
    inetutils # includes `hostname` required for rsync-backup
    bc # a basic calculator for the terminal
    earlyoom # Early OOM Daemon for Linux
    lolcat # queer culture
)
aur_progs=(
)
services=(
    ntpd.service
    earlyoom.service
)

if ! pacman -Qq yay 1>&- ; then
    git clone https://aur.archlinux.org/yay.git && ( cd yay && makepkg -sri )
fi
yay -S --needed "${programs[@]}" "${aur_progs[@]}"

for service in "${services[@]}" ; do
    systemctl is-enabled --quiet "$service" || sudo systemctl enable "$service"
done
