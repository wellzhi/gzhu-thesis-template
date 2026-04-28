#!/usr/bin/env bash
# 删除 LaTeX / latexmk / BibTeX 编译产生的冗余文件（重新编译即可生成）。
# 默认保留 main.pdf；若需一并删除主 PDF，请加参数 --pdf
#
# 用法：
#   ./clean-latex-artifacts.sh
#   ./clean-latex-artifacts.sh --pdf

set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT" || exit 1

RM_PDF=0
if [[ "${1:-}" == "--pdf" || "${1:-}" == "-p" ]]; then
  RM_PDF=1
fi

removed=0
rm_one() {
  local f
  for f in "$@"; do
    if [[ -f "$f" ]]; then
      rm -f -- "$f"
      printf 'removed: %s\n' "$f"
      removed=$((removed + 1))
    fi
  done
}

# 主文档相关（与 main.tex 同名）
rm_one \
  main.aux \
  main.log \
  main.toc \
  main.out \
  main.synctex.gz \
  main.xdv \
  main.fls \
  main.fdb_latexmk \
  main.bbl \
  main.blg \
  main.bcf \
  main.run.xml \
  main.lof \
  main.lot \
  main.loa \
  main.glo \
  main.gls \
  main.ist \
  main.idx \
  main.ilg \
  main.ind \
  main.nav \
  main.snm \
  main.vrb \
  main-blx.bib

# \include{content/...} 时可能在 content 下产生 .aux
shopt -s nullglob
rm_one content/*.aux
shopt -u nullglob

if [[ "$RM_PDF" -eq 1 ]]; then
  rm_one main.pdf
fi

if [[ "$removed" -eq 0 ]]; then
  echo "No matching artifact files found (already clean)."
else
  echo "Done. Removed $removed file(s). Run: latexmk -xelatex main.tex"
fi
