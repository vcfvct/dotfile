"use single quote as leader key, comma is useful for previous char search in line
let mapleader = "'"
autocmd BufRead,BufNewFile *.ts,*.json,*.js,*.html,*.dart,Jenkinsfile,*.jsx,*.tsx setlocal number
syntax on
set hlsearch
hi Search ctermbg=LightYellow
hi Search ctermfg=Red

set autoindent                          " Good auto indent
set smartindent                         " Makes indenting smart
set expandtab                           " Converts tabs to spaces
set shiftwidth=2                        " Change the number of space characters inserted for indentation
set softtabstop=2                       " Insert 2 spaces for a tab
set backspace=indent,eol,start
set incsearch
set cursorline                          " Enable highlighting of the current line
set nobackup                            " This is recommended by coc
set nowritebackup                       " This is recommended by coc
set noswapfile
set noshowmode                          " mode is shown in status line(lightline)

" https://github.com/neovim/neovim/issues/11699
set t_BE=
" show line number
"set number

" Ignore case on searches and 'smart' when use upper case it will highlight only
" upper(not vise-versa)
set ignorecase
set smartcase

set scrolloff=5
set laststatus=2

" spell check only for txt and md file. use `set spell` to enable on the fly
" autocmd BufRead *.txt,*.md, setlocal spell
" set spelllang=en
" set spellfile=~/Documents/backups/vi-spell-file.add
" set spellcapcheck=

" map jj to esc for insert mode and keep cursor position
" inoremap jj <ESC>`^

" in visual mode, use Ctrl+c to copy selected text to system clipboard
" On Windows & MacOS there is no difference between `+`(clipboard) and `*`(Primary), since these systems only have a single clipboard, and both registers refer to the same thing (it doesn't matter which one you use).
" vmap <C-c> "+y
" this changes the default vim register to the `+` register, which linked to the system clipboard
set clipboard=unnamedplus
" use black hole register `_` so we the delete/change does not interfere the clipboard.
vnoremap d "_d
nnoremap d "_d
nnoremap x "_x
nnoremap c "_c
" Bind p in visual/select mode to paste without overriding the current register
xnoremap p pgvy

" file explorer
map <C-n> :CocCommand explorer<CR>
nmap <leader>e :CocCommand explorer<CR>

" hide directory banner in file explore
let g:netrw_banner=0
" The tree list view
let g:netrw_liststyle = 3

" map ctrl + m to toggle comment in normal/visual mode
nmap <C-c> <leader>c<Space>
vmap <C-c> <leader>c<Space>
" vmap <C-C> <leader>cs

nmap <leader>rp :%s/
" nmap F :%s/

" add extra space
let NERDSpaceDelims=1

" map ctrl + p to find file
map <C-p> :Files<cr>
map <C-g> :Rg 

map <C-t> :FZF<cr>
" preview content on the right side when search
" command! -bang -nargs=* Rg
  " \ call fzf#vim#grep(
  " \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  " \   fzf#vim#with_preview(), <bang>0)
" command! -bang -nargs=* Ag
  " \ call fzf#vim#grep(
  " \   'ag --column --numbers --noheading --color --smart-case '.shellescape(<q-args>), 1,
  " \   fzf#vim#with_preview(), <bang>0)



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
      let name = parent . '/' . strpart(s, 0, 8)
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
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdcommenter'
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'itchyny/lightline.vim'
Plug 'Yggdroot/indentLine'
" Plug 'morhetz/gruvbox'
Plug 'voldikss/vim-floaterm'
Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'rebelot/kanagawa.nvim'
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'github/copilot.vim'
Plug 'OmniSharp/omnisharp-vim'
call plug#end()

colors snazzy 
" colorscheme kanagawa

" does not work with ts optional chaining
" let g:polyglot_disabled = ['typescript', 'ts']
let g:indentLine_fileTypeExclude = ['markdown']
" use s to search 2 char in esaymotion
nmap s <Plug>(easymotion-s2)

source ~/.coc.vim

" Custom syntax highlighting
au BufNewFile,BufRead Jenkinsfile setf groovy
au BufNewFile,BufRead *.ejs setf html
au BufNewFile,BufRead Gearsfile,Bogiefile setf yaml
" jsonc: https://code.visualstudio.com/docs/languages/json#_json-with-comments
autocmd FileType json syntax match Comment +\/\/.\+$+
autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>

" map recording to 'Q' so it is less annoying
nnoremap Q q
nnoremap q <Nop>
" use 'space q' to quite/save/all
nnoremap <leader>qq :q!<cr>
nnoremap <leader>qw :wq<cr>
nnoremap <leader>qa :qall!<cr>

nnoremap <space> :
:map <F4> @:

" resize pane
nmap <A-UP> :res +2<CR>
nmap <A-Down> :res -2<CR>
nmap <Left> :vertical res +2<CR>
nmap <Right> :vertical res -2<CR>

""" window/pane management
tnoremap <C-q> <C-\><C-n>
"" navigation
tnoremap <C-h> <C-\><C-n><C-w>h
" tnoremap <leader>jj <C-\><C-n><C-w>j
" tnoremap <leader>kk <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
noremap <C-h> <C-w>h
noremap <leader>jj <C-w>j
noremap <leader>kk <C-w>k
noremap <C-l> <C-w>l
inoremap <C-h> <Esc><C-w>h
" inoremap <leader>jj <Esc><C-w>j
" inoremap <leader>kk <Esc><C-w>k
inoremap <C-l> <Esc><C-w>l

""" float term bindings
nnoremap   <silent>   <F7>    :FloatermNew<CR>
tnoremap   <silent>   <F7>    <C-\><C-n>:FloatermNew<CR>
nnoremap   <silent>   <F8>    :FloatermPrev<CR>
tnoremap   <silent>   <F8>    <C-\><C-n>:FloatermPrev<CR>
nnoremap   <silent>   <F9>    :FloatermNext<CR>
tnoremap   <silent>   <F9>    <C-\><C-n>:FloatermNext<CR>
nnoremap   <silent>   <F12>   :FloatermToggle<CR>
tnoremap   <silent>   <F12>   <C-\><C-n>:FloatermToggle<CR>

let g:floaterm_width  = 0.8
let g:floaterm_height = 0.8

if has("win32")
  let g:floaterm_shell="pwsh.exe -NoLogo"
  " this would make vim split term work but will break floaterm"
  " set shell=pwsh.exe
endif

""" fzf open in float
let g:fzf_layout = { 'window': {
    \ 'width': 0.9,
    \ 'height': 0.7,
    \ 'highlight': 'Comment',
    \ 'rounded': v:false } }

" ctrl-b in visual model to do base64 decode, remove '-d' to do encode
vnoremap <leader>bd :!base64 -d
" format xml with python3
com! FormatXML :%!python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"
com! FormatJSON %!python3 -m json.tool
