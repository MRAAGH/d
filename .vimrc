" PLUGINS
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

if empty(glob('~/.vim/autoload/plug.vim'))
else

  call plug#begin('~/.vim/plugged')

  Plug 'Valloric/YouCompleteMe'

  Plug 'tpope/vim-commentary'
  Plug 'pangloss/vim-javascript'
  Plug 'tpope/vim-surround'
  " Plug 'ctrlpvim/ctrlp.vim'
  " Plug 'austintaylor/vim-commaobject' " a,
  Plug 'tpope/vim-fugitive'
  Plug 'terryma/vim-smooth-scroll'
  Plug 'machakann/vim-highlightedyank'
  Plug 'haya14busa/incsearch.vim'
  Plug 'tpope/vim-repeat'
  Plug 'PotatoesMaster/i3-vim-syntax'
  " Plug 'vim-utils/vim-space' " a<space>
  Plug 'tpope/vim-vinegar'
  Plug 'JamesLinus/vim-angry' " a,
  " Plug 'jeetsukumaran/vim-pythonsense' " af ac
  Plug 'kana/vim-textobj-user'
  Plug 'bps/vim-textobj-python' " af ac
  " Plug 'libclang-vim/vim-textobj-clang' " a;
  Plug 'Julian/vim-textobj-brace' " aj
  " Plug 'Chun-Yang/vim-textobj-chunk' " ac
  " Plug 'glts/vim-textobj-comment' " ac
  Plug 'kana/vim-textobj-entire' " ae
  " Plug 'sgur/vim-textobj-parameter' " a,
  Plug 'saaguero/vim-textobj-pastedtext' " gb
  Plug 'Julian/vim-textobj-variable-segment' " av
  Plug 'idbrii/textobj-word-column.vim' " ac




  " colors
  " Plug 'trusktr/seti.vim'
  " Plug 'wesgibbs/vim-irblack'
  Plug 'MRAAGH/vim-distinguished'
  " Plug 'nanotech/jellybeans.vim'
  Plug 'MRAAGH/twilight256.vim'


  call plug#end()

endif




" choose your century
set nocompatible

" allow backspacing over everything in insert mode
" nope
" set backspace=indent,eol,start
set backspace=indent,eol

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  set undofile		" keep an undo file (undo changes after closing)
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
" set incsearch		" do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" inoremap <C-U> <C-G>u<C-U>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" " Convenient command to see the difference between the current buffer and the
" " file it was loaded from, thus the changes you made.
" " Only define it when not defined already.
" if !exists(":DiffOrig")
"   command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
" 		  \ | wincmd p | diffthis
" endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif


" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
packadd matchit









" CUSTOMIZE

" customize ctrlp
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn))$'
"let g:ctrlp_custom_ignore = 'node_modules\|git'

" color scheme
colorscheme twilight256
autocmd FileType javascript colorscheme distinguished

" go to next marker
" nnoremap <Space><Space> /<++><CR>"_c4l

" code snippet in md files
autocmd FileType markdown nnoremap <Space>s a```<CR>```<Esc>k$a

" nmap <C-N><C-N> :set nu!<CR>:set rnu!<CR>

" nnoremap <C-N> :NERDTreeToggle<CR>

" toggle numbers
nnoremap <silent> <C-N> :set nu! relativenumber!<CR>
set number
set relativenumber

" Hex read
nnoremap <silent> <F6> :%!xxd<CR> :set filetype=xxd<CR> :set noendofline<CR>

" Hex write
nnoremap <silent> <F7> :%!xxd -r<CR> :set binary<CR> :set filetype=<CR> :set noendofline<CR>
" ;set display=uhex<CR>

:set scrolloff=8

" tabs to spaces
":se et
":se ts=4
:set expandtab
:set shiftwidth=2
:set softtabstop=2

" swap colon and semicolon
nnoremap ; :
nnoremap : ;

" pane switching
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

" tabs
nnoremap <C-Y> gT
nnoremap <C-O> gt

" scrolling
" nnoremap <C-U> <C-D>
" nnoremap <C-I> <C-U>
noremap <silent> <C-I> :call smooth_scroll#up(&scroll, 4, 2)<CR>
noremap <silent> <C-U> :call smooth_scroll#down(&scroll, 4, 2)<CR>
" noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
" noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>


" swap ^ and 0
nnoremap ^ 0
nnoremap 0 ^

" position of new splits
set splitbelow
set splitright

" case insensitive
set ignorecase

" reload files
set autoread

" better Y
nmap Y y$

" better S
nnoremap S :!bash<CR>

" foldmethod
set foldmethod=indent
set nofoldenable
set foldlevel=2

" clear search results with esc
" nnoremap <ESC> :noh<CR>
" actually, enter
" nnoremap <CR> :noh<CR>
" actually, nothing ... there's a good plugin for that

" prevent automatic comment
" can not be set inside vimrc because plugins override this setting
" therefore, set it just before opening the new line
nnoremap <silent> o :set formatoptions-=o<CR>o
nnoremap <silent> O :set formatoptions-=o<CR>O

" configuration of youcompleteme
let g:ycm_confirm_extra_conf = 0

" configuration for highlightedyank
if !exists('##TextYankPost')
  map y <Plug>(highlightedyank)
endif

let g:highlightedyank_highlight_duration = 200
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" configuration for incsearch
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" ctrl s for saving
nnoremap <C-S> :w<CR>

" ctrl d for quit
nnoremap <C-D> :q<CR>

" swap visual and logical
nnoremap gj j
nnoremap j gj
nnoremap gk k
nnoremap k gk

" paste from specific register
nnoremap "P "0P
nnoremap "p "0p

nnoremap qq 0qq
vnoremap q :norm@q<CR>

let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

set cursorline
set cursorcolumn

" angry
let g:angry_disable_maps = 1
vmap <silent> a, <Plug>AngryOuterPrefix
omap <silent> a, <Plug>AngryOuterPrefix
vmap <silent> i, <Plug>AngryInnerPrefix
omap <silent> i, <Plug>AngryInnerPrefix

" pythonsense
" let g:is_pythonsense_suppress_motion_keymaps = 1
" let g:is_pythonsense_suppress_location_keymaps = 1
