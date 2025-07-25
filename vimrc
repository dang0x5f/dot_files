call plug#begin('~/.vim/the_plugs_i_met')
" Plug 'preservim/nerdtree'
" Plug 'dense-analysis/ale'
Plug 'dracula/vim', { 'as' : 'dracula' }
Plug 'vimwiki/vimwiki'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
call plug#end()

set termguicolors
colorscheme dracula

let g:dracula_italic = 0

let g:vimwiki_list = [{'name':'main','path':'/mnt/vimwiki/'}, {'name':'local','path':'~/.vim/.vimwiki/'}]

let g:gitgutter_grep=''
set updatetime=100
runtime! ftplugin/man.vim


" ************************************ Key Binds ***************************** {{{
nnoremap <Space> <Nop>
vnoremap <Space> <Nop>
let mapleader = " "

imap jj <Esc>

nnoremap Q <Nop>

nnoremap K :bn<CR>
nnoremap J :bp<CR>
nnoremap <Space>d :bd<CR>
nnoremap <Space>b :ls<CR>:b<Space>

vnoremap <Space>- :s///gc<LEFT><LEFT><LEFT>
nnoremap <Space>- :s///gc<LEFT><LEFT><LEFT>

nnoremap + J

nnoremap <C-k> :m .-2<CR>==
nnoremap <C-j> :m .+1<CR>==
vnoremap <C-k> :m '<-2<CR>gv=gv
vnoremap <C-j> :m '>+1<CR>gv=gv

vnoremap <Space>/ y/\V<C-R>=escape(@",'/\')<CR><CR>

nnoremap o o<Esc>
nnoremap O O<Esc>

vmap <C-c> "+y
vmap <C-v> "+p

inoremap {<CR> {<CR>}<Esc>ko

inoremap <C-[> <C-[>l

vnoremap > > gv
vnoremap < < gv

map <F8> :call SwitchColor(1)<CR>
" ********************************** Key Binds End *************************** }}}

" ************************************ VimScript ***************************** {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

autocmd TerminalOpen * if bufwinnr('') > 0 | setlocal nobuflisted | endif
autocmd TerminalOpen * setlocal nobuflisted

au FileType c,cpp setlocal comments-=:// comments+=f://

let s:colors     = 'dracula seoul256-light seoul256 solarized'
let s:color_list = split(s:colors)
let s:index      = 0
function! SwitchColor(num)
    let s:index += a:num
    let i = s:index % len(s:color_list)
    execute "colorscheme " . s:color_list[i]
    redraw
    execute "colorscheme"
endfunction

function! HourColor()
    let hr = str2nr(strftime('%H'))
    if hr >= 7 && hr <= 18
        let i = 0
    else
        let i = 1
    endif
    
    " let hourcolors = 'seoul256-light dracula'
    let hourcolors = 'zaibatsu dracula'
    execute "colorscheme " . split(hourcolors)[i]
    redraw
    execute "colorscheme"
endfunction
autocmd VimEnter * call HourColor()
autocmd VimLeave * !echo -ne "\033[0m"
" ************************************ VimScript End ************************* }}}

" ************************************ Settings ****************************** {{{
set nobackup

set number
set relativenumber

set tabstop=4
set expandtab
set shiftwidth=4

set scrolloff=999

set history=500

set hidden

set cursorline

set timeout timeoutlen=5000 ttimeoutlen=100

set backspace=indent,eol,start

set cindent
set cinoptions=g0

set incsearch
set ignorecase
set smartcase
set showcmd
set showmatch
set nohlsearch

set colorcolumn=80

set wildmenu
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx,*.out

syntax on

filetype on
filetype plugin on
filetype indent on
" ********************************** Settings End **************************** }}}

" *********************************** Status Line **************************** {{{
set statusline=
set statusline+=\ %F\ %M\ %Y\ %R\ %{FugitiveStatusline()}
set statusline+=%=
set statusline+=\ %b\ 0x%B\ [y:%l,x:%c]\ [%p%%]\ [\%n\/%{bufnr('$')}]
set laststatus=2
" ********************************** Status Line End ************************* }}}
