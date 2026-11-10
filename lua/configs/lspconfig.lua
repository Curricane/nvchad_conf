-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local servers = { "lua_ls" }
vim.lsp.enable(servers)

-- 退出时直接 kill 掉 LSP 进程，不等 graceful shutdown，:q 更快
vim.api.nvim_create_autocmd("VimLeavePre", {
  desc = "lsp: force stop clients on exit",
  callback = function()
    for _, client in ipairs(vim.lsp.get_clients()) do
      vim.lsp.stop_client(client.id, true)
    end
  end,
})
