#! /usr/bin/env bash
set -e -u

line=1

usage() {
    echo "Usage: $0 [OPTION]..."
    echo
    echo "  -h show this help text"
    echo "  -u copy username instead of password"
    exit 1
}

uniq_fzf_history() {
	history_file="$HOME/.password-store/fzf.history"
	uniq "${history_file}" > "${history_file}.uniq" && mv "${history_file}.uniq" "${history_file}"
}

while getopts hu option
do
    case $option in
        u) line=2;;
        *) usage;;
    esac
done

tmppipe=$(mktemp --dry-run)
mkfifo --mode=600 "$tmppipe"

"$TERMINAL" -- bash -c "\
    shopt -s globstar
    prefix=\${PASSWORD_STORE_DIR:-\${HOME}/.password-store}
    files=( \"\$prefix\"/**/*.gpg )
    args=()
    for file in \"\${files[@]}\"
    do
        file=\${file%.gpg}
        file=\${file#\${prefix}/}
        args+=(\"\$file\")
    done
    printf \"%s\0\" \"\${args[@]}\" | fzf \"--history=\${HOME}/.password-store/fzf.history\" --read0 > $(printf %q "$tmppipe")
" & selection=$(cat "$tmppipe")

rm "$tmppipe"
pass show -c"$line" "$selection"
uniq_fzf_history
