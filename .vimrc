" start: personal
syntax on
set t_Co=256
set colorcolumn=80
set notimeout ttimeout ttimeoutlen=200
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

Plugin 'tomtom/tcomment_vim'
Plugin 'sjl/badwolf'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'flazz/vim-colorschemes'

let g:airline#extensions#tabline#enabled = 1
call vundle#end()
filetype plugin indent on
" end: required for Vundle

colorscheme badwolf
noremap ,, :%s/\s\+$//e<CR>
noremap <CR><CR> :CtrlP<CR>
