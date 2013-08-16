command! ColorPicker :call ReadColor()

function! ReadColor()
    if !exists("g:colorpicker_path")
        let g:colorpicker_path = $HOME."/.vim/bundle/vim-colorpicker/colorpicker.py"
    endif
    let s:oldcolor = matchstr(getline(line('.')),'\(#[0-9A-Fa-f]\{6}\|#[0-9A-Fa-f]\{3}\|rgb([ .0-9,]\{5,})\)',col('.')-1)
    if s:oldcolor != ""
        let s:color = substitute(system(g:colorpicker_path." '".s:oldcolor."'"),'\n','','g')
        execute "s/".s:oldcolor."/".s:color."/"
    else
        let s:color = substitute(system(g:colorpicker_path),'\n','','g')
        execute "normal! i\<C-R>=s:color\<ESC>"
    endif

endfunction
