## install nvim
https://github.com/neovim/neovim/wiki/Installing-Neovim


### Ubuntu
> sudo add-apt-repository ppa:neovim-ppa/unstable

###  Windows
* when get `[coc.nvim] build/index.js not found, please install dependecies and compile coc.nvim by yarn install`, need to go to `~\AppData\Local\nvim-data\plugged\coc.nvim` and use npm/yarn to install node dependencies for coc.
* when vim plug failed to update, need to add `set shellcmdflag=-c` in addition to the `set shell=pwsh.exe` according to [this github issue](https://github.com/neovim/neovim/issues/13893#issuecomment-774631930).

### ChromeOS
* the version 0.9.1 cannot be compiled/installed via `brew` any more throwing some gcc error. Also neovim dropped `deb` distribution after 0.9.0. The alternative is to manually download the `appimage` or `linux64` package from the release page.

```sh
curl -L -o nvim https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod nvim
sudo mv nvim /usr/local/bin/
```

### Telescope
* use `<C-c>` to close the modal window instead of hitting esc or `ctrl-[` twice.
