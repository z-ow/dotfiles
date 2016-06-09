"=======================================================================================
" Not compatible with vi.
set nocompatible
" Set the character encoding used inside Vim.
" set encoding=utf-8
" Used for opening existed file.
set fileencodings=utf-8,gbk
" Set leader key.
let mapleader=","
" Use plugin.
filetype plugin indent on
" Always show status bar.
set laststatus=2



"=======================================================================================
" Identify platforms.
silent function! OSX()
    return has('macunix')
endfunction
silent function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction
silent function! WINDOWS()
    return (has('win16') || has('win32') || has('win64'))
endfunction



function! ToggleBG()
    let s:tbg = &background
    " Inversion
    if s:tbg == "dark"
        set background=light
    else
        set background=dark
    endif
endfunction
noremap <leader>bg :call ToggleBG()<CR>



if WINDOWS()
    " Set runtime path for Windows.
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME
    "Fix menu display for Windows.
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
    language messages en_US.UTF-8
endif



let iCanHazPlug=1
let plug_readme=expand('~/.vim/autoload/plug.vim')
if !filereadable(plug_readme)
    echo "Installing vim-plug..."
    echo ""
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let iCanHazPlug=0
endif



call plug#begin('~/.vim/bundle')

Plug  'rizzatti/dash.vim'
Plug  'tpope/vim-commentary'
Plug  'tpope/vim-surround'
Plug  'vim-airline/vim-airline'
Plug  'vim-airline/vim-airline-themes'
Plug  'scrooloose/nerdtree'
Plug  'Xuyuanp/nerdtree-git-plugin'
Plug  'ctrlpvim/ctrlp.vim'
Plug  'godlygeek/tabular'
Plug  'terryma/vim-multiple-cursors'
Plug  'mattn/emmet-vim'
Plug  'majutsushi/tagbar'
Plug  'easymotion/vim-easymotion'
Plug  'vim-scripts/bufexplorer.zip'
Plug  'altercation/vim-colors-solarized'
Plug  'snipmate'
Plug  'AutoClose'
Plug  'klen/python-mode'
Plug  'unterzicht/vim-virtualenv'
Plug  'mbbill/undotree'
Plug  'plasticboy/vim-markdown'
function! BuildYCM(info)
    if a:info.status == 'installed' || a:info.force
        !./install.py
    endif
endfunction
Plug  'Valloric/YouCompleteMe', {'do': function('BuildYCM'), 'for': 'python, javascript' }
" syntax
Plug  'scrooloose/syntastic'
" git plugins
Plug  'airblade/vim-gitgutter'
Plug  'tpope/vim-fugitive'
" javascript plugins
Plug  'ternjs/tern_for_vim'
" c# plugins
Plug 'OmniSharp/Omnisharp-vim', {'for': 'cs'}
Plug  'tpope/vim-dispatch'
" Plug  'OrangeT/vim-csharp'
" Plug  'Shougo/vimproc.vim'
" Plug  'Shougo/vimshell.vim'
Plug  'kshenoy/vim-signature'
Plug  'ryanoasis/vim-devicons'

call plug#end()


if iCanHazPlug == 0
    echo "Installing vim plugins..."
    echo ""
    :PlugInstall
endif



"=======================================================================================
" save as sudo
ca w!! w !sudo tee "%"

" when scrolling, keep cursor 3 lines away from screen border
set scrolloff=3



"=======================================================================================
" Colorscheme
colorscheme solarized
set background=dark

if has('gui_running')
    if has("gui_macvim")
        set guifont=Monaco\ for\ Powerline:h11
    elseif has("gui_win32")
        set guifont=Consolas:h10
    endif
endif

highlight clear SignColumn
set cursorline              " Highlight the current line

" Tabs and spaces handling
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

set incsearch               " Incremental search
set hlsearch                " Highlighted search results

syntax on                   " Syntax highlight on

set number                  " Show line numbers

