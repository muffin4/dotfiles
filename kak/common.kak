set-option global startup_info_version 20200901
set-option -add global ui_options ncurses_assistant=cat

# Per-Winfer indendation fallbacks/defaults
hook global WinSetOption filetype=c|cpp %{
    set-option window indentwidth 0
    set-option window tabstop 8
}
hook global WinSetOption filetype=latex|context %{
    set-option window indentwidth 2
    set-option window tabstop 4
}
hook global WinSetOption filetype=makefile %{
    set-option window indentwidth 0
    set-option window tabstop 8
}
hook global WinSetOption filetype=python %{
    set-option window indentwidth 4
    set-option window tabstop 4
    set-option window autowrap_column 120
}
hook global WinSetOption filetype=git-commit %{
    set-option window autowrap_column 73
}
hook global WinSetOption filetype=yaml %{
    set-option window indentwidth 2
}
hook global WinSetOption filetype=rust %{
    set-option window formatcmd rustfmt
    set-option window autowrap_column 100
    set-option window makecmd "cargo"
    map -docstring "cargo run" window user m ": make run<ret>"
}

# highlighters
add-highlighter global/ show-matching
add-highlighter global/ number-lines -separator " " -hlcursor -min-digits 3
add-highlighter global/ wrap -word

set-face global Whitespace rgb:303030+f
add-highlighter global/ show-whitespaces

hook global WinSetOption autowrap_column=.* %{
    add-highlighter -override window/autowrap_column column %opt{autowrap_column} default,red
}

# delete with D aswell for convenience
map -docstring "delete" global normal D d

# scrolling
map -docstring "scroll down" global normal <c-e> vj
map -docstring "scroll up" global normal <c-y> vk
set-option global scrolloff 2,0

define-command copy-to-clipboard %{ nop %sh{
    [ -n "$TMUX" ] && tmux set-buffer -- "$kak_selection"
    [ -n "$DISPLAY" ] && printf %s "$kak_selection" | xclip -in -selection clipboard >&- 2>&-
}}
map -docstring "copy primary selection to tmux buffer and X11 clipboard" global user y ": copy-to-clipboard<ret>"

# paste from X11 clipboard
map -docstring "paste before" global user P "!xclip -out -selection clipboard<ret>"
map -docstring "paste after" global user p "<a-!>xclip -out -selection clipboard<ret>"
map -docstring "replace selections" global user R "|xclip -out -selection clipboard<ret>"

# ,. to escape instert mode
hook global InsertChar \. %{ try %{
    exec -draft hH <a-k>,\.<ret>d
    exec <esc>
}}

# user mappings
map global normal '#' ": comment-line<ret>"
map -docstring "run makecmd" global user m ": make<ret>"
map -docstring "save buffer" global user w ": write<ret>"

# insert result of math
map global normal = \
    ':prompt math: %{exec "!printf ""%%s"" ""$(echo ""%val{text}"" | bc)""<lt>ret<gt>"}<ret>'

hook global -always BufOpenFifo '\*grep\*' %{ map -- global normal - ': grep-next-match<ret>' }
hook global -always BufOpenFifo '\*make\*' %{ map -- global normal - ': make-next-error<ret>' }

# only show autocomplete options when prompting for them
set-option global autocomplete prompt

define-command -docstring "open a new scratch buffer, not linked to a file" scratch %{ edit -scratch }
alias global s scratch

# quit all
alias global qa kill
alias global qa! kill!

define-command ide -params 0..1 %{
    try %{ rename-session %arg{1} }

    rename-client main
    set-option global jumpclient main

    evaluate-commands %sh{
        if ! grep --quiet --word-regexp docs -- <(echo "$kak_client_list")
        then
            echo "new edit *debug* \; rename-client docs"
            echo "set-option global docsclient docs"
        fi

        if ! grep --quiet --word-regexp tools -- <(echo "$kak_client_list")
        then
            echo "new edit *debug* \; rename-client tools"
            echo "set-option global toolsclient tools"
        fi
    }

    nop %sh{
        if [ -n "$TMUX" ]; then
            tmux select-layout tiled \; \
                 select-pane -t "$TMUX_PANE" \; \
                 resize-pane -x 124 \; \
                 resize-pane -y 100% \; \
                 resize-pane -U 3
        fi
    }
}

evaluate-commands %sh{
    [ -n "$TMUX" ] && printf "%s\n" \
        "require-module tmux" \
        "alias global terminal tmux-terminal-vertical"
}

evaluate-commands %sh{
    if [ -n "$(command -v rg)" ]; then
        echo "set-option global grepcmd 'rg --follow --hidden --with-filename --column'"
    fi
}

# Highlight the word under the cursor
set-face global CurWord default,rgba:30303040
hook global NormalIdle .* %{
    eval -draft %{ try %{
        exec <space><a-i>w <a-k>\A\w+\z<ret>
        add-highlighter -override global/curword regex "\b\Q%val{selection}\E\b" 0:CurWord
    } catch %{
        add-highlighter -override global/curword group
    } }
}

# empty *scratch* buffer when kak is started file argument
hook -once global BufCreate .* %{ evaluate-commands %sh{
    if [ 'x*scratch*' = "x$kak_bufname" ]; then
        echo "execute-keys \%\\d"
    fi
}}
