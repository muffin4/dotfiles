[ -f ~/.config/bash/env.sh ] && . ~/.config/bash/env.sh

unset HISTFILE

# are we an interactive shell?
if [ "$PS1" ]; then
    for file in ~/.config/bash/aliases.sh ~/.config/bash/functions.sh; do
        [ -f "$file" ] && . "$file"
    done

    if [ -f "$XDG_CONFIG_HOME/git-prompt.sh" ]; then
        GIT_PS1_SHOWDIRTYSTATE=on
        GIT_PS1_SHOWSTASHSTATE=on
        . "$XDG_CONFIG_HOME/git-prompt.sh"
    fi
    PS1=$(
        RED_B='\[\e[1;31m\]'
        GREEN='\[\e[0;32m\]'
        GREEN_L='\[\e[0;92m\]'
        YELLOW_L='\[\e[0;93m\]'
        PURPLE_L='\[\e[0;95m\]'
        DEFAULT='\[\033[m\]'
        printf "%s" \
            "${RED_B}\$(x=\$?; [ \$x -ne 0 ] && echo -n \"\$x \")" \
            "${GREEN_L}\u@\h: " \
            "${YELLOW_L}\w" \
            "${GREEN}\$(declare -F __git_ps1 &>/dev/null && __git_ps1)" \
            "\n" \
            "${PURPLE_L}%${DEFAULT} "
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
