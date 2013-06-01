" Modified from vim-coffeescript to detect iced coffee script files
" Language:    IcedCoffeeScript
" Maintainer:  Mick Koch <kchmck@gmail.com>
" URL:         http://github.com/kchmck/vim-coffee-script
" License:     WTFPL

autocmd BufNewFile,BufRead *.iced set filetype=iced
autocmd BufNewFile,BufRead *._iced set filetype=iced

function! s:DetectIced()
    if getline(1) =~ '^#!.*\<iced\>'
        set filetype=iced
    endif
endfunction

autocmd BufNewFile,BufRead * call s:DetectIced()
