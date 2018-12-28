set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

"Plugin 'vimscript/perl-mauke.vim'
Plugin 'cocopon/iceberg.vim'
Plugin 'itchyny/lightline.vim'
Plugin 'Yggdroot/indentLine'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'leafgarland/typescript-vim'
Plugin 'cohama/lexima.vim'
Plugin 'posva/vim-vue'
Plugin 'fatih/vim-go'
Plugin 'nsf/gocode', {'rtp': 'vim/'}
Plugin 'roxma/vim-hug-neovim-rpc'
Plugin 'mattn/emmet-vim'

if has('lua')
    Plugin 'Shougo/neocomplete.vim'
    Plugin 'Shougo/neosnippet'
    Plugin 'Shougo/neosnippet-snippets'
endif

call vundle#end()
filetype plugin indent on

syntax on
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set number
set list
set listchars=tab:»-,trail:.,space:.,eol:↲,nbsp:%
set backspace=indent,eol,start
set clipboard=unnamed,autoselect
set whichwrap=b,s,h,l,<,>,[,],~

set wrap
set linebreak
set breakindent

" set cursorline

" search
set incsearch
set ignorecase
set smartcase
set hlsearch

" status line
set laststatus=2
set showmode
set showcmd
set ruler

colorscheme iceberg

autocmd FileType vue syntax sync fromstart

augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.css setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.vue setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#min_keyword_length = 3
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#auto_completion_start_length = 1
"let g:neocomplete#sources#omni#input_patterns.go = '\h\w\.\w*'
inoremap <expr><BS> neocomplete#smart_close_popup()."<C-h>"

imap <expr><CR> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-y>" : "\<CR>"
imap <expr><TAB> pumvisible() ? "\<C-n>" : neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)

" vim-go
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_fmt_autosave = 1
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:go_metalinter_autosave = 1
let g:go_metalinter_autosave_enabled = ['vet', 'golint']

