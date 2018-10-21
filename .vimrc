set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'vimscript/perl-mauke.vim'
Plugin 'cocopon/iceberg.vim'
Plugin 'itchyny/lightline.vim'
Plugin 'Yggdroot/indentLine'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'leafgarland/typescript-vim'
Plugin 'cohama/lexima.vim'

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

augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.css setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
augroup END

let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#min_keyword_length = 3
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#auto_completion_start_length = 1
inoremap <expr><BS> neocomplete#smart_close_popup()."<C-h>"

imap <expr><CR> neosnippet#expandable() ? "<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "<C-y>" : "<CR>"
imap <expr><TAB> pumvisible() ? "<C-n>" : neosnippet#jumpable() ? "<Plug>(neosnippet_expand_or_jump)" : "<TAB>"

