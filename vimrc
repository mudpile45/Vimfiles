call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

if has('win32')  " Windows settings
    " Paste
    map <S-Insert>      "+gP
    " Copy
    vnoremap <C-Insert> "+y
    " Cut
    vnoremap <S-Del> "+x
    behave mswin
    if hostname() == "ONEIDA"
        " This mapping only gets used at work
        map <F2> mx:silent ! beautifyxml %:e`x
    endif
    let $EDITOR="notepad"
else
    let $EDITOR="vim"
endif    

if has('gui_running')
    "colors torte
    colors xoria256 
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start    
set modelines=1
set noswapfile
set wildmode=list:longest  "Make filename completion work like bash's
set history=1000           " keep 50 lines of command line history
set ruler		           " show the cursor position all the time
set showcmd		           " display incomplete commands
set incsearch	           " do incremental searching
set visualbell
set expandtab
set tabstop=4
set nocompatible
set ruler
set smartindent
set shiftwidth=4
syntax on
set hlsearch
set virtualedit=all
set ic
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set tabstop=4
set number				" line numbers
set cindent
set autoindent
set mouse=a				" use mouse in xterm to scroll
set scrolloff=5 		" 5 lines bevore and after the current line when scrolling
set ignorecase			" ignore case
set smartcase			" but don't ignore it, when search string contains uppercase letters
set hidden 				" allow switching buffers, which have unsaved changes
set shiftwidth=4		" 4 characters for indenting

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Allow to write to files you don't have permissions for
command W w !sudo tee % > /dev/null

" Key mappings

" Don't use Ex mode, use Q for formatting
map Q gq
"make S-Tab unindent 
imap <S-Tab> <C-d>
"Seems <S-Tab> doesn't work, so use this escape code
imap [Z <C-d> 

"Use Ctrl+PageUp/Down to switch buffers
map <C-PageUp> :bp
map <C-PageDown> :bn
"Use Ctrl+Left and Ctrl+Right to switch between tabs
map <C-Left> :tabprev
map <C-Right> :tabnext

map <F10> :call MaxOrRestore()<CR>
map <F9> :call CmdPromptHere()<CR>
map <S-F9> :call ExplorerHere()<CR>
map <F8> :call ChdirHere()<CR>
map <Leader>t :NERDTreeToggle<CR>

"Misc var settings
let g:maxxedOut = "no"


""""" Create a centered comment header (like this one) """""
let width = 60
let char = "#"
map  0$:let num = col("."):let num = (width/2) - ((num + 2)/2)0:exec "normal " . num . "i" . chara $ll:exec "normal " . num . "i" . char
"""""""""""" End create centered comment headers """"""""""""

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")
let g:perlOn = "no"

" Functions
set diffexpr=MyDiff()
function! MyDiff()
    let opt = '-a --binary '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    let eq = ''
    if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
    let cmd = '""' . $VIMRUNTIME . '\diff"'
    let eq = '"'
    else
    let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
            endif
            else
            let cmd = $VIMRUNTIME . '\diff'
            endif
            silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

autocmd BufEnter *.pl call PerlOn()
autocmd BufLeave *.pl call PerlOff()
autocmd BufEnter *.pm call PerlOn()
autocmd BufLeave *.pm call PerlOff()

function! PerlOn()
    "Assumes perltidy is in path
    map <F3> mx:%!perltidy -l=100`x  
    map <C-F11> :silent ! perl % && pause<CR>
    map <F11> :silent ! start perl -d %<CR>
    "Look up current word in perldoc
    map  :call PerlDoc()
    map <F5> :silent ! perl -wc % > syntax.txt 2>&1<CR>vl:e syntax.txt<CR>h
"   imap ( ()i
"    imap < <>i 
"   imap [ []i
"   imap ' ="''"<CR>i
"   imap " ='""'<CR>i
"    imap { {}i
"   echo 'Perl key bindings enabled'
    let g:perlOn = "yes"
endfunction

function! PerlOff()
   if g:perlOn == "yes"
       unmap <F3>
       unmap <C-F11>
       unmap <F11>
       unmap 
       unmap <F5>
   endif
   let g:perlOn = "no"
"  echo 'Perl key bindings disabled'
endfunction

function! MaxOrRestore()
    if has("win32")
        if g:maxxedOut == "no"
            simalt ~x
            let g:maxxedOut = "yes"
        else
            simalt ~r
            let g:maxxedOut = "no"
        endif
    else
        echo "MaxOrRestore only supported on windows"
    endif
endfunction

function! CmdPromptHere()
    let vimPath = getcwd()
    let curPath = substitute(substitute(expand("%"), "\\", "/","g"), "[^/]*$","", "")
    execute 'chdir ' . curPath
    if has("win32")
        silent execute '! start cmd'
    elseif has("mac")
        silent execute '! open /Applications/Utilities/Terminal.app/'
    endif
    execute ':chdir ' . vimPath
endfunction

function! ExplorerHere()
    let vimPath = getcwd()
    let curPath = substitute(substitute(expand("%"), "\\", "/","g"), "[^/]*$","", "")
    execute 'chdir ' . curPath
    if has("win32")
        silent execute '! start .'
    elseif has("mac")
        silent execute '! open .'
    endif
    execute ':chdir ' . vimPath
    echo "Explorer opened at " . curPath
endfunction

function! ChdirHere()
    let curPath = substitute(substitute(expand("%"), "\\", "/","g"), "[^/]*$","", "")
    execute 'chdir ' . curPath
    echo "Pwd changed to " . curPath
endfunction

function! PerlDoc()
    let theLine = getline(".")
    if match(theLine, "^use.*;$") >= 0  "Is a use statement (and thus also a perl module)
        let moduleName = substitute(theLine, "use \\([^ ;]*\\).*", "\\1", "")
        let result = system("perldoc " . moduleName)
    elseif match(theLine, "::") >= 0   "Is a perl module
        let moduleName = substitute(theLine, "^.* \\(\\w*::[^ ;]*\\).*", "\\1","")
        let result = system("perldoc " . moduleName)
    else
        let temp = @a
        exec "normal miwb\"ayw`i"   
        let result = system("perldoc -f " . @a)
        let @a = temp
    endif
    let temp = @a
    let @a = result
    exec "normal n\"aP"
    let @a = temp
endfunction
"endif

function! CreateHeader(string, ...)
    if a:string == ""
        exec "normal! \"ay"
        let string = @a
    else
        let string = a:string
    endif
    if a:0 < 1
        let delim = "="
    else
        let delim = a:1
    endif
    let width = 80
    let startPos = (width / 2) - (len(string) / 2)
    let i = 0
    let result = ""
    while i < startPos
        let result = result . delim
        let i = i + 1
    endwhile
    let result = result . string
    let i = i + len(string)
    while i < width
        let result = result . delim
        let i = i + 1
    endwhile
    return result
endfunction

