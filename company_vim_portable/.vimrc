" Portable Vim configuration for company gvim 7.4.x.
" Focus: personal editing habits + SV/UVM workflow, offline plugins only.

set nocompatible
set encoding=utf-8
silent! set langmenu=zh_CN.UTF-8
silent! language messages zh_CN.UTF-8

" Use the current server habit.
let mapleader="'"

" Load local offline plugins.  Keep this before plugin settings.
if !has('job')
    let g:gutentags_dont_load = 1
endif
if filereadable(expand('~/.vim/autoload/pathogen.vim'))
    execute pathogen#infect('bundle/{}', 'plugged/{}')
endif

" Basic editing.
set history=400
set mouse=a
set wrap
set linebreak
set textwidth=80
set number
set ruler
set autoread
set autochdir
set bsdir=buffer
set backspace=indent,eol,start
set wildmenu
set showcmd
set showmatch
set matchtime=5
set ignorecase
set smartcase
set incsearch
set hlsearch
set laststatus=2
set cmdheight=1
set nobackup
set writebackup
set noswapfile
set undolevels=500
set fileformats=unix,dos
set fileencodings=utf-8,gbk,big5,euc-jp,gb2312

" Indent defaults.  SV/UVM uses 3 spaces below.
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smarttab
set expandtab
set autoindent

" Fold defaults.
set foldcolumn=2
set foldmethod=syntax
set foldlevel=100

" Status line.
function! PortableGetPWD()
    return getcwd()
endfunction
set statusline=
set statusline+=%1*%-3.3n%0*
set statusline+=\ %f
set statusline+=\ %h%1*%m%r%w%0*
set statusline+=[
set statusline+=%{strlen(&ft)?&ft:'none'},
set statusline+=%{&fileencoding},
set statusline+=%{&fileformat}]
set statusline+=\ [PWD]\ %{PortableGetPWD()}
set statusline+=\ %=
set statusline+=0x%-8B
set statusline+=%-14.(%l,%c%V%)\ %<%P

" GUI settings.
if has('gui_running')
    silent! set guioptions=mcr
    silent! set guioptions-=T
    silent! set guioptions-=r
    silent! set guioptions-=L
    if exists('&guifont')
        set guifont=Monospace\ 18
    endif
    set cursorline
    set cursorcolumn
    set background=dark
    silent! colorscheme desert
else
    silent! colorscheme molokai
endif

" Filetype and syntax.
filetype plugin indent on
syntax enable
syntax on

augroup PortableFiletype
    autocmd!
    autocmd FileType make setlocal noexpandtab
    autocmd FileType verilog,systemverilog setlocal tabstop=3 softtabstop=3 shiftwidth=3 expandtab
    autocmd BufRead,BufNewFile *.sv,*.svh,*.svi set filetype=systemverilog
    autocmd BufRead,BufNewFile *.v set filetype=verilog
    autocmd BufRead,BufNewFile *.rdl set filetype=systemrdl
augroup END

" Personal key habits.
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <S-j> <C-w>+
nnoremap <S-k> <C-w>-
nnoremap <leader>ev :sp ~/.vimrc<CR>
nnoremap <leader>sv :source ~/.vimrc<CR>
nnoremap <C-s> :w!<CR>
nnoremap <C-w> :w<CR>
nnoremap <C-q> :wq<CR>
nnoremap <C-b> :bd<CR>
nnoremap J 3j
nnoremap K 3k
nnoremap <silent> H 0
nnoremap <silent> L $
map vh :Vexplore<CR>
map vl :Vexplore!<CR>

augroup CustomKeyMappings
    autocmd!
    autocmd VimEnter * nnoremap <silent> H 0
    autocmd VimEnter * nnoremap <silent> L $
augroup END

if has('clipboard')
    vnoremap <Leader>y "+y
    nnoremap <Leader>p "+p
endif

" Project tags and ctags.
let s:ctags_bin = ''
if executable(expand('~/bin/exctags'))
    let s:ctags_bin = expand('~/bin/exctags')
