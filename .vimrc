""""""""""""""""""""""""""""" Generic Settings  """"""""""""""""""""""""""""""
"" LEFT LEADERS: \, ;.
"" UNKNOWN BEHAVIOUR, YET TO UNDERSTAND: '|', ',', '[', ']'...
"" See effects of overriding 'f' key for folding. Maybe 'f' is too easy key for
"" folding; some other slightly more complex keybinding can be set for this an
"" 'f' can be used for some other more frequent task.

"""""""""""""""""""""""""""""""" Setting :  """""""""""""""""""""""""""""""""
" This setting has to be before all the mappings and remappings. This may need
" another setting for the reverse mapping, need to re-investigate on this.
noremap ; :
set t_Co=256  " Set 256 colors. Is it working?
" colors my-industry-gray  " Gray colour scheme.
" colors gruvbox
" For mac, these look good:
" Slate, peachpuff, pablo.
" Industry, evening, morning, murphy, shine, torte.
" noremap : ;

"""""""""""""""""""""""""""""  Vundle Settings  """"""""""""""""""""""""""""""

set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
" call vundle#rc()
" let Vundle manage Vundle, required
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" call vundle#end()            " required
" filetype plugin indent on    " required


""""""""""""""""""""""""""""" Tab and space section """"""""""""""""""""""""""
" What to use for an indent.
" This will affect Ctrl-T and 'autoindent'.
" Python: 2 spaces
" C: tabs (pre-existing files) or 4 spaces (new files)
au BufRead,BufNewFile *.py,*pyw set shiftwidth=4
au BufRead,BufNewFile *.py,*.pyw set expandtab
" There is another function with similar name, in google vimrc/plugins,
" overriding them here. TODO: investigate what is that function and use aprprt.
fu! Select_c_style()
    if search('^\t', 'n', 150)
        set shiftwidth=8
        set noexpandtab
    el
        set shiftwidth=4
        set expandtab
    en
endf
au BufRead,BufNewFile *.c,*.h call Select_c_style()
" Makefiles treat tabs differently and are necessary.
au BufRead,BufNewFile Makefile* set noexpandtab
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""" Whitespace section """""""""""""""""""""""""""""
" Use the below highlight group when displaying bad whitespace is desired.
highlight BadWhitespace ctermbg=red guibg=red

" Display tabs at the beginning of a line in Python mode as bad.
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad.
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Remove trailing whitespaces, above is good only for python files.
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" Another approach, this and above both are taken from:
" https://vi.stackexchange.com/q/454/3012
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

" Above is only for python, this one is needed for java so added, remove if problematic.
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
" Till here.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""" New lines section """""""""""""""""""""""""""""""

" Use UNIX (\n) line endings.
" Only used for new files so as to not force existing files to change their
" line endings.
" Python: yes
" C: yes
" Why not for all?
au BufNewFile *.py,*.pyw,*.c,*.h set fileformat=unix

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""" Text wrap section """"""""""""""""""""""""""""""

" Wrap text after a certain number of characters
" Python: 79
" C: 79
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h set textwidth=79

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""  Abbriviations  """""""""""""""""""""""""""""""
iabbr ibg ing
" The above is useless, should abbrivate fooibg to fooing, it just works with
" ing as a standalone word.


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""  Python syntax n arbitrary settings """"""""""""""""""""

" For full syntax highlighting:
let python_highlight_all=1
syntax on

" Automatically indent based on file type: ``filetype indent on``
filetype indent on
" Keep indentation level from previous line: ``set autoindent``
set autoindent
autocmd FileType python let b:dispatch = 'python2 %'
nnoremap <F9> :Dispatch<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""  Session settings """"""""""""""""""""""""""""
function! MakeSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  if (filewritable(b:sessiondir) != 2)
    exe 'silent !mkdir -p ' b:sessiondir
    redraw!
  endif
  let b:filename = b:sessiondir . '/session.vim'
  exe "mksession! " . b:filename
endfunction

function! LoadSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  let b:sessionfile = b:sessiondir . "/session.vim"
  if (filereadable(b:sessionfile))
    exe 'source ' b:sessionfile
  else
    echo "No session loaded."
  endif
endfunction

" Adding automatons for when entering or leaving Vim
if argc() == 0
  au VimEnter * nested :call LoadSession()
end
au VimLeave * :call MakeSession()

