#!/bin/sh
# 日常改稿：启用快速编译（插图占位、关 SyncTeX），不改变 figures/ 中文件。
sh clean.sh
set -e
cd "$(dirname "$0")"
: > thesis.fast.build
# -g：强制跑 XeLaTeX。latexmk 不把 thesis.fast.build 当作依赖，仅删/建该文件时
# main.tex 时间戳不变，会被误判「已是最新」而跳过编译，PDF 仍停留在另一模式。
exec latexmk -g -xelatex main.tex
