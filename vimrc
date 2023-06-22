" Build directory structure
" necessary autoload, backup, colors, plugged
" mkdir -p ~/.vim ~/.vim/autoload ~/.vim/backup ~/.vim/colors ~/.vim/plugged

" fix single quotes in c/cpp code
" au FileType c,cpp setlocal comments-=:// comments+=f://

" Suppress unsaved buffer warning when moving between buffers
set hidden

" fix backspace not deleting in some environments
set backspace=indent,eol,start

" disable compatibility with vi, known to cause problems
set nocompatible

" enable file detection
filetype on

" enable and load plugins
filetype plugin on

" load an indent file for the detected file type
filetype indent on

" C-Indentation, indent block by moving to a bracket {} and type =%
set cindent
set cinoptions=g0

" syntax highlighting
syntax on

" number lines
set number
set relativenumber

" Fix shift - O lag
set timeout timeoutlen=5000 ttimeoutlen=100

" True Color Support
set termguicolors
" :help xterm-true-color
"let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" horizontal cursor location
" SEARCH 256COLOR CHART for 3 digit values
" sets cursor color (ctermbg)
" disables underline (cterm)
set cursorline
highlight CursorLine ctermbg=234 cterm=bold
" SETS FOLD LINE COLOR SO IT IS READABLE.
hi Folded ctermbg=000
"hi! Normal ctermbg=NONE guibg=NONE
"hi! NonText ctermbg=NONE guibg=NONE

" vertical cursor location
"set cursorcolumn

" shift width, aka, line indentation within functions
set shiftwidth=4

" set tab width
set tabstop=4

" use space characters instead of tabs
set expandtab

" do not save backup files
set nobackup

" cursor line scroll limit
set scrolloff=10

" do not wrap lines
" set no wrap

" highlight typed characters as you search
set incsearch

" case insensitive search
set ignorecase

" override the ignorecase for exclusive capital case word searches
set smartcase

" shows input cmd in bar. eg yy , dd , etc
set showcmd

" display mode in bar
set showmode

" show matching words in search
set showmatch

" use highlighting when searching
" nohlsearch helps highlight goaway, :nohl cmd works too
" set hlsearch
set nohlsearch

" fixing single quotes in c/cpp code
au FileType c,cpp setlocal comments-=:// comments+=f://

" set cmd history. default=2
set history=500

" scrolloff, keeps cursor centered while it can
set so=999

" enable TAB autocompletion. USE :e COMMAND
set wildmenu

" wildmenu similar to bash completion. USE :e COMMAND
set wildmode=list:longest

" There are certain files that we would never want to edit with vim
"   Wildmenu will ignore these extensions
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" USE :help TO GET HELP UNDERSTANDING COMMANDS. eg :help folding

" FOLD KEYBINDS zo=open ; zc=close ; zR=openALL ; zM=closeALL

" PLUGINS -------------------------------------------------------------------- {{{

" curl plug.vim from github and place in .vim/auto/plug.vim
" google vim plugin manager 
" plugin syntax: Plug 'username/plugin-name'
" :source ~/.vimrc
" :PlugInstall

call plug#begin('~/.vim/plugged')

" ale checks syntax
" Plug 'dense-analysis/ale'
" nerdtree offers filesystem structure
Plug 'preservim/nerdtree'
Plug 'NLKNguyen/papercolor-theme'
Plug 'dracula/vim'

call plug#end()

"color dracula
set t_Co=256
set background=dark
"setting colorscheme below removes transparency
"colorscheme PaperColor


" }}}

" MAPPINGS ------------------------------------------------------------------- {{{

" keymap syntax: map_mode <key_bind> <key_action>
" nnoremap - normalMode
" inoremap - insertMode
" vnoremap - visualMode
"
let mapleader = ";"
map nk :bn<CR>
map nj :bp<CR>
" future use: if --more-- causes problems, look into set nomore
map nb :ls<CR>:b<Space>

" yanks from cursor to end of line
" nnoremap Y y$
map <leader>cc "+y
map <leader>cv "+p

" auto bracket completion, can also add apostrophe and quotes
inoremap {<CR> {<CR>}<Esc>ko
" inoremap ( ()<Esc>ha
" inoremap [ []<Esc>ha

" toggle NERDtree
nnoremap <F3> :NERDTreeToggle<cr>
" ignore certain files/dirs
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$']


" }}}

" VIMSCRIPT ------------------------------------------------------------------ {{{

" code folding
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
    

" }}}

" STATUS LINE ---------------------------------------------------------------- {{{

" clear status line after vimrc reload
set statusline=

" statusline left side
" set statusline+=\ %F\ %M\ %Y\ %R
" set statusline+=\ %f\ %M\ %Y\ %R\ \%2n\/%{bufnr('$')}
set statusline+=\ %f\ %M\ %Y\ %R

" set status line divider
set statusline+=%=

" statusline right side
" set statusline+=\ buffer:\%2n\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%
" set statusline+=\ buffer:\%2n\ row:\ %l\ col:\ %c\ [%p%%]
set statusline+=\ row:\ %l\ col:\ %c\ [%p%%]\ [\%n\/%{bufnr('$')}]

"show the status on the second to last line
set laststatus=2

" }}}
