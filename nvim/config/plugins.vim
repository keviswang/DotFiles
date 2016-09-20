scriptencoding utf-8

let s:plugin_config_dir = expand($HOME . '/.config/nvim/config/plugins/')
function! s:defind_hooks(bundle)
  call dein#config(g:dein#name, {
    \ 'hook_source' : "source " . s:plugin_config_dir . split(g:dein#name, '\.')[0] . ".vim"
    \ })
endfunction

function! s:post_hook(plugin)
  call dein#config(g:dein#name, {
    \ 'hook_post_source' : "source " . s:plugin_config_dir . split(g:dein#name, '\.')[0] . ".vim"
    \ })
endfunction

function! s:hook_add(filename)
	return "source  " . s:plugin_config_dir . split(a:filename, '\.')[0] . ".vim"
endfunction

function! s:add(repo, ...)
	if len(a:000) > 0
    call dein#add(a:repo, a:000[0])
  else
    call dein#add(a:repo)
  endif
	exec 'call add(g:unite_source_menu_menus.AddedPlugins.command_candidates, ["['
                \ . a:repo . (len(a:000) > 0 ? (']' . ' [lazy loaded]  [' . string(a:000[0])) : '')
                \ . ']","OpenBrowser https://github.com/'
                \ . a:repo
                \ . '"])'
endfunction

" auto install plugin manager 'dein'
if &runtimepath !~# '/dein.vim'
	let s:dein_dir = expand(g:settings.plugin_bundle_dir . '/repos/github.com/Shougo/dein.vim')
	if ! isdirectory(s:dein_dir)
		execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
	endif

	execute 'set runtimepath+='.substitute(
		\ fnamemodify(s:dein_dir, ':p') , '/$', '', '')
endif

" dein configurations.
" let g:dein#install_progress_type = 'title'
" let g:dein#install_message_type = 'none'

let g:unite_source_menu_menus.AddedPlugins = {'description': 'All the Added plugins                    <leader>lp'}
let g:unite_source_menu_menus.AddedPlugins.command_candidates = []
nnoremap <silent><Leader>lp :Unite -silent -winheight=17 menu:AddedPlugins<CR>

if !dein#load_state(g:settings.plugin_bundle_dir)
  finish
endif

call dein#begin(g:settings.plugin_bundle_dir, [expand('<sfile>')])

" Loaded on startup {{{
" ---
call s:add('Shougo/dein.vim')
call s:add('Shougo/vimproc.vim', {'build' : 'make'})
call s:add('christoomey/vim-tmux-navigator')
call s:add('kana/vim-operator-user')
call s:add('itchyny/vim-cursorword')
call s:add('itchyny/vim-parenmatch')
call s:add('rafi/vim-tagabana')
call s:add('rafi/vim-blocks')

" }}}


" LAZY LOADING {{{
" --------------------------------------------------------

" UI
call s:add('morhetz/gruvbox', { 'hook_add': s:hook_add('gruvbox.vim') })
call s:add('vim-airline/vim-airline',                { 'merged' : 0})
call s:add('vim-airline/vim-airline-themes',         { 'merged' : 0})
if dein#tap('vim-airline')
  call s:defind_hooks('vim-airline')
endif

call s:add('dyng/ctrlsf.vim',{'on_cmd' : 'CtrlSF', 'on_map' : '<Plug>CtrlSF', 'hook_add' : s:hook_add('ctrlsf.vim') })

call s:add('rhysd/accelerated-jk', {
	\	'on_map' : {'n': '<Plug>'},
	\ 'hook_add': s:hook_add('accelerated-jk.vim')
 	\ })
call s:add('kana/vim-operator-replace', {
	\ 'depends' : 'vim-operator-user',
	\ 'on_map' : '<Plug>',
	\ 'hook_add' : 'xmap p <Plug>(operator-replace)' })
call s:add('rhysd/vim-operator-surround', {
	\ 'depends' : 'vim-operator-user',
	\ 'on_map' : { 'n' : '<Plug>' },
	\ 'hook_add': s:hook_add('vim-operator-surround.vim')
	\ })
call s:add('osyo-manga/vim-jplus', {
	\ 'on_map' : { 'n' : '<Plug>' },
	\ 'hook_add' : 'nmap J <Plug>(jplus)'
	\ })
call s:add('lambdalisue/vim-protocol', { 'on_path' : '^https\?://' })
call s:add('kana/vim-smartchr', { 'on_event' : 'InsertCharPre' })
if dein#tap('vim-smartchr')
	call s:defind_hooks('vim-smartchr')
endif

call s:add('tyru/caw.vim', {
	\ 'on_map' : {'nx' : '<Plug>'},
	\ 'hook_add' : s:hook_add('caw.vim')
	\ })

call s:add('Shougo/context_filetype.vim', { 'on_event' : 'InsertEnter' })

	" Neovim {{{
	if has('nvim')
		call s:add('neomake/neomake', { 'on_cmd' : 'Neomake' })
		if dein#tap('neomake')
			call s:defind_hooks('neomake')
		endif

		call s:add('Shougo/deoplete.nvim', {
			\ 'depends' : 'context_filetype.vim',
			\ 'on_event' : 'InsertEnter'
			\ })
		if dein#tap('deoplete.nvim')
			call s:post_hook('deoplete.nvim')
		endif
		call s:add('Shougo/neoinclude.vim', { 'depends': 'deoplete.nvim' })
		call s:add('zchee/deoplete-clang', { 'depends' : 'deoplete.nvim',  'on_ft' : [ 'c', 'cpp' ] })
		call s:add('zchee/deoplete-jedi', { 'depends' : 'deoplete.nvim', 'on_ft' : 'python' })

		" Unite {{{
		        call s:add('Shougo/unite.vim', { 'depends': 'neomru.vim' })
			if dein#tap('unite.vim')
				call s:post_hook('unite.vim')
			endif

			call s:add('Shougo/vimfiler.vim', {
				\ 'depends' : 'unite.vim',
				\ 'on_map' : { 'n' : '<Plug>' },
				\ 'on_if' : "isdirectory(bufname('%'))"
				\ })
			if dein#tap('vimfiler.vim')
				call s:defind_hooks('vimfiler.vim')
			endif

			call s:add('Shougo/neomru.vim', { 'on_if' : 1, 'on_source' : ['unite.vim'] })
			call s:add('Shougo/neoyank.vim', { 'on_if' : 1, 'on_event' : 'TextYankPost', 'on_source' : ['unite.vim'] })
			call s:add('Shougo/unite-outline', { 'on_source' : 'unite.vim' })
			call s:add('tsukkee/unite-tag', { 'on_source' : ['unite.vim', 'neoinclude.vim'] })
			call s:add('hewes/unite-gtags', { 'on_source' : 'unite.vim' })

	" }}}
	endif
	" }}}


" }}}


call dein#end()
call dein#save_state()

if !has('vim_starting') && dein#check_install()
  " Installation check.
  call dein#install()
endif
