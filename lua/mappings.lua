require "nvchad.mappings"

---- [delete key map]
local nomap = vim.keymap.del
nomap("n", "<A-i>")
-- global lsp mappings
nomap("n", "<leader>ds")
-- tabufline new buf
nomap("n", "<leader>b")
-- nvimtree NvimTreeToggle
nomap("n", "<C-n>")
-- nomap("t", "<A-i")

-- telescope
nomap("n", "<leader>fw")
nomap("n", "<leader>fb")
nomap("n", "<leader>fh")
nomap("n", "<leader>ma")
nomap("n", "<leader>fo")
nomap("n", "<leader>fz")
nomap("n", "<leader>cm")
nomap("n", "<leader>gt")
nomap("n", "<leader>pt")
nomap("n", "<leader>th")
nomap("n", "<leader>ff")
nomap("n", "<leader>fa")
nomap("n", "<leader>fm")

-- horizontal term
nomap("n", "<leader>h")

-------------------- add yours here
local map = vim.keymap.set
local wk = require("which-key")

-- float Terminal
map({ "n", "t" }, "<A-3>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "Terminal Toggle Floating term" })

-- horizontal Terminal
map("n", "<A-1>", function()
  require("nvchad.term").new { pos = "sp" }
end, { desc = "terminal new horizontal term" })

-- move
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move current line / block with Alt-j/k ala vscode" })
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move current line / block with Alt-j/k ala vscode" })

-- nvim-tree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Explorer" })


-- goto-preview
wk.register({
  g = {
    name = "goto-preview",
    pd = { "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", "Preview Definition" },
    pt = { "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", "Preview Type" },
    pi = { "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", "Preview Implementation" },
    P = { "<cmd>lua require('goto-preview').close_all_win()<CR>", "Close All Preview Windows" },
  },
})

-- git keymap
-- get keymap from gitsigns see configs.gitsigns
-- git keymap from Telescope
wk.register({
  g = {
    name = "Git",
    g = { "<cmd>lua require 'lvim.core.terminal'.lazygit_toggle()<cr>", "Lazygit" },
    j = { "<cmd>lua require 'gitsigns'.nav_hunk('next', {navigation_message = false})<cr>", "Next Hunk" },
    k = { "<cmd>lua require 'gitsigns'.nav_hunk('prev', {navigation_message = false})<cr>", "Prev Hunk" },
    l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
    L = { "<cmd>lua require 'gitsigns'.blame_line({full=true})<cr>", "Blame Line (full)" },
    p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    u = {
      "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
      "Undo Stage Hunk",
    },
    o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
    C = {
      "<cmd>Telescope git_bcommits<cr>",
      "Checkout commit(for current file)",
    },
    d = {
      "<cmd>Gitsigns diffthis HEAD<cr>",
      "Git Diff",
    },
  },

}, { prefix = "<leader>" })
-- map('n', '<leader>go', "<cmd>Telescope git_status<cr>", { desc = "Open changed file" })
-- map('n', '<leader>gb', "<cmd>Telescope git_branches<cr>", {desc = "Checkout branch" })
-- map('n', '<leader>gc', "<cmd>Telescope git_commits<cr>", {desc = "Checkout commit" })

-- symbols-outline
map('n', '<A-t>', ':SymbolsOutline<cr>', { desc = "Triggle SymbolsOutline" })

-- lsp stuff
map('n', 'K', "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = 'Show hover' })
wk.register({
  g = {
    name = "goto",
    d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Goto Definition" },
    D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Goto Declaration" },
    r = { "<cmd>lua vim.lsp.buf.references()<cr>", "Goto References" },
    I = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Goto Implementation" },
    s = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Show Signature Help" },
    l = { function()
      local float = vim.diagnostic.config().float
      if float then
        local config = type(float) == "table" and float or {}
        config.scope = "line"
        vim.diagnostic.open_float(config)
      end
    end, "Show Line Diagnostics" },
    R = { function()
      local builtin = require 'telescope.builtin'
      local themes = require 'telescope.themes'
      local opts = themes.get_dropdown {
        layout_strategy = "horizontal",
        layout_config = {
          width = 0.8,
          height = 0.9,
          preview_cutoff = 1,
          preview_width = 0.7,
          prompt_position = "top",
        },
        sorting_strategy = "ascending",
        ignore_filename = false,
        show_line = false,
        previewer = true,
      }
      builtin.lsp_references(opts)
    end, "Tele References" },
  },
})

wk.register({
  l = {
    name = "LSP",
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    d = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
    w = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
    f = { function()
      require("conform").format { lsp_fallback = true }
    end, "format files" },
    i = { "<cmd>LspInfo<cr>", "Info" },
    I = { "<cmd>Mason<cr>", "Mason Info" },
    j = {
      "<cmd>lua vim.diagnostic.goto_next()<cr>",
      "Next Diagnostic",
    },
    k = {
      "<cmd>lua vim.diagnostic.goto_prev()<cr>",
      "Prev Diagnostic",
    },
    l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
    q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
    r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    S = {
      "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
      "Workspace Symbols",
    },
    e = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
  },

}, { prefix = "<leader>" })

-- hop keymap see init.lua


-- buffer
wk.register({
  b = {
    name = "Buffers",
    f = { "<cmd>Telescope buffers<CR>", "telescope find buffers" }
  }
}, { prefix = "<leader>" })

-- search
map("n", "<leader>f", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
wk.register({
  s = {
    name = "Search",
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
    C = { "<cmd>Telescope commands<cr>", "Commands" },
    f = { "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", "telescope find all files" },
    h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
    H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
    k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    l = { "<cmd>Telescope resume<cr>", "Resume last search" },
    -- marks
    m = { "<cmd>Telescope marks<CR>", "telescope find marks" },
    M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    p = { "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
      "Colorscheme with Preview",
    },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    R = { "<cmd>Telescope registers<cr>", "Registers" },
    t = { "<cmd>Telescope live_grep<CR>", "telescope live grep" },
  }
}, { prefix = "<leader>" })

-- Lazy
wk.register({
  p = {
    name = "Plugins",
    i = { "<cmd>Lazy install<cr>", "Install" },
    s = { "<cmd>Lazy sync<cr>", "Sync" },
    S = { "<cmd>Lazy clear<cr>", "Status" },
    c = { "<cmd>Lazy clean<cr>", "Clean" },
    u = { "<cmd>Lazy update<cr>", "Update" },
    p = { "<cmd>Lazy profile<cr>", "Profile" },
    l = { "<cmd>Lazy log<cr>", "Log" },
    d = { "<cmd>Lazy debug<cr>", "Debug" },
  }
}, { prefix = "<leader>" })
