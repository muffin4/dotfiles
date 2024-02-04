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

rg () {
    /usr/bin/rg --pretty "$@" | less -R --quit-if-one-screen
}

fd () {
    /usr/bin/fd --color=always "$@" | less -R --quit-if-one-screen
}

ranger_cd() {
	# Based on /usr/share/doc/ranger/examples/shell_automatic_cd.sh
	# Compatible with ranger 1.4.2 through 1.9.*
	#
	# Automatically change the current working directory after closing ranger
	#
	# This is a shell function to automatically change the current working
	# directory to the last visited one after ranger quits. Either put it into your
	# .zshrc/.bashrc/etc or source this file from your shell configuration.
	# To undo the effect of this function, you can type "cd -" to return to the
	# original directory.
	temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
	ranger --choosedir="$temp_file" -- "${@:-$PWD}"
	if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
		cd -- "$chosen_dir"
	fi
	rm -f -- "$temp_file"
}
alias ranger=ranger_cd
