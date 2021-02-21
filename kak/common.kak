set-option global startup_info_version 20200901
set-option -add global ui_options ncurses_assistant=cat

# Per-Buffer indendation fallbacks/defaults
hook global BufSetOption filetype=c|cpp %{
    set-option buffer indentwidth 0
    set-option buffer tabstop 8
}
hook global BufSetOption filetype=latex|context %{
    set-option buffer indentwidth 2
    set-option buffer tabstop 4
}
hook global BufSetOption filetype=makefile %{
  set-option buffer indentwidth 0
  set-option buffer tabstop 8
}
hook global BufSetOption filetype=python %{
    set-option buffer indentwidth 4
    set-option buffer tabstop 4
    set-option buffer autowrap_column 120
}
hook global BufSetOption filetype=git-commit %{
    set-option buffer autowrap_column 73
}
hook global BufSetOption filetype=yaml %{
    set-option buffer indentwidth 2
}
hook global BufSetOption filetype=rust %{
    set-option buffer formatcmd rustfmt
    set-option buffer autowrap_column 100
    set-option buffer makecmd "cargo"
    map -docstring "cargo run" buffer user m ": make run<ret>"
}

# highlighters
add-highlighter global/ show-matching
add-highlighter global/ number-lines -separator " " -hlcursor -min-digits 3
add-highlighter global/ wrap -word

hook global BufSetOption autowrap_column=.* %{
    add-highlighter -override buffer/autowrap_column column %opt{autowrap_column} default,red
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

# only show autocomplete options when prompting for them
set-option global autocomplete prompt

# command aliases
alias global bd delete-buffer

define-command -docstring "open a new scratch buffer, not linked to a file" scratch %{ edit -scratch }
alias global s scratch

define-command ide %{
    rename-client main
    set-option global jumpclient main

    new rename-client docs
    set-option global docsclient docs

    new rename-client tools
    set-option global toolsclient tools
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
