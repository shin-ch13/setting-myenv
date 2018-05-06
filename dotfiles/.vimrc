"編集中のファイル名を表示
set title
"括弧入力時の対応する括弧を表示
set showmatch
"コードの色分け
syntax on
"クリップボードの使用
set clipboard=unnamed,autoselect
"バックスペースの有効化
set backspace=indent,eol,start

"tab幅の設定
set tabstop=2
set expandtab
set shiftwidth=2
"連続した空白に対するカーソルの動く幅
set softtabstop=2

"行番号の表示
set number
"スワップファイルを作らない
set noswapfile

"自動インデント
set smartindent
set autoindent

"[検索]大文字小文字を区別しない
set ignorecase
"検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
"検索時に最後まで行ったら最初に戻る
set wrapscan

"1文字入力ごとに検索を行う
set incsearch
"検索結果のハイライト
set hlsearch
"ハイライトの切り替え
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>

"保存時の文字コード
set fileencoding=utf-8
"読み込み時の文字コードの自動判別、左優先
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
"改行コードの自動判別、左側優先
set fileformats=unix,dos,mac
"◻や◯が崩れるのを防ぐ(iTerm2の設定から一部変更の必要性))
set ambiwidth=double

"カーソルの左右移動で行末から行頭への移動
set whichwrap=b,s,h,l,<,>,[,],~
"カーソルラインのハイライト
set cursorline
" 行が折り返し表示されていた場合、行単位ではなく表示行単位でカーソルを移動する
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk

"コマンドモードの補完
set wildmenu
"保存するコマンド履歴の数
set history=5000
"クリップボードからコピペする際のインデントのズレを防ぐ
if &term =~ "xterm"
  let &t_SI .= "\e[?2004h"
  let &t_EI .= "\e[?2004l"
  let &pastetoggle = "\e[201~"

  function XTermPasteBegin(ret)
    set paste
    return a:ret
  endfunction

  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif


"マウス操作の有効化
if has('mouse')
  set mouse=a
  if has('mouse_sgr')
    set ttymouse=sgr
  elseif v:version > 703 || v:version is 703 && has('patch632')
    set ttymouse=sgr
  else
    set ttymouse=xterm2
  endif
endif
