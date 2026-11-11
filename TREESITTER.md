# treesitter 说明（nvim-treesitter main 分支）

## 为什么用 main 分支

Nvim 0.12 改了 treesitter 的若干内部约定，`nvim-treesitter` 的 `master` 分支已经
**封版**（上游只保证与 Nvim 0.11 向后兼容），实测在 0.12 上会炸：

```
Decoration provider "conceal_line":
Lua: .../vim/treesitter.lua:197: attempt to call method 'range' (a nil value)
  .../nvim-treesitter/query_predicates.lua:141: in function 'handler'
```

原因是 directive/predicate handler 的 `captures` 参数：

```
0.11:  { [capture_id] = TSNode }
0.12:  { [capture_id] = TSNode[] }
```

`master` 还把 table 当 node 传给 `get_node_text()`，一到 markdown（hover 弹窗、
代码块注入）就崩。`main` 是为 0.12 重写的版本，且自带匹配的 queries。

## 本机的三件特殊事

1. **tree-sitter-cli ≥ 0.26.1** 是硬性要求（main 用 `tree-sitter build -o parser.so`
   编译 parser）。本机装的是 `cargo install tree-sitter-cli`（0.27.2，在 `~/.cargo/bin`）。

2. **github.com:443 在本机不通**，而 main 的 parser 下载走
   `curl https://github.com/<owner>/<repo>/archive/<sha>.tar.gz`。
   `api.github.com` / `codeload.github.com` 是通的，所以仓库里放了 `bin/curl`：
   把 `/archive/<ref>.tar.gz` 改写成
   `https://codeload.github.com/<owner>/<repo>/tar.gz/<ref>`，其它 URL 原样透传。
   `lua/plugins/init.lua` 里会把 `<config>/bin` 插到 `vim.env.PATH` 最前面，
   因此 nvim 内执行 `:TSInstall` / `:TSUpdate`（以及 lazy 的 `build = ":TSUpdate"`）
   都会用到它。

3. **安装目录**：main 默认装到 `stdpath('data')/site`
   - parser：`~/.local/share/nvim/site/parser/<lang>.so`
   - queries：`~/.local/share/nvim/site/queries/<lang>`（软链到插件的 `runtime/queries`）
   `site` 在 runtimepath 里排在 nvim 自带的 `runtime` 之前，所以 main 的新 query
   会覆盖 nvim 0.12 自带的旧 query（这点很关键：旧 query 配新 parser 会报
   `Invalid field name ...`）。

## 高亮 / 缩进（main 不再自动开启）

`lua/plugins/init.lua` 里：

```lua
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    if pcall(vim.treesitter.start, args.buf) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
```

- 有 parser 的 buffer 才 `start()`（没有就 `pcall` 掉）
- 缩进是 main 里 experimental 的功能，通过 `indentexpr` 挂上

## 常用命令

```vim
:TSInstall rust               " 装 parser（会走 bin/curl）
:TSInstall! rust              " 强制重装
:TSUpdate                     " 更新已安装的 parser
:TSUninstall rust             " 卸载
:TSLog                        " 看安装日志
:checkhealth nvim-treesitter  " 体检
```

想加语言：把名字加进 `lua/plugins/init.lua` 的 `require("nvim-treesitter").install{...}` 列表，
重启后会自动装。

## 排查：装不上怎么办

1. `tree-sitter --version` 必须 ≥ 0.26.1
2. `PATH` 里有 `<config>/bin`（进 nvim 后 `:echo $PATH` 看）
3. 手动验证包装器：
   ```bash
   PATH=~/.config/nvchad_conf/bin:$PATH curl -sS -o /tmp/t.tgz -w '%{http_code}\n' -L \
     https://github.com/tree-sitter-grammars/tree-sitter-printf/archive/<sha>.tar.gz
   ```
   期望 `200`，文件 ~几十 KB。

## 历史遗留

`~/.local/share/nvim/lazy/nvim-treesitter/parser/*.so` 是切 main 之前（master 时代）
留下的旧 parser，现在不会被用到（`site/parser` 优先），位置也没人清理。
想彻底干净可以删掉那个 `parser/` 目录。
