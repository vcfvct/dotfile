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

## alacritty
* Install [vc++ redistribution](https://docs.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist?view=msvc-170)
* grab the [executable](https://github.com/alacritty/alacritty/releases).
* The config file is under `%AppData%\alacritty\alacritty.yml`, where AppData is usually `C:\Users\<your_user_name>\AppData\Roaming`.
    * in the `shell` section, put `program: wsl` so wsl is the default shell. And `"~"` as `args` so the starting directory is linux home.

## bat
* installation:
```bash
curl -L https://github.com/sharkdp/bat/releases/download/v0.19.0/bat_0.19.0_amd64.deb --output bat.deb
sudo dpkg -i bat.deb

```
* to pipe with specific language syntax with `-l` flag: `az functionapp list | bat -l json`


## vscode
* ctrl-w is conflict with vim, have to disable base on [this github comment](https://github.com/VSCodeVim/Vim/issues/2056#issuecomment-334899171)
```json
"vim.handleKeys": {
    "<C-w>": false
}
```

## tmux
* direct `sudo apt install tmux` should get quite up to date version(3.x).

## yarn
* `curl -o- -L https://yarnpkg.com/install.sh | bash`

## jwt
* this [jwt tool](https://github.com/mike-engel/jwt-cli) is useful for decoding jwt tokens.
  * command line: `jwt decode $JWT`
  * inside vim, visual mode select the line and enter *command* mode do `!jwt decode -`

## VcXsrv
* This should be install first otherwise the neovim start up will hang with the `set clipboard=unnamedplus`.
### WSL vim clipboard sharing
From [this gist](https://gist.github.com/necojackarc/02c3c81e1525bb5dc3561f378e921541).
#### 1. Set up VcXsrv Windows X Server

Download and install [VcXsrv Windows X Server](https://sourceforge.net/projects/vcxsrv/),
then run XLaunch with the following options:

* Multiple windows (default)
* Start no client (default)
* Extra settings
  * Clipboard (default)
    * Primary Selection (default)
  * Native opengl (default)
  * Disable access control

Basically, you just need to tick all of the extra options. Other than that, every setting is the default.
Click the [Save configuration] button and save the configuration in `C:\Users\<USER NAME>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup` in order to start `VcXsrv` when Windows starts.
Upon `finish`, check all the allow access at the windows firewall/network popup.

#### 2. Connect VxXsrv from Ubuntu on WSL2
Log in to Ubuntu on WSL2 and set the `DISPLAY` environment variable:

```bash
LOCAL_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
export DISPLAY=$LOCAL_IP:0
```

That's it! Enjoy your Vim life on Windows!

