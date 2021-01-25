export XDG_CONFIG_HOME="$HOME/.config"

# used by rofi-sensible-terminal to determine which terminal to launch
export TERMINAL=/usr/bin/kitty

# disable interpreting ctrl-s and ctrl-q as control flow signals
stty -ixon

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

[ -d "$XDG_RUNTIME_DIR" ] && export TMPDIR="$XDG_RUNTIME_DIR"
