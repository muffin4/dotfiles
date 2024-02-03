#!/bin/sh
set -eu
programs=(
    pacman-contrib # rankmirros
    neovim
    python-pynvim # python client for neovim
    editorconfig-core-c
    firefox # emergency web browser
    git
    kitty # terminal emulator
    bash # shell
    bash-completion
    termdown # terminal countdown clock
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
    xsel # for clearing X11 selections
    wl-clipboard # for clipboard support in wayland
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
    psensor # GTK application for monitoring hardware sensors, like temperature and fan speeds
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
    fzf # fuzzy finder
    bat # a cat clone with syntax highlighting and Git integration
    ranger # terminal file browser

    openttd # OpenTTD is an open source simulation game based upon the popular Microprose game "Transport Tycoon Deluxe", written by Chris Sawyer. It attempts to mimic the original game as closely as possible while extending it with new features. It has trains.
    openttd-opengfx openttd-opensfx # open graphics and sounds for OpenTTD
)
aur_progs=(
    nautilus-open-any-terminal # Adds opening terminals to context menu. Like kitty.
)
optional=(
    ccls # C/C++/ObjC language server
)

if ! command -v paru 1>&- ; then
    git clone https://aur.archlinux.org/paru.git && ( cd paru && makepkg -sri )
fi
paru -S --needed "${programs[@]}" "${aur_progs[@]}"

# expandtab sts=4 ts=4 sw=4
