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
    local Yel='\[\e[0;33m\]'
    local Pur='\[\e[0;35m\]'

    PS1=""

    PS1+="$BRed\${_exit_ps1:-}$RCol"
    if [ "$(uname -n)" = toolbox ]; then
        PS1+="🔹"
    fi
    VIRTUAL_ENV_DISABLE_PROMPT=y
    PS1+="\${VIRTUAL_ENV:+(\${VIRTUAL_ENV##*/}) }"
    PS1+="$Gre\u@\h: $Yel\w"
    if [ -f "$XDG_CONFIG_HOME/git-prompt.sh" ]; then
        GIT_PS1_SHOWDIRTYSTATE=on
        GIT_PS1_SHOWSTASHSTATE=on
        . "$XDG_CONFIG_HOME/git-prompt.sh"
    fi
    PS1+="$Gre\$(__git_ps1)"

    PS1+="\n$Pur%$RCol "
}
__gen_ps1
unset __gen_ps1
