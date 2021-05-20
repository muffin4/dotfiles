setlocal noexpandtab
setlocal softtabstop=0

setlocal formatprg=gofmt

setlocal nolist

nnoremap <buffer><silent> <leader>f :call gofmt#apply()<cr>
