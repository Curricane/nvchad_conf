-- lua/configs/hop.lua
-- Configuration for hop.nvim
local hop = require "hop"
hop.setup { keys = 'etovxqpdygfblzhckisuran' }
vim.api.nvim_set_keymap('', 'f', "<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<cr>", {})
vim.api.nvim_set_keymap('', 'F', "<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<cr>", {})