elseif executable('exctags')
    let s:ctags_bin = 'exctags'
elseif executable('ctags')
    let s:ctags_bin = 'ctags'
endif
if s:ctags_bin != ''
    let g:tagbar_ctags_bin = s:ctags_bin
    let Tlist_Ctags_Cmd = s:ctags_bin
    let g:gutentags_ctags_executable = s:ctags_bin
endif

set tags=./tags,./.tags,tags,../tags,../../tags

nnoremap <leader>tt :tnext<CR>
nnoremap <leader>tp :tprevious<CR>
nnoremap <leader>tl :tselect <C-R><C-W><CR>

" Gutentags: enable only on Vim with job support.
if has('job')
    let g:gutentags_project_root = ['.root', '.svn', '.git', '.project']
    let g:gutentags_ctags_tagfile = '.tags'
    let g:gutentags_cache_dir = expand('~/.cache/tags')
    if !isdirectory(g:gutentags_cache_dir)
        silent! call mkdir(g:gutentags_cache_dir, 'p')
    endif
    let g:gutentags_ctags_extra_args = ['-R', '--languages=systemverilog', '--extra=+q', '--fields=+i']
endif

" Completion.  Vim 7.4.629 does not have completeopt noselect/noinsert.
if has('patch-7.4.775') || v:version > 704
    set completeopt=menuone,noselect,noinsert
    let g:mucomplete#enable_auto_at_startup = 1
    let g:mucomplete#completion_delay = 120
    let g:mucomplete#minimum_prefix_length = 2
else
    set completeopt=menuone,menu
    let g:mucomplete#enable_auto_at_startup = 0
endif
let g:mucomplete#no_mappings = 1
inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

set complete=.,w,i,b,u,d,k
set dictionary=~/.vim/words/uvm_kwords,/usr/share/dict/words
if exists('$VCS_HOME') && filereadable(expand('$VCS_HOME/gui/tb/qdbg_sv.ini'))
    execute 'set dictionary+=' . fnameescape(expand('$VCS_HOME/gui/tb/qdbg_sv.ini'))
endif
set isfname+={,}
set isfname-=,

" SV/UVM helper plugins.
let g:verilog_syntax_fold_lst = "function,task"
let g:SuperTabDefaultCompletionType = 'context'
let g:EasyMotion_smartcase = 1
let g:localrc_filename = '.uvmrc'

runtime! macros/matchit.vim
if exists('loaded_matchit')
    let b:match_ignorecase = 0
    let b:match_words =
        \ '<begin>:<end>,' .
        \ '<if>:<else>,' .
        \ '<module>:<endmodule>,' .
        \ '<class>:<endclass>,' .
        \ '<program>:<endprogram>,' .
        \ '<clocking>:<endclocking>,' .
        \ '<property>:<endproperty>,' .
        \ '<sequence>:<endsequence>,' .
        \ '<package>:<endpackage>,' .
        \ '<covergroup>:<endgroup>,' .
        \ '<generate>:<endgenerate>,' .
        \ '<interface>:<endinterface>,' .
        \ '<function>:<endfunction>,' .
        \ '<task>:<endtask>,' .
        \ '<case>|<casex>|<casez>:<endcase>,' .
        \ '<fork>:<join>|<join_any>|<join_none>,' .
        \ '`ifdef>:`else>:`endif>,'
endif

" Tools and navigation.
nnoremap <C-n> :NERDTreeToggle<CR>

function! s:ToggleTagWindow()
    if exists(':TagbarToggle') == 2
        TagbarToggle
    elseif exists(':TlistToggle') == 2
        TlistToggle
    else
        echo "Tagbar/Taglist plugin is not available"
    endif
endfunction
nnoremap <silent> <F4> :call <SID>ToggleTagWindow()<CR>
nnoremap <silent> <F8> :call <SID>ToggleTagWindow()<CR>

nnoremap <leader>fmt :VerilogErrorFormat vcs 0<CR>
nnoremap cn :cnext<CR>
nnoremap cp :cprevious<CR>
nnoremap cl :clist<CR>
nnoremap cw :cwindow 10<CR>

nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
map <Leader><Leader>h <Plug>(easymotion-linebackward)
map <Leader><Leader>j <Plug>(easymotion-j)
map <Leader><Leader>k <Plug>(easymotion-k)
map <Leader><Leader>l <Plug>(easymotion-lineforward)
map <Leader><Leader>. <Plug>(easymotion-repeat)

" Markdown table alignment helper from the old DV vimrc.
inoremap <silent> <Bar> <Bar><Esc>:call <SID>align_markdown_table()<CR>a
function! s:align_markdown_table()
    let l:pattern = '^\s*|\s.*\s|\s*$'
    if exists(':Tabularize') && getline('.') =~# '^\s*|' &&
        \ (getline(line('.') - 1) =~# l:pattern || getline(line('.') + 1) =~# l:pattern)
        let l:column = strlen(substitute(getline('.')[0:col('.')], '[^|]', '', 'g'))
        let l:position = strlen(matchstr(getline('.')[0:col('.')], '.*|\s*\zs.*'))
        Tabularize/|/l1
        normal! 0
        call search(repeat('[^|]*|', l:column) . '\s\{-\}' . repeat('.', l:position), 'ce', line('.'))
    endif
endfunction

" Header/template helpers.
let $project_name = $PRJ_NAME
if $project_name == ''
    let $project_name = fnamemodify(getcwd(), ':t')
endif

nnoremap <F5> :call <SID>DefineDet()<CR>'s
function! s:AddDefine()
    let l:classname = expand('%:r')
    let l:extension = expand('%:e')
    if l:extension =~# '^\%(cpp\|h\|c\)$'
        call append(0, '#ifndef __' . toupper(l:classname . '_' . l:extension) . '__')
        call append(1, '#define __' . toupper(l:classname . '_' . l:extension) . '__')
        call append(line('$'), '#endif')
    else
        call append(0, '`ifndef __' . toupper(l:classname . '_' . l:extension) . '__')
        call append(1, '`define __' . toupper(l:classname . '_' . l:extension) . '__')
        call append(2, '')
        call append(3, 'class ' . l:classname . ' extends ;')
        call append(4, '   `uvm_component_utils(' . l:classname . ')')
        call append(5, '')
        call append(6, '   function new(string name = "' . l:classname . '", uvm_component parent);')
        call append(7, '      super.new(name, parent);')
        call append(8, '   endfunction')
        call append(9, '')
        call append(10, 'endclass')
        call append(11, '')
        call append(12, '`endif')
    endif
endfunction
function! s:DefineDet()
    for l:num in range(1, 8)
        if getline(l:num) =~# '^`ifndef.*$'
            return
        endif
    endfor
    call <SID>AddDefine()
endfunction

nnoremap <F6> :call <SID>TitleDet()<CR>'s
function! s:AddTitle()
    call append(0, '// ***********************************************************************')
    call append(1, '// PROJECT        : ' . $project_name)
    call append(2, '// FILENAME       : ' . expand('%:t'))
    call append(3, '// Author         : ' . toupper($USER))
    call append(4, '// LAST MODIFIED  : ' . strftime('%Y-%m-%d %H:%M'))
    call append(5, '// ***********************************************************************')
    call append(6, '// DESCRIPTION    :')
    call append(7, '// ***********************************************************************')
endfunction
function! s:UpdateTitle()
    normal! m'
    silent! execute '/LAST MODIFIED/s@:.*$@\=strftime(": %Y-%m-%d %H:%M")@'
    normal! ''
endfunction
function! s:TitleDet()
    for l:num in range(1, 10)
        if getline(l:num) =~# 'LAST MODIFIED'
            call <SID>UpdateTitle()
            return
        endif
    endfor
    call <SID>AddTitle()
endfunction

" Abbreviations.
iabbrev //b //----------------------------------------------------------
iabbrev #b ############################################################
iabbrev *b #**********************************************************
iabbrev dp debug point
iabbrev /b ///<
