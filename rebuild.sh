#!/bin/sh
# 从零完整重编（定稿质量）：关闭快速模式、清理 latexmk 产物后全文编译。
sh clean.sh
rm main.pdf
set -e
cd "$(dirname "$0")"
rm -f thesis.fast.build
latexmk -C main.tex
latexmk -xelatex main.tex
