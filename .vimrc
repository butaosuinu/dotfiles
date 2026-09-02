set nocompatible
filetype off

" Plugins are managed by Vundle. Bootstrap it on first launch so that a fresh
" dotfiles checkout does not error out, and fall back to a plain configuration
" when it cannot be installed at all.
let s:bundle_dir = expand('~/.vim/bundle')
let s:vundle_dir = s:bundle_dir . '/Vundle.vim'

if !isdirectory(s:vundle_dir) && executable('git')
    echo 'Installing Vundle.vim ...'
    silent execute '!git clone --depth 1 https://github.com/VundleVim/Vundle.vim '
                \ . shellescape(s:vundle_dir)
    if !isdirectory(s:vundle_dir)
        echomsg 'Vundle.vim could not be installed; starting without plugins.'
    endif
endif

if isdirectory(s:vundle_dir)
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()

    Plugin 'VundleVim/Vundle.vim'

    Plugin 'cocopon/iceberg.vim'
    Plugin 'itchyny/lightline.vim'
    Plugin 'Yggdroot/indentLine'
    Plugin 'bronson/vim-trailing-whitespace'
    Plugin 'cohama/lexima.vim'
    Plugin 'posva/vim-vue'
    Plugin 'fatih/vim-go'
    Plugin 'mattn/emmet-vim'
    Plugin 'Shougo/neosnippet'
    Plugin 'Shougo/neosnippet-snippets'
    " neosnippet uses it to pick the snippet set by cursor context.
    Plugin 'Shougo/context_filetype.vim'

    call vundle#end()

    " Fetch whatever is not on disk yet, then reload so the colorscheme and the
    " plugin-dependent mappings below actually take effect.
    let s:missing = 0
    for s:bundle in get(g:, 'vundle#bundles', [])
        if !isdirectory(s:bundle.path())
            let s:missing = 1
            break
        endif
    endfor

    if s:missing
        augroup vimrcBootstrap
            autocmd!
            autocmd VimEnter * ++once PluginInstall | quit | source $MYVIMRC
        augroup END
    endif
endif

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

silent! colorscheme iceberg

augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.css setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.vue setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType vue syntax sync fromstart
augroup END

if isdirectory(s:bundle_dir . '/neosnippet')
    imap <expr><CR> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-y>" : "\<CR>"
    imap <expr><TAB> pumvisible() ? "\<C-n>" : neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
    imap <C-k> <Plug>(neosnippet_expand_or_jump)
    smap <C-k> <Plug>(neosnippet_expand_or_jump)
endif

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
