# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*/tmux[.]conf %{
  set-option buffer filetype tmux
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=tmux %{
    require-module tmuxconf

    set-option window static_words %opt{tmux_static_words}
}

hook -group tmux-highlight global WinSetOption filetype=tmux %{
    add-highlighter window/tmux ref tmux
    add-hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/tmux }
}

provide-module tmuxconf %§

# Highlighters & completion
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/tmux regions
add-highlighter shared/tmux/default default-region group
add-highlighter shared/tmux/double_string region '"' (?<!\\)(\\\\)*" fill string
add-highlighter shared/tmux/single_string region "'" (?<!\\)(\\\\)*' fill string
add-highlighter shared/tmux/comment       region '#' '$'             fill comment

evaluate-commands %sh{
    # Grammar
    # commands and options taken from man 1 tmux
    commands="attach-session attach detach-client detach has-session has kill-server kill-session
              list-clients lsc list-commands lscm list-sessions ls lock-client lockc lock-session
              locks new-session new refresh-client refresh rename-session rename show-messages
              showmsgs source-file source start-server start suspend-client suspendc switch-client
              switchc copy-mode break-pane breakp capture-pane capturep choose-client choose-tree
              display-panes displayp find-window findw join-pane joinp kill-pane killp kill-window
              killw last-pane lastp last-window last link-window linkw list-panes lsp list-windows
              lsw move-pane movep move-window movew new-window neww next-layout nextl next-window
              next pipe-pane pipep previous-layout prevl previous-window prev rename-window renamew
              resize-pane resizep resize-window resizew respawn-pane respawnp respawn-window
              respawnw rotate-window rotatew select-layout selectl select-pane selectp
              select-window selectw split-window splitw swap-pane swapp swap-window swapw
              unlink-window unlinkw bind-key bind list-keys lsk send-keys send send-prefix
              unbind-key unbind set-option set set-window-option show-options show set-hook
              show-hooks set-environment show-environment command-prompt confirm-before confirm
              display-menu menu display-message display choose-buffer clear-history clearhist
              delete-buffer deleteb list-buffers lsb load-buffer loadb paste-buffer pasteb
              save-buffer saveb set-buffer setb show-buffer showb clock-mode if-shell if
              lock-server lock run-shell run wait-for wait"
    copy_commands="append-selection append-selection-and-cancel back-to-indentation begin-selection
                   bottom-line cancel clear-selection copy-end-of-line copy-line copy-pipe
                   copy-pipe-no-clear copy-pipe-and-cancel copy-selection copy-selection-no-clear
                   copy-selection-and-cancel cursor-down cursor-down-and-cancel cursor-left
                   cursor-right cursor-up end-of-line goto-line halfpage-down
                   halfpage-down-and-cancel halfpage-up history-bottom history-top jump-again
                   jump-backward jump-forward jump-reverse jump-to-backward jump-to-forward
                   middle-line next-matching-bracket next-paragraph next-space next-space-end
                   next-word next-word-end other-end page-down page-down-and-cancel page-up
                   previous-matching-bracket previous-paragraph previous-space previous-word
                   rectangle-toggle scroll-down scroll-down-and-cancel scroll-up search-again
                   search-backward search-backward-incremental search-backward-text search-forward
                   search-forward-incremental search-forward-text search-reverse select-line
                   select-word start-of-line stop-selection top-line"
    server_options="backspace buffer-limit command-alias default-terminal escape-time exit-empty
                    exit-unattached focus-events history-file message-limit set-clipboard
                    terminal-overrides user-keys"
    session_options="activity-action assume-paste-time base-inder bell-action default-command
                     default-shell default-size destroy-unattached detach-on-destroy
                     display-panes-active-colour display-panes-colour display-panes-time
                     display-time history-limit key-table lock-after-time lock-command
                     message-command-style message-style mouse perfix prefix2 renumber-windows
                     repeat-time set-titles set-titles-string silence-action status status-format
                     status-interval status-justify status-keys status-left status-left-length
                     status-left-style status-position status-right status-right-length
                     status-right-style status-style update-environment visual-activity visual-bell
                     visual-silence word-separators"
    window_options="aggressive-resize automatic-rename automatic-rename-format clock-mode-colour
                    clock-mode-style main-pane-height main-pane-width mode-keys mode-style
                    monitor-activity monitor-bell monitor-silence other-pane-height
                    other-pane-width pane-active-border-style pane-base-index pane-border-format
                    pane-border-status pane-border-style synchronize-panes
                    window-status-activity-style window-status-bell-style
                    window-status-current-format window-status-current-style window-status-format
                    window-status-last-style window-status-separator window-status-style
                    window-size wrap-search xterm-keys"
    pane_options="allow-rename alternate-screen remain-on-exit window-active-style window-style"

    values="off on"

join() { sep=$2; eval set -- $1; IFS="$sep"; echo "$*"; }

    # Add the language's grammar to the static completion list
    printf %s\\n "declare-option str-list tmux_static_words $(join "${commands}" ' ')"

    # Highlight keywords (which are always surrounded by whitespace)
    printf '%s\n' "add-highlighter shared/tmux/default/commands regex (?:\s|\A)\K($(join "${commands} ${copy_commands} ${server_options} ${session_options} ${window_options} ${pane_options}" '|'))(?:(?=\s)|\z) 0:keyword
                   add-highlighter shared/tmux/default/values regex (?:\s|\A)\K($(join "${values}" '|'))(?:(?=\s)|\z) 0:value"
}

§
