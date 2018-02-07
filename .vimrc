" CopyRight Diandian
" Version 0.1 for vim 8.0
""""""""""""""""""""""""""

"Install Plugins for vim
if filereadable(expand("~/.vimrc.bundles"))
	source ~/.vimrc.bundles
endif

" 文本格式与排版
set formatoptions=tcrqn "自动格式化"
set autoindent          "继承缩进方式，适合注释"
set smartindent         "为C提供缩进"
set cindent             "使用C缩进"
set expandtab           "使用空格代替tab"
set softtabstop=4
set shiftwidth=4
set fileformats=unix,dos
filetype plugin indent on

" 匹配搜索
set showmatch "括号匹配"
set scrolloff=10 "在顶部与底部时保持10行距离"
set incsearch   "边输入边匹配"
set hlsearch

" 显示
set laststatus=2 "显示状态栏"
set ruler       "显示当前位置"

set nu "显示行号"
"nnoremap <F2> :set number!<CR>
"colorscheme desert
colorscheme molokai 

syntax on
"nnoremap <F3> :exec exists('syntax_on')?'syn off':'syn on'<CR>

set colorcolumn=81
highlight ColorColumn ctermbg=6
"highlight Functions
syn match cFunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^()]*)("me=e-2
syn match cFunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>\s*("me=e-1
hi cFunctions gui=NONE cterm=bold  ctermfg=red

" highlight current row
set cursorline
set cursorcolumn
set wildmenu

nmap <F5> :NERDTreeToggle<CR>
" for syntastic
execute pathogen#infect()
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" for ctags
set tags=tags;
set autochdir

"*******************  cscope     ********************************************
"cscope选项
" -R: 迭代生成
" -b: build only
" -q: build cscope.in.out and cscope.po.out
" -k: for kernel
" -i: input files
" -I: file path
" -C: ignore char
if has("cscope")
    set cscopetag "enable ctrl+] and ctrl+t/o
    "check cscope before checking ctags, set csto=1 to reverse
    set csto=1
    " add cscope database file
    if filereadable("cscope.out")
	cs add cscope.out
    endif
    "set hotkey for cscope
    "s: symbols 查找符号的出现位置
    "g: global defination 查找符号定义位置
    "c: call 调用该函数的函数
    "d: called 本函数调用的函数
    "e: egrep
    "f: file, open file under cursor
    "i: include, find files include filename undercursor
    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
endif
set csre " using relative path "
"*****************************************************************************

" for taglists
nmap <F8> :TlistToggle<CR>
let Tlist_Show_One_File = 1 "Only show one Tlist windows
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1
let Tlist_Auto_Open = 1	    "open taglist when open vim
"let Tlist_Close_On_Select = 1	"close file after tag select
let Tlist_File_Folder_Auto_Close = 1 " only show the last windows when several files open

""""""注释 NERDCOMMENT"""""""""""
"\cc for comment
"\cu for uncomment

""""""""""""""""""""Generate Header Automatically"""""""""""""""""""""""""""
map <F4> :call TitleDet()<CR>

function AddTitleForC()
    call append(0,"/*===================================================================")
    call append(1,"#    Copyright(C) ".strftime("%Y")."  All rights reserved")
    call append(2,"#")
    call append(3,"#    @auther:        Dian")
    call append(4,"#    @file:          ".expand("%:t"))
    call append(5,"#    @create date:   ".strftime("%Y-%m-%d %H-%M"))
    call append(6,"#    @last change:   ".strftime("%Y-%m-%d %H-%M"))
    call append(7,"#    @Function:      ")
    call append(8,"===================================================================*/")
    call append(9,"")
    echohl WarningMsg | echo "Successful in adding copyright." | echohl None
endfunction

function AddTitleForShell()
    call append(0,"#====================================================================")
    call append(1,"#    Copyright(C) ".strftime("%Y")."  All rights reserved")
    call append(2,"#")
    call append(3,"#    @auther:        Dian")
    call append(4,"#    @file:          ".expand("%:t"))
    call append(5,"#    @create date:   ".strftime("%Y-%m-%d %H-%M"))
    call append(6,"#    @last change:   ".strftime("%Y-%m-%d %H-%M"))
    call append(7,"#    @Function:      ")
    call append(8,"#====================================================================")
    call append(9,"")
    echohl WarningMsg | echo "Successful in adding copyright." | echohl None
endfunction

function AddTitle()
    if &filetype=='c'
        call AddTitleForC()
    elseif &filetype == 'c++'
        call AddTitleForC()
    elseif &filetype == 'make'
        call AddTitleForShell()
    elseif &filetype == 'sh'
        call AddTitleForShell()
    endif
endfunction

"update the revision time and filename
function UpdateTitle()
    normal m'
    execute'/#    @last change   /s@:.*$@\=strftime("%Y-%m-%d %H-%m")@'
    normal "
    normal mk
    execute '/#       @file      /s@:.*$@\=":".expand("%:p:h")."\\".expand("%:t")@'  
    execute "noh"  
    normal 'k
    echohl WarningMsg | echo "Successful in updating the copy right." | echohl None
endfunction

function TitleDet()
    let n=2
    let line=getline(n)
    let str='^#\s+auther:\s+Dian$'
    if line =~ str
        call UpdateTitle()
        return
    endif
    call AddTitle()
endfunction

