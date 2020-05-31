function gll
    set -l selections (
      git ll --color=always |
        fzf --ansi --no-sort --height 100% \
            --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                       xargs -I@ sh -c 'git show --color=always @'"
      )
    if test -n $selections 
        set -l commit (echo "$selections" | cut -d' ' -f2)
        git show $commit
    end 
end

