-- lua/core/commands.lua
-- This file contains custom user commands.

vim.api.nvim_create_user_command("ToggleImagePaste", function()
  -- This function uses the lazy.nvim API to toggle a plugin on and off.
  local lazy = require "lazy"
  lazy.toggle "HakonHarnes/img-clip.nvim"

  -- Notify the user about the current state.
  -- We need to get the plugin spec to check its `enabled` status.
  local plugin = lazy.get_plugin "HakonHarnes/img-clip.nvim"
  if plugin.spec.enabled then
    vim.notify("🖼️ Image paste ENABLED.", vim.log.levels.INFO)
  else
    vim.notify("🖼️ Image paste DISABLED.", vim.log.levels.WARN)
  end
end, { desc = "Toggle the img-clip.nvim plugin for pasting images" })

-- :GitShow [rev] [file] —— 在 tab 里看某个 commit 的 diff（默认 HEAD）
-- 放这里而不是 configs/git_view.lua，是因为 mappings.lua 是 vim.schedule 里加载的，
-- 命令要在启动阶段就可用。
vim.api.nvim_create_user_command("GitShow", function(args)
  require("configs.git_view").show(args.fargs[1], args.fargs[2])
end, { nargs = "*", desc = "Show a commit diff in a tab (default HEAD)" })

-- :GitBranchDiff [base] [file] —— 当前分支 vs base（默认 master/main）的左右对照
vim.api.nvim_create_user_command("GitBranchDiff", function(args)
  require("configs.git_view").branch_diff(args.fargs[1], args.fargs[2])
end, { nargs = "*", desc = "Side-by-side diff of current branch vs base branch" })
