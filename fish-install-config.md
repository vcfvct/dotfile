## install fish shell
Either do `brew install fish` or download the installer from `https://fishshell.com/`.

After installation, type `fish` in terminal to enter the shell. 

## install package manager 
Both fihserman and oh-my-fish are good.
* fisherman: https://github.com/jorgebucaran/fisher
  * `curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish`
* omf: https://github.com/oh-my-fish/oh-my-fish

### add packages 
* `z`, which is for smart jump: `fisher add jethrokuan/z`
* `nvm`, node version manager: `fisher add jorgebucaran/fish-nvm`. 
* `fzf`, for fuzzy finding: `fisher add jethrokuan/fzf`, https://github.com/jethrokuan/fzf.
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
* Fish config file is under `~/.config/fish/config.fish`, [Example](https://www.github.com/vcfvct/devConfig/blob/master/.config/fish/config.fish)
* custom function can be created under `~/.config/fish/functions/`. [Example](https://www.github.com/vcfvct/devConfig/tree/master/.config/fish/functions), where functions like setpw/setproxy/unsetproxy can be used when password change or activate/deactivate proxy.

## set fish as default shell
* add fish path(for example `/usr/local/bin/fish`) to the `/etc/shells` file.
* run `chsh -s /usr/local/bin/fish`

## comparison with `zsh`
The advantage of `zsh` is its `POSIX` compatibility. However for a user shell in personal computer, I still think that is not that important as long as we are not writing scripts for other user/application. `Fish's` out of box configure is super. Other than the [**Long** configuration](https://www.github.com/vcfvct/devConfig/blob/master/.zshrc) of `zsh`, there are still some feature gap there. 
  * The `zsh-autosuggestion` is not context-aware meaning that it cannot give relevant information based on what directory you are, which is quite handy. It is tracked by [this zsh github issue](https://github.com/zsh-users/zsh-autosuggestions/issues/42)
  * both shells are able to parse the `man` pages and give suggestions, however the `TAB` completion in fish on this is much more user friendly than the `zsh` one. Also fish will parse the `man` page exhaustively that all long or shorthand options are included. For example `tmux a` then tab, fish will give many options like `a/at/attach/attach-session`, while `zsh` only complete directly with `attach`.
  * It is not easy to get the `vi mode` indicator showing up at the beginning of the `prompt` in `zsh` comparing to what's in fish. 
