set nocompatible

syntax on

set number " line number

set relativenumber

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

"Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch
set hlsearch " highlight search result

" Unbind some useless/annoying default key bindings.
nmap Q <Nop>

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse+=a

set showcmd " Show (partial) command in status line.
set showmatch " Show matching brackets.
set autowrite " Automatically save before commands like :next and :make
set cursorline
set ruler
set tabstop=8
set ignorecase " ignore capital or low character
set smartcase " search capital will only match capital character
set autoindent " indent according to previous line
set ttyfast " faster redrawing
set lazyredraw " only redraw when necessary
set splitbelow " open new windows below the current window
set splitright " open new windows right of the current window
set report=0
set synmaxcol=200
set noswapfile " don't generate swap file
set undofile " can undo when next time open the file
set directory=~/.vim/.swp//
set undodir=~/.vim/.undo//
set listchars=tab:»■,trail:■ " show the trailing space
set list
filetype indent on

" change the default mapping and the default command to invoke CtrlP:
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
" When invoked without an explicit starting directory,
" CtrlP will set its local working directory according to this variable:
let g:ctrlp_working_path_mode = 'ra'
filetype plugin indent on
" Auto generate tags file on file write of *.c and *.h files
autocmd BufWritePost *.c,*.h silent! !ctags . &

let NERDTreeShowLineNumbers=1 " show line number
map  <F2> :NERDTreeToggle<CR>
let NERDTreeShowBookmarks=1
let g:NERDTreeShowHidden = 1 " show hidden files

