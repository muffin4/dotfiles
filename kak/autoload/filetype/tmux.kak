# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*/tmux[.]conf %{
  set-option buffer filetype tmux
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=tmux %{
    require-module tmuxconf
}

hook -group tmux-highlight global WinSetOption filetype=tmux %{
    add-highlighter window/tmux ref tmux
    add-hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/tmux }
}

provide-module tmuxconf %§

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/tmux regions
add-highlighter shared/tmux/default default-region group
add-highlighter shared/tmux/double_string region '"' (?<!\\)(\\\\)*" fill string
add-highlighter shared/tmux/single_string region "'" (?<!\\)(\\\\)*' fill string
add-highlighter shared/tmux/comment       region '#' '$'             fill comment

§
