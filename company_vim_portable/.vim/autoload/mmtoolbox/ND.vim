"===============================================================================
"
"          File:  ND.vim
" 
"   Description:  Part of the verilog-support toolbox.
"
"                 Vim/gVim integration of NaturalDocs.
"
"                 See help file toolboxND.txt .
" 
"   VIM Version:  7.0+
"        Author:  Jeff McNeal, jeff.mcneal@verilab.com
"  Organization:  
"       Created:  08.17.2016
"       License:  Copyright (c) 2013, Jeff McNeal
"                 This program is free software; you can redistribute it and/or
"                 modify it under the terms of the GNU General Public License as
"                 published by the Free Software Foundation, version 2 of the
"                 License.
"                 This program is distributed in the hope that it will be
"                 useful, but WITHOUT ANY WARRANTY; without even the implied
"                 warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
"                 PURPOSE.
"                 See the GNU General Public License version 2 for more details.
"===============================================================================
"
"-------------------------------------------------------------------------------
" Basic checks.   {{{1
"-------------------------------------------------------------------------------
"
" need at least 7.0
if v:version < 700
	echohl WarningMs
	echo 'The plugin mmtoolbox/ND.vim needs Vim version >= 7.'
	echohl None
	finish
endif
"
" prevent duplicate loading
" need compatible
if &cp || ( exists('g:ND_Version') && ! exists('g:ND_DevelopmentOverwrite') )
	finish
endif
let g:ND_Version= '0.1'     " version number of this script; do not change
"
"-------------------------------------------------------------------------------
" Auxiliary functions   {{{1
"-------------------------------------------------------------------------------
"
"-------------------------------------------------------------------------------
" s:ErrorMsg : Print an error message.   {{{2
"
" Parameters:
"   line1 - a line (string)
"   line2 - a line (string)
"   ...   - ...
" Returns:
"   -
"-------------------------------------------------------------------------------
function! s:ErrorMsg ( ... )
	echohl WarningMsg
	for line in a:000
		echomsg line
	endfor
	echohl None
endfunction    " ----------  end of function s:ErrorMsg  ----------
"
"-------------------------------------------------------------------------------
" s:GetGlobalSetting : Get a setting from a global variable.   {{{2
"
" Parameters:
"   varname - name of the variable (string)
" Returns:
"   -
"
" If g:<varname> exists, assign:
"   s:<varname> = g:<varname>
"-------------------------------------------------------------------------------
function! s:GetGlobalSetting ( varname )
	if exists ( 'g:'.a:varname )
		exe 'let s:'.a:varname.' = g:'.a:varname
	endif
endfunction    " ----------  end of function s:GetGlobalSetting  ----------
" }}}2
"-------------------------------------------------------------------------------
"
"-------------------------------------------------------------------------------
" Modul setup.   {{{1
"-------------------------------------------------------------------------------
"
" platform specifics   {{{2
"
let s:MSWIN = has("win16") || has("win32")   || has("win64")     || has("win95")
let s:UNIX	= has("unix")  || has("macunix") || has("win32unix")
"
let s:SettingsEscChar = ' |"\'
"
if s:MSWIN
	"
	"-------------------------------------------------------------------------------
	" MS Windows
	"-------------------------------------------------------------------------------
	"
	let s:plugin_dir = substitute( expand('<sfile>:p:h:h:h'), '\\', '/', 'g' )
	"
else
	"
	"-------------------------------------------------------------------------------
	" Linux/Unix
	"-------------------------------------------------------------------------------
	"
	let s:plugin_dir = expand('<sfile>:p:h:h:h')
	"
endif
"
" settings   {{{2
"
let s:Makefile    = ''
let s:CmdLineArgs = ''
"
let s:ND_Executable = 'make'
"
call s:GetGlobalSetting ( 'ND_Executable' )
"
let s:Enabled = 1
"
" check make executable   {{{2
"
if ! executable ( s:ND_Executable )
	let s:Enabled = 0
endif
"
" custom commands {{{2
"
if s:Enabled == 1
	command! -bang -nargs=* -complete=file MakeCmdlineArgs   :call mmtoolbox#ND#Property('<bang>'=='!'?'echo':'set','cmdline-args',<q-args>)
	command! -bang -nargs=? -complete=file MakeFile          :call mmtoolbox#ND#Property('<bang>'=='!'?'echo':'set','makefile',<q-args>)
	command!       -nargs=* -complete=file Make              :call mmtoolbox#ND#Run(<q-args>)
	command!       -nargs=0                MakeHelp          :call mmtoolbox#ND#Help()
	command! -bang -nargs=0                MakeSettings      :call mmtoolbox#ND#Settings('<bang>'=='!')
else
	"
	" Disabled : Print why the script is disabled.   {{{3
	function! mmtoolbox#ND#Disabled ()
		let txt = "Make tool not working:\n"
		if ! executable ( s:Make_Executable )
			let txt .= "make not executable (".s:Make_Executable.")\n"
			let txt .= "see :help toolbox-make-config"
		else
			let txt .= "unknown reason\n"
			let txt .= "see :help toolbox-make"
		endif
		echohl Search
		echo txt
		echohl None
		return
	endfunction    " ----------  end of function mmtoolbox#ND#Disabled  ----------
	" }}}3
	"
	command! -bang -nargs=* Make          :call mmtoolbox#ND#Disabled()
	command!       -nargs=0 MakeHelp      :call mmtoolbox#ND#Help()
	command! -bang -nargs=0 MakeSettings  :call mmtoolbox#ND#Settings('<bang>'=='!')
	"
endif
"
" }}}2
"
"-------------------------------------------------------------------------------
" GetInfo : Initialize the script.   {{{1
"-------------------------------------------------------------------------------
function! mmtoolbox#ND#GetInfo ()
	if s:Enabled
		return [ 'ND', g:ND_Version ]
	else
		return [ 'ND', g:ND_Version, 'disabled' ]
	endif
endfunction    " ----------  end of function mmtoolbox#ND#GetInfo  ----------
"
"-------------------------------------------------------------------------------
" AddMaps : Add maps.   {{{1
"-------------------------------------------------------------------------------
function! mmtoolbox#ND#AddMaps ()
endfunction    " ----------  end of function mmtoolbox#ND#AddMaps  ----------
"
"-------------------------------------------------------------------------------
" AddMenu : Add menus.   {{{1
"-------------------------------------------------------------------------------
function! mmtoolbox#ND#AddMenu ( root, esc_mapl )
	"
	exe 'amenu '.a:root.'.run\ &make<Tab>:Make            :Make<CR>'
	exe 'amenu '.a:root.'.make\ &clean<Tab>:Make\ clean   :Make clean<CR>'
	exe 'amenu '.a:root.'.make\ &doc<Tab>:Make\ doc       :Make doc<CR>'
	"
	exe 'amenu '.a:root.'.-Sep01- <Nop>'
	"
"	exe 'amenu '.a:root.'.&choose\ make&file<Tab>:MakeFile                      :MakeFile<space>'
"	exe 'amenu '.a:root.'.cmd\.\ line\ ar&g\.\ for\ make<Tab>:MakeCmdlineArgs   :MakeCmdlineArgs<space>'
"	"
"	exe 'amenu '.a:root.'.-Sep02- <Nop>'
"	"
"	exe 'amenu '.a:root.'.&help<Tab>:MakeHelp          :MakeHelp<CR>'
"	exe 'amenu '.a:root.'.&settings<Tab>:MakeSettings  :MakeSettings<CR>'
	"
endfunction    " ----------  end of function mmtoolbox#ND#AddMenu  ----------
"
