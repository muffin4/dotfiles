" Author: Isa Cichon
" When started as "evim", evim.vim will already have done these settings. {{{
if v:progname =~? "evim"
	finish
endif " }}}
" vim-plug {{{
call plug#begin(stdpath('config').'/plugged')
Plug 'bronson/vim-visual-star-search'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/gv.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

" colorschemes
Plug 'altercation/vim-colors-solarized'
Plug 'NLKNguyen/papercolor-theme'
Plug 'morhetz/gruvbox'

" go
let g:gofmt_exe = '/usr/bin/gofmt'
Plug 'muffin4/gofmt.vim', { 'branch': 'no-empty-changes' }
call plug#end()
" }}}
" Misc {{{
behave xterm
filetype plugin indent on

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" keep vim default: move cursor to first non-blank after various commands
set startofline

" shows matching parentheses when inserting one
set showmatch

" only insert one space when using J
set nojoinspaces

" set the internal encoding and make a greater effort to determine whether a
" file is in utf-8 without byte order mark
set encoding=utf-8

" use tmux escape sequences and set window title
set t_ts=]2;
set t_fs=\\
set title

" visual line breaks at 'breakat' characters
set wrap linebreak

if executable('rg')
	set grepprg=rg\ --line-number
endif

set laststatus=2    " always show status line

function! MapToggle(key, option)
	let cmd = ':set ' . a:option . '! \| set ' . a:option . '?<cr>'
	exec 'nnoremap' a:key cmd
	exec 'inoremap' a:key ' \<C-O>' . cmd
endfunction
command -nargs=+ MapToggle call MapToggle(<f-args>)

MapToggle <F1> list
MapToggle <F2> wrap
MapToggle <F3> smartcase

function! ToggleBackground()
	if &background == "light"
		set background=dark
	else
		set background=light
	endif
	set background?
endfunction
nnoremap <silent> <F4> :call ToggleBackground()<cr>
inoremap <silent> <F4> <C-O>:call ToggleBackground()<cr>
" }}}
" Mouse {{{
if has('mouse') " use the mouse if compiled with support for mouse
	set mouse=a
	" scroll through time
	nnoremap <A-ScrollWheelUp> g-
	nnoremap <A-ScrollWheelDown> g+
endif
" }}}
" Colors {{{
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
	if !exists("g:syntax_on")
		syntax enable
	endif
	set background=dark
	colorscheme gruvbox
	if has("win32") || has("win16")
		set guifont=Courier_New:h10:cANSI:qDRAFT
	else
		set guifont=Fira\ Mono\ 12
	endif
endif
" }}}
" Tabs & Indents {{{
set smarttab        " use shiftwidth at the start of a line
set nosmartindent
set autoindent      " always set autoindenting on
" }}}
" UI Layout {{{
set number          " displays line-numbering at the start of every line
set ruler           " show the cursor position all the time
set showcmd         " display incomplete commands
set nocursorline    " don't highlight current line
set wildmenu        " add a menu for command-line completion (like in :e foo<TAB>)
set lazyredraw      " don't redraw while executing macros, registers, or other commands that have not been typed
set guioptions+=c   " use console dialogs instead of popup dialogs for simple choices
set guioptions-=m   " menubar
set guioptions-=T   " toolbar
set guioptions-=r   " right-hand scrollbar
set guioptions-=l   " left-hand scrollbar
set guioptions-=R   " right-hand scrollbar when there is a vertically split window
set guioptions-=L   " left-hand scrollbar when there is a vertically split window
set guioptions-=b   " bottom scrollbar
set guicursor=n-v-c-ve-o-i-ci-r-cr-sm:block-Cursor/lCursor-blinkoff0
" }}}
" Searching {{{
set incsearch               " search as characters are entered
set hlsearch                " highlight all visible matches
" make backspace remove search highlights
" first one is necessary for ideavim
nnoremap <bs> :nohlsearch<cr>
nnoremap <silent><bs> :nohlsearch<cr>
nnoremap <leader>/ /\<\><left><left>
" }}}
" Folds {{{
set foldenable          " don't use folds
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " never use more than 10 folds
set foldmethod=syntax   " fold based on indent level
" }}}
" Backups {{{
set nobackup    " do not keep a backup file
set writebackup " use a backup file when trying to write a file
" move file~ and .file.un~ from working directory
if has("win32") || has("win16")
	set backupdir=$TEMP//,c:/tmp//,c:/temp//,.
	set directory=$TEMP//,c:/tmp//,c:/temp//,.
	set viewdir=$HOME/vimfiles/view
else
	set backupdir='~/.nvim-tmp//,~/.tmp//,~/tmp//,/var/tmp//,/tmp//,.'
	set directory='~/.nvim-tmp//,~/.tmp//,~/tmp//,/var/tmp//,/tmp//,.'
endif
" }}}
" Buffers {{{
set hidden
set splitright " open a new window on the right of the currently active with :vs
set splitbelow " open a new window below the currently active with :vs
" }}}
" Leader {{{
let mapleader = "\\"
nmap <space> <leader>
vmap <space> <leader>
nnoremap <leader>w :w<cr>

" format whole file using formatexpr or formatprg
nnoremap <leader>f :normal gggqG<cr>
" }}}
" Clipboard {{{
nnoremap <leader>p o<esc>p
nnoremap <leader>P O<esc>p
" }}}
" Vimrc {{{
nnoremap <leader>ve :next $MYVIMRC<cr>
nnoremap <leader>vs :split $MYVIMRC<cr>
nnoremap <leader>vv :vsplit $MYVIMRC<cr>
" }}}
" Spelling {{{
"set default spelling languages to english and german
set spelllang=de,en_us
" enable completion by dictionary when spelling is enabled
set complete+=kspell
" }}}
" Movement {{{
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
" window movement
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
" }}}
" Abbreviations {{{
iabbrev hte the
iabbrev waht what
" }}}
" jedi-vim {{{
let g:jedi#completions_command = ""
" }}}
" ctrlp {{{
if executable('fd')
	let g:ctrlp_user_command = 'fd . %s --type f '
else
	let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
endif
" }}}
" go {{{
" don't highlight trailing whitespace as error
let g:go_highlight_trailing_whitespace_error = 0
" }}}
" lsp {{{
lua << EOF
local custom_lsp_attach = function(client)
	-- See `:help nvim_buf_set_keymap()` for more information
	vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})
	vim.api.nvim_buf_set_keymap(0, 'n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
	vim.api.nvim_buf_set_keymap(0, 'n', '<leader>r', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap = true})
	vim.api.nvim_buf_set_keymap(0, 'n', '<leader>d', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', {noremap = true})
	-- ... and other keymappings for LSP

	-- Use LSP as the handler for omnifunc.
	--		See `:help omnifunc` and `:help ins-completion` for more information.
	vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- For plugins with an `on_attach` callback, call them here. For example:
	-- require('completion').on_attach()

	-- remove annoying default diagnostics display
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
		vim.lsp.diagnostic.on_publish_diagnostics, {
			-- Disable virtual text
			virtual_text = false,
		}
	)
end

local lspconfig = require('lspconfig')
if lspconfig.pyls then
	lspconfig.pyls.setup({
		on_attach = custom_lsp_attach
	})
end
EOF
" }}}

" vim:foldmethod=marker:foldlevel=0
