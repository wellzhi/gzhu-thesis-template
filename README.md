# 广州大学硕士学位论文 · LaTeX模板示例

在 **工程根目录**（与 **`main.tex` 同级**，例如本仓库的 `thesis_template/`）下执行编译；输出 **`main.pdf`** 与主文件同目录。

**文档结构：** 本仓库缘由 → 用法速览 → 环境与工具链 → 编译说明（含插图、参考文献）→ 仓库结构 → 根目录编译产物

---

## 为何有本仓库

- 在采用word写作过程中，设置图片不压缩保持清晰度，当word文件偏大时（100多M），编辑数学公式输入不兼容内容时，出现word奔溃，导致论文文件打不开，修复麻烦。

- 为方便将广州大学硕士学位论文版式固化为可重复编译的工程，下表从常见维度对比 **Word** 与 **LaTeX**，便于按个人习惯进行取舍。

### Word 与 LaTeX 常见维度对照

| 维度 | Microsoft Word | LaTeX（如本仓库） |
|:--|:--|:--|
| **编辑方式** | 所见即所得；图文顺序在版心内拖动、调整较直观。 | 源代码与版式分离；需编辑 `.tex` 并编译出 PDF，非所见即所得。 |
| **数学公式** | 内置公式编辑器；长文档中若大量手改，编号与交叉引用偶发不一致需人工核对。 | 公式与编号多由编译链统一处理，复杂式与多编号场景通常更省事。 |
| **插图与版式** | 对象多嵌在文档内，大图多时常显著增大 `.docx` 体积；极端情况下可能出现卡顿或未响应。 | 插图多为外链文件，主文稿较轻；若使用浮动体，图表现在页顶／页底属常规结果，可通过 `[H]`、`placeins` 等约束。 |
| **参考文献** | 可借助 Zotero、EndNote 等与 Word 联动，样式取决于插件与校方模板一致性。 | 常配合 BibTeX 与国标 `.bst`，大批量引用格式由数据库与样式统一驱动。 |
| **版本与协作** | 修订、批注流程成熟；`.docx` 为二进制包，Git 下语义化 diff 较弱。 | `.tex`、`.bib` 为纯文本，差异对比清晰，常与 Git、审稿流程配合。 |
| **页数与同字数观感** | 通过行距、段距与分页可拉出更「松」的版面，同字数篇幅通常更长。 | 默认往往更紧凑（与版心、字号、行距设置有关），同字数篇幅常少于「松排版」Word 稿。 |
| **字体与环境** | 一般随系统装好中文字体即可，所见即校验。 | 需配置 `fontspec`/xeCJK 等（本工程已示例）；新环境需保证系统或 TeX 侧有所用字体，按 `main.log` 排错。 |

> **说明：LaTeX 的突出点在于**源文件结构化**与**版式批处理一致**。纯文本源码更利于 diff、脚本与自动化。

---
## 1. 用法速览

| 场景 | 命令 | 备注 |
|:--|:--|:--|
| 日常改稿 | `./compile-fast.sh` | 写入 `thesis.fast.build`，插图为 draft 占位框，编译更快 |
| **定稿 / 送审 / 提交** | `./compile-final.sh` | **删除**快速标记，嵌入 `figures/` 中真实图 |
| 从零干净重编 | `./rebuild.sh` | 先清理辅助文件再全文编译 |
| 手动 | `latexmk -g -xelatex main.tex` | `-g` 建议保留；开关快速/定稿仅靠 `thesis.fast.build` 时，latexmk 常需强制重跑 |

> **送审稿 PDF**：一律用 **`./compile-final.sh`**；若怀疑 `.aux`/`.bbl` 损坏，改用 **`./rebuild.sh`**。不要用 **`compile-fast`** 的输出交稿。

---

## 2. 环境与工具链（macOS）

| 项目 | 要求 |
|:--|:--|
| TeX 发行版 | MacTeX 或 TeX Live（含 `latexmk`、`xelatex`、`bibtex`） |
| 引擎 | **XeLaTeX**（勿用 pdfLaTeX） |
| 中文字体 | 如字体缺失，请安装对应字体 |

---

## 3. 编译说明

### 3.1 快速模式（`thesis.fast.build`）

| 状态 | 行为 |
|:--|:--|
| 根目录存在空文件 **`thesis.fast.build`** | `graphicx` 选项为 **draft**，图为占位框，不严格要求磁盘上必有图文件；关闭 SyncTeX |
| **不存在**该文件 | 正常 `\includegraphics`；若图中路径下缺文件，`main.tex` 中定义的 **`\ThesisFigFillWidth` / `\ThesisIncludeOrPlaceholder`** 会排文字占位框而非中断编译 |

`thesis.fast.build` 写入 **`.gitignore`**，通常勿提交仓库。

### 3.2 参考文献与 BibTeX

