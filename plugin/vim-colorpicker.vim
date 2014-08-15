if exists('g:colorpicker') && g:colorpicker
    finish
endif

command! -nargs=? -complete=customlist,s:cmdcomplete ColorPicker :call s:ReadColor(<q-args>)

let g:color_picker_version = get(g:, 'color_picker_version', '2')
let s:colorpicker_path = expand("<sfile>:p:h").'/colorpicker'.g:color_picker_version.'.py'

function! s:cmdcomplete(A,L,P)
    return ['rgb', 'hex']
endfunction

function! s:ReadColor(...)
    let s:format = get(a:, 1, '')
    let pattern = '\(#[0-9A-Fa-f]\{6}\|#[0-9A-Fa-f]\{3}\|rgba\=([ .0-9,]\{5,})\)'
    call search(pattern, 'b', line('.'))
    let s:oldcolor = matchstr(getline('.'), pattern, col('.')-1)
    if s:oldcolor != ""
        if s:oldcolor =~ '#.*'
            let s:color = system(s:colorpicker_path." '".s:oldcolor."' ".s:format)[:-2]
        else
            let s:red   = pyeval('"%02x" % '.split(s:oldcolor,'[(),]')[1])
            let s:green = pyeval('"%02x" % '.split(s:oldcolor,'[(),]')[2])
            let s:blue  = pyeval('"%02x" % '.split(s:oldcolor,'[(),]')[3])
            let s:alpha = s:oldcolor =~ 'rgba' ? "'".split(s:oldcolor,'[(),]')[4]."'" : ''
            let s:color = system(s:colorpicker_path." '#".s:red.s:green.s:blue."' ".s:alpha.' rgb '.s:format)[:-2]
        endif
        if s:color != ''
            execute 's/'.s:oldcolor.'/'.s:color.'/'
        endif
    else
        let s:color = system(s:colorpicker_path.' '.s:format)[:-2]
        silent execute "normal! a\<C-R>=s:color\<ESC>"
    endif

endfunction

let g:colorpicker = 1
