"---------------------------------------------------------------------------
" vim-smartchr
"
inoremap <expr> , smartchr#one_of(', ', ',')

" Smart =.
inoremap <expr> =
      \ search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
      \ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
      \ : smartchr#one_of(' = ', '=', ' == ')
augroup MyAutoCmd
  " Substitute .. into -> .
  autocmd FileType c,cpp inoremap <buffer> <expr> .
        \ smartchr#loop('.', '->', '...')
  autocmd FileType perl,php inoremap <buffer> <expr> .
        \ smartchr#loop(' . ', '->', '.')
  autocmd FileType perl,php inoremap <buffer> <expr> -
        \ smartchr#loop('-', '->')
  autocmd FileType vim inoremap <buffer> <expr> .
        \ smartchr#loop('.', ' . ', '..', '...')

augroup END