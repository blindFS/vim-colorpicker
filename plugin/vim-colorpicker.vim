command! -nargs=? -complete=customlist,s:cmdcomplete ColorPicker :call ReadColor(<args>)

function! s:cmdcomplete(A,L,P)
    return ["'rgb'","'hex'"]
endfunction

function! ReadColor(...)
    if !exists("g:colorpicker_path")
        let g:colorpicker_path = $HOME."/.vim/bundle/vim-colorpicker/colorpicker.py"
    endif
    let s:format = ""
    if a:0 > 0
        let s:format = a:1
    endif
    call search('\(#[0-9A-Fa-f]\{6}\|#[0-9A-Fa-f]\{3}\|rgb([ .0-9,]\{5,})\)','b',line('.'))
    let s:oldcolor = matchstr(getline('.'),'\(#[0-9A-Fa-f]\{6}\|#[0-9A-Fa-f]\{3}\|rgb([ .0-9,]\{5,})\)',col('.')-1)
    if s:oldcolor != ""
        if s:oldcolor =~ "#.*"
            let s:color = substitute(system(g:colorpicker_path." '".s:oldcolor."' ".s:format),'\n','','g')
        else
            let s:red   = pyeval("str(hex(".split(s:oldcolor,'[(),]')[1]."))[2:]")
            let s:green = pyeval("str(hex(".split(s:oldcolor,'[(),]')[2]."))[2:]")
            let s:blue  = pyeval("str(hex(".split(s:oldcolor,'[(),]')[3]."))[2:]")
            let s:color = substitute(system(g:colorpicker_path." '#".s:red.s:green.s:blue."' rgb ".s:format),'\n','','g')
        endif
            execute "s/".s:oldcolor."/".s:color."/"
    else
        let s:color = substitute(system(g:colorpicker_path." ".s:format),'\n','','g')
        execute "normal! a\<C-R>=s:color\<ESC>"
    endif

endfunction
