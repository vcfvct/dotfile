## install nvim
https://github.com/neovim/neovim/wiki/Installing-Neovim


### Ubuntu
> sudo add-apt-repository ppa:neovim-ppa/unstable

###  Windows
* when get `[coc.nvim] build/index.js not found, please install dependecies and compile coc.nvim by yarn install`, need to go to `~\AppData\Local\nvim-data\plugged\coc.nvim` and use npm/yarn to install node dependencies for coc.
* when vim plug failed to update, need to add `set shellcmdflag=-c` in addition to the `set shell=pwsh.exe` according to [this github issue](https://github.com/neovim/neovim/issues/13893#issuecomment-774631930).
