function fish_user_key_bindings
    ### fzf ###
    bind \cr 'fzf_reverse_isearch'
    bind \cp 'fzf_find_edit'
    bind \co 'fzf_find_edit'
    if bind -M insert >/dev/null 2>/dev/null
        bind -M insert \cr 'fzf_reverse_isearch'
        bind -M insert \cp 'fzf_find_edit'
        bind -M insert \co 'fzf_find_edit'
    end
    ### fzf ###
end
