setlocal noexpandtab
setlocal softtabstop=0

setlocal formatprg=gofmt

setlocal nolist

nnoremap <leader>f :call gofmt#apply()<cr>
