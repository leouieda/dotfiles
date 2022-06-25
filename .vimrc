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
Plug 'vim-syntastic/syntastic'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ap/vim-css-color'                " highlight RGB colors
Plug 'mattn/emmet-vim'                 " for HTML completion
Plug 'junegunn/limelight.vim'

call plug#end()

" GENERAL CONGIGURATION
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Some of the following is taken from Steve Losh:
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
set nocompatible
set nojoinspaces
set laststatus=2
set modelines=0
set showmode
set showcmd
set visualbell
set cursorline
set mouse=vi
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
" Set identation to 4 spaces in general with some exceptions
set autoindent ts=4 sts=4 sw=4 expandtab
" Configure format options. From github.com/santisoler/dotfiles
" Find more about format options with :h fo-table
" t: auto-wrap text using textwidth
" c: auto-wrap comments inserting comment leader automatically
" q: format comments with "gq"
" j: remove comment leader when joining lines
set formatoptions=tcqj
set formatoptions+=r  " insert comment char after hitting enter in Insert mode
set formatoptions-=o  " don't insert comment char on new line in Normal mode
set formatoptions+=n  " recognize numbered lists when formatting text
"set formatlistpat="^\s*\(\d\+[.)]\|[-*]\(\s\[[ A-Za-z]\]\)*\)\s\+"
set breakindent
autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType htmldjango setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType less setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType tex setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType bib setlocal ts=2 sts=2 sw=2 expandtab
" Rules for files that use tabs instead of spaces
autocmd FileType make setlocal ts=4 sw=4 noexpandtab
autocmd BufEnter .gitconfig set ts=4 sw=4 noexpandtab
" Set a visual 80 char column
set colorcolumn=80
" Remove the text width so that vim doesn't automatically break lines
set textwidth=0
" Set visual wrapping of lines so I can still read them
set wrap
highlight ColorColumn ctermbg=black
" Line numbers
set number
highlight LineNr ctermfg=DarkGrey
highlight SignColumn ctermbg=black
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
autocmd Filetype gitcommit setlocal spell
" Map F2 to paste mode so that pasting in the terminal doesn't mess identation
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode
" Disable folding. It's really annoying and I never remeber the commands.
set nofoldenable
" Ommit the <C-W> when moving between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Keep searches centered (source: ThePrimeagen)
nnoremap n nzzzv
nnoremap N Nzzzv

" Keep cursor fixed when joining lines (source: ThePrimeagen)
nnoremap J mzJ`z

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
let g:tex_flavor = 'latex'
let g:vimtex_enabled=1
let g:vimtex_complete_enabled=1
let g:vimtex_complete_close_braces=1

" braceless.vim
autocmd FileType python BracelessEnable +indent +highlight

" CoC code completion
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
" Use <Tab> and <S-Tab> to navigate the completion list:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Close the preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
" Configure extensions to install
let g:coc_global_extensions = 'coc-explorer coc-yaml coc-sh coc-python coc-markdownlint coc-css coc-cmake coc-html'

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_rst_checkers = ['text/language_check']
let g:syntastic_tex_checkers = ['text/language_check']
let g:syntastic_python_checkers = ['flake8']

" limelight
nnoremap <leader>l :Limelight!!<CR>
let g:limelight_conceal_ctermfg = 'black'
