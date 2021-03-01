export VISUAL=kak
[ "$TERM" = "xterm" ] && export TERM=xterm-256color
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export LESSHISTFILE=/dev/null
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME:-"$HOME/.config"}/ripgreprc"
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
export XZ_DEFAULTS=--threads=0
