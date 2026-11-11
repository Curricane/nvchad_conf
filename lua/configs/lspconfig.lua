-- LSP 策略：默认不自动启动任何 LSP，全部按需用 <leader>lt 拉起 / 关闭
-- （rust 走 rustaceanvim，lua 走 lua_ls，见 start_for_buffer）

local M = {}

-- NvChad 的 defaults() 里会 vim.lsp.enable "lua_ls"（自动挂载），先拿它的 capabilities/on_attach 等默认值
require("nvchad.configs.lspconfig").defaults()

local lua_ls_bin = vim.fn.expand "~/.local/share/nvim/mason/bin/lua-language-server"

-- mason 装的 lua-language-server 不在 PATH 里，必须写绝对路径，否则 spawn 失败
vim.lsp.config("lua_ls", { cmd = { lua_ls_bin } })

-- 关键：把 NvChad 默认的自动启动关掉，改成手动
vim.lsp.enable("lua_ls", false)

-- filetype -> LSP server（按需扩展）
local ft_servers = {
  lua = "lua_ls",
}

--- 给当前 buffer 手动启动对应的 LSP
---@param buf? integer
---@return boolean ok, string info
function M.start_for_buffer(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  local server = ft_servers[ft]
  if not server then
    return false, "no LSP configured for ft=" .. ft
  end

  local cfg = vim.lsp.config[server]
  if not cfg or not cfg.cmd then
    return false, server .. ": config unavailable"
  end

  local root = vim.fs.root(buf, cfg.root_markers or { ".git" }) or vim.fn.getcwd()
  local id = vim.lsp.start(vim.tbl_deep_extend("force", {}, cfg, { root_dir = root }), { bufnr = buf })
  if not id then
    return false, server .. ": failed to start"
  end
  return true, server
end

-- 退出时直接 kill 掉 LSP 进程，不等 graceful shutdown，:q 更快
vim.api.nvim_create_autocmd("VimLeavePre", {
  desc = "lsp: force stop clients on exit",
  callback = function()
    for _, client in ipairs(vim.lsp.get_clients()) do
      vim.lsp.stop_client(client.id, true)
    end
  end,
})

return M
