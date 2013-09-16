augroup nikcrypt
if exists("nikcrypt_loaded")
    finish
endif
let nikcrypt_loaded = 1

autocmd BufReadPre,FileReadPre *.aes call s:NikCryptReadPre()
autocmd BufReadPost,FileReadPost *.aes call s:NikCryptReadPost()
autocmd BufWritePre,FileWritePre *.aes call s:NikCryptWritePre()
autocmd BufWritePost,FileWritePost *.aes call s:NikCryptWritePost()

function! s:NikCryptReadPre()
    if has("filterpipe") != 1
        echo "No filter..."
        exit 1
    endif
    set secure
    set cmdheight=3
    set viminfo=
    set clipboard=
    set noswapfile
    set noshelltemp
    set shell=/bin/sh
    set bin
    " New versions of vim store undo stuff in a file--we don't want that for
    " pw protected stuff
    if v:version >= 703 
      set undodir=~/.vim/undodir
      set noundofile
      set undolevels=0 "maximum number of changes that can be undone
      set undoreload=0 "maximum number lines to save for undo on a buffer reload
    endif 

endfunction

function! s:NikCryptReadPost()
    let l:openssl_str = "%!openssl enc -aes-256-cbc -d -a -pass stdin -in " . expand("%")
    let b:pass = inputsecret("Decryption password: ")
    
    execute "0,$d"
    silent! execute "normal i". b:pass
    silent! execute l:openssl_str

    set undolevels&
    redraw!
endfunction

function! s:NikCryptWritePre()
    let l:openssl_str = "%!openssl enc -aes-256-cbc -a -pass pass:"
    if ! exists("b:pass")
        let l:a  = inputsecret("       New encryption password: ")
        let l:ac = inputsecret("Retype new encryption password: : ")
        if l:a != l:ac
            echo "Passwords didn't match! Please try again"
            call s:WaitForInput()
        else
            let b:pass = l:a
        endif
    else
        let l:a ="Nothing to see here"
        let l:ac="Nothing to see here"
        unlet l:a
        unlet l:ac
    endif
    silent! execute l:openssl_str . b:pass
endfunction

function! s:NikCryptWritePost()
    " Undo the encryption.
    silent! undo
    set nobin
    set shell&
    set cmdheight&
    redraw!
endfunction

function! s:WaitForInput()
    let char = getchar()
    return 1
endfunction
"openssl commands:
"
" decrypt: %!openssl enc -d -aes-256-cbc -a 
" encrypt: %!openssl enc -aes-256-cbc -a 
"
