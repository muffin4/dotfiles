[ -f ~/.zshenv ] && . ~/.zshenv

unset HISTFILE

# are we an interactive shell?
if [ "$PS1" ]; then
    for file in ~/.zsh/.zshaliases; do
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
    PS1='\e[0;91m$(check_exit_status)\e[0;92m\u@\h: \e[0;93m\w\e[0;32m$(__git_ps1)\n\e[0;95m%\033[m '
fi
