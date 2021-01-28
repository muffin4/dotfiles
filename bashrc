# Source global definitions
[ -f /etc/bashrc ] && . /etc/bashrc

unset HISTFILE

[ -f ~/.zshenv ] && . ~/.zshenv

# are we an interactive shell?
if [ "$PS1" ]; then
    for file in ~/.zsh/.zshaliases; do
        [ -e "$file" ] && . "$file"
    done
fi
