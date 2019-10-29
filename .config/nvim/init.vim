set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

""" neovim window/pane management
tnoremap <C-q> <C-\><C-n> 
"" navication
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
inoremap <C-h> <Esc><C-w>h
inoremap <C-j> <Esc><C-w>j
inoremap <C-k> <Esc><C-w>k
inoremap <C-l> <Esc><C-w>l

" Quickly create a new terminal in a vertical split
tnoremap <C-b> <C-\><C-n>:vsp<CR><C-w><C-w>:term<CR>
noremap <C-b> :vsp<CR><C-w><C-w>:term<CR>
inoremap <C-b> <Esc>:vsp<CR><C-w><C-w>:term<CR>

" Quickly create a new terminal in a horizontal split
tnoremap <C-_> <C-\><C-n>:sp<CR><C-w><C-w>:term<CR>
noremap <C-_> :sp<CR><C-w><C-w>:term<CR>
inoremap <C-_> <Esc>:sp<CR><C-w><C-w>:term<CR>

" live preview substitution.
set inccommand=nosplit
