-- lua/configs/fzf-lua.lua
-- Telescope 的替代品：ibhagwan/fzf-lua（依赖系统里的 fzf / rg / fd，本机都有）
-- 用默认 profile（fzf 二进制），故意保持极简，行为尽量贴近原来的 Telescope
return {
  winopts = {
    border = "rounded",
    preview = {
      layout = "vertical",
      vertical = "down:45%",
      wrap = "nowrap",
    },
  },
  keymap = {
    -- fzf 原生动作：<C-q> 全选并打开
    fzf = {
      ["ctrl-q"] = "select-all+accept",
    },
  },
}
