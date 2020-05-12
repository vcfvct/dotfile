
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" neovim Quickly create a new terminal in a vertical split
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

" live preview substitution.
set inccommand=nosplit

if has('wsl')
  augroup Yank
    autocmd!
    autocmd TextYankPost * :call system('clip.exe ',@")
  augroup END
endif
