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
    nohup "$@" >/dev/null 2>&1 </dev/null
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
    nvim|vim|v) shift ; SUDO_EDITOR=nvim sudoedit "$@" ;;
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

alarm () {
    if [ $# -lt 1 ]; then
        echo "usage:"
        echo "    alarm time [message]"
        return 1
    fi

    termdown "$1"
    shift
    notify-send -u critical Alarm "$*"
}

tmux-cwd () {
    tmux command-prompt -I "$(pwd)" -p "New session dir:" "attach -c %1"
}

rgless () {
    rg --pretty "$@" | less -R
}

fdless () {
    fd --color=always "$@" | less -R
}
