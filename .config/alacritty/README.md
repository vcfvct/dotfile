use `xxd -psd` to get the hex dump of a give file or standard input.  This is very useful because escape sequences we set in Alacritty needs to be presented in hex codes.

example: `ctrl-a n` is `016e0a` where `01` is `ctrl-a`, `6e` is `n` and `0a` is `enter` key. So we put `\x01\x6e` for the `chars` part of the key_bindings.

from [here](https://arslan.io/2018/02/05/gpu-accelerated-terminal-alacritty/#make-alacritty-feel-like-iterm2)
