" unite.vim
"
scriptencoding utf-8
let g:unite_enable_auto_select = 1
let g:unite_restore_alternate_file = 1
let g:unite_matcher_fuzzy_max_input_length = 25
let g:unite_source_directory_mru_limit = 80
let g:unite_source_file_rec_max_depth = 6
let g:unite_kind_jump_list_after_jump_scroll = 50
let g:unite_source_buffer_time_format = '(%m-%d-%Y %H:%M:%S) '
let g:unite_source_file_mru_time_format = '(%m-%d-%Y %H:%M:%S) '
let g:unite_source_directory_mru_time_format = '(%m-%d-%Y %H:%M:%S) '

let g:unite_source_menu_menus.unite = {
      \     'description' : 'Start unite sources',
      \ }
let g:unite_source_menu_menus.unite.command_candidates = {
      \       'history'    : 'Unite history/command',
      \       'quickfix'   : 'Unite qflist -no-quit',
      \       'resume'     : 'Unite -buffer-name=resume resume',
      \       'directory'  : 'Unite -buffer-name=files '.
      \             '-default-action=lcd directory_mru',
      \       'mapping'    : 'Unite mapping',
      \       'message'    : 'Unite output:message',
      \       'scriptnames': 'Unite output:scriptnames',
      \     }

" For unite-alias.
let g:unite_source_alias_aliases = {}
let g:unite_source_alias_aliases.test = {
      \ 'source' : 'file_rec',
      \ 'args'   : '~/',
      \ }
let g:unite_source_alias_aliases.line_migemo = 'line'
let g:unite_source_alias_aliases.calc = 'kawaii-calc'
let g:unite_source_alias_aliases.l = 'launcher'
let g:unite_source_alias_aliases.kill = 'process'
let g:unite_source_alias_aliases.message = {
      \ 'source' : 'output',
      \ 'args'   : 'message',
      \ }
let g:unite_source_alias_aliases.mes = {
      \ 'source' : 'output',
      \ 'args'   : 'message',
      \ }
let g:unite_source_alias_aliases.scriptnames = {
      \ 'source' : 'output',
      \ 'args'   : 'scriptnames',
      \ }

autocmd MyAutoCmd FileType unite call s:unite_my_settings()

let g:unite_ignore_source_files = []

call unite#custom#profile('action', 'context', {
      \ 'start_insert' : 1
      \ })

" migemo.
call unite#custom#source('line_migemo', 'matchers', 'matcher_migemo')

" Custom filters."{{{
call unite#custom#source(
      \ 'buffer,file_rec,file_rec/async,file_rec/git', 'matchers',
      \ ['converter_relative_word', 'matcher_fuzzy'])
call unite#custom#source(
      \ 'file_mru', 'matchers',
      \ ['matcher_project_files', 'matcher_fuzzy',
      \  'matcher_hide_hidden_files', 'matcher_hide_current_file'])
" call unite#custom#source(
"       \ 'file', 'matchers',
"       \ ['matcher_fuzzy', 'matcher_hide_hidden_files'])
call unite#custom#source(
      \ 'file_rec,file_rec/async,file_rec/git,file_mru', 'converters',
      \ ['converter_uniq_word'])
call unite#custom#source(
      \ 'buffer', 'converters',
      \ ['converter_uniq_word','converter_word_abbr'])
call unite#filters#sorter_default#use(['sorter_rank'])
" call unite#filters#sorter_default#use(['sorter_length'])
"}}}

" Custom source highlight.
function! s:rec_on_syntax(args, context)
  syntax match uniteSource__FileRecFileName /\[.\+\]/ contained containedin=uniteSource__FileRec
  highlight default link uniteSource__FileRecFileName Type
endfunction
call unite#custom#source('file_rec', 'syntax', 'uniteSource__FileRec')
call unite#custom#source('file_rec', 'on_syntax', function('s:rec_on_syntax'))

