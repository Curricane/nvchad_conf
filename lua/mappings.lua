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
