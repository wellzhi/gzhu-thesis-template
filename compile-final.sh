#!/bin/sh
# 定稿 / 提交前：关闭快速模式，全文嵌入高清图，生成可用于打印与提交的 main.pdf。
sh clean.sh --pdf
set -e
cd "$(dirname "$0")"
rm -f thesis.fast.build

_start=$(date +%s)
if latexmk -g -xelatex main.tex; then
  _status=0
else
  _status=$?
fi
_end=$(date +%s)
_elapsed=$((_end - _start))

if [ "$_elapsed" -lt 60 ]; then
  printf 'compile-final: 耗时 %d 秒（退出码 %d）\n' "$_elapsed" "$_status"
else
  printf 'compile-final: 耗时 %d 分 %d 秒（退出码 %d）\n' \
    "$((_elapsed / 60))" "$((_elapsed % 60))" "$_status"
fi

exit "$_status"
