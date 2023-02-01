hi Comment ctermfg=3 " コメントの色を水色
nnoremap <Esc><Esc> :nohlsearch<CR><ESC> " Escの2回押しでハイライト消去
set clipboard=unnamed,autoselect " ヤンクでクリップボードにコピー
set expandtab " 入力モードでTabキー押下時に半角スペースを挿入
set guioptions+=a " yでコピーした時にクリップボードに入る
set hlsearch " 検索結果をハイライト表示
set ignorecase " 検索するときに大文字小文字を区別しない
set incsearch " インクリメントサーチ
set listchars=tab:^\ ,trail:~ " 行末のスペースを可視化
set number " 行番号を表示
set shiftwidth=2 " インデント幅
set showmatch " 対応する括弧を強調
set smartcase " 大文字で検索すると大文字小文字を区別 
set virtualedit=block " 短形選択で文字がなくても右へ進める
set wildmenu " vimバーからファイルを選択できる
set wrapscan " 折り返し検索
colorscheme codedark " VSコード風のテーマ
set background=dark "デフォルトのbackgroundのカラーテーマを設定。
syntax on " シンタックスハイライトを有効化
let g:airline_theme = 'codedark'

"" vim-airline
" ステータスラインに表示する項目を変更する
let g:airline_theme = 'wombat'               " テーマの指定
let g:airline#extensions#tabline#enabled = 1 " タブラインを表示
let g:airline_powerline_fonts = 1            " Powerline Fontsを利用
let g:airline#extensions#default#layout = [
  \ [ 'a', 'b', 'c' ],
  \ ['z']
  \ ]
let g:airline_section_c = '%t %M'
let g:airline_section_z = get(g:, 'airline_linecolumn_prefix', '').'%3l:%-2v'
" 変更がなければdiffの行数を表示しない
let g:airline#extensions#hunks#non_zero_only = 1 

" タブラインの表示を変更する
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#show_close_button = 0

" vim helpの日本語化
call plug#begin()
  Plug 'vim-jp/vimdoc-ja'
  Plug 'rust-lang/rust.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'tomasiser/vim-code-dark'
  Plug 'altercation/solarized'
  Plug 'lambdalisue/fern.vim'
  Plug 'lambdalisue/fern-git-status.vim'
  Plug 'lambdalisue/nerdfont.vim'
  Plug 'lambdalisue/fern-renderer-nerdfont.vim'
  Plug 'lambdalisue/glyph-palette.vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
call plug#end()

nmap <C-j> <Plug>AirlineSelectPrevTab
nmap <C-k> <Plug>AirlineSelectNextTab
" Ctrl+nでファイルツリーを表示/非表示する
nnoremap <C-n> :Fern . -reveal=% -drawer -toggle -width=40<CR>
let g:fern#renderer = 'nerdfont' " icon show
" アイコンに色をつける
augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END

"" git操作
" g]で前の変更箇所へ移動する
nnoremap g[ :GitGutterPrevHunk<CR>
" g[で次の変更箇所へ移動する
nnoremap g] :GitGutterNextHunk<CR>
" ghでdiffをハイライトする
nnoremap gh :GitGutterLineHighlightsToggle<CR>
" gpでカーソル行のdiffを表示する
nnoremap gp :GitGutterPreviewHunk<CR>
" 記号の色を変更する
highlight GitGutterAdd ctermfg=green
highlight GitGutterChange ctermfg=blue
highlight GitGutterDelete ctermfg=red

"" 反映時間を短くする(デフォルトは4000ms)
set updatetime=250

"" fzf.vim
" Ctrl+pでファイル検索を開く
" git管理されていれば:GFiles、そうでなければ:Filesを実行する
fun! FzfOmniFiles()
  let is_git = system('git status')
  if v:shell_error
    :Files
  else
    :GFiles
  endif
endfun
nnoremap <C-p> :call FzfOmniFiles()<CR>

" Ctrl+gで文字列検索を開く
" <S-?>でプレビューを表示/非表示する
command! -bang -nargs=* Rg
\ call fzf#vim#grep(
\ 'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
\ <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 3..'}, 'up:60%')
\ : fzf#vim#with_preview({'options': '--exact --delimiter : --nth 3..'}, 'right:50%:hidden', '?'),
\ <bang>0)
nnoremap <C-g> :Rg<CR>

" frでカーソル位置の単語をファイル検索する
nnoremap fr vawy:Rg <C-R>"<CR>
" frで選択した単語をファイル検索する
xnoremap fr y:Rg <C-R>"<CR>

" fbでバッファ検索を開く
nnoremap fb :Buffers<CR>
" fpでバッファの中で1つ前に開いたファイルを開く
nnoremap fp :Buffers<CR><CR>
" flで開いているファイルの文字列検索を開く
nnoremap fl :BLines<CR>
" fmでマーク検索を開く
nnoremap fm :Marks<CR>
" fhでファイル閲覧履歴検索を開く
nnoremap fh :History<CR>
" fcでコミット履歴検索を開く
nnoremap fc :Commits<CR>

" debug
packadd termdebug
set mouse=a " mause enable
let g:termdebugger='rust-gdb'
" GDBデバッグ時のWindow横幅サイズ指定
let g:termdebug_wide = 160
