-- lua/core/commands.lua
-- This file contains custom user commands.

vim.api.nvim_create_user_command(
  "ToggleImagePaste",
  function()
    -- This function uses the lazy.nvim API to toggle a plugin on and off.
    local lazy = require("lazy")
    lazy.toggle("HakonHarnes/img-clip.nvim")
    
    -- Notify the user about the current state.
    -- We need to get the plugin spec to check its `enabled` status.
    local plugin = lazy.get_plugin("HakonHarnes/img-clip.nvim")
    if plugin.spec.enabled then
      vim.notify("🖼️ Image paste ENABLED.", vim.log.levels.INFO)
    else
      vim.notify("🖼️ Image paste DISABLED.", vim.log.levels.WARN)
    end
  end,
  { desc = "Toggle the img-clip.nvim plugin for pasting images" }
)
