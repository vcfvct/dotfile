"use space as leader key
let mapleader = "\<Space>"
" set nu
color cobalt2 
syntax on
set hlsearch
hi Search ctermbg=LightYellow
hi Search ctermfg=Red

set autoindent
set smartindent
set expandtab
set shiftwidth=2
set softtabstop=2
set backspace=indent,eol,start
set incsearch

" show line number
"set number

" Ignore case on searches and 'smart' when use upper case it will highlight only
" upper(not vise-versa)
set ignorecase
set smartcase

set scrolloff=5
set laststatus=2

" spell check only for txt and md file. use `set spell` to enable on the fly
autocmd BufRead *.txt,*.md, setlocal spell
set spelllang=en
set spellfile=~/Documents/backups/vi-spell-file.add
set spellcapcheck=


" map jj to esa for insert mode
inoremap jj <ESC>

" in visual mode, use Ctrl+c to copy selected text to system clipboard 
" On Windows & MacOS there is no difference between `+`(clipboard) and `*`(Primary), since these systems only have a single clipboard, and both registers refer to the same thing (it doesn't matter which one you use).
vmap <C-c> "+y
" this changes the default vim register to the `+` register, which linked to the system clipboard
set clipboard=unnamedplus
" use black hole register `_` so we the delete does not interfere the clipboard.
vnoremap d "_d
nnoremap d "_d
nnoremap x "_x
" Bind p in visual/select mode to paste without overriding the current register
xnoremap p pgvy

map <C-n> :NERDTreeToggle
" hide directory banner in file explore 
let g:netrw_banner=0
" The tree list view
let g:netrw_liststyle = 3

if empty(argv())
    au VimEnter * NERDTree
endif
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.DS_Store$', '\~$', '\.git']
" let g:NERDTreeChDirMode = 2

" map ctrl + m to toggle comment in normal/visual mode
nmap <C-m> <leader>c<Space>
vmap <C-m> <leader>c<Space>
" add extra space
let NERDSpaceDelims=1

" map ctrl + p to find file
map <C-p> :GFiles<cr>
map <C-g> :Ag 
map <A-F> :Format<cr>

map <C-t> :FZF<cr>

" lightline
let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ 'active': {
  \   'left': [
  \     [ 'mode', 'paste' ],
  \     [ 'git', 'diagnostic', 'cocstatus', 'filename', 'method' ]
  \   ],
  \   'right':[
  \     [ 'filetype', 'fileencoding', 'lineinfo', 'percent' ],
  \     [ 'blame' ]
  \   ],
  \ },
  \ 'component_function': {
  \   'blame': 'LightlineGitBlame',
  \   'filename': 'LightLineFilename',
  \ }
\ }

function! LightlineGitBlame() abort
  let blame = get(b:, 'coc_git_blame', '')
  " return blame
  return winwidth(0) > 120 ? blame : ''
endfunction
" display full path in status bar, path name length limited.
function! LightLineFilename()
  let name = ""
  let subs = split(expand('%:p'), "/") 
  let i = 1
  for s in subs
    let parent = name
    if i == len(subs)
      let name = parent . '/' . s
    elseif i == 1
      let name = s
    else
      let name = parent . '/' . strpart(s, 0, 12)
    endif
    let i += 1
  endfor
  return name
endfunction


" H/L to switch  between tabs.
nnoremap H gT
nnoremap L gt

call plug#begin()
" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdcommenter'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'itchyny/lightline.vim'
call plug#end()

" Custom syntax highlighting
au BufNewFile,BufRead Jenkinsfile setf groovy
au BufNewFile,BufRead *.ejs setf html
au BufNewFile,BufRead Gearsfile,Bogiefile setf yaml
" jsonc: https://code.visualstudio.com/docs/languages/json#_json-with-comments
autocmd FileType json syntax match Comment +\/\/.\+$+

source ~/.coc.vim
" map recording to 'Q' so it is less annoying 
nnoremap Q q
nnoremap q <Nop>
" use 'space q' to quite/save/all
nnoremap <leader>qq :q!<cr>
nnoremap <leader>qw :wq<cr>
nnoremap <leader>qa :qall!<cr>

