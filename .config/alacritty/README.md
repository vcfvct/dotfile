## Themes

Each palette lives in `themes/*.toml` under `[colors.*]`. To switch themes,
change the single `[general] import` entry in `alacritty.toml`, for example:

```toml
[general]
import = ["themes/gruvbox.toml"]
```

The path is relative to `alacritty.toml`; the importing file takes precedence
if it defines the same color. Keep the palettes out of `[schemes.*]` (Alacritty
does not use that table), and don't retain color overrides in the main file.
With `live_config_reload = true`, saving the change reloads the colors.

use `xxd -psd` to get the hex dump of a give file or standard input.  This is very useful because escape sequences we set in Alacritty needs to be presented in hex codes.

example: `ctrl-a n` is `016e0a` where `01` is `ctrl-a`, `6e` is `n` and `0a` is `enter` key. So we put `\x01\x6e` for the `chars` part of the key_bindings.

from [here](https://arslan.io/2018/02/05/gpu-accelerated-terminal-alacritty/#make-alacritty-feel-like-iterm2)
