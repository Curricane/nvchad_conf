-- 看「已经提交的改动」用的小工具（零插件，靠 git 自身 + fzf-lua）
--
-- 为什么需要它：fzf-lua 的 git_commits 默认 preview 就是 `git show`，但
--   * 回车（默认 action）是 git checkout —— 会把 HEAD 切走，不是「看」
--   * preview 窗口太小/不能滚动查找
-- 所以这里把 picker 的 enter 改成「在新 tab 里打开可滚动的 diff」，
-- 并补一个 :GitShow 命令 + lazygit 浮动终端。
--
-- 映射（见 lua/mappings.lua）：
--   <leader>gc  commit 列表（enter 看完整 diff，<C-d> 看该 commit 改了哪些文件）
--   <leader>gC  当前文件的历史 commit（enter 看该文件在那一刻的 diff）
--   <leader>gv  HEAD 这个 commit 的 diff（“我刚提交了什么”）
--   <leader>gg  lazygit（浏览/操作 commit 最舒服的方式）
--   <leader>gd  gitsigns 的 diffthis HEAD（工作区 vs HEAD）

local M = {}

local api = vim.api

---@param str string?
---@return string?
local function strip_ansi(str)
  if not str then
    return nil
  end
  return (str:gsub("\27%[[%d;]*m", ""))
end

---@return boolean
local function in_git_repo()
  vim.fn.system { "git", "rev-parse", "--git-dir" }
  return vim.v.shell_error == 0
end

---跑一条 git 命令，失败时通知并返回 nil
---@param args string[]
---@return string[]?
local function git_lines(args)
  local out = vim.fn.systemlist(args)
  if vim.v.shell_error ~= 0 then
    vim.notify(table.concat(out, "\n"), vim.log.levels.ERROR, { title = "git" })
    return nil
  end
  return out
end

---在新 tab 里用只读 diff buffer 展示文本
---@param lines string[]
---@param title string
local function open_diff_tab(lines, title)
  vim.cmd "tabnew"
  local buf = api.nvim_get_current_buf()
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].undolevels = -1
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "diff"
  vim.wo.foldmethod = "manual" -- diff buffer 默认会被当成 diff mode 折叠，这里不折
  vim.wo.wrap = false
  pcall(api.nvim_buf_set_name, buf, ("git-show:%s"):format(title))
  vim.keymap.set("n", "q", "<cmd>tabclose<cr>", { buffer = buf, desc = "Close commit diff" })
  vim.keymap.set("n", "<Esc>", "<cmd>tabclose<cr>", { buffer = buf, desc = "Close commit diff" })
  api.nvim_echo({ { ("git show %s"):format(title) } }, false, {})
end

---打开某个 commit 的 diff（file 给定时只看该文件）
---@param rev string?  默认 HEAD
---@param file string? 只过滤这个路径
function M.show(rev, file)
  rev = (rev ~= nil and rev ~= "") and rev or "HEAD"
  if not in_git_repo() then
    vim.notify("当前目录不是 git 仓库", vim.log.levels.WARN, { title = "git" })
    return
  end
  local args = { "git", "--no-pager", "show", "--stat", "--patch", "--color=never", rev }
  if file then
    vim.list_extend(args, { "--", file })
  end
  local lines = git_lines(args)
  if not lines then
    return
  end
  open_diff_tab(lines, file and ("%s -- %s"):format(rev, file) or rev)
end

---@param line string?
---@return string? sha
local function sha_from(line)
  return strip_ansi(line):match "(%x%x%x%x%x%x%x%x*)"
end

-- git 空树（用于 root commit：没有 parent 时没法用 <rev>^!）
local EMPTY_TREE = "4b825dc642cb6eb9a060e54bf8d69288fbee4904"

---@param rev string
---@return boolean
local function has_parent(rev)
  local out = vim.fn.systemlist { "git", "rev-list", "--parents", "-n", "1", rev }
  local fields = vim.split(out[1] or "", "%s+", { trimempty = true })
  return #fields >= 2
end

---左右对照看某个 commit 的改动（diffview.nvim）
---@param rev string?  默认 HEAD
---@param file string? 只看这个路径
function M.diffview(rev, file)
  rev = (rev ~= nil and rev ~= "") and rev or "HEAD"
  if not in_git_repo() then
    vim.notify("当前目录不是 git 仓库", vim.log.levels.WARN, { title = "git" })
    return
  end
  -- <rev>^! 就是 “这个 commit 引入的改动”；root commit 没 parent，用空树替代
  local range = has_parent(rev) and (rev .. "^!") or (EMPTY_TREE .. ".." .. rev)
  local cmd = "DiffviewOpen " .. range
  if file then
    cmd = cmd .. " -- " .. vim.fn.fnameescape(file)
  end
  vim.cmd(cmd)
end

---工作区 ↔ HEAD（所有未提交的改动，左右对照，能直接 stage hunk）
---@param rev string?
function M.worktree(rev)
  vim.cmd(("DiffviewOpen %s"):format(rev or "HEAD"))
end

---@param ref string
---@return boolean
local function ref_exists(ref)
  vim.fn.system { "git", "rev-parse", "--verify", "--quiet", ref .. "^{commit}" }
  return vim.v.shell_error == 0
end

