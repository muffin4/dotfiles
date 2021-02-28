# install plug.kak plugin that manages plugins
source "%val{config}/plugins/plug.kak/rc/plug.kak"
plug "robertmeta/plug.kak" noload

plug "andreyorst/fzf.kak" config %{
    map -docstring "enter fzf mode" global user f ": fzf-mode<ret>"
} defer fzf %{
    set-option global fzf_project_use_tilda true
    declare-option str-list fzf_exclude_files "*.o" "*.bin" "*.obj" ".*cleanfiles"
    declare-option str-list fzf_exclude_dirs ".git" ".svn" "rtlrun*"
    set-option global fzf_file_command %sh{
        if [ -n "$(command -v fd)" ]; then
            eval "set -- $kak_quoted_opt_fzf_exclude_files $kak_quoted_opt_fzf_exclude_dirs"
            while [ $# -gt 0 ]; do
                exclude="$exclude --exclude '$1'"
                shift
            done
            cmd="fd . --no-ignore --type f --follow --hidden $exclude"
        else
            eval "set -- $kak_quoted_opt_fzf_exclude_files"
            while [ $# -gt 0 ]; do
                exclude="$exclude -name '$1' -o"
                shift
            done
            eval "set -- $kak_quoted_opt_fzf_exclude_dirs"
            while [ $# -gt 0 ]; do
                exclude="$exclude -path '*/$1' -o"
                shift
            done
            cmd="find . \( ${exclude% -o} \) -prune -o -type f -follow -print"
        fi
        echo "$cmd"
    }
    evaluate-commands %sh{
        if [ -n "$(command -v bat)" ]; then
            echo "set-option global fzf_highlight_command bat"
        fi
    }
    evaluate-commands %sh{
        if [ -n "${kak_opt_grepcmd}" ]; then
            echo "set-option global fzf_sk_grep_command '${kak_opt_grepcmd}'"
        fi
    }
}

# Configure tab and backspace key behavior based on previous settings
plug "andreyorst/smarttab.kak" defer smarttab %{
    # set-option global softtabstop 4
} config %{
    hook global BufSetOption filetype=.* %{
        evaluate-commands %sh{
            if [ $kak_opt_indentwidth -ne 0 ]; then
                echo "expandtab"
                echo "set-option buffer softtabstop $kak_opt_indentwidth"
            elif [ $kak_opt_filetype = "gas" ] || [ $kak_opt_filetype = "nasm" ]; then
                echo "noexpandtab"
            else
                echo "smarttab"
            fi
        }
    }
}

# Kakoune Language Server Protocol Client
plug "kak-lsp/kak-lsp" do %{
    cargo build --release --locked
    cargo install --force --path .
} config %{
    hook global WinSetOption filetype=(rust|python|c) %{
        lsp-enable-window
    }
    map -docstring "enter lsp mode" global user l ": enter-user-mode lsp<ret>"
}
