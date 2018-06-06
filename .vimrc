set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'vimscript/perl-mauke.vim'
Plugin 'cocopon/iceberg.vim'

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
colorscheme iceberg