| 项目 | 说明 |
|:--|:--|
| 数据库 | `content/references.bib` |
| 样式 | `bst/gbt7714-numerical-local.bst`（在 `content/11-references.tex` 中设定） |
| 首次引用顺序 | 数字型国标顺序；`**\begin{document}` 后的 `\nocite{…}`** 可微调参考文献表条目顺序（见 `main.tex` 注释） |

首次编译或删掉 `main.bbl` 后，仅跑一轮 XeLaTeX 时出现 **Citation undefined** 属于正常现象；请以 **`latexmk`** 或 **`xelatex → bibtex → xelatex → xelatex`** 完整跑通，直至不再报未定义引用。

### 3.3 为何使用 `latexmk -g`

切换快速 / 定稿往往只增删 **`thesis.fast.build`**，latexmk 可能不把它当作 `main.tex` 的依赖而**跳过**一次编译。**`-g`** 强制重跑。`compile-fast.sh` 与 `compile-final.sh` 已内置 **`latexmk -g -xelatex`**。

若手动创建或删除了标记文件，请执行：

```bash
latexmk -g -xelatex main.tex
```

### 3.4 清理

| 方式 | 作用 |
|:--|:--|
| `./clean.sh` | 删除常见辅助文件（默认保留 `main.pdf`；`--pdf` 可一并删除 PDF） |
| `latexmk -C` | 按 latexmk 规则清理 |

---

## 4. 仓库结构

### 4.1 正文（`content/`）

与 `main.tex` 中 `\input{content/…}` 顺序一致。

| # | 文件 | 说明 |
|:--:|:--|:--|
| 00 | `00-cover.tex` | 封面 |
| 01 | `01-declaration.tex` | 原创性声明与版权使用授权 |
| 02 | `02-titlepage.tex` | 扉页 |
| 03 | `03-abstract-cn.tex` | 中文摘要与关键词 |
| 04 | `04-abstract-en.tex` | 英文摘要与 Keywords |
| 05 | `05-table-of-contents.tex` | 目录 |
| 06 | `06-ch1-intro.tex` | 第一章 绪论 |
| 07 | `07-ch2-theory.tex` | 第二章 相关方法与理论基础 |
| 08 | `08-ch3-body.tex` | 第三章 **基于数据预测的智能分析方法** |
| 09 | `09-ch4-body.tex` | 第四章 **基于异常检测的故障诊断方法** |
| 10 | `10-ch5-conclusion.tex` | 第五章 总结与展望 |
| 11 | `11-references.tex` | 参考文献章 |
| 12 | `12-achievements.tex` | 攻读硕士期间科研成果（按学校格式自行填写） |
| 13 | `13-acknowledgments.tex` | 致谢 |

### 4.2 其他路径

| 路径 | 说明 |
|:--|:--|
| `main.tex` | 导言区、`thesis.fast.build` 与插图宏、`\input` 顺序、学籍与封面信息宏（如 `\gzuStudentID`）、`\nocite` 等 |
| `bst/gbt7714-numerical-local.bst` | GB/T 7714 数字编码著录样式（本地拷贝） |
| `figures/ch1/` … `figures/ch4/` | 插图检索路径（见 `main.tex` 中 `\graphicspath`） |
| `.latexmkrc` | `latexmk` 主文件与 `$bibtex_use` 等 |

**修改论文元信息**：在 `main.tex` 中编辑学校/个人信息相关宏；摘要正文在 `content/03-abstract-cn.tex` 与 `content/04-abstract-en.tex`。

若本机另有 **`import/`**、**`code/converter/`** 或 **`content/references/`**（文献 PDF 归档等），属个人扩展，以你本地目录为准；模板不依赖这些路径即可完整编译。

---

## 5. 根目录编译产物（`main.*`）

**长期保留：** `main.tex`（源）、`main.pdf`（成品，是否纳入版本库依课题组规定）。

**多为可再生成：** 删掉后重新 `latexmk` 即可；建议配合 `.gitignore`，不要把辅助文件当「手改源」。

### 5.1 源与输出

| 文件 | 说明 |
|:--|:--|
| `main.tex` | 主控文档，需版本管理 |
| `main.pdf` | 交付与打印 |

### 5.2 辅助与日志

| 文件 | 说明 |
|:--|:--|
| `main.aux` | 交叉引用、目录、`citation` 等；BibTeX 依赖 |
| `main.bbl`、`main.blg` | BibTeX 输出与 BibTeX 日志 |
| `main.log` | 完整编译日志，排错优先查看 |
| `main.toc` | 目录缓存 |
| `main.out` | PDF 书签（hyperref） |
| `main.fls`、`main.fdb_latexmk` | latexmk 依赖追踪 |
| `main.synctex.gz`（若有） | 源码与 PDF 正反向同步 |

### 5.3 中间文件

| 文件 | 说明 |
|:--|:--|
| `main.xdv` | XeTeX 驱动输出，`xdvipdfmx` 生成 PDF |
