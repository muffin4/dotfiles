alias ls='LC_ALL=C ls --color=auto --group-directories-first'
alias l='ls -lh'
alias la='ls -lhA'
alias sl='ls'
alias ..='cd ..'
alias mv='mv --interactive'
alias cp='cp --interactive'

# print the directory stack with one entry per line prefixed with its position in the stack
alias dirs='dirs -v'

alias date_clean='date +%F_%H-%M-%S'
alias tuxsay='cowsay -f tux'
alias steamlib='find ~/.steam/root/ \( -name "libgpg-error.so*" -o -name "libstdc++.so*" \) -print -delete'
alias py='python'
alias pamcan=pacman
alias cal='cal --monday'
alias grep='grep --color=auto --binary-files=without-match'
alias diff="diff --color=auto"
alias bc="bc --mathlib --quiet"
alias hibernate="systemctl hibernate"
alias v=vim
if command -v nvim >/dev/null; then alias vim=nvim; fi
alias view="vim -R"
alias o="shtart xdg-open"
alias files="nautilus"

alias trash="gio trash"

alias tmuxdotties='tmux new -c ~/dotfiles -s dotties -A'
alias tmuxpass='tmux new -c ~/.password-store -s pass -A'
alias tmuxjornal='tmux new -c ~/.jornal -s jornal -A'

alias sed4='sed -e "1s/..../& /g"'

type _complete_alias &>/dev/null && while read line; do
    if [[ $line =~ ^alias\ ([^=]+)= ]]; then
        _alias=${BASH_REMATCH[1]}
        [[ $(type -a -t "$_alias") == alias ]] && \
            complete -F _complete_alias "$_alias"
        unset _alias
    fi
done <<< "$(alias -p)"

# edit todo files
alias todoe="$VISUAL \\
    /home/isabelle/dotfiles/todo.md \\
    /home/isabelle/documents/games/chess/todo.md \\
    /home/isabelle/documents/games/stellaris/wiki-todos.md \\
    /home/isabelle/documents/games/eso/todo.md \\
    /home/isabelle/documents/uni/fu/swps/red_potato/todo.md \\
"

alias xclip="xclip -selection clipboard"
alias xsel="xsel --clipboard"

alias bell="printf '\a'"
