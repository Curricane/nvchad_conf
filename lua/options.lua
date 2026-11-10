require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

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
