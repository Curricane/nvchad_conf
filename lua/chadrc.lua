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
  -- lazyload it when there are 1+ buffers
  tabufline = {
    enabled = true,
    lazyload = false,
    order = { "treeOffset", "buffers", "tabs", "btns" },
    modules = nil,
  },
}

return M