" Clipboard supprt:
" set clipboard=unnamedplus
set clipboard=unnamed


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""" Plugins Section """"""""""""""""""""""""""""""""
" Take a look at:

" Plugin 'Valloric/YouCompleteMe'  " Using Google's one.
" Plugin 'davidhalter/jedi-vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'jlanzarotta/bufexplorer'
" This ctrlp now has an active alternative, check that."
Plugin 'kien/ctrlp.vim'
" Experimental brackets closing etc settings. Reverse interesting order.
Plugin 'jiangmiao/auto-pairs'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'Valloric/YouCompleteMe'

" Airline status bar: NOT WORKING IN A GIT REPO ATM.
" Plugin 'vim-airline/vim-airline'
" Plugin 'vim-airline/vim-airline-themes'

" Plugin 'Townk/vim-autoclose'
" Go lang
" Plugin 'fatih/vim-go'
" Rust lang
Plugin 'rust-lang/rust.vim'
" Add a plugin for elixir and maybe phoenix.
" TODO plugin!
Plugin 'aserebryakov/vim-todo-lists'
" A great colorscheme!
Plugin 'morhetz/gruvbox'

" let g:gruvbox_(option) = '(value)'

" Python highlight?
Plugin 'vim-python/python-syntax'

" Need some light schemes.
Plugin 'junegunn/seoul256.vim'
Plugin 'scheakur/vim-scheakur'
Plugin 'rakr/vim-one'
Plugin 'rakr/vim-two-firewatch'
Plugin 'flazz/vim-colorschemes'
Plugin 'arzg/vim-corvine'
" A colorscheme 'ice-age' has been added manually, it's been archived by its
" author. It's in ~/.vim/bundle/vim-colorschemes/colors/ice-age.vim.
Plugin 'atelierbram/vim-colors_atelier-schemes'

" Here is a dark plugin, which has a very good light theme fork.
Plugin 'romainl/Apprentice'
Plugin 'wimstefan/Lightning'

" Language support for nim.
Bundle 'zah/nim.vim'

" Async and test dispatcher. Remove if doesn't show python output in next buf.
Plugin 'tpope/vim-dispatch'

" Markdown preview
" Plugin 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plugin 'iamcco/markdown-preview.nvim'
let g:mkdp_browser = 'google-chrome'

"" neovim only
"" main one
"Plugin 'ms-jpq/coq_nvim', {'branch': 'coq'}
"" 9000+ Snippets
"Plugin 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}


" Alternative for youcompleteme
" Plugin 'vim-scripts/AutoComplPop'


" Pomodoro!
" Plugin 'pydave/AsyncCommand'
" Plugin 'mnick/vim-pomodoro'
" Show pomodoro in the status line.
" set statusline=%#ErrorMsg#%{PomodoroStatus()}%#StatusLine#
" Another pomodoro one, graphical tomato and works with powerline.
" Plugin 'bling/vim-airline'  " This one is awesome.
" Plugin 'Zuckonit/vim-airline-tomato'

"""""""""""""""""""""""""""""  End of Plugins  """""""""""""""""""""""""""""""
call vundle#end()            " required
filetype plugin indent on    " required


""""""""""""""""""""""""""""" Misc options """""""""""""""""""""""""""""""""""
set nocompatible  " Be improved, no compatibility with vi.
set hlsearch  " Saerch highlighting
set incsearch  " Incremental/live search
set number  " Number indexing
set ruler  " Show cursor location at bottom right corner, in nopaste mode.
set numberwidth=4
set runtimepath+=$HOME/.vim/plugin
set mouse=a  " All mouse actions.
" set omnifunc=javascriptcomplete#CompleteJS" A commented out cmd, ! a comment
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
" Open all the folds
" map F zM
" Close all the folds
" map <C-f> zR
" Toggle fold on the current line
" map f za
"map <F3> :30Vex .<CR>
" map <silent><C-Left> <ESC>:bn<CR>
" map <silent><C-Right> <ESC>:bp<CR>
" Also remap these function key keyindings to work over byobu/tmux.
nmap <silent> <F2> <Plug>ToggleProject
noremap <silent> <F4> :NERDTreeToggle <CR>
noremap <silent> <F3> :BufExplorer <CR>

" Save session and quit vim, to reopen with the same session.
" nmap <silent>\wq <ESC>:quitall<CR>  " Not sure this is elegant.

" noremap <silent> <F7> :QFix <CR> " What plugin??
" noremap <silent> ,c :Ack "//\ *TODO" <CR>  " This Ack doens't work
" The following specifies <C-Right> n <C-Left>, duplicating below settings.
" nmap <silent> [1;5C <esc> :bn <CR>
" nmap <silent> [1;5D <esc> :bp <CR>
noremap <F4> <esc> :Vex <CR>
map <F4> :NERDTreeToggle <CR>

" Debug options.
let g:ycm_server_use_vim_stdout = 1
let g:ycm_server_log_level = 'debug'


""""""""""""" Custom added options, might need to change if needed """""""""""
au BufRead,BufNewFile *py,*pyw,*.c,*.h,*.js,*.html,*.css set tabstop=4 expandtab shiftwidth=4
" As we have .ng files, less and many more, just generalizing above
" set shiftwidth=2
" set tabstop=2
set shiftwidth=4
set tabstop=4
set expandtab
" Generalized till here
au BufRead,BufNewFile *.py,*.pyw set foldmethod=indent

" Set *.ng filetype syntax highlighting and plugins for *.ng files.
au BufRead,BufNewFile *.ng set ft=html

" Set *.css filetype syntax highlighting and plugins for *.less and *.gss files.
au BufRead,BufNewFile *.gss,*.less set ft=css

" Set foldmethod as indentation for both html and javascript.
" TODO: Set a proper foldmethod based on brackets for js.
au BufRead,BufNewFile *.js,*.html set foldmethod=indent

"""""""""""""""""""""""" Tab related key bindings """""""""""""""""""""""""""
function! OpenTabNDir ()
  <ESC>
  :tabe
  :NERDTreeToggle
  <CR>
