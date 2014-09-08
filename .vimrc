" Start pathogen to load the plugins in .vim/bundle
execute pathogen#infect()

set laststatus=2
set t_Co=256
set ttimeoutlen=50
set encoding=utf-8

" Set identation to 4 spaces
set noai ts=4 sw=4 expandtab

" Set an 80 char column
set colorcolumn=80 textwidth=79

" Line numbers
set number
highlight LineNr ctermfg=DarkGrey
highlight SignColumn ctermbg=black

" Rule for Makefiles to use tab
autocmd BufEnter ?akefile* set noet ts=4 sw=4

" Syntax highlighting
syntax on
set background=dark

" Configure files to syntax highlight
autocmd BufNewFile,BufRead *.ipy set filetype=python
autocmd BufNewFile,BufRead *.pyx set filetype=python
autocmd BufNewFile,BufRead SConstruct set filetype=python
autocmd BufNewFile,BufRead *.md set filetype=markdown

" Remove trailing spaces on save
autocmd BufWritePre * :%s/\s\+$//e

" Git commits
autocmd Filetype gitcommit setlocal spell textwidth=72

" For nerdcommenter
filetype plugin indent on

" Map F2 to paste mode so that pasting in the terminal doesn't mess idendtation
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Airline config
""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#symbol = '⎇  '
let g:airline_left_sep = ''
let g:airline_right_sep = ''

" Spell Check
""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing \ss will toggle and untoggle spell checking
map <leader>ss :call ToggleSpell()<cr>
" ]s and [s to move down-up marked words
" Shortcuts using <leader> (\)
" Add word to dictionary
map <leader>sa zg
" Substitution option for marked word
map <leader>s? z=
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
nmap <silent> <F7> :call ToggleSpell()<CR>

" Jedi autocompletion
""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