function! s:unite_my_settings() abort "{{{
  " Directory partial match.
  call unite#custom#alias('file', 'h', 'left')
  call unite#custom#default_action('directory', 'narrow')
  " call unite#custom#default_action('file', 'my_tabopen')

  call unite#custom#default_action('versions/git/status', 'commit')

  " call unite#custom#default_action('directory', 'cd')

  " Overwrite settings.
  imap <buffer>  <BS>      <Plug>(unite_delete_backward_path)
  imap <buffer>  jj        <Plug>(unite_insert_leave)
  imap <buffer>  <Tab>     <Plug>(unite_complete)
  imap <buffer> '          <Plug>(unite_quick_match_default_action)
  nmap <buffer> '          <Plug>(unite_quick_match_default_action)
  nmap <buffer> cd         <Plug>(unite_quick_match_default_action)
  nmap <buffer> <C-z>      <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-z>      <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-w>      <Plug>(unite_delete_backward_path)
  nmap <buffer> <C-j>      <Plug>(unite_toggle_auto_preview)
  nnoremap <silent><buffer> <Tab>     <C-w>w
  nnoremap <silent><buffer><expr> l
        \ unite#smart_map('l', unite#do_action('default'))
  nnoremap <silent><buffer><expr> P
        \ unite#smart_map('P', unite#do_action('insert'))

  let unite = unite#get_current_unite()
  if unite.profile_name ==# '^search' || unite.profile_name ==# '^grep'
    nnoremap <silent><buffer><expr> r     unite#do_action('replace')
  else
    nnoremap <silent><buffer><expr> r     unite#do_action('rename')
  endif

  nnoremap <silent><buffer><expr> cd     unite#do_action('lcd')
  nnoremap <silent><buffer><expr> !     unite#do_action('start')
  nnoremap <buffer><expr> S
        \ unite#mappings#set_current_sorters(
        \  empty(unite#mappings#get_current_sorters()) ?
        \   ['sorter_reverse'] : [])
  nnoremap <buffer><expr> cof
        \ unite#mappings#set_current_matchers(
        \ empty(unite#mappings#get_current_matchers()) ?
        \ ['matcher_fuzzy'] : [])
  nmap <buffer> x     <Plug>(unite_quick_match_jump)

endfunction"}}}

" let g:unite_abbr_highlight = 'TabLine'

" Profile {{{
call unite#custom#profile('default', 'context', {
            \   'safe': 0,
            \   'start_insert': 1,
            \   'ignorecase' : 1,
            \   'short_source_names': 1,
            \   'update_time': 200,
            \   'direction': 'rightbelow',
            \   'winwidth': 40,
            \   'winheight': 15,
            \   'max_candidates': 100,
            \   'no_auto_resize': 1,
            \   'vertical_preview': 1,
            \   'cursor_line_time': '0.10',
            \   'hide_icon': 0,
            \   'candidate-icon': ' ',
            \   'marked_icon': '✓',
            \   'prompt' : ' ➭'
            \ })
call unite#custom#profile('file_rec/async,file_rec/git', 'context', {
            \   'start_insert' : 1,
            \   'quit'         : 1,
            \   'split'        : 1,
            \   'keep_focus'   : 1,
            \   'winheight'    : 20,
            \ })
call unite#custom#profile('buffer,buffer_tab', 'context', {
            \   'start_insert' : 0,
            \   'quit'         : 1,
            \   'keep_focus'   : 1,
            \ })

" }}}

" Use ag(the silver searcher)
" https://github.com/ggreer/the_silver_searcher

" The silver searcher settings
let s:my_ag_opts = [
	\ '--vimgrep', '--smart-case', '--skip-vcs-ignores', '--hidden',
	\ '--ignore', '.git', '--ignore', '.idea', '--ignore', '.stversions',
	\ '--ignore', 'bower_modules', '--ignore', 'node_modules', '--ignore', '.tmp'
	\ ]