endfunction

nmap <silent><C-Left> <ESC>:tabp<CR>
nmap <silent>\T <ESC>:tabp<CR>
nmap <silent><C-Right> <ESC>:tabn<CR>
nmap <silent>\t <ESC>:tabn<CR>
nmap <silent>\oe <ESC>:tabe<CR> :e
nmap <silent>\o <ESC> exec OpenTabNDir
nmap <silent>\qt <ESC>:tabc<CR>
nmap :qt :tabc
nmap :ot :tabe
nmap ;ot :tabe


"""""""""""""""""""""""""" swap file management """"""""""""""""""""""""""""
set backupdir=~/.vimdir//
set directory=~/.vimdir//


"""""""""""""""""""""""""" persistent undo buffer """"""""""""""""""""""""""""
set undofile                " Save undos after file closes
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo


""""""""""""""""""""""""""""""""  Text Width   """"""""""""""""""""""""""""""

call matchadd('ColorColumn', '\%81v\s*\zs\S', 100)

"""""""""""""""""""""""""" UTF-8 decoration """"""""""""""""""""""""""""
" modify selected text using combining diacritics
command! -range -nargs=0 Overline        call s:CombineSelection(<line1>, <line2>, '0305')
command! -range -nargs=0 Underline       call s:CombineSelection(<line1>, <line2>, '0332')
command! -range -nargs=0 DoubleUnderline call s:CombineSelection(<line1>, <line2>, '0333')
command! -range -nargs=0 Strikethrough   call s:CombineSelection(<line1>, <line2>, '0336')

function! s:CombineSelection(line1, line2, cp)
  execute 'let char = "\u'.a:cp.'"'
  execute a:line1.','.a:line2.'s/\%V[^[:cntrl:]]/&'.char.'/ge'
endfunction


" Settings for plugin 'vim-airline/vim-airline-themes'
set ttimeoutlen=50
set encoding=utf-8

" Start in a nice colour scheme. TODO: Do light/dark schemes based on times.
" colo PaperColor
colo gruvbox
" colo graywh
"
" List contents of all registers (that typically contain pasteable text).
nnoremap <silent> "" :registers "0123456789abcdefghijklmnopqrstuvwxyz*+.<CR>

se background=dark

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""                            Google Settings                           """"
""""                                                                      """"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" "" Kept at the bottom to override in case of conflicts.
" set nocompatible
" source /usr/share/vim/google/google.vim
" filetype plugin indent on
" syntax on
" 
" Glug ft-python
" Glug ft-javascript
" Glug youcompleteme-google
" Glug autogen
" " Glug blaze
" " Glug blazedeps
" " Glug blazebuild-fold
" 
" " Gtags
" source /usr/share/vim/google/gtags.vim
" 
" " These don't automatically load up, they need to be Glug'ed.
" Glug alert
" Glug clang-format
" Glug codefmt
" Glug compatibility
" Glug corpweb
" Glug critique
" " Glug deprecated
" Glug easygoogle
" Glug fileswitch
" Glug findinc
" Glug ft-cpp
" " Glug ft-java
" Glug ft-javascript
" Glug ft-proto
" Glug ft-python
" " Glug ft-soy
" Glug g4
" Glug git5
" Glug glaive
" Glug glug
" " Glug gocode
" Glug google-filetypes
" " Glug google-logo
" Glug googlepaths
" Glug googler
" Glug googlespell
" Glug googlestyle
" Glug grok
" " Glug gtimporter
" Glug helloworld
" Glug launchbrowser
" Glug lcov  " Deprecated.
" Glug legacy
" Glug logmsgs
" Glug maktaba
" Glug mru
" Glug outline-window
" Glug piper
" Glug refactorer
" Glug relatedfiles
" Glug safetmpdirs
" Glug scampi
" Glug selector
" Glug syntastic-google
" Glug ultisnips-google
" Glug vcscommand-g4
" Glug whitespace

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO: Set abbrs, say for function, try: except blocks, maybe for closing )"s.
" Learn critique and blaze in vim. Write functions forauthor, timestamps,
" project names(write thisin a meta file in the proj dir, on start read it and
" set an env var, and then write that in every files header with author). Macros
" /functions for:
" %s///gn, <, >s///gn: Count occurrences.
" <esc>qq/,a<enter><esc>: dict/obj formatter.
" Shortcuts for the same.
" Learn tags, vim scripting with fuctions. Involve in vim at google.
" Marks to use: 1, 2, 3, 4, 5, q, a, z, j, h, k, l, u, f, d, s etc, easier to use.
