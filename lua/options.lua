require "nvchad.options"

-- nvim-treesitter master 与 Nvim 0.12 的 captures 参数不兼容，必须尽早装 shim
-- （在 nvim-treesitter 被加载之前，即启动阶段）
require "configs.ts_compat"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

-- 三方插件（rustaceanvim、blink.cmp 1.10.2）还在用 nvim 0.12 已废弃的旧式调用
-- client.request(...) / client.notify(...)，每次起 LSP 都会弹一次
-- "client.request is deprecated" 的提示。这些调用本身仍然可用（内部会转发到方法式），
-- 所以只静音这一类别，其它 nvim 自己的 deprecation 提示照常显示。
local orig_deprecate = vim.deprecate
vim.deprecate = function(name, alternative, version, plugin, backtrace)
  if (plugin == nil or plugin == "Nvim") and type(name) == "string" and name:match "^client%." then
    return
  end
  return orig_deprecate(name, alternative, version, plugin, backtrace)
end

-- 大文件（> 2MB）不写 undo/swap 文件。
-- 背景：~/.local/state/nvim/undo 里曾有一个 25G 的 undo 文件（target/scheduler.log），
-- 这类日志/生成文件的 undo 历史既没用，又会拖慢打开和退出。
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("bigfile_no_undo", { clear = true }),
  callback = function(args)
    local name = vim.api.nvim_buf_get_name(args.buf)
    local size = name ~= "" and vim.fn.getfsize(name) or 0
    local is_log = name:match("%.log$") ~= nil
    if is_log or size > 2 * 1024 * 1024 then
      vim.bo[args.buf].undofile = false
      vim.bo[args.buf].swapfile = false
    end
  end,
})
