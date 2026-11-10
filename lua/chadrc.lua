-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "onedark",
  --
  -- -- hl_override = {
  -- -- 	Comment = { italic = true },
  -- -- 	["@comment"] = { italic = true },
  -- -- },
  --  nvdash = {
  --    load_on_startup = false,
  --
  --    header = {
  --        "           ▄ ▄                   ",
  --        "       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     ",
  --        "       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     ",
  --        "    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     ",
  --        "  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ",
  --        "  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄",
  --        "▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █",
  --        "█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █",
  --        "    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    ",
  --      },
  --
  --      buttons = {
  --        { "  Find File", "Spc f  ", "Telescope find_files" },
  --        { "󰈚  Recent Files", "Spc s r", "Telescope oldfiles" },
  --        { "󰈭  Find Word", "Spc s t", "Telescope live_grep" },
  --        { "  Bookmarks", "Spc s m", "Telescope marks" },
  --        { "  Themes", "Spc s c", "Telescope themes" },
  --        { "  Mappings", "Spc c h", "NvCheatsheet" },
  --      },
  --  }
  -- nvdash 默认按钮用的是 Telescope 命令，Telescope 已经被 fzf-lua 取代，这里重写
  -- keys 是 dash buffer 内的局部快捷键，不需要 leader
  nvdash = {
    load_on_startup = true,
    buttons = {
      { txt = "  Find File", keys = "f", cmd = "FzfLua files" },
      { txt = "  Recent Files", keys = "o", cmd = "FzfLua oldfiles" },
      { txt = "  Find Word", keys = "g", cmd = "FzfLua live_grep" },
      { txt = "  Marks", keys = "m", cmd = "FzfLua marks" },
      { txt = "  Themes", keys = "t", cmd = ":lua require('nvchad.themes').open()" },
      { txt = "  Mappings", keys = "c", cmd = "NvCheatsheet" },

      { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },

      {
        txt = function()
          local stats = require("lazy").stats()
          local ms = math.floor(stats.startuptime) .. " ms"
          return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
        end,
        hl = "NvDashFooter",
        no_gap = true,
        content = "fit",
      },

      { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
    },
  },
  -- lazyload it when there are 1+ buffers
  tabufline = {
    enabled = true,
    lazyload = false,
    order = { "treeOffset", "buffers", "tabs", "btns" },
    modules = nil,
  },
}

return M
