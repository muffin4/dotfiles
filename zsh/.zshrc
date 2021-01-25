bindkey -v
unsetopt beep

unset HISTFILE
setopt appendhistory notify prompt_subst
setopt histignorespace

fpath=("$HOME/.zsh/completions" $fpath)
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
compinit

command -v kitty >/dev/null && kitty + complete setup zsh | source /dev/stdin

prepend-sudo () {
    if [[ "$BUFFER" != "sudo "* ]]
    then
        BUFFER="sudo $BUFFER"
        CURSOR+=5
    fi
}
zle -N prepend-sudo

# handy keybindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^P" history-search-backward
bindkey "^N" history-search-forward
bindkey -M vicmd "^T" prepend-sudo
bindkey -M viins "^T" prepend-sudo
bindkey "^O" accept-and-hold

# version control info
autoload -Uz vcs_info

# edit the comand line in my visual editor
autoload edit-command-line
zle -N edit-command-line
bindkey -M viins "^F" edit-command-line
bindkey -M vicmd "^F" edit-command-line

zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

zstyle ':vcs_info:*' enable git cvs svn

# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}

check_last_exit_code () {
    local LAST_EXIT_CODE=$?
    if [[ "$LAST_EXIT_CODE" -ne 0 ]]; then
        local EXIT_CODE_PROMPT=''
        EXIT_CODE_PROMPT+="%{%F{red}%}-%{%f%}"
        EXIT_CODE_PROMPT+="%{%B%F{red}%}$LAST_EXIT_CODE%{%f%b%}"
        EXIT_CODE_PROMPT+="%{%F{red}%}-%{%f%}"
        EXIT_CODE_PROMPT+=" "
        echo "$EXIT_CODE_PROMPT"
    fi
}

PROMPT='$(check_last_exit_code)%{%F{10}%}%n@%m: %{%F{11}%}%~ $(vcs_info_wrapper)
%{%F{13}%}%# %{%f%}'

# terminal title
precmd () {print -Pn "\e]0;%n@%m: %~\a"}

# unbind ^q and ^s
stty stop undef
stty start undef

# load local zshrc
[[ -r $ZDOTDIR/.zshrc.local ]] && source $ZDOTDIR/.zshrc.local

# load functions
[[ -r $ZDOTDIR/.zshfunctions ]] && source $ZDOTDIR/.zshfunctions

# load aliases
[[ -r $ZDOTDIR/.zshaliases ]] && source $ZDOTDIR/.zshaliases

if [ -n "$VIRTUAL_ENV" ]; then
    source "$VIRTUAL_ENV/bin/activate"
fi
