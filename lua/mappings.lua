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
