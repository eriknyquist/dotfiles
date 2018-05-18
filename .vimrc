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

function! HLNext ()
    let [bufnum, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'), col-1), @/))
    let target_pat = '\c\%#'.@/
	let hlgroup = 'Error'

    let hlnext = matchadd(hlgroup, target_pat, 101)
    redraw
endfunction

" Recognise hidden .tags file
set tags=./tags,./TAGS,tags,TAGS,./.tags,./.TAGS,.tags,.TAGS

" re-mappings
noremap ' l:nohl<CR>h
noremap ,, :%s/\s\+$//e<CR>
noremap <CR><CR> :CtrlP<CR>
nnoremap <silent> n n:call HLNext()<CR>
nnoremap <silent> N n:call HLNext()<CR>

" commands

" Run a shell command silently and redraw the screen
command! -nargs=1 Silent execute 'silent <args>' | redraw!

" Run 'ctags' in current directory
command! Tags Silent !ctags -o .tags -R .

" end: personal



"-------------------------- required for Vundle --------------------------------

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

Plugin 'kien/ctrlp.vim'
Plugin 'tomtom/tcomment_vim'
Plugin 'sjl/badwolf'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'flazz/vim-colorschemes'

let g:airline#extensions#tabline#enabled = 1
call vundle#end()
filetype plugin indent on
" end: required for Vundle

" This has to go after the plugin declarations....
colorscheme badwolf

"------------------------- Plugin configuration --------------------------------

" configure netrw
let g:netrw_liststyle=3
let g:netrw_banner=0
let g:netrw_altv=1
let g:netrw_winsize=25
