" PLUGIN INSTALL USING VIM-PLUG (https://github.com/junegunn/vim-plug)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Automatically download and install vim-plug if it's not installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Plugins are downloaded from Github (username/repo)

Plug 'lervag/vimtex'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdcommenter'
Plug 'airblade/vim-gitgutter'
Plug 'tweekmonster/braceless.vim', {'for': ['python']}

call plug#end()

" GENERAL CONGIGURATION
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Some of the following is taken from Steve Losh:
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
set nocompatible
set nojoinspaces
set laststatus=2
set modelines=0
set autoindent
set showmode
set showcmd
set visualbell
set cursorline
" Remove the underline from enabling cursorline
highlight Cursorline cterm=none
" Set line numbering to red background:
highlight CursorLineNR cterm=bold ctermbg=yellow ctermfg=black
set ruler
set undofile
set ignorecase
set smartcase
au FocusLost * :wa
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>
vnoremap <tab> %
set encoding=utf-8
set t_Co=256
set ttimeoutlen=50
" Set identation to 4 spaces
set noai ts=4 sw=4 expandtab
" Set an 80 char column
set textwidth=88
set colorcolumn=89
highlight ColorColumn ctermbg=black
" Line numbers
set number
highlight LineNr ctermfg=DarkGrey
highlight SignColumn ctermbg=black
" Rule for Makefiles to use tab
autocmd BufEnter ?akefile* set noet ts=4 sw=4
" Syntax highlighting
syntax on
autocmd BufNewFile,BufRead *.ipy set filetype=python
autocmd BufNewFile,BufRead *.pyx set filetype=python
autocmd BufNewFile,BufRead SConstruct set filetype=python
autocmd BufNewFile,BufRead *.md set filetype=markdown
" Color scheme
set background=dark
highlight clear SpellBad
highlight SpellBad cterm=underline,bold ctermbg=none ctermfg=red
" Remove trailing spaces on save
autocmd BufWritePre * :%s/\s\+$//e
" Git commits
autocmd Filetype gitcommit setlocal spell textwidth=72
" Map F2 to paste mode so that pasting in the terminal doesn't mess identation
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Spell Check
" Function to rotate the spell language that is used
let b:myLang=0
let g:myLangList=["nospell","pt_br","en_us"]
function! ToggleSpell()
    let b:myLang=b:myLang+1
    if b:myLang>=len(g:myLangList) | let b:myLang=0 | endif
    if b:myLang==0
        setlocal nospell
    else
        execute "setlocal spell spelllang=".get(g:myLangList, b:myLang)
    endif
    echo "spell checking language:" g:myLangList[b:myLang]
endfunction
" Pressing \ss will toggle and untoggle spell checking
map <leader>ss :call ToggleSpell()<cr>
" ]s and [s to move down-up marked words
" Shortcuts using <leader> (\)
" Add word to dictionary
map <leader>sa zg
" Substitution option for marked word
map <leader>s? z=
" Spelling always on for some files
autocmd BufNewFile,BufRead *.ipy,*.py,*.md,*.tex,*.rst,*.c,*.h,Makefile setlocal spell

" Run 'make' on save
function! EnableRunMakeOnSave()
    autocmd BufWritePost * silent! execute "!make >/dev/null 2>&1" | redraw! | echo "Done: make finished."
    echo "Running 'make' on save enabled."
endfunction
map <leader>m :call EnableRunMakeOnSave()<cr>

" Replace Esc with Ctrl+L to make this work better on Termux.
" Android uses Esc as a shortcut for the home screen.
" Use solution in:
" http://vim.wikia.com/wiki/Avoid_the_escape_key
" This is a variation on the previous mapping that additionally checks for
" the popup menu (present when doing completions). During completions, <C-L>
" adds a character from the current match, so this mapping will preserve that
" behavior. See :help popupmenu-keys for more.
:inoremap <expr> <C-L> (pumvisible() <bar><bar> &insertmode) ? '<C-L>' : '<Esc>'


" PLUGIN CONFIGURATION
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nerdcommenter
filetype plugin indent on

" airline
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#symbol = '⎇  '
let g:airline_left_sep = ''
let g:airline_right_sep = ''

" vimtex
let g:vimtex_enabled=1
let g:vimtex_complete_enabled=1
let g:vimtex_complete_close_braces=1

" braceless.vim
autocmd FileType python BracelessEnable +indent +highlight
