-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()


local servers = { "lua_ls" }
vim.lsp.enable(servers)
