require "nvchad.mappings"

-- delete key map
local nomap = vim.keymap.del
nomap("n", "<A-i>")
-- nomap("t", "<A-i")

-- add yours here

local map = vim.keymap.set

--- float Terminal
map({ "n", "t" }, "<A-3>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "Terminal Toggle Floating term" })

--- move
map("n", "<A-k>", ":m .-2<CR>==", {desc = "Move current line / block with Alt-j/k ala vscode"})
map("n", "<A-j>", ":m .+1<CR>==", {desc = "Move current line / block with Alt-j/k ala vscode"})

-- nvim-tree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", {desc = "Explorer"})


map('n', 'gpd', "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { desc = "preview definition" })
map('n', 'gpt', "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", { desc = "preview type" })
map('n', 'gpi', "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",{ desc = "previm impl" })
map('n', 'gP', "<cmd>lua require('goto-preview').close_all_win()<CR>", { desc = "close all preview windows" })

-- git keymap
-- get keymap from gitsigns see configs.gitsigns
-- git keymap from Telescope
map('n', '<leader>go', "<cmd>Telescope git_status<cr>", { desc = "Open changed file" })
map('n', '<leader>gb', "<cmd>Telescope git_branches<cr>", {desc = "Checkout branch" })
map('n', '<leader>gc', "<cmd>Telescope git_commits<cr>", {desc = "Checkout commit" })

-- symbols-outline
map('n', '<A-t>', ':SymbolsOutline<cr>', {desc = "Triggle SymbolsOutline"})

-- lsp stuff
map('n', 'K', "<cmd>lua vim.lsp.buf.hover()<cr>", {desc = 'Show hover'})
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', {desc = 'Goto definition'})
map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', {desc = 'Goto Declaration'})
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', {desc = 'Goto references'})
map('n', 'gI', "<cmd>lua vim.lsp.buf.implementation()<cr>", {desc = "Goto Implementation" })
map('n', 'gs', "<cmd>lua vim.lsp.buf.signature_help()<cr>", {desc = "show signature help" })
map('n', 'gl', function()
  local float = vim.diagnostic.config().float

  if float then
    local config = type(float) == "table" and float or {}
    config.scope = "line"

    vim.diagnostic.open_float(config)
  end
end,
{desc = "Show line diagnostics"})
map('n', 'gR', function()
  local builtin = require 'telescope.builtin'
  local themes = require 'telescope.themes'
  local opts = themes.get_dropdown {
    layout_strategy = "horizontal",
    layout_config = {
      width = 0.8,
      height = 0.9,
      preview_cutoff = 1,
      preview_width = 0.7,
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
    ignore_filename = false,
    show_line = false,
    previewer = true,
  }
  builtin.lsp_references(opts)
end,
{desc = "Tele references"})

-- hop keymap see init.lua
