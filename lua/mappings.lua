require "nvchad.mappings"
local M = {}

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


-- plugins key mapping
M.set_hop_keymaps = function()
  vim.api.nvim_set_keymap('', 'f',
    "<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<cr>"
    , {})
  vim.api.nvim_set_keymap('', 'F',
    "<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<cr>"
    , {})
end

M.set_goto_preview = function()
  vim.api.nvim_set_keymap('n', 'gpd', "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
    { desc = "preview definition" })
  vim.api.nvim_set_keymap('n', 'gpt', "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
    { desc = "preview type" })
  vim.api.nvim_set_keymap('n', 'gpi', "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
    { desc = "previm impl" })
  vim.api.nvim_set_keymap('n', 'gP', "<cmd>lua require('goto-preview').close_all_win()<CR>",
    { desc = "close all preview windows" })
end


is_maximized = true
M.toggle_maximize_split = function()
  if is_maximized then
    vim.cmd('wincmd =')
    is_maximized = false
  else
    vim.cmd('wincmd |')
    vim.cmd('wincmd _')
    is_maximized = true
  end
end

vim.api.nvim_set_keymap('n', '<C-w>z', "<cmd>lua require('keybindings').toggle_maximize_split()<CR>", { noremap = true })


return M