" Source: grep {{{
let g:unite_source_grep_max_candidates = 200
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = join(s:my_ag_opts)
let g:unite_source_grep_recursive_opt = ''
" }}}

" Source: rec(ursive) {{{
let g:unite_source_rec_unit = 3000
let g:unite_source_rec_min_cache_files = 200
let g:unite_source_rec_max_cache_files = 25000
let g:unite_source_rec_async_command = ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''] + s:my_ag_opts
" }}}

nnoremap <silent> [Space]n  :UniteNext<CR>
nnoremap <silent> [Space]p  :UnitePrevious<CR>

  nnoremap <silent> <leader>b
        \ :<C-u>Unite -buffer-name=build`tabpagenr()` -no-quit build<CR>
  nnoremap <silent> <leader>o
        \ :<C-u>Unite outline -no-start-insert -resume<CR>
  nnoremap <silent> <C-k>
        \ :<C-u>Unite change jump<CR>
  nnoremap <silent> <leader>g
        \ :<C-u>Unite grep -buffer-name=grep`tabpagenr()`
        \ -auto-preview -no-split -no-empty -resume<CR>
  nnoremap <silent> <leader>r
        \ :<C-u>Unite -buffer-name=register
        \ -default-action=append register history/yank<CR>
  xnoremap <silent> ;r
        \ d:<C-u>Unite -buffer-name=register
        \ -default-action=append register history/yank<CR>

  nnoremap <silent> <C-t>
        \ :<C-u>Unite -auto-resize -select=`tabpagenr()-1` tab<CR>
  nnoremap <silent> <C-w>
        \ :<C-u>Unite -force-immediately window:all:no-current<CR>

  nnoremap <silent> [Window]s
        \ :<C-u>Unite -buffer-name=files -no-split -multi-line -unique -silent
        \ jump_point file_point file_mru
        \ `finddir('.git', ';') != '' ? 'file_rec/git' : ''`
        \ buffer_tab:- file file/new<CR>

  nnoremap <silent> [Window]<Space>
        \ :<C-u>Unite -buffer-name=files -path=~/.vim/rc file_rec<CR>
  nnoremap <silent> [Window]n
        \ :<C-u>Unite -start-insert -default-action=lcd dein<CR>
  nnoremap <silent> [Window]g
        \ :<C-u>Unite -start-insert ghq<CR>

  nnoremap <silent> [Space]ft
        \ :<C-u>Unite -start-insert filetype filetype/new<CR>

  " Tag jump.
  nnoremap <silent><expr> tt  &filetype == 'help' ?  "g\<C-]>" :
        \ ":\<C-u>UniteWithCursorWord -buffer-name=tag -immediately
        \  tag tag/include\<CR>"
  nnoremap <silent><expr> tp  &filetype == 'help' ?
        \ ":\<C-u>pop\<CR>" : ":\<C-u>Unite jump\<CR>"

  " Execute help.
  nnoremap <silent> <C-h>  :<C-u>Unite -buffer-name=help help<CR>

  " Search.

" 异步搜索文件
nnoremap <C-P>    :Unite -buffer-name=files -start-insert file_rec/async:!<cr>
nnoremap <silent><leader>v :Unite -auto-preview -no-split grep:.::<C-R><C-w><CR>
" 在文件内搜索内容
nnoremap <space>/ :Unite -auto-preview grep:.<cr>

  nnoremap <silent> /
        \ :<C-u>Unite -buffer-name=search%`bufnr('%')`
        \ -start-insert line:forward:wrap<CR>
  nnoremap <silent> *
        \ :<C-u>UniteWithCursorWord -buffer-name=search%`bufnr('%')`
        \ line:forward:wrap<CR>
  nnoremap [Alt]/       /
  nnoremap [Alt]?       ?
  nnoremap <silent> n
        \ :<C-u>UniteResume search%`bufnr('%')`
        \  -no-start-insert -force-redraw<CR>