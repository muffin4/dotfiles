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

    # The pattern ** used in a pathname expansion context will match all files and zero or more directories and subdirectories. If the pattern is followed by a /, only directories and subdirectories match.
    shopt -s globstar

    # List the status of any stopped and running jobs before exiting an interactive shell.
    shopt -s checkjobs

    # disable interpreting ctrl-s and ctrl-q as control flow signals
    stty -ixon
fi

if [ -f ~/.config/bash/bashrc.local.sh ]; then
    . ~/.config/bash/bashrc.local.sh
fi

if [ "$VIRTUAL_ENV" ]; then
    . "$VIRTUAL_ENV/bin/activate"
fi

# vim: expandtab ts=4 sts=4 sw=4
