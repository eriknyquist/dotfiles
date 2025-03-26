" Cheatsheet to remind myself of useful commands/keys that I always forget to use...
"
"  ci(  Delete all text inside parens (cursor must be inside parens) and go to insert mode.
"       Replace the ( with { or [ or whatever is needed.
"
"  _    Jump to first non-whitespace character after the cursor on current line
"
"  %    Jump to matching brace, bracket or paren for current cursor position
"
"  qa   Start recording keystrokes in register 'a'
"
"  q    Stop recording
"
"  @a   Replay keystrokes in register 'a'
"
"  5@a  Replay keystrokes in register 'a' 5 times
"
"  "0p  Paste the last thing that was yanked-- doesn't get overwritten by delete commands.
"       Useful when you yank a line, then delete bunch of other lines, and want to paste that
"       original thing you yanked, where 'p' would just paste the last line you deleted.
"
"  ,,   Strip all trailing whitespace (custom remap defined in this file)


"----------------------------------- Functions ---------------------------------


" colours the currently selected search match red
function! HighlightNextMatch ()
    let [bufnum, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'), col-1), @/))
    let target_pat = '\c\%#'.@/
	let hlgroup = 'Error'

    let hlnext = matchadd(hlgroup, target_pat, 101)
    redraw
endfunction

" sets custom highlights used for all search matches
function! SetSearchHighlight ()
    execute 'highlight Search ctermbg=White'
    execute 'highlight Search ctermfg=Black'
    execute 'highlight Normal ctermfg=Gray'
endfunction


"------------------------------ Custom re-mappings -----------------------------


" turn off syntax colours when I'm searching for something
nnoremap / :call SetSearchHighlight()<CR>:syntax off<CR>/

" highlight the current match in red when I'm cycling through matches
nnoremap <silent> n n:call HighlightNextMatch()<CR>
nnoremap <silent> N n:call HighlightNextMatch()<CR>

" turn syntax colours back on, and remove all highlights
noremap ; :syntax on<CR>l:nohl<CR>h;

" strip trailing whitespace in current buffer
noremap ,, :%s/\s\+$//e<CR>

" commands

" Run a shell command silently and redraw the screen
command! -nargs=1 Silent execute 'silent <args>' | redraw!

" Run 'ctags' in current directory
command! Tags Silent !ctags -o .tags -R .


"-------------------------- required for Vundle --------------------------------


set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'tomtom/tcomment_vim'
Plugin 'luochen1990/rainbow'
Plugin 'sjl/badwolf'
Plugin 'airblade/vim-gitgutter'
Plugin 'flazz/vim-colorschemes'
Plugin 'vim-airline/vim-airline'

call vundle#end()
filetype plugin indent on
" end: required for Vundle

" This has to go after the plugin declarations....
colorscheme badwolf

set hlsearch

augroup BufWriteGroup
    autocmd!
    autocmd BufWritePost $VIM_CTAGS_FTYPES Silent !update_ctags <afile>
augroup END


"---------------------------- Plugin configuration -----------------------------


"let g:airline#extensions#tabline#enabled = 1

let g:rainbow_active = 1

" Set some nice bright colours for bracket/paren/brace colour matching
let g:rainbow_conf = { 'guifgs':   ['Cyan', 'Red', 'Green', 'Blue', 'Yellow', 'Magenta'],
\                      'ctermfgs': ['Cyan', 'Red', 'Green', 'Blue', 'Yellow', 'Magenta'] }

" ---------------------------------- Settings ----------------------------------

set t_Co=256
set colorcolumn=80
set notimeout ttimeout ttimeoutlen=200
set paste
set shellcmdflag=-ic
syntax on
colorscheme badwolf
set shiftwidth=4
set tabstop=4
set expandtab
set autoindent
set visualbell
set t_vb=

" Recognise hidden .tags file
set tags=./tags,./TAGS,tags,TAGS,./.tags,./.TAGS,.tags,.TAGS
