# 看 git 改动的方式（含已提交的 commit）

分两类：**没提交的** 走 gitsigns，**已提交的** 走 `configs/git_view.lua`（git show 到只读 diff buffer）+ lazygit。

## 已提交的改动

| 按键 / 命令 | 作用 |
| --- | --- |
| `<leader>gc` | commit 列表（preview 就是 diff）→ **回车**在新 tab 打开完整 diff；**`<C-d>`** 看这个 commit 改了哪些文件 |
| `<leader>gC` | 当前文件的历史 commit → 回车看该文件在那一刻的 diff |
| `<leader>gv` | HEAD 这个 commit 的 diff（"我刚提交了什么"） |
| `:GitShow` | 等于 `<leader>gv` |
| `:GitShow <sha>` | 看任意 commit |
| `:GitShow <sha> <path>` | 只看某个文件在该 commit 里的改动 |
| `<leader>gg` | **lazygit** 浮动窗口（浏览 commit / reset / cherry-pick / stash 最舒服） |

diff tab 里：

- `q` 或 `<Esc>` 关闭
- `]c` / `[c` 跳上/下一个 hunk（`filetype=diff` 自带）
- 只读（`modifiable=false`），不会误改

### 为什么不用 fzf-lua 的默认行为

fzf-lua 的 `git_commits` 默认 **回车 = `git checkout`**（会切走 HEAD，detached），
不是"看"。`configs/git_view.lua` 把 `enter` 换成开 diff tab，
`<C-d>` 换成"这个 commit 的文件列表"，其它默认键（`<C-y>` 复制 sha 等）保留。

另外 `FzfLua git_bcommits` 默认回车是 `git_buf_edit`（把 buffer 内容换到那个版本），
同样改成开 diff，不动当前 buffer。

## 没提交的改动

| 按键 | 作用 |
| --- | --- |
| `<leader>gd` | `Gitsigns diffthis HEAD`：工作区 vs HEAD，左右分屏 |
| `<leader>gp` | 预览当前 hunk |
| `<leader>gj` / `<leader>gk` | 上/下一个 hunk（`target='all'`，staged 的一起算） |
| `<leader>gs` / `<leader>gr` / `<leader>gu` | stage / reset / undo stage 当前 hunk |
| `<leader>gR` | reset 整个 buffer |
| `<leader>gl` / `<leader>gL` | blame 当前行 / 全量 blame |
| `<leader>go` | 改动文件列表（git status） |
| `<leader>gb` | 切分支 |

## 为什么零插件

只需要「能滚动的 diff」的话，`git show --stat --patch` + `filetype=diff` 就够了，
不需要 diffview.nvim / neogit。真要 side-by-side、逐文件树、三方 diff 再装
`sindrets/diffview.nvim`（`<leader>gv` 那种位置留着了）。