" Backspace for dummies
set backspace=indent,eol,start
set linespace=0             " No extra spaces between rows
set showmatch               " Show matching brackets/parenthesis
set ignorecase              " Case insensitive search
set wildmenu                " Show list instead of just completing

" Command <Tab> completion, list matches, then longest common part, all
set wildmode=full

" Backspace and cursor keys to wrap.
set whichwrap=b,s,h,l,<,>,[,]

" Storage setting {

    " Better backup, swap and redo storage
    set directory=~/.vim/dirs/tmp
    " Make backup files
    set backup
    set backupdir=~/.vim/dirs/backups
    set undofile
    set undodir=~/.vim/dirs/undos

    " Create needed directories
    if !isdirectory(&backupdir)
        call mkdir(&backupdir, "p")
    endif
    if !isdirectory(&directory)
        call mkdir(&directory, "p")
    endif
    if !isdirectory(&undodir)
        call mkdir(&undodir, "p")
    endif
" }

" ctrlp cache dir
let g:ctrlp_cache_dir = '~/.vim/dirs/cache/ctrlp'


" plugin settings
" NERDTree
let g:NERDTreeWinPos="right"
" let g:NERDTreeHighlightCursorline = 1
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif


"=======================================================================================
" Customized Mapping
"
noremap <Up>    <NOP>
noremap <Down>  <NOP>
noremap <Left>  <NOP>
noremap <Right> <NOP>

" Buffer Move
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>
" Keep the current visual block selection active after changing indent.
vmap > >gv
vmap < <gv

" In insert mode, delete from the current cursor to end-of-line
inoremap <C-Del> <C-\><C-O>D

" No highlight search
nnoremap <leader><space> :noh<cr>

" Mapping for gitgutter
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk

" Using <space> for folding toggle
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

" disable arrow keys
noremap <c-k> <c-w>k
noremap <c-j> <c-w>j
noremap <c-h> <c-w>h
noremap <c-l> <c-w>l

" Settings for Common Lisp.
if WINDOWS()
 let g:slimv_swank_cmd = '!start "C:/Program Files (x86)/LispCabinet/bin/ccl/wx86cl.exe" -l "C:/Program Files (x86)/LispCabinet/site/lisp/slime/start-swank.lisp"'
endif



" NERDTree
let NERDTreeIgnore=['\.vim$', '\.pyc$']



" Python-mode
" let g:pymode_run_bind      = '<leader>r'
let g:pymode_motion          = 0
let g:pymode_rope            = 0
let g:pymode_rope_completion = 0
let g:pymode_doc             = 0
let g:pymode_run             = 0
let g:pymode_lint            = 0
" Refactoring mapping
" let g:pymode_rope_goto_definition_bind = '<leader>d'
" let g:pymode_rope_rename_bind          = '<leader>r'
" let g:pymode_rope_rename_module_bind   = '<leader>rm'



" Solarized
" let g:solarized_termcolors=256



" " Jedi-vim
" let g:jedi#goto_command             = ''
" let g:jedi#goto_assignments_command = ''
" let g:jedi#rename_command           = ''
" let g:jedi#show_call_signatures     = 2



" Youcompleteme
  let g:ycm_auto_trigger = 0


" Vim-airline
let g:airline_powerline_fonts = 1



" Syntastic
let g:syntastic_python_checkers = ['flake8', 'mccabe']
let g:syntastic_always_populate_loc_list = 1



" Bufexplorer
nnoremap <silent> <F11>   : BufExplorer<CR>
nnoremap <silent> <m-F11> : BufExplorerHorizontalSplit<CR>
nnoremap <silent> <c-F11> : BufExplorerVerticalSplit<CR>



"=======================================================================================
" Autocmd
autocmd BufWritePre * :%s/\s\+$//ge    " Delete trial spaces
autocmd! BufWritePost ~/.vimrc nested :source ~/.vimrc
" autocmd FileType javascript nnoremap <buffer><localleader>c I//<esc>
" autocmd FileType python nnoremap <buffer><localleader>c I#<esc>
" autocmd BufWrite * :sleep 2000m



