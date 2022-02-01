## download
with `curl -L` which is --location so it would follow redirect(many github distro links has redirect).

## exa
* download latest dist from github 
* follow [stpes](https://the.exa.website/install/linux) to put man/executable/completion to corresponding locations

## rg
* download the .deb file and run `dpkg -i xxxx.deb`.

## fzf
* fzf should be installed first as nvim plug rely on it.
* `sudo apt install fzf` with a quite old version `0.20.0`, but works fine. Or just downlaod the [latest executable](https://github.com/junegunn/fzf/releases?page=1) and replace in `/usr/bin/`


## neovim
```bash
# add the repo
sudo add-apt-repository ppa:neovim-ppa/unstable

# update & install
sudo apt update
sudo apt install neovim
```
* vimplug
```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

## VcXsrv
* This should be install first otherwise the neovim start up will hang with the `set clipboard=unnamedplus`.

## alacritty
* Install [vc++ redistribution](https://docs.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist?view=msvc-170)
* grab the [executable](https://github.com/alacritty/alacritty/releases).
* The config file is under `%AppData%\alacritty\alacritty.yml`, where AppData is usually `C:\Users\<your_user_name>\AppData\Roaming`.

## bat
```bash 
curl -L https://github.com/sharkdp/bat/releases/download/v0.19.0/bat_0.19.0_amd64.deb --output bat.deb
sudo dpkg -i bat.deb

```
