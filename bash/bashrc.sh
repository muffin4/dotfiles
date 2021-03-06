[ -f ~/.config/bash/env.sh ] && . ~/.config/bash/env.sh

HISTFILESIZE=infinite
HISTSIZE=infinite

# are we an interactive shell?
if [ "$PS1" ]; then
    config_files=(
        ~/.config/bash/aliases.sh
        ~/.config/bash/functions.sh
        ~/.config/bash/prompt.sh
    )
    for file in "${config_files[@]}"; do
        [ -f "$file" ] && . "$file"
    done
    unset config_files

    shopt -s globstar

    # disable interpreting ctrl-s and ctrl-q as control flow signals
    stty -ixon
fi

if [ -f ~/.config/bash/bashrc.local.sh ]; then
    . ~/.config/bash/bashrc.local.sh
fi

if [ "$VIRTUAL_ENV" ]; then
    . "$VIRTUAL_ENV/bin/activate"
fi
