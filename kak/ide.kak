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
    hook global WinDisplay .* %{ eval %sh{
        if [ "$kak_client" = "$kak_opt_jumpclient" ] || [ "$kak_client" = "$kak_opt_docsclient" ]; then
            echo focus "$kak_client"
        fi
    }}
}