---自动推断“基准分支”（PR 里的 base）：优先 origin 的默认分支，再退到 master/main
---@return string?
function M.default_base()
  local out = vim.fn.systemlist { "git", "symbolic-ref", "--short", "refs/remotes/origin/HEAD" }
  if vim.v.shell_error == 0 and out[1] and out[1] ~= "" then
    return out[1]
  end
  for _, ref in ipairs { "master", "main", "origin/master", "origin/main" } do
    if ref_exists(ref) then
      return ref
    end
  end
end

---当前分支 ↔ base 的左右对照（三点 = merge-base，只看“你这条分支的改动”，适合 review）
---@param base string? 默认自动推断 master/main
---@param file string? 只看这个路径
function M.branch_diff(base, file)
  if not in_git_repo() then
    vim.notify("当前目录不是 git 仓库", vim.log.levels.WARN, { title = "git" })
    return
  end
  base = (base ~= nil and base ~= "") and base or M.default_base()
  if not base then
    vim.notify(
      "找不到 master/main 分支，手动传一个：:GitBranchDiff <base>",
      vim.log.levels.WARN,
      { title = "git" }
    )
    return
  end
  if not ref_exists(base) then
    vim.notify(("分支/ref 不存在：%s"):format(base), vim.log.levels.WARN, { title = "git" })
    return
  end
  -- 三点：diff 的是 merge-base(base,HEAD) 与 HEAD，不会把 base 上别人的新提交混进来
  local cmd = ("DiffviewOpen %s...HEAD"):format(base)
  if file then
    cmd = cmd .. " -- " .. vim.fn.fnameescape(file)
  end
  vim.cmd(cmd)
end

---选一个分支跟当前分支比（fzf 列表，默认把 master/main 放最上面）
function M.branch_pick()
  local fzf = require "fzf-lua"
  local branches = git_lines { "git", "for-each-ref", "--format=%(refname:short)", "refs/heads", "refs/remotes" }
  if not branches then
    return
  end
  -- origin/HEAD 是符号引用，没意义；去掉它
  branches = vim.tbl_filter(function(b)
    return b ~= "origin" and b ~= "origin/HEAD"
  end, branches)
  local base = M.default_base()
  if base then
    table.sort(branches, function(a, b)
      local a_def, b_def = a == base, b == base
      if a_def ~= b_def then
        return a_def
      end
      return a < b
    end)
  end
  fzf.fzf_exec(branches, {
    prompt = "Branch base> ",
    actions = {
      ["default"] = function(selected)
        if selected and selected[1] then
          M.branch_diff((selected[1]:gsub("%s+$", "")))
        end
      end,
    },
  })
end

---文件历史浏览器（commit 列表 + 文件树 + 左右对照）
---@param file string? 只看这个文件
function M.history(file)
  vim.cmd(("DiffviewFileHistory %s"):format(file and vim.fn.fnameescape(file) or ""))
end

function M.close()
  vim.cmd "DiffviewClose"
end

---commit 列表 → 回车左右对照看这个 commit，<C-d> 看它改了哪些文件
function M.commits()
  local fzf = require "fzf-lua"
  fzf.git_commits {
    actions = {
      ["enter"] = function(selected)
        local sha = sha_from(selected and selected[1])
        if sha then
          M.diffview(sha)
        end
      end,
      ["ctrl-d"] = function(selected, opts)
        local sha = sha_from(selected and selected[1])
        if sha then
          M.commit_files(sha, opts)
        end
      end,
    },
  }
end

---某个 commit 改动的文件列表（enter = 左右对照看该文件在这个 commit 里的 diff）
---@param rev string
---@param opts table? fzf-lua 的运行期 opts（从 action 回调透传）
function M.commit_files(rev, opts)
  local fzf = require "fzf-lua"
  local path = require "fzf-lua.path"
  fzf.git_diff {
    ref = rev,
    ref1 = rev .. "~",
    winopts = opts and opts.winopts or nil,
    actions = {
      ["enter"] = function(selected, o)
        local file = path.entry_to_file(selected[1], o).path
        M.diffview(rev, file)
      end,
    },
  }
end

---当前 buffer 的历史 commit（enter = 左右对照看该文件那一刻的改动）
function M.bcommits()
  local fzf = require "fzf-lua"
  local rel = vim.fn.expand "%:."
  fzf.git_bcommits {
    actions = {
      ["enter"] = function(selected)
        local sha = sha_from(selected and selected[1])
        if sha then
          M.diffview(sha, rel)
        end
      end,
    },
  }
end

---lazygit 浮动终端（再按一次 <leader>gg 或 <C-q> 关掉）
function M.lazygit()
  -- 已经开着就关掉（toggle）
  for _, win in ipairs(api.nvim_list_wins()) do
    if vim.b[api.nvim_win_get_buf(win)].git_view_lazygit then
      api.nvim_win_close(win, true)
      return
    end
  end

  if vim.fn.executable "lazygit" ~= 1 then
    vim.notify("lazygit 没装", vim.log.levels.WARN, { title = "git" })
    return
  end

  local width = math.max(20, math.floor(vim.o.columns * 0.9))
  local height = math.max(10, math.floor(vim.o.lines * 0.85))
  local buf = api.nvim_create_buf(false, true)
  local win = api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
  })
  vim.b[buf].git_view_lazygit = true
  vim.wo[win].winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder"

  vim.fn.jobstart({ "lazygit" }, {
    term = true,
    on_exit = function()
      pcall(api.nvim_win_close, win, true)
    end,
  })
  vim.keymap.set("t", "<C-q>", function()
    pcall(api.nvim_win_close, win, true)
  end, { buffer = buf, desc = "Close lazygit" })
  vim.cmd "startinsert"
end

return M
