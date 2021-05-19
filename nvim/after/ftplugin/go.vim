setlocal noexpandtab
setlocal softtabstop=0

setlocal formatprg=gofmt

setlocal nolist

nnoremap <silent><leader>f :call gofmt#apply()<cr>
