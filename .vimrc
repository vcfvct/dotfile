"use single quote as leader key, comma is useful for previous char search in line
let mapleader = "'"
autocmd BufRead,BufNewFile *.ts,*.json,*.js,*.html,Jenkinsfile,Gearsfile,Bogiefile setlocal number
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


" map jj to esa for insert mode and keep cursor position
inoremap jj <ESC>`^

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
let g:NERDTreeChDirMode = 2
nmap <leader>ff :NERDTreeFind<cr>

" make large tree render faster with color
" let g:NERDTreeHighlightCursorline = 0

" map ctrl + m to toggle comment in normal/visual mode
nmap <C-m> <leader>c<Space>
vmap <C-m> <leader>c<Space>
vmap <C-M> <leader>cs

nmap <leader>rp :%s/
" nmap F :%s/

" add extra space
let NERDSpaceDelims=1

" map ctrl + p to find file
map <C-p> :Files<cr>
map <C-g> :Rg 
com! FormatJSON %!python3 -m json.tool

map <C-t> :FZF<cr>
" preview content on the right side when search
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=* Ag
  \ call fzf#vim#grep(
  \   'ag --column --numbers --noheading --color --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)



" save using <A-s> in every mode
" when in operator-pending or insert, takes you to normal mode
nnoremap <A-s> :w<Cr>
vnoremap <A-s> <C-c>:write<Cr>
inoremap <A-s> <Esc>:w<Cr>
onoremap <A-s> <Esc>:write<Cr>
" use shift-enter to add trailing comma
inoremap <S-CR> <ESC>A;<ESC>
vnoremap <S-CR> <ESC>A;<ESC>
nnoremap <S-CR> A;<ESC>

" move line up/down
nmap m :m -2<CR>
nmap M :m +1<CR>
vmap m :m -2<CR>
vmap M :m +1<CR>

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
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdcommenter'
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'itchyny/lightline.vim'
Plug 'kkoomen/vim-doge'
Plug 'Yggdroot/indentLine'
Plug 'easymotion/vim-easymotion'
Plug 'Valloric/MatchTagAlways'
Plug 'morhetz/gruvbox'
call plug#end()

colorscheme gruvbox
" color cobalt2 

" does not work with ts optional chaining
" let g:polyglot_disabled = ['typescript', 'ts']
let g:indentLine_fileTypeExclude = ['nerdtree', 'markdown']
" use s to search 2 char in esaymotion
nmap s <Plug>(easymotion-s2)

source ~/.coc.vim

" Custom syntax highlighting
au BufNewFile,BufRead Jenkinsfile setf groovy 
au BufNewFile,BufRead *.ejs setf html
au BufNewFile,BufRead Gearsfile,Bogiefile setf yaml
" jsonc: https://code.visualstudio.com/docs/languages/json#_json-with-comments
autocmd FileType json syntax match Comment +\/\/.\+$+

" map recording to 'Q' so it is less annoying 
nnoremap Q q
nnoremap q <Nop>
" use 'space q' to quite/save/all
nnoremap <leader>qq :q!<cr>
nnoremap <leader>qw :wq<cr>
nnoremap <leader>qa :qall!<cr>

nnoremap <space> :


