" start: personal
syntax on
colorscheme desert
set t_Co=256
set colorcolumn=80
set shiftwidth=4
set tabstop=4
set expandtab
set hlsearch
set paste
hi Search cterm=NONE ctermbg=red
" end: personal

" start: required for Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

Plugin 'airblade/vim-gitgutter'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'flazz/vim-colorschemes'

let g:airline#extensions#tabline#enabled = 1
call vundle#end()
filetype plugin indent on
" end: required for Vundle
