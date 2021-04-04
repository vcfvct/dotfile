
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" neovim Quickly create a new terminal in a vertical split
" tnoremap <leader>vs <C-\><C-n>:vsp<CR><C-w><C-w>:term<CR>i
noremap <leader>vs :vsp<CR><C-w><C-w>:term<CR>i
noremap <C-s> :vsp<CR><C-w><C-w>:term<CR>i
tnoremap <C-s> <C-\><C-n>:vsp<CR><C-w><C-w>:term<CR>i
inoremap <C-s> <Esc>:vsp<CR><C-w><C-w>:term<CR>i

" Quickly create a new terminal in a horizontal split
tnoremap <C-_> <C-\><C-n>:sp<CR><C-w><C-w>:term<CR>i
noremap  <C-_> :sp<CR><C-w><C-w>:term<CR>i
inoremap <C-_> <Esc>:sp<CR><C-w><C-w>:term<CR>i
" tnoremap <leader>sp  <C-\><C-n>:sp<CR><C-w><C-w>:term<CR>i
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

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "json", "javascript", "java", "lua", "typescript", "bash", "html", "css", "yaml" },
  highlight = { enable = true, },
}
EOF
