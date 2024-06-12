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

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function opts(desc)
      return { buffer = bufnr, desc = desc }
    end

    local map = vim.keymap.set

    map("n", "<leader>gr", gs.reset_hunk, opts "Reset Hunk")
    map("n", "<leader>gR", gs.reset_buffer, opts "Reset Buffer")
    map("n", "<leader>gp", gs.preview_hunk, opts "Preview Hunk")
    map("n", "<leader>gl", gs.blame_line, opts "Blame Line")
    map("n", "<leader>gd", gs.diffthis, opts "Diff this")
    map("n", "<leader>gj", gs.next_hunk, opts "Next Hunk")
    map("n", "<leader>gk", gs.prev_hunk, opts "Prev Hunk")
  end,
}

return options
