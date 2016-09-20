scriptencoding utf-8

function! IsWindows() abort
  return (has('win32') || has('win64'))
endfunction

function! IsMac() abort
  return has('macunix')
endfunction

" Use English interface.
language message C

" set default encoding to utf-8
set encoding=utf-8
set termencoding=utf-8

" Disable packpath
set packpath=

set langmenu=en_US

" Use <Leader> in global plugin.
let g:mapleader = ','
" Use <LocalLeader> in filetype plugin.
let g:maplocalleader = 'm'

" Release keymappings for plug-in.
nnoremap m  <Nop>
xnoremap m  <Nop>
nnoremap ,  <Nop>
xnoremap ,  <Nop>

let s:save_cpo = &cpo
set cpo&vim

" Unite menus settings {{{
let g:unite_source_menu_menus = get(g:,'unite_source_menu_menus',{})
" }}}

"Vim settings
let g:settings                         = get(g:, 'settings', {})
let g:settings.default_indent          = 2
let g:settings.max_column              = 120
let g:settings.plugin_bundle_dir       = expand($HOME . '/.config/nvim/dein')
let g:settings.error_symbol            = '✖'
let g:settings.warning_symbol          = '⚠'
let g:settings.colorscheme             = 'gruvbox'
let g:settings.colorscheme_default     = 'desert'
let g:settings.filemanager             = 'vimfiler'

let $CACHE = expand('~/.cache/neovim')
if !isdirectory(expand($CACHE))
  call mkdir(expand($CACHE), 'p')
endif

let g:loaded_gzip              = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_rrhelper          = 1
let g:loaded_2html_plugin      = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_LogiPat           = 1
let g:loaded_logipat           = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_spellfile_plugin  = 1
let g:loaded_man               = 1
let g:loaded_matchit           = 1
let g:loaded_matchparen        = 1