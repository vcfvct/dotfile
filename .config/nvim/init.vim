
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

""" neovim window/pane management
tnoremap <C-q> <C-\><C-n> 
"" navication
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <leader>jj <C-\><C-n><C-w>j
tnoremap <leader>kk <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
noremap <C-h> <C-w>h
noremap <leader>jj <C-w>j
noremap <leader>kk <C-w>k
noremap <C-l> <C-w>l
inoremap <C-h> <Esc><C-w>h
inoremap <leader>jj <Esc><C-w>j
inoremap <leader>kk <Esc><C-w>k
inoremap <C-l> <Esc><C-w>l

" Quickly create a new terminal in a vertical split
tnoremap <leader>vs <C-\><C-n>:vsp<CR><C-w><C-w>:term<CR>i
noremap <leader>vs :vsp<CR><C-w><C-w>:term<CR>i
" inoremap <leader>vs <Esc>:vsp<CR><C-w><C-w>:term<CR>

" Quickly create a new terminal in a horizontal split
tnoremap <C-_> <C-\><C-n>:sp<CR><C-w><C-w>:term<CR>i
noremap  <C-_> :sp<CR><C-w><C-w>:term<CR>i
" inoremap <C-_> <Esc>:sp<CR><C-w><C-w>:term<CR>
tnoremap <leader>sp  <C-\><C-n>:sp<CR><C-w><C-w>:term<CR>i
noremap  <leader>sp :sp<CR><C-w><C-w>:term<CR>i
" inoremap <leader>vs  <Esc>:sp<CR><C-w><C-w>:term<CR>
"
" resize pane 
nmap 6 :res +2<CR>
nmap 7 :res -2<CR>
nmap 8 :vertical res +2<CR>
nmap 9 :vertical res -2<CR>
 
" live preview substitution.
set inccommand=nosplit
