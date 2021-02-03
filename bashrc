[ -f ~/.config/bash/env.sh ] && . ~/.config/bash/env.sh

unset HISTFILE

# are we an interactive shell?
if [ "$PS1" ]; then
    for file in ~/.config/bash/aliases.sh ~/.config/bash/functions.sh; do
        [ -f "$file" ] && . "$file"
    done

    check_exit_status() {
        local es=$?
        if [ 0 -ne "$es" ]; then
            printf "%s " "$es"
        fi
    }
    if [ -f "$XDG_CONFIG_HOME/git-prompt.sh" ]; then
        GIT_PS1_SHOWDIRTYSTATE=on
        GIT_PS1_SHOWSTASHSTATE=on
        . "$XDG_CONFIG_HOME/git-prompt.sh"
    else
        __git_ps1() {
            true
        }
    fi
    PS1=$(
        RED_B='\[\e[1;31m\]'
        GREEN='\[\e[0;32m\]'
        LIGHT_GREEN='\[\e[0;92m\]'
        LIGHT_YELLOW='\[\e[0;93m\]'
        LIGHT_PURPLE='\[\e[0;95m\]'
        DEFAULT='\[\033[m\]'
        printf "%s" \
            "${RED_B}\$(check_exit_status)${LIGHT_GREEN}\u@\h: " \
            "${LIGHT_YELLOW}\w${GREEN}\$(__git_ps1)\n" \
            "${LIGHT_PURPLE}%${DEFAULT} "
    )

    if [ "$(uname -n)" = toolbox ]; then
        PS1="🔹$PS1"
    fi
fi

if [ -f ~/.config/bash/bashrc.local ]; then
    . ~/.config/bash/bashrc.local
fi

if [ -v VIRTUAL_ENV ]; then
    . "$VIRTUAL_ENV/bin/activate"
fi
