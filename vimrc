"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (has("nvim"))
"For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
    set termguicolors
endif

" colors
syntax enable
set t_Co=256
set t_ut=
syntax on
colorscheme onedark
set background=dark

" Set Tab
set tabstop=4
set shiftwidth=4

" row, column place
set ruler

" along with your programming language, auto adjust
filetype indent on

" vi / vim compatible mode
" set compatible

" Set number of lines
set nu
" hi LineNr cterm=none ctermfg=DarkGrey ctermbg=NONE

" High light current line
set cursorline
hi CursorLine cterm=None ctermfg=None

" vim hint mode
set showmode

" auto indicate
set ai

" Use UTF-8 without BOM
set encoding=utf-8 nobomb


" Hligh light search result
set hlsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" increment search
set incsearch


let g:airline_theme='onedark'

" Highligth python syntax
let python_highlight_all = 1

"#######################################################

" statusline
set laststatus=2
" set statusline=%#filepath#[%{expand('%:p')}]%#filetype#[%{strlen(&fenc)?&fenc:&enc},\ %{&ff},\ %{strlen(&filetype)?&filetype:'plain'}]%#filesize#%{FileSize()}%{IsBinary()}%=%#position#%c,%l/%L\ [%3p%%]
set statusline=%#filepath#[%{expand('%:p')}]%=%#position#%c,%l/%L\ [%3p%%]
hi filepath cterm=none ctermbg=238 ctermfg=40
" hi filetype cterm=none ctermbg=238 ctermfg=244
" hi filesize cterm=none ctermbg=238 ctermfg=244
hi position cterm=none ctermbg=238 ctermfg=40
function IsBinary()
	if (&binary == 0)
		return ""
	else
		return "[Binary]"
	endif
endfunction
	
function FileSize()
	let bytes = getfsize(expand("%:p"))
	if bytes <= 0
		return "[Empty]"
	endif
	if bytes < 1024
		return "[" . bytes . "B]"
	elseif bytes < 1048576
		return "[" . (bytes / 1024) . "KB]"
	else
		return "[" . (bytes / 1048576) . "MB]"
	endif
endfunction
			 
"#######################################################


"#######################################################

" shortcut
" Toggle mouse
map <C-n> :call SwitchMouseMode()<CR>
map! <C-n> <Esc>:call SwitchMouseMode()<CR>
function SwitchMouseMode()
	if (&mouse == "a")
		let &mouse = ""
		echo "Mouse is disabled."
	else
		let &mouse = "a"
		echo "Mouse is enabled."
	endif
endfunction


" paste mode
map <F3> :call SwitchPasteMode()<CR>
map! <F3> :call SwitchPasteMode()<CR>
function SwitchPasteMode()
	if (&paste == 1)
		let &paste = 0
		echo "Paste Mode is disabled."
	else
		let &paste = 1
		echo "Paste Mode is enabled."
	endif
endfunction
"#######################################################
