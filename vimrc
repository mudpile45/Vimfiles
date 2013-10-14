call pathogen#infect()

" Plugin initializations
autocmd FileType javascript
  \ :setl omnifunc=jscomplete#CompleteJS
let g:node_usejscomplete = 1

let g:UltiSnipsListSnippets = "<Leader><tab>"
command! UltiSnipsView :e ~/.vim/bundle/UltiSnips/UltiSnips/

" Bufexplorer customizations
let g:bufExplorerFindActive=0        " Do not go to active window.
let g:bufExplorerShowRelativePath=1  " Show relative paths.

" CtrlP customizations
let mapleader=","
let g:ctrlp_map = '<Leader>o'
let g:ctrlp_switch_buffer = 0
map <Leader>m :CtrlPMRU<CR>
map <Leader>b :CtrlPBuffer<CR>
map <Leader>f :CtrlP<CR>

" more memorable mapping for color selector plugin
command! ColorSelector SelectColorS

" Python-mode.vim settings
  " Don't show as many whitespace warnings from python linters
  let g:pymode_lint_ignore = "E2,E501" 
  let g:pymode_lint_cwindow = 0
  

" Task-list.vim remapping
  " Task list by default sets mapping to <Leader>t, but I use that for
  " NERDTree, so reset it to <Leader>tl
  map <Leader>tl <Plug>TaskList 

" Make orgmode use the current file
"   This is needed so that todo <Leader>cat and Agenda <Leader>caL modes work
map <Leader>cac :let g:org_agenda_files = [expand("%:p")]<CR>
map <Leader>cah :silent ! emacs -batch --visit="%" --funcall org-export-as-html-batch<CR>
map <Leader>cam :silent ! emacs -batch --visit="%" --funcall org-export-as-html-batch; pandoc -s "%:r".html -t markdown_strict > "%:r".md<CR>


let g:ctrlp_custom_ignore = {
      \ 'dir':  'node_modules',
      \}
map <Leader>i :IndentGuidesToggle<CR>

" Use OS X clipboard even inside tmux sessions
let g:fakeclip_terminal_multiplexer_type = "unknown"

