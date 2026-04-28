$pdf_mode = 5;
@default_files = ('main.tex');
# 条件运行 BibTeX（与 latexmk 默认一致）。若设为 2，则只要 .aux 有变动就强制跑 BibTeX；
# 当 XeLaTeX 异常退出导致根目录 main.aux 被截断为空时，BibTeX 会误报
# “I found no \bibdata / \citation / \bibstyle” 并使 latexmk 失败。
$bibtex_use = 1;

# 与 main.tex 中 thesis.fast.build 一致：快速模式关 SyncTeX、略减 I/O；定稿模式保留 SyncTeX 便于编辑器跳转 PDF
our $thesis_fast = -e 'thesis.fast.build';
if ($thesis_fast) {
  $xelatex = 'xelatex -synctex=0 %O %S';
} else {
  $xelatex = 'xelatex -synctex=1 %O %S';
}
