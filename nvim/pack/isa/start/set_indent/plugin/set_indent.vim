function s:spaces(num) abort
	execute "set tabstop=" .. a:num
	execute "set softtabstop=" .. a:num
	execute "set shiftwidth=0"
	set expandtab
endfunction

command -nargs=1 Spaces call s:spaces(<args>)

function s:tabs(num) abort
	execute "set tabstop=" .. a:num
	execute "set softtabstop=0"
	execute "set shiftwidth=0"
	set noexpandtab
endfunction

command -nargs=1 Tabs call s:tabs(<args>)
