## Working dir
* use `:cd` or tcd/lcd to change current working dir so that fzf can conduct searches.
* in NerdTree, use `C` to open dir under cursor as root. use `cd` to change pwd to dir under cursor. more shortcuts [here](https://www.cheatography.com/stepk/cheat-sheets/vim-nerdtree/).
  * if a file is open , use `:NERDTreeFind` to switch pwd to current dir.

## Spelling
* `zg` to add word to custom spell file. `]s` and `[s` to navigate back/forth on spell error words.
* use `z=` to do spell correction on the current word.

## Misc
* use `%` to match brackets/parenthesis. What's more handy, in visual mode, `%` will select the hold matching block.
* As `7890` are mapped to the pane resize, 
  * for go to line, cannot use `nG` will go to line `n`, fall back to use `:n` for that. 
  * for go to beginning of the line, `0` will not work so use `^` instead
* use `:help index` to check what key is mapped to

## Fold
[This can be useful](https://www.linux.com/training-tutorials/vim-tips-folding-fun/) when dealing with long json files
* `zc/zo` to close/open the fold.
* `zM/zO` to close/open all the fold.
* `zj/zk` navigating to prev/next fold, `]z/[z` to move between start/end of a fold.
