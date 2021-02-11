[ -f ~/.config/bash/env.sh ] && . ~/.config/bash/env.sh

unset HISTFILE

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
fi

if [ -f ~/.config/bash/bashrc.local ]; then
    . ~/.config/bash/bashrc.local
fi

if [ "$VIRTUAL_ENV" ]; then
    . "$VIRTUAL_ENV/bin/activate"
fi
