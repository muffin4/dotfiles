if exists(":RustFmt")
	nnoremap <buffer> <leader>f :RustFmt<cr>
endif

setlocal formatprg=rustfmt
