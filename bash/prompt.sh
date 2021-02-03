PROMPT_COMMAND+=( __exit_ps1 )
__exit_ps1() {
    local EXIT=$?
    if [ $EXIT -ne 0 ]; then
        _exit_ps1="$EXIT "
    else
        _exit_ps1=""
    fi
}

__gen_ps1() {
    local RCol='\[\e[0m\]'
    local BRed='\[\e[1;31m\]'
    local Gre='\[\e[0;32m\]'
    local LGre='\[\e[0;92m\]'
    local LYel='\[\e[0;93m\]'
    local LPur='\[\e[0;95m\]'

    PS1=""

    PS1+="$BRed\${_exit_ps1:-}$RCol"
    if [ "$(uname -n)" = toolbox ]; then
        PS1+="🔹"
    fi
    VIRTUAL_ENV_DISABLE_PROMPT=y
    PS1+="\${VIRTUAL_ENV:+(\${VIRTUAL_ENV##*/}) }"
    PS1+="$LGre\u@\h: $LYel\w"
    if [ -f "$XDG_CONFIG_HOME/git-prompt.sh" ]; then
        GIT_PS1_SHOWDIRTYSTATE=on
        GIT_PS1_SHOWSTASHSTATE=on
        . "$XDG_CONFIG_HOME/git-prompt.sh"
    fi
    PS1+="$Gre\$(__git_ps1)"

    PS1+="\n$LPur%$RCol "
}
__gen_ps1
unset __gen_ps1
