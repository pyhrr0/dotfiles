set nocompatible

" ---------------------------------------------------------------------------- "
" Plugins
" ---------------------------------------------------------------------------- "

call plug#begin('~/.vim/plugged')
Plug 'dylanaraps/wal.vim'
Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vista.vim'
Plug 'itchyny/lightline.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'airblade/vim-gitgutter'
Plug 'romainl/vim-devdocs'

let languages = ['python', 'go', 'c', 'cpp', 'rust']
Plug 'prabirshrestha/vim-lsp',                    {'for': languages}
Plug 'prabirshrestha/async.vim',                  {'for': languages}
Plug 'prabirshrestha/asyncomplete.vim',           {'for': languages}
Plug 'prabirshrestha/asyncomplete-lsp.vim',       {'for': languages}
Plug 'prabirshrestha/asyncomplete-ultisnips.vim', {'for': languages}

call plug#end()

" ---------------------------------------------------------------------------- "
" General settings
" ---------------------------------------------------------------------------- "

filetype plugin indent on

colorscheme wal

if !exists("g:syntax_on")
    syntax enable
endif

set background=dark
"set backspace=indent,eol,start
set laststatus=2
set number
set relativenumber
set clipboard=unnamedplus
set ruler
set ttyfast
set showcmd
set wildmenu
set wildmode=list:longest,full
set path+=**
set ttymouse=sgr
set tags=./tags;,~/.vimtags;
set completeopt+=preview
set splitright
set splitbelow

" Temp files
set nobackup
set noswapfile
set viminfo=""

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase

" Indentation
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Folding
set foldmethod=indent
set nofoldenable

" ---------------------------------------------------------------------------- "
" Key mappings
" ---------------------------------------------------------------------------- "

" Clear search highlight
nnoremap <leader><space> :noh<CR>

" Search and replace
nnoremap <Leader>r :%s/\<<C-R><C-W>\>//gI<left><left><left>

" Vimdiff merging
nnoremap <leader>mr :diffg RE<CR>
nnoremap <leader>mb :diffg BA<CR>
nnoremap <leader>ml :diffg LO<CR>

" Toggle Vista
let g:vista#renderer#enable_icon = 1
nnoremap <leader>t :Vista!!<CR>

" Fzf
nnoremap <leader>f :Files<CR>
nnoremap <leader>g :Rg <C-R><C-W><CR>
nnoremap <leader>l :Lines <C-R><C-W><CR>
nnoremap <leader>b :Buffers<CR>

" Documentation
nnoremap <leader>K :DD <CR>

" Lsp bindings
nnoremap <leader>d   :LspDefinition<CR>
nnoremap <leader>td  :LspTypeDefinition<CR>
nnoremap <leader>df  :LspDocumentFormat<CR>
nnoremap <leader>h   :LspHover<CR>
nnoremap <leader>ref :LspReferences<CR>
nnoremap <leader>rn  :LspRename<CR>
nnoremap <leader>dd  :LspDocumentDiagnostics<CR>

" ---------------------------------------------------------------------------- "
" Plugin configuration
" ---------------------------------------------------------------------------- "

" ultisnips
let g:UltiSnipsExpandTrigger="<C-L>"
let g:UltiSnipsJumpForwardTrigger="<C-J>"
let g:UltiSnipsJumpBackwardTrigger="<C-K>"

" vim-lsp
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1

if executable('gopls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls']},
        \ 'whitelist': ['go'],
        \ })
endif

if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif

if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rls']},
        \ 'whitelist': ['rust'],
        \ })
endif

if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif

" asyncomplete-ultisnips.vim
au Filetype cpp,c,python,rust call asyncomplete#register_source(
    \ asyncomplete#sources#ultisnips#get_source_options({
    \     'name': 'ultisnips',
    \     'whitelist': ['*'],
    \     'completor': function('asyncomplete#sources#ultisnips#completor'),
    \ }))

" vim-fzf
command! -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
    \   fzf#vim#with_preview(), <bang>0)

" vista
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

set statusline+=%{NearestMethodOrFunction()}
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

" lightline
let g:lightline = {
    \ 'colorscheme': 'one',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'filename', 'modified', 'method' ] ]
    \ },
    \ 'component_function': {
    \   'method': 'NearestMethodOrFunction'
    \ },
    \ }

" ---------------------------------------------------------------------------- "
" Event handling
" ---------------------------------------------------------------------------- "

" Remove trailing whitespace on write
autocmd BufWritePre * if &filetype != 'markdown' | %s/\s\+$//e | endif
