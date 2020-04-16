function gll
    set -l selections (
      git ll --color=always |
        fzf --ansi --no-sort --height 100% \
            --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                       xargs -I@ sh -c 'git show --color=always @'"
      )
    if test -z $selections 
        set -l commits (echo "$selections" | cut -d' ' -f2 | tr '\n' ' ')
        git show $commits
    end 
end