"=======================================================================================
" onoremap ih :<c-u> execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<CR>
" Vimscript file settings{{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker

augroup END
"}}}



"=======================================================================================
" key mappings
nnoremap <leader>t :Tabularize /
nnoremap <leader>gd :YcmCompleter GoTo<CR>
nnoremap <leader>gr :YcmCompleter GoToReferences<CR>

au BufRead *.py map <buffer> <F5> :w<CR>:!/usr/bin/env python % <CR>





" omnisharp-vim
let g:OmniSharp_host = "http://localhost:2000"
let g:OmniSharp_timeout = 1
let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
augroup omnisharp_commands
    autocmd!
    autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
    " Synchronous build (blocks Vim)
    "autocmd FileType cs nnoremap <F5> :wa!<cr>:OmniSharpBuild<cr>
    " Builds can also run asynchronously with vim-dispatch installed
    autocmd FileType cs nnoremap <leader>b :wa!<cr>:OmniSharpBuildAsync<cr>
    " automatic syntax check on events (TextChanged requires Vim 7.4)
    autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck
    " Automatically add new cs files to the nearest project on save
    autocmd BufWritePost *.cs call OmniSharp#AddToProject()
    "show type information automatically when the cursor stops moving
    " autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
    "The following commands are contextual, based on the current cursor position.
    autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
    autocmd FileType cs nnoremap <leader>fi :OmniSharpFindImplementations<cr>
    autocmd FileType cs nnoremap <leader>ft :OmniSharpFindType<cr>
    autocmd FileType cs nnoremap <leader>fs :OmniSharpFindSymbol<cr>
    autocmd FileType cs nnoremap <leader>fu :OmniSharpFindUsages<cr>
    "finds members in the current buffer
    autocmd FileType cs nnoremap <leader>fm :OmniSharpFindMembers<cr>
    " cursor can be anywhere on the line containing an issue
    autocmd FileType cs nnoremap <leader>x  :OmniSharpFixIssue<cr>
    autocmd FileType cs nnoremap <leader>fx :OmniSharpFixUsings<cr>
    autocmd FileType cs nnoremap <leader>tt :OmniSharpTypeLookup<cr>
    " autocmd FileType cs nnoremap <leader>dc :OmniSharpDocumentation<cr>
    "navigate up by method/property/field
    autocmd FileType cs nnoremap <C-K> :OmniSharpNavigateUp<cr>
    "navigate down by method/property/field
    autocmd FileType cs nnoremap <C-J> :OmniSharpNavigateDown<cr>
augroup END

set updatetime=500

nnoremap <leader><space> :OmniSharpGetCodeActions<cr>
vnoremap <leader><space> :call OmniSharp#GetCodeActions('visual')<cr>

" rename with dialog
nnoremap <leader>nm :OmniSharpRename<cr>
nnoremap <F2> :OmniSharpRename<cr>
" rename without dialog - with cursor on the symbol to rename... ':Rename newname'
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

" Force OmniSharp to reload the solution. Useful when switching branches etc.
nnoremap <leader>rl :OmniSharpReloadSolution<cr>
nnoremap <leader>cf :OmniSharpCodeFormat<cr>
" Load the current .cs file to the nearest project
nnoremap <leader>tp :OmniSharpAddToProject<cr>

" (Experimental - uses vim-dispatch or vimproc plugin) - Start the omnisharp server for the current solution
nnoremap <leader>ss :OmniSharpStartServer<cr>
nnoremap <leader>sp :OmniSharpStopServer<cr>

" Add syntax highlighting for types and interfaces
nnoremap <leader>th :OmniSharpHighlightTypes<cr>
"Don't ask to save when changing buffers (i.e. when jumping to a type definition)
set hidden
