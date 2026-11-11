# 看 git 改动的方式（左右对照）

三类操作：**已提交的 commit**、**未提交的改动**、**按文件追历史**。
对照视图统一用 `diffview.nvim`（左边文件树 + 左右两页并排），选 commit 用 fzf-lua。

## 已提交的 commit

| 按键 / 命令 | 作用 |
| --- | --- |
| `<leader>gc` | commit 列表（preview 带 diff）→ **回车**：`DiffviewOpen <sha>^!` 左右对照看这个 commit；**`<C-d>`**：这个 commit 改了哪些文件 |
| `<leader>gv` | 上一个 commit（HEAD）的左右对照 |
| `<leader>gC` | 当前文件的历史 commit → 回车看该文件那一刻的左右对照 |
| `<leader>gh` | 整个仓库的历史浏览器（commit 列表 + 文件树 + 左右对照） |
| `<leader>gH` | 当前文件的历史浏览器 |
| `:GitShow [rev] [path]` | 还是保留一份**纯文本 unified diff**（方便复制/粘贴、grep） |
| `<leader>gx` | 同上，HEAD 的 unified diff |

`DiffviewOpen <sha>^!` 就是 `git show <sha>` 的并排版本；`^!` 表示"这个 commit 引入的改动"。
root commit 没有 parent，代码里自动退化成 `git diff <空树>..<sha>`。

## 未提交的改动

| 按键 | 作用 |
| --- | --- |
| `<leader>gd` | 工作区 ↔ HEAD，左右对照（所有未提交改动，能直接 stage） |
| `<leader>gD` | 工作区 ↔ index（`DiffviewOpen` 无参，分 `Changes` / `Staged changes` 两块） |
| `<leader>ge` | 只在当前文件做双窗 diff（gitsigns `diffthis HEAD`） |
| `<leader>gp` / `gj` / `gk` | 预览 / 下一个 / 上一个 hunk |
| `<leader>gs` / `gr` / `gu` | stage / reset / undo stage 当前 hunk |
| `<leader>gl` / `<leader>gL` | blame 当前行 / 全量 blame |
| `<leader>go` | 改动文件列表（git status） |
| `<leader>gg` | lazygit 浮动窗（`<C-q>` 关闭） |

## diffview 里怎么操作

打开后是 diffview 自己的 tabpage，常用键（都是 buffer-local 默认值）：

| 键 | 作用 |
| --- | --- |
| `q` | 关闭 diffview |
| `<leader>b` | 显示/隐藏文件树（注意：只在 diffview 里覆盖全局的 Buffers） |
| `<leader>e` | 光标跳到文件树 |
| `<Tab>` / `<S-Tab>` | 下一个 / 上一个文件的 diff |
| `o` / `<CR>` | （文件树里）打开该文件的 diff |
| `-` | （文件树里）stage / unstage 整个文件 |
| `S` / `U` | stage 全部 / unstage 全部 |
| `X` | 把文件还原到 index 状态 |
| `R` | 刷新列表 |
| `y` | 复制光标下 commit 的 hash |
| `]c` / `[c` | 上/下一个改动块 |
| `<leader>gQ` | 关掉 diffview（全局也能用） |

## 为什么不是 unified diff

之前的实现是 `git show` 输出塞进只读 buffer（一列显示 `-`/`+`）。
改动的上下文和前后关系得在脑子里拼，多文件 commit 还要滚很久。
现在默认走 diffview，**左旧右新并排**、行内高亮、文件树定位；
`git show` 那个纯文本版本留着（`<leader>gx` / `:GitShow`），复制 patch 时更顺手。

diffview 也顺手把 fzf-lua 的坑填了：`git_commits` 默认回车是 `git checkout`（会切走 HEAD），
`git_bcommits` 默认回车会改写当前 buffer —— 两个都换成了"看"。
