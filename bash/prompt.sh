__PS1='; '

# Based on /usr/share/doc/ranger/examples/shell_subshell_notice.sh
# Compatible with ranger 1.5.3 through 1.9.*
# Change the prompt when you open a shell from inside ranger
if [ -n "$RANGER_LEVEL" ]; then __PS1="(in ranger) ${__PS1}"; fi

PS1=$__PS1
