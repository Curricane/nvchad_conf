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
map("v", "<A-k>", ":m '<-2<CR>gv-gv", { desc = "Move current block up" })
map("v", "<A-j>", ":m '>+1<CR>gv-gv", { desc = "Move current block up" })

-- nvim-tree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Explorer" })


-- goto-preview
wk.add(
  {
    { "g",  group = "goto" },
    { "gP",  "<cmd>lua require('goto-preview').close_all_win()<CR>",                desc = "Close All Preview Windows" },
    { "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",      desc = "Preview Definition" },
    { "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",  desc = "Preview Implementation" },
    { "gpt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", desc = "Preview Type" },
  }
)

-- git keymap
-- get keymap from gitsigns see configs.gitsigns
-- git keymap from Telescope
wk.add(
  {
    { "<leader>g",  group = "Git" },
    { "<leader>gC", "<cmd>Telescope git_bcommits<cr>",                                                desc = "Checkout commit(for current file)" },
    { "<leader>gL", "<cmd>lua require 'gitsigns'.blame_line({full=true})<cr>",                        desc = "Blame Line (full)" },
    { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>",                                 desc = "Reset Buffer" },
    { "<leader>gb", "<cmd>Telescope git_branches<cr>",                                                desc = "Checkout branch" },
    { "<leader>gc", "<cmd>Telescope git_commits<cr>",                                                 desc = "Checkout commit" },
    { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>",                                                desc = "Git Diff" },
    { "<leader>gg", "<cmd>lua require 'lvim.core.terminal'.lazygit_toggle()<cr>",                     desc = "Lazygit" },
    { "<leader>gj", "<cmd>lua require 'gitsigns'.nav_hunk('next', {navigation_message = false})<cr>", desc = "Next Hunk" },
    { "<leader>gk", "<cmd>lua require 'gitsigns'.nav_hunk('prev', {navigation_message = false})<cr>", desc = "Prev Hunk" },
    { "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>",                                   desc = "Blame" },
    { "<leader>go", "<cmd>Telescope git_status<cr>",                                                  desc = "Open changed file" },
    { "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>",                                 desc = "Preview Hunk" },
    { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",                                   desc = "Reset Hunk" },
    { "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>",                                   desc = "Stage Hunk" },
    { "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",                              desc = "Undo Stage Hunk" },
  }
)
-- map('n', '<leader>go', "<cmd>Telescope git_status<cr>", { desc = "Open changed file" })
-- map('n', '<leader>gb', "<cmd>Telescope git_branches<cr>", {desc = "Checkout branch" })
-- map('n', '<leader>gc', "<cmd>Telescope git_commits<cr>", {desc = "Checkout commit" })

-- symbols-outline
map('n', '<A-t>', ':SymbolsOutline<cr>', { desc = "Triggle SymbolsOutline" })

-- lsp stuff
map('n', 'K', "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = 'Show hover' })
wk.add(
  {
    { "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>",    desc = "Goto Declaration" },
    { "gI", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "Goto Implementation" },
    {
      "gR",
      function()
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
      end,
      desc = "Tele References"
    },
    { "gd", "<cmd>lua vim.lsp.buf.definition()<cr>",     desc = "Goto Definition" },
    {
      "gl",
      function()
        local float = vim.diagnostic.config().float
        if float then
          local config = type(float) == "table" and float or {}
          config.scope = "line"
          vim.diagnostic.open_float(config)
        end
      end,
      desc = "Show Line Diagnostics"
    },
    { "gr", "<cmd>lua vim.lsp.buf.references()<cr>",     desc = "Goto References" },
    { "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", desc = "Show Signature Help" },
  }
)



wk.add(
  {
    { "<leader>l",  group = "LSP" },
    { "<leader>lI", "<cmd>Mason<cr>",                                       desc = "Mason Info" },
    { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",     desc = "Workspace Symbols" },
    { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>",               desc = "Code Action" },
    { "<leader>ld", "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", desc = "Buffer Diagnostics" },
    { "<leader>le", "<cmd>Telescope quickfix<cr>",                          desc = "Telescope Quickfix" },
    {
      "<leader>lf",
      function()
        require("conform").format { lsp_fallback = true }
      end,
      desc = "format files"
    },
    { "<leader>li", "<cmd>LspInfo<cr>",                         desc = "Info" },
    { "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<cr>",  desc = "Next Diagnostic" },
    { "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>",  desc = "Prev Diagnostic" },
    { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>",      desc = "CodeLens Action" },
    { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix" },
    { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>",        desc = "Rename" },
    { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>",  desc = "Document Symbols" },
    { "<leader>lw", "<cmd>Telescope diagnostics<cr>",           desc = "Diagnostics" },
  }
)

-- hop keymap see init.lua


-- buffer
wk.add(
  {
    { "<leader>b",  group = "Buffers" },
    { "<leader>bf", "<cmd>Telescope buffers<CR>", desc = "telescope find buffers" },
    {
      "<leader>bh",
      function()
        require("nvchad.tabufline").closeBufs_at_direction("left")
      end,
      desc = "Close all to the right"
    },
    {
      "<leader>bl",
      function()
        require("nvchad.tabufline").closeBufs_at_direction("right")
      end,
      desc = "Close all to the left"
    },
  }
)

-- search
map("n", "<leader>f", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
wk.add(
  {
    { "<leader>s",  group = "Search" },
    { "<leader>sC", "<cmd>Telescope commands<cr>",                                                    desc = "Commands" },
    { "<leader>sH", "<cmd>Telescope highlights<cr>",                                                  desc = "Find highlight groups" },
    { "<leader>sM", "<cmd>Telescope man_pages<cr>",                                                   desc = "Man Pages" },
    { "<leader>sR", "<cmd>Telescope registers<cr>",                                                   desc = "Registers" },
    { "<leader>sb", "<cmd>Telescope git_branches<cr>",                                                desc = "Checkout branch" },
    { "<leader>sc", "<cmd>Telescope colorscheme<cr>",                                                 desc = "Colorscheme" },
    { "<leader>sf", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",           desc = "telescope find all files" },
    { "<leader>sh", "<cmd>Telescope help_tags<cr>",                                                   desc = "Find Help" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>",                                                     desc = "Keymaps" },
    { "<leader>sl", "<cmd>Telescope resume<cr>",                                                      desc = "Resume last search" },
    { "<leader>sm", "<cmd>Telescope marks<CR>",                                                       desc = "telescope find marks" },
    { "<leader>sp", "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>", desc = "Colorscheme with Preview" },
    { "<leader>sr", "<cmd>Telescope oldfiles<cr>",                                                    desc = "Open Recent File" },
    { "<leader>st", "<cmd>Telescope live_grep<CR>",                                                   desc = "telescope live grep" },
  }
)

-- Lazy
wk.add(
  {
    { "<leader>p",  group = "Plugins" },
    { "<leader>pS", "<cmd>Lazy clear<cr>",   desc = "Status" },
    { "<leader>pc", "<cmd>Lazy clean<cr>",   desc = "Clean" },
    { "<leader>pd", "<cmd>Lazy debug<cr>",   desc = "Debug" },
    { "<leader>pi", "<cmd>Lazy install<cr>", desc = "Install" },
    { "<leader>pl", "<cmd>Lazy log<cr>",     desc = "Log" },
    { "<leader>pp", "<cmd>Lazy profile<cr>", desc = "Profile" },
    { "<leader>ps", "<cmd>Lazy sync<cr>",    desc = "Sync" },
    { "<leader>pu", "<cmd>Lazy update<cr>",  desc = "Update" },
  }
)
