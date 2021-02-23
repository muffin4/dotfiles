define-command ide -params 0..1 %{
    try %{ rename-session %arg{1} }

    rename-client main
    set-option global jumpclient main

    evaluate-commands %sh{
        if ! grep --quiet --word-regexp docs -- <(echo "$kak_client_list")
        then
            echo "set-option global docsclient docs"
            echo "new rename-client docs \; edit *debug*"
        fi

        if ! grep --quiet --word-regexp tools -- <(echo "$kak_client_list")
        then
            echo "set-option global toolsclient tools"
            echo "new rename-client tools \; edit *debug*"
        fi
    }

    nop %sh{
        if [ -n "$kak_client_env_TMUX" ]; then
            TMUX=${kak_client_env_TMUX} tmux \
                select-layout tiled \; \
                select-window -t "$kak_client_env_TMUX_PANE" \; \
                select-pane -t "$kak_client_env_TMUX_PANE" \; \
                resize-pane -x 124 \; \
                resize-pane -y 100% \; \
                resize-pane -U 3
        fi
    }

    # focus client when the displayed window changes
    hook -group focusclient global WinDisplay .* %{ evaluate-commands %sh{
        case "$kak_bufname" in
            "*make*" | "*debug*") exit;;
        esac

        for existing_client in $kak_client_list; do
            [ "$kak_client" = "$existing_client" ] && { echo focus; break; }
        done
    }}
}
