set --local manifest $argv[1]
if not test -r "$manifest"
    echo "Missing fish plugin manifest: $manifest" >&2
    exit 1
end
if not functions -q fisher
    echo "Homebrew Fisher is not on the fish function path." >&2
    exit 1
end
set --local installed (fisher list)
while read --local plugin
    set plugin (string trim -- "$plugin")
    if test -z "$plugin"; or string match -q '#*' -- "$plugin"
        continue
    end
    # The old fish-nvm repository was renamed.
    if test "$plugin" = jorgebucaran/fish-nvm
        set plugin jorgebucaran/nvm.fish
    end
    if not contains -- "$plugin" $installed
        fisher install "$plugin"; or exit 1
    end
end < "$manifest"
set -Ux theme_nerd_fonts yes
set -Ux EDITOR nvim
