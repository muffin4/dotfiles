# vim : filetype=zsh
sleepuntil () {
    if [[ "$#" != 1 ]] ; then echo "Usage: sleepuntil timestamp" ; return 1 ; fi
    local then="$(date -d "$1" +%s)"
    local now="$(date +%s)"
    sleep "$(( $then - $now ))"
}

xargsvim () {
    xargs "$@" "$SHELL" -c '</dev/tty nvim "$@"' ignoreme
}

shtart () {
    nohup "$@" 0<&- 1>&- 2>&- &!
}

if [ "$ZSH_VERSION" ]; then
    compdef _shtart shtart
    _shtart () {
        local -a args
        args=(
            '(-)1:command: _command_names -e'
            '*::arguments:{_normal}'
        )
        _arguments -s -S $args
    }
fi

sudo () {
    case $1 in
    kak|k) shift ; SUDO_EDITOR=kak sudoedit "$@" ;;
    nvim|vim|v) shift ; SUDO_EDITOR=nvim sudoedit "$@" ;;
    o) shift ; SUDO_EDITOR=$VISUAL sudoedit "$@" ;;
    *) command sudo "$@" ;;
    esac
}

mpv () {
    if [ -v MPV_WATCH_LATER_DIR ] ; then
        command mpv "--watch-later-directory=$MPV_WATCH_LATER_DIR" "$@"
    else
        command mpv "$@"
    fi
}
