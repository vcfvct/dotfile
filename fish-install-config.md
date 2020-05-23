## install fish shell
Either do `brew install fish` or download the installer from `https://fishshell.com/`.

After installation, type `fish` in terminal to enter the shell. 

## install package manager 
Both fihserman and oh-my-fish are good.
* fisherman: https://github.com/jorgebucaran/fisher
  * `curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish`
  * the package list file is in `~/.config/fish/fishfile`, run `fisher` to install all packages listed.
* omf: https://github.com/oh-my-fish/oh-my-fish

### add packages(OR from the `fishfile`)
* `z`, which is for smart jump: `fisher add jethrokuan/z`
* `nvm`, node version manager: `fisher add jorgebucaran/fish-nvm`. 
* `bd`, smart dir back `fisher add 0rax/fish-bd`
* Theme that shows git information/context 
  * This requires [powerline font](https://github.com/powerline/fonts). check out the repo and run `install.sh`
    * another option is use the nerd font to get more fancy.  
      * `brew tap caskroom/fonts`
      * `brew cask install font-meslo-nerd-font`
      * set -U theme_nerd_fonts yes
  * [Bob-the-fish theme](https://github.com/oh-my-fish/theme-bobthefish/): `fisher add oh-my-fish/theme-bobthefish`.
  * [Another Famous 'agnoster' theme](https://github.com/oh-my-fish/theme-agnoster): `fisher add oh-my-fish/theme-agnoster`.
* More packages can be found in this [awesome-fish repo](https://github.com/jorgebucaran/awesome-fish)

## proxy setup
* run below command to set the encoded password on ENV. 
  > set -xU pw (echo -n (security find-generic-password -wa (whoami)) | base64) 
* run below commands to set proxy on ENV
  ```
  set -xU http_proxy http://$USER:(echo $pw | base64 --decode)@proxy.YouCompany.com:8099
  set -xU https_proxy $http_proxy
  set -xU no_proxy localhost,127.0.0.1
  set -xU HTTP_PROXY $http_proxy
  set -xU HTTPS_PROXY $http_proxy
  ```
* use the custom function mentioned below to set pw when renew password or on/off proxy. 

## config fish
* Fish config file is under `~/.config/fish/config.fish`, [Example](.config/fish/config.fish)
* custom function can be created under `~/.config/fish/functions/`. [Example](.config/fish/functions), where functions like setpw/setproxy/unsetproxy can be used when password change or activate/deactivate proxy.

## set fish as default shell
* add fish path(for example `/usr/local/bin/fish`) to the `/etc/shells` file.
* run `chsh -s /usr/local/bin/fish`

## set up zsh
* `sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
* `git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions`
* `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting`
* `git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm`
* `git clone https://github.com/lukechilds/zsh-better-npm-completion ~/.oh-my-zsh/custom/plugins/zsh-better-npm-completion`

## comparison with `zsh`
The advantage of `zsh` is its `POSIX` compatibility. However for a user shell in personal computer, I still think that is not that important as long as we are not writing scripts for other user/application. `Fish's` out of box configure is super. Other than the [**Long** configuration](.zshrc) of `zsh`, there are still some feature gap there. 
  * The `zsh-autosuggestion` is not context-aware meaning that it cannot give relevant information based on what directory you are, which is quite handy. It is tracked by [this zsh github issue](https://github.com/zsh-users/zsh-autosuggestions/issues/42)
  * both shells are able to parse the `man` pages and give suggestions, however the `TAB` completion in fish on this is much more user friendly than the `zsh` one. Also fish will parse the `man` page exhaustively that all long or shorthand options are included. For example `tmux a` then tab, fish will give many options like `a/at/attach/attach-session`, while `zsh` only complete directly with `attach`.
  * ~~It is not easy to get the `vi mode` indicator showing up at the beginning of the `prompt` in `zsh` comparing to what's in fish.~~ (themes like `powerlevel10k`/pure have this)
  * the async loading is tricky causing loading heavy plugins like `nvm` is really slow(>1s).
  * the alias expansion is all or nothing which is not super convenient. things like git/nvim are good but aliases like the `z` will be expanded to an odd full command.
  * the `bindkey` is tricky that it has to work with `zle` and not easy to bind to things like vi normal mode.
The part I miss in zsh for now is the transient prompt in `powerlevel10k` which makes the terminal screen looks cleaner.
