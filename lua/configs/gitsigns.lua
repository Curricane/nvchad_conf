-- overload nvchad.configs.gitsigns
local options = {
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "󰍵" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "│" },
  },

  -- 注意：这里曾经有一份 buffer-local 的 <leader>g* 映射（gs.next_hunk / gs.prev_hunk ...），
  -- 它们会盖掉 lua/mappings.lua 里的全局定义，而且 next_hunk/prev_hunk 已被 gitsigns
  -- 标记为 @deprecated（默认 target='unstaged'，会跳过已 staged 的 hunk）。
  -- 现在统一由 mappings.lua 的 <leader>gj / <leader>gk 负责（nav_hunk + target='all'）。
}

return options
