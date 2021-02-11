alias ls='LC_ALL=C ls --color=auto --group-directories-first'
alias l='ls -lh'
alias la='ls -lhA'
alias date_clean='date +%F_%H-%M-%S'
alias mv='mv --interactive'
alias cp='cp --interactive'
alias tuxsay='cowsay -f tux'
alias sl='ls'
alias ..='cd ..'
alias steamlib='find ~/.steam/root/ \( -name "libgpg-error.so*" -o -name "libstdc++.so*" \) -print -delete'
alias py='python'
alias pamcan=pacman
alias g=git
alias cal='cal --monday'
alias grep='grep --color=auto --binary-files=without-match'
alias rg='rg --hidden --follow'
alias diff="diff --color=auto"
alias bc="bc --mathlib --quiet"
alias hibernate="systemctl hibernate"
alias v=vim
alias k=kak

alias tmuxdotties='tmux new -c ~/dotfiles -s dotties -A'
alias sed4='sed -e "1s/..../& /g"'
