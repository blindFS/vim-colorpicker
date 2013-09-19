command! -nargs=? -complete=customlist,s:cmdcomplete ColorPicker :call s:ReadColor(<args>)

function! s:cmdcomplete(A,L,P)
    return ["'rgb'","'hex'"]
endfunction

function! s:ReadColor(...)
    let s:colorpicker_path = expand("<sfile>:p:h").'/colorpicker.py'
    let s:format = a:0 > 0? a:1 : ""
    call search('\(#[0-9A-Fa-f]\{6}\|#[0-9A-Fa-f]\{3}\|rgb([ .0-9,]\{5,})\)','b',line('.'))
    let s:oldcolor = matchstr(getline('.'),'\(#[0-9A-Fa-f]\{6}\|#[0-9A-Fa-f]\{3}\|rgb([ .0-9,]\{5,})\)',col('.')-1)
    if s:oldcolor != ""
        if s:oldcolor =~ "#.*"
            let s:color = substitute(system(s:colorpicker_path." '".s:oldcolor."' ".s:format),'\n','','g')
        else
            let s:red   = pyeval("str(hex(".split(s:oldcolor,'[(),]')[1]."))[2:]")
            let s:green = pyeval("str(hex(".split(s:oldcolor,'[(),]')[2]."))[2:]")
            let s:blue  = pyeval("str(hex(".split(s:oldcolor,'[(),]')[3]."))[2:]")
            let s:color = substitute(system(s:colorpicker_path." '#".s:red.s:green.s:blue."' rgb ".s:format),'\n','','g')
        endif
        if s:color != ""
            execute "s/".s:oldcolor."/".s:color."/"
        endif
    else
        let s:color = substitute(system(s:colorpicker_path." ".s:format),'\n','','g')
        execute "normal! a\<C-R>=s:color\<ESC>"
    endif

endfunction