if has('win32')  " Windows settings
  " Fix Chinese characters
  set guifontwide=NSimsun
  " Paste
  map <S-Insert>    "+gP
  " Copy
  vnoremap <C-Insert> "+y
  " Cut
  vnoremap <S-Del> "+x
  behave mswin
  "Enable mapping for Chinese font
  map <Leader>U :set guifont=<CR>
  map <Leader>u :set guifont=MingLiU:h10:cANSI<CR>
  if hostname() == "ONEIDA"
    " This mapping only gets used at work
    map <F2> mx:silent ! beautifyxml %:e`x
  endif
  let $EDITOR="notepad"
else
  let $EDITOR="vim"
endif  


set fileencoding=utf8
set fileencodings=ucs-bom,utf8
set backspace=indent,eol,start    " allow backspacing over everything in insert mode
set modelines=1
set noswapfile
set wildmode=list:longest  "Make filename completion work like bash's
set history=1000       " keep 50 lines of command line history
set ruler          " show the cursor position all the time
set showcmd          " display incomplete commands
set incsearch        " do incremental searching
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
set number        " line numbers
set cindent
set autoindent
set scrolloff=5     " 5 lines bevore and after the current line when scrolling
set ignorecase      " ignore case
set smartcase     " but don't ignore it, when search string contains uppercase letters
set hidden        " allow switching buffers, which have unsaved changes
set shiftwidth=4    " 4 characters for indenting
set omnifunc=syntaxcomplete#Complete
" folds are nice, but not till i want them
set foldmethod=indent
set foldlevel=20
set pastetoggle=<Leader>p
" set relativenumber    "Make line numbers relative to where you currently are
set cryptmethod=blowfish  "Use blowfish instead of crappy zip algorithm if we use vim encryption

" Enable persistent undo (I guess only for vim 7.3)
if v:version >= 703 
  set undodir=~/.vim/undodir
  set undofile
  set undolevels=10000 "maximum number of changes that can be undone
  set undoreload=100000 "maximum number lines to save for undo on a buffer reload
endif 

" Always show status bar
set laststatus=2

" Switch syntax highlighting on, when the terminal has
" colors Also switch on highlighting the last used search
" pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  if &t_Co >= 256 || has("gui_running")
    colors xoria256 
  endif
endif

" Allow to write to files you don't have permissions for
command! W w !sudo tee % > /dev/null

" Session saving options (for session.vim plugin)
let g:session_autoload = "no"
" let g:session_autosave = "yes"
let g:session_default_to_last = "yes"

"###################### Key mappings #######################
" Make regex search properly magical (\v means you don't need to use a \
" before parenthesis etc.)
nnoremap / /\v
vnoremap / /\v
" clear search with <Leader><Space>
nnoremap <leader><space> :noh<cr>
" Autocomplete an HTML tag (from insert mode)
imap <C-a> </<C-x><C-o><Esc>==$a
" Toggle line numbers
map <Leader>n <Esc>:call Toggle_number()<CR>
" Toggle mouse support
map <Leader>\m <Esc>:call Toggle_mouse()<CR>
" Edit current .vimrc
map <Leader>rc <Esc><C-w>n:e $MYVIMRC<CR>
" Reload current .vimrc
map <Leader>rrc <Esc>:source $MYVIMRC<CR>

" Bind 'Dash' lookup to 'm' (looks up word under key with Dash) if we're
" running on a mac
if has("mac") 
  nnoremap <Leader>k :Dash<CR>
endif

" Open yankring
map <Leader>yr :YRShow<CR>
" make Y yank to end of line rather than yanking whole line to be consistent
" with C and D
"
" This `nnoremap Y y$ ` gets overridden by below when YankRing calls the YRRunAfterMaps()
" function
nnoremap Y y$ 
" Yankring compatible version of above
function! YRRunAfterMaps()
  nnoremap Y   :<C-U>YRYankCount 'y$'<CR>
  
  "=============================== start gp map ==============================
  " this needs to be in this function otherwise yankring clobbers it

  " select just pasted text (and preserve mode)
  " from: http://vim.wikia.com/wiki/Selecting_your_pasted_text
  " nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

  "this is this simple version: 
  nnoremap gp `[V`]
  " cooler more elaborate version
  nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
  "============================== end gp map =================================
endfunction
" stop yankring from hijacking gp mapping
let g:yankring_paste_using_g = 1

"Change to cwd mappings
map <F8> :call ChdirHere()<CR> 
map <Leader>cd :call ChdirHere()<CR>

" Move to middle of line
map <Leader>\| :exe "normal ".(virtcol("$")/2)."\|"<CR>

" Remap j and k to move visually instead of by actual line
" map arrow keys to preserve original functionality
noremap <Up> k
noremap <Down> j
noremap j gj
noremap k gk
noremap gj j
noremap gk k


" tComment is better but I'm used to nerdComment mappings...
" so rather than retrain the fingers, just make Vim remap it
vmap ,ci gc
map ,ci gcc<Esc>
call tcomment#DefineType('iced',             '# %s'             )

" ConqueShell mappings
" map <Leader>cs <Esc>:ConqueTerm bash<CR>
" map <Leader>css <Esc>:ConqueTermSplit bash<CR>
" map <Leader>cv <Esc>:ConqueTermVSplit bash<CR>

" Buffer mappings
map <Leader>bp <Esc>:bprev<CR>
map <Leader>bn <Esc>:bnext<CR>
map <Leader>bc <Esc>:bnew<CR>
map <Leader>bc <Esc><C-W>n
map <Leader>bd <Esc>:bd<CR>
map <Leader>bD <Esc>:bd!<CR>

" Tab mappings
map <Leader>tp <Esc>:tabprev<CR>
map <Leader>tn <Esc>:tabnext<CR>
map <Leader>tc <Esc>:tabnew<CR>
map <Leader>td <Esc>:tabclose<CR>

"Save session (using session plugin)
map <Leader>ss <Esc>:SaveSession<CR>
map <Leader>so <Esc>:OpenSession 

" Emacs-like bindings for insert mode
  "TODO: Need to add nonGUI bindings
  " undo
  inoremap <C-z> <C-o>u
  " Paste
  inoremap <C-y> <C-o>P
  "Delete to beginning of line
  inoremap <C-k> <C-o>d$
  "Delete to end of line
  inoremap <C-u> <C-o>d0
  " Move to beg of line
  inoremap <C-a> <C-o>0
  " Move to end of line
  inoremap <C-e> <C-o>$
  " Move forward one word
  inoremap ƒ <C-o>w
  " Move backward one word
  inoremap ∫ <C-o>b
  " delete one word forward
  " inoremap <C-d> <C-o>dw
  " delete one word backward
  inoremap <C-w> <C-o>db
  "Move down one line (not emacs like cause <C-n> and <C-p> are taken)
  inoremap ∆ <C-o>j
  "Move up one line (not emacs like cause <C-n> and <C-p> are taken)
  inoremap ˚ <C-o>k
  "Move right (not emacs like cause <C-n> and <C-p> are taken)
  inoremap ¬ <C-o>l
  "Move left (not emacs like cause <C-n> and <C-p> are taken)
  inoremap ˙ <C-o>h



" Open coffeescript preview
map <Leader>csp <Esc>:CoffeePreviewToggle<CR>

" Don't use Ex mode, use Q for formatting
map Q gq
"make S-Tab unindent 
"same for select mode
" vmap <S-Tab> <gv
" vmap [Z <gv
" vmap <Tab> >gv
" Reselect selected area after indent to allow for continuous indenting
vmap > >gv
vmap < <gv
vmap > >gv
vmap < <gv

" 
" And allow using tab and shift-tab to in/de-dent as well it in insert mode
"Seems <S-Tab> doesn't work very well, so use this escape code
" imap <Tab> <C-t>
" imap [Z <C-d>
" map [Z <<
" map <Tab> >>

" Omnicomplete with <C-c> (pnemonic 'complete')
imap <C-c> <C-x><C-o>

"Use Ctrl+PageUp/Down to switch buffers
map <C-PageUp> :bp
map <C-PageDown> :bn
"Use Ctrl+Left and Ctrl+Right to switch between tabs
map <C-Left> :tabprev
map <C-Right> :tabnext

" Don't show help when i hit F1, I'm usually trying to hit escape anyways
map <F1> <Esc>
imap <F1> <Esc>

map <F10> :call MaxOrRestore()<CR>
map <Leader>cmd :call CmdPromptHere()<CR>
map <Leader>eh :call ExplorerHere()<CR>
map <Leader>t :NERDTreeToggle<CR>
map <Leader>\t :NERDTreeFind<CR>
"On very rare occasions randomizing a list is useful
"Below mapping binds it to a key
map <Leader>r :%!perl -e 'use List::Util 'shuffle'; print shuffle(<>);'<cr>
"copy current file's full path to system clipboard
map <Leader>\fn :let @+='"'.expand("%").'"'<cr>
" the same but for only the working directory
map <Leader>\fp :let @+='"'.getcwd().'"'<cr>
"Misc var settings
map <Leader>gu <Esc>:GundoToggle<CR>
""""" Create a centered comment header (like this one) """""
map <Leader>cc <Esc>:let tmp=@z<CR>0"zY<Esc>:let @z = CreateHeader(@z)<CR>V"zP<Esc>:let @z=tmp<CR>
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
  \ exe "normal g`\"" |
  \ endif

  augroup END

else

  set autoindent    " always set autoindenting on

endif " has("autocmd")
let g:perlOn = "no"

" Functions
"set diffexpr=MyDiff()
"function! MyDiff()
"  let opt = '-a --binary '
"  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
"  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
"  let arg1 = v:fname_in
"  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
"  let arg2 = v:fname_new
"  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
"  let arg3 = v:fname_out
"  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
"  let eq = ''
"  if $VIMRUNTIME =~ ' '
"  if &sh =~ '\<cmd'
"  let cmd = '""' . $VIMRUNTIME . '\diff"'
"  let eq = '"'
"  else
"  let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
"      endif
"      else
"      let cmd = $VIMRUNTIME . '\diff'
"      endif
"      silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
"endfunction

function! Toggle_mouse()
  if &mouse == "a"
    set mouse=
    echo "Mouse support disabled"
  else
    set mouse=a
    echo "Mouse support enabled"
  endif
endfunction

function! Toggle_number()
  "Toggles between relative line #s, standard line #s and no numbering
  if &number == 1
    set nonumber
  elseif &relativenumber == 1
    set number
  elseif &relativenumber == 0 && &number == 0
    set relativenumber
  endif
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
  map  :call PerlDoc()<CR>
  map <F5> :silent ! perl -wc % > syntax.txt 2>&1<CR>vl:e syntax.txt<CR>h
" imap ( ()i
"  imap < <>i 
" imap [ []i
" imap ' ="''"<CR>i
" imap " ='""'<CR>i
"  imap { {}i
" echo 'Perl key bindings enabled'
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
  call ChdirHere()
  " if has("win32")
  "   silent execute '! start cmd'
  " elseif has("mac")
    " Should really move this out to a plugin, for now rely iTerm.sh
    " utility in DB path (stolen from sublime)
    " silent execute '! iTerm.sh '
    silent execute '! Terminal.sh '
  " endif
  execute ':chdir ' . vimPath
endfunction

function! ExplorerHere()
  let vimPath = getcwd()
  let curPath = substitute(substitute(expand("%"), "\\", "/","g"), "[^/]*$","", "")
  call ChdirHere()
  if has("win32")
    silent execute '! start .'
  elseif has("mac")
    silent execute '! open .'
  endif
  execute ':chdir ' . vimPath
endfunction

function! ChdirHere()
  let thePath = substitute(substitute(expand("%"), "\\", "/","g"), "[^/]*$","", "") 
  "take care of escaping spaces
  let thePath = substitute(thePath, " ", "\\\\ ", "g")
  let thePath = substitute(thePath, "/$","","")
  if thePath != ""
    execute 'cd ' . thePath 
  endif
  
  "hack around to make the escaped spaces match vims functions
  let thePath = substitute(thePath, "\\\\ ", " ", "g")
  if  getcwd() == thePath 
    echo "Pwd changed to " . getcwd()
  elseif thePath == "" 
    echo "Already in " . getcwd()
  else
    echo "Failed to change from " . getcwd() . " to " . thePath 
  endif
  "echo "[" . thePath . "]"
endfunction

function! PerlDoc()
  let theLine = getline(".")
  if match(theLine, "^use.*;$") >= 0  "Is a use statement (and thus also a perl module)
    let moduleName = substitute(theLine, "use \\([^ ;]*\\).*", "\\1", "")
    let result = system("perldoc -t 2>/dev/null " . moduleName)
  elseif match(theLine, "::") >= 0   "Is a perl module
    let moduleName = substitute(theLine, "^.* \\(\\w*::[^ ;]*\\).*", "\\1","")
    let result = system("perldoc -t 2>/dev/null " . moduleName)
  else
    let temp = @a
    exec "normal miwb\"ayw`i" 
    let result = system("perldoc -t -f " . @a)
    let @a = temp
  endif
  let temp = @a
  let @a = result
  exec "normal n\"aP"
  set buftype=nofile
  set bufhidden=hide
  setlocal noswapfile
  let @a = temp
endfunction
"endif

function! TwoToFour()
  " Set two space indents to 4 space (for languages where whitepsace matters
  " like CoffeeScript or Python)
  "
  " Works by setting tabstops to 2, retabbing it to use hard tabs, setting
  " it back go 4 and then converting tabs to spaces again.
  set ts=2 sts=2 noet
  retab!
  set ts=4 sts=4 et
  retab!
endfunction


function! FourToTwo()
  " Opposite of above
  set ts=4 sts=4 noet
  retab!
  set ts=2 sts=2 et
  retab!
endfunction


function! CreateHeader(string, ...)
  " CreateHeader(string, delim)
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
  let width = &textwidth
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


"smart indent when entering insert mode with i on empty lines
function! IndentWithI()
  if len(getline('.')) == 0 && line('.') > 1
    " delete the current line (it's empty anyway), move up a line and use
    " o to start this line at the right indentation since `cc` command
    " doesn't seem to work as expected in python
    return "ddko" 
  else
    return "i"
  endif
endfunction
nnoremap <expr> i IndentWithI()

"""""""""""""""""""""""""""""""""""""""
"  Start Tagbar Coffeescript support  "
"""""""""""""""""""""""""""""""""""""""
set tags=tags
let g:tagbar_type_coffee = {
  \ 'ctagstype' : 'coffee',
  \ 'kinds'   : [
    \ 'c:classes',
    \ 'm:methods',
    \ 'f:functions',
    \ 'v:variables',
    \ 'f:fields',
  \ ]
\ }

" Posix regular expressions for matching interesting items. Since this will 
" be passed as an environment variable, no whitespace can exist in the options
" so [:space:] is used instead of normal whitespaces.
" Adapted from: https://gist.github.com/2901844
let s:ctags_opts = '
  \ --langdef=coffee
  \ --langmap=coffee:.coffee
  \ --regex-coffee=/(^|=[[:space:]])*class[[:space:]]([A-Za-z]+\.)*([A-Za-z]+)([[:space:]]extends[[:space:]][A-Za-z.]+)?$/\3/c,class/
  \ --regex-coffee=/^[[:space:]]*(module\.)?(exports\.)?@?([A-Za-z.]+):.*[-=]>.*$/\3/m,method/
  \ --regex-coffee=/^[[:space:]]*(module\.)?(exports\.)?([A-Za-z.]+)[[:space:]]+=.*[-=]>.*$/\3/f,function/
  \ --regex-coffee=/^[[:space:]]*([A-Za-z.]+)[[:space:]]+=[^->\n]*$/\1/v,variable/
  \ --regex-coffee=/^[[:space:]]*@([A-Za-z.]+)[[:space:]]+=[^->\n]*$/\1/f,field/
  \ --regex-coffee=/^[[:space:]]*@([A-Za-z.]+):[^->\n]*$/\1/f,staticField/
  \ --regex-coffee=/^[[:space:]]*([A-Za-z.]+):[^->\n]*$/\1/f,field/
  \ --regex-coffee=/(constructor:[[:space:]]\()@([A-Za-z.]+)/\2/f,field/
  \ --regex-coffee=/(constructor:[[:space:]]\()@[A-Za-z.]+(,[[:space:]]@([A-Za-z.]+)){0}/\3/f,field/
  \ --regex-coffee=/(constructor:[[:space:]]\()@[A-Za-z.]+(,[[:space:]]@([A-Za-z.]+)){1}/\3/f,field/
  \ --regex-coffee=/(constructor:[[:space:]]\()@[A-Za-z.]+(,[[:space:]]@([A-Za-z.]+)){2}/\3/f,field/
  \ --regex-coffee=/(constructor:[[:space:]]\()@[A-Za-z.]+(,[[:space:]]@([A-Za-z.]+)){3}/\3/f,field/
  \ --regex-coffee=/(constructor:[[:space:]]\()@[A-Za-z.]+(,[[:space:]]@([A-Za-z.]+)){4}/\3/f,field/
  \ --regex-coffee=/(constructor:[[:space:]]\()@[A-Za-z.]+(,[[:space:]]@([A-Za-z.]+)){5}/\3/f,field/
  \ --regex-coffee=/(constructor:[[:space:]]\()@[A-Za-z.]+(,[[:space:]]@([A-Za-z.]+)){6}/\3/f,field/
  \ --regex-coffee=/(constructor:[[:space:]]\()@[A-Za-z.]+(,[[:space:]]@([A-Za-z.]+)){7}/\3/f,field/
  \ --regex-coffee=/(constructor:[[:space:]]\()@[A-Za-z.]+(,[[:space:]]@([A-Za-z.]+)){8}/\3/f,field/
  \ --regex-coffee=/(constructor:[[:space:]]\()@[A-Za-z.]+(,[[:space:]]@([A-Za-z.]+)){9}/\3/f,field/'

let $CTAGS = substitute(s:ctags_opts, '\v\([nst]\)', '\\', 'g')
"""""""""""""""""""""""""""""""""""""
"  End Tagbar Coffeescript support  "
"""""""""""""""""""""""""""""""""""""

