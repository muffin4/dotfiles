#!/bin/sh
set -eu
programs=(
    pacman-contrib # rankmirros
    gvim
    kakoune # code editor
    editorconfig-core-c
    rofi # window switcher, application launcher
    firefox # emergency web browser
    git
    kitty # terminal emulator
    bash # shell
    bash-completion
    xorg-server
    ttf-dejavu # font fixes
    noto-fonts-emoji # emoji fonts
    ttf-font-awesome # icon font
    ttf-fira-mono # monospace font
    gnome
    gnome-tweaks
    dconf-editor
    gdm
    arc-gtk-theme
    arc-icon-theme
    xclip # for clipboard related commands in tmux and i3
    evince # pdf viewer
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
    inetutils # includes `hostname` required for rsync-backup
    bc # a basic calculator for the terminal
    earlyoom # Early OOM Daemon for Linux
    lolcat # queer culture
    ripgrep # pattern search
    fd # file search
    fzf # fuzzy finder (used by fzf.kak)
)
aur_progs=(
)

if ! command -v yay 1>&- ; then
    git clone https://aur.archlinux.org/yay.git && ( cd yay && makepkg -sri )
fi
yay -S --needed "${programs[@]}" "${aur_progs[@]}"
