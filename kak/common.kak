set-option global startup_info_version 20200901
set-option -add global ui_options ncurses_assistant=cat

# indendation fallbacks/defaults
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
    set-option buffer autowrap_column 79
}
hook global BufSetOption filetype=git-commit %{
    set-option buffer autowrap_column 72
    autowrap-enable
}
hook global BufSetOption filetype=yaml %{
    set-option buffer indentwidth 2
}
hook global BufSetOption filetype=rust %{
    set-option buffer formatcmd rustfmt
    set-option buffer autowrap_column 100
    set-option buffer makecmd "cargo"
    map -docstring "cargo build" buffer user m ": make build<ret>"
    map -docstring "cargo run"   buffer user r ": make run<ret>"
    map -docstring "cargo test"  buffer user t ": make test<ret>"
}

# highlighters
add-highlighter global/ show-matching
add-highlighter global/ number-lines -separator " " -hlcursor -min-digits 3
add-highlighter global/ wrap -word

set-face global Whitespace rgb:dddddd+f
add-highlighter global/ show-whitespaces

# use EditorConfig: https://editorconfig.org/
hook global WinCreate ^[^*]+$ editorconfig-load

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
map -docstring "quit" global user q ": quit<ret>"
map -docstring "format buffer" global user = ": format<ret>"

hook global -always BufOpenFifo '\*grep\*' %{
    map -- global normal - ': grep-next-match<ret>'
    map -- global normal <a-minus> ': grep-previous-match<ret>'
}
hook global -always BufOpenFifo '\*make\*' %{
    map -- global normal - ': make-next-error<ret>'
    map -- global normal <a-minus> ': make-previous-error<ret>'
}

# only show autocomplete options when prompting for them
set-option global autocomplete prompt

define-command -docstring "open a new scratch buffer, not linked to a file" scratch %{ edit -scratch }
alias global s scratch

# quit all
alias global qa kill
alias global qa! kill!

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
set-face global CurWord default,rgba:f0f0f040
define-command -hidden highlight-current-word %{
    eval -draft %{ try %{
        exec <space><a-i>w <a-k>\A\w+\z<ret>
        add-highlighter -override global/curword regex "\b\Q%val{selection}\E\b" 0:CurWord
    } catch %{
        add-highlighter -override global/curword group
    } }
}

hook global InsertIdle .* highlight-current-word
hook global NormalIdle .* highlight-current-word

define-command -params .. fifo %{ evaluate-commands %sh{
    output=$(mktemp -d "${TMPDIR:-/tmp}"/kak-fifo.XXXXXXXX)/fifo
    mkfifo ${output}
    ( eval "$@" > ${output} 2>&1 & ) > /dev/null 2>&1 < /dev/null
    printf %s\\n "evaluate-commands -try-client '$kak_opt_toolsclient' %{
            edit! -fifo ${output} *fifo*
            hook -always -once buffer BufCloseFifo .* %{ nop %sh{ rm -r $(dirname ${output}) } }
        }"
}}

# empty *scratch* buffer when kak is started file argument
hook -once global BufCreate .* %{ evaluate-commands %sh{
    if [ '*scratch*' = "$kak_bufname" ]; then
        echo "execute-keys \%\\d"
    fi
}}

# window mode
declare-user-mode client

map -docstring "enter window mode" \
    global normal <c-w> ": enter-user-mode client<ret>"
map -docstring "quit" \
    global client <c-q> ": quit<ret>"

evaluate-commands %sh{
    echo 'map -docstring "split horizontally" \
        global client <c-s> \
        ": tmux-terminal-horizontal kak -c %%val{session}<ret>"'
    echo 'map -docstring "split vertically" \
        global client <c-v> \
        ": tmux-terminal-vertical kak -c %%val{session}<ret>"'
}
