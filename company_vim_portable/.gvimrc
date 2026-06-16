" Portable gVim UI overrides.
if has('gui_running')
    silent! set guioptions+=m
    silent! set guioptions-=T
    silent! set guioptions-=r
    silent! set guioptions-=L
    if exists('&guifont')
        set guifont=Monospace\ 20
    endif
endif
