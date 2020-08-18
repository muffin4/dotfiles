[ -f "${HOME}/.xprofile" ] && . "${HOME}/.xprofile"
[ -f "${HOME}/.xinitrc.local" ] && . "${HOME}/.xinitrc.local"

exec i3
