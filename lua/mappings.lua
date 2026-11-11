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

-- picker (fzf-lua)
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
local wk = require "which-key"

-- 浮动终端
-- 注意：Ctrl-` 不是 ASCII 控制字符，普通 xterm 系终端根本不会把它发出来；
-- 只有终端支持 kitty keyboard protocol（kitty / wezterm / ghostty / foot 等）
-- 或者开了 modifyOtherKeys 时 Nvim 才收得到。所以这里用 vim.keymap.set 直接绑，
-- 并且保留 <A-3> 作为任何终端都能用的备选。
local function float_term_toggle()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end

vim.keymap.set({ "n", "t" }, "<C-`>", float_term_toggle, { desc = "Terminal Toggle Floating" })
vim.keymap.set({ "n", "t" }, "<A-3>", float_term_toggle, { desc = "Terminal Toggle Floating (fallback)" })

wk.add {
  -- Terminals & Explorer
  { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Explorer" },
  {
    "<A-1>",
    function()
      require("nvchad.term").new { pos = "sp" }
    end,
    desc = "Terminal New Horizontal",
  },
  -- symbols-outline.nvim 已归档（2024-01 停更），改用 fzf-lua 的文档符号；需要可折叠的树再用 aerial.nvim
  { "<A-t>", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Symbols Outline (fzf-lua)" },

  -- Window & Buffer Management
  { "<leader>b", group = "Buffers" },
  { "<leader>bf", "<cmd>FzfLua buffers<cr>", desc = "Find Buffers" },
  {
    "<leader>bh",
    function()
      require("nvchad.tabufline").closeBufs_at_direction "left"
    end,
    desc = "Close Buffers to the Left",
  },
  {
    "<leader>bl",
    function()
      require("nvchad.tabufline").closeBufs_at_direction "right"
    end,
    desc = "Close Buffers to the Right",
  },

  -- Code Navigation (g for Goto)
  { "g", group = "Goto" },
  { "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "Goto Declaration" },
  { "gI", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "Goto Implementation" },
  {
    "gR",
    function()
      require("lazy").load { plugins = { "fzf-lua" } }
      require("fzf-lua").lsp_references { winopts = { height = 0.85, width = 0.8 } }
    end,
    desc = "LSP References",
  },
  { "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Goto Definition" },
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
    desc = "Show Line Diagnostics",
  },
  { "gr", "<cmd>lua vim.lsp.buf.references()<cr>", desc = "Goto References" },
  { "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", desc = "Show Signature Help" },
  { "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>", desc = "Close All Preview Windows" },
  { "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", desc = "Preview Definition" },
  { "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", desc = "Preview Implementation" },
  { "gpt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", desc = "Preview Type" },

  -- Git：看改动默认用 diffview.nvim（左边文件树 + 左右两页对照）
  -- fzf-lua 的 git_commits 默认回车是 git checkout（会切走 HEAD），所以这里换掉
  { "<leader>g", group = "Git" },
  {
    "<leader>gC",
    function()
      require("configs.git_view").bcommits()
    end,
    desc = "Buffer Commits (side-by-side)",
  },
  { "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Diff index vs worktree" },
  {
    "<leader>gH",
    function()
      require("configs.git_view").history(vim.fn.expand "%:.")
    end,
    desc = "File History (side-by-side)",
  },
  { "<leader>gL", "<cmd>lua require 'gitsigns'.blame_line({full=true})<cr>", desc = "Blame Line (Full)" },
  {
    "<leader>gQ",
    function()
      require("configs.git_view").close()
    end,
    desc = "Close Diffview",
  },
  { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer" },
  { "<leader>gb", "<cmd>FzfLua git_branches<cr>", desc = "Checkout Branch" },
  {
    "<leader>gc",
    function()
      require("configs.git_view").commits()
    end,
    desc = "Commits (side-by-side)",
  },
  {
    "<leader>gd",
    function()
      require("configs.git_view").worktree "HEAD"
    end,
    desc = "Diff worktree vs HEAD",
  },
  { "<leader>ge", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff This File (vs HEAD)" },
  {
    "<leader>gg",
    function()
      require("configs.git_view").lazygit()
    end,
    desc = "Lazygit",
  },
  {
    "<leader>gh",
    function()
      require("configs.git_view").history()
    end,
    desc = "Repo History (side-by-side)",
  },
  -- target='all' 才会连 staged 的 hunk 一起跳；默认是 'unstaged'，会跳过 staged 的改动
  {
    "<leader>gj",
    "<cmd>lua require 'gitsigns'.nav_hunk('next', {target = 'all', navigation_message = false})<cr>",
    desc = "Next Hunk",
  },
  {
    "<leader>gk",
    "<cmd>lua require 'gitsigns'.nav_hunk('prev', {target = 'all', navigation_message = false})<cr>",
    desc = "Prev Hunk",
  },
  { "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "Blame Line" },
  { "<leader>go", "<cmd>FzfLua git_status<cr>", desc = "Open Changed File" },
  { "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", desc = "Preview Hunk" },
  { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk" },
  { "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", desc = "Stage Hunk" },
  { "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk" },
  {
    "<leader>gv",
    function()
      require("configs.git_view").diffview "HEAD"
    end,
    desc = "Last Commit (side-by-side)",
  },
  {
    "<leader>gx",
    function()
      require("configs.git_view").show "HEAD"
    end,
    desc = "Raw git show HEAD (unified)",
  },

  -- LSP
  { "K", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "Show Hover" },
  { "<leader>l", group = "LSP" },
  { "<leader>lI", "<cmd>Mason<cr>", desc = "Mason Info" },
  { "<leader>lS", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", desc = "Workspace Symbols" },
  { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
  { "<leader>ld", "<cmd>FzfLua diagnostics_document<cr>", desc = "Buffer Diagnostics" },
  { "<leader>le", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
  {
    "<leader>lf",
    function()
      require("conform").format { lsp_fallback = true }
    end,
    desc = "Format File",
  },
  { "<leader>li", "<cmd>LspInfo<cr>", desc = "LSP Info" },
  { "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next Diagnostic" },
  { "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic" },
  { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens Action" },
  { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix List" },
  {
    "<leader>lt",
    function()
      local buf = vim.api.nvim_get_current_buf()
      local clients = vim.lsp.get_clients { bufnr = buf }
      if #clients > 0 then
        local names = {}
        for _, c in ipairs(clients) do
          names[#names + 1] = c.name
          vim.lsp.stop_client(c.id)
        end
        vim.notify("LSP stopped: " .. table.concat(names, ", "))
      elseif vim.bo[buf].filetype == "rust" then
        -- rustaceanvim 配了 server.auto_attach = false，所以默认不会自己起
        vim.notify "rust-analyzer starting…"
        require("lazy").load { plugins = { "rustaceanvim" } }
        require("rustaceanvim.lsp").start()
      else
        local ok, info = require("configs.lspconfig").start_for_buffer(buf)
        if ok then
          vim.notify(info .. " starting…")
        else
          vim.notify(info, vim.log.levels.WARN)
        end
      end
    end,
    desc = "Toggle LSP (rust: start/stop rust-analyzer)",
  },
  { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
  { "<leader>ls", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Document Symbols" },
  { "<leader>lw", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },

  -- Search (fzf-lua)
  { "<leader>f", "<cmd>FzfLua files<cr>", desc = "Find Files" },
  { "<leader>s", group = "Search" },
  { "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
  { "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Find Highlight Groups" },
  { "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
  { "<leader>sR", "<cmd>FzfLua registers<cr>", desc = "Registers" },
  { "<leader>sb", "<cmd>FzfLua git_branches<cr>", desc = "Checkout Branch" },
  { "<leader>sc", "<cmd>FzfLua colorschemes<cr>", desc = "Colorscheme" },
  {
    "<leader>sf",
    function()
      require("lazy").load { plugins = { "fzf-lua" } }
      require("fzf-lua").files { fd_opts = "--color=never --type f --hidden --no-ignore --follow --exclude .git" }
    end,
    desc = "Find All Files (incl. hidden)",
  },
  { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Find Help" },
  { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
  { "<leader>sl", "<cmd>FzfLua resume<cr>", desc = "Resume Last Search" },
  { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Find Marks" },
  { "<leader>sp", "<cmd>FzfLua colorschemes<cr>", desc = "Colorscheme with Preview" },
  { "<leader>sr", "<cmd>FzfLua oldfiles<cr>", desc = "Open Recent File" },
  { "<leader>st", "<cmd>FzfLua live_grep<cr>", desc = "Live Grep" },

  -- Lazy Package Manager
  { "<leader>p", group = "Plugins (Lazy)" },
  { "<leader>pS", "<cmd>Lazy clear<cr>", desc = "Status" },
  { "<leader>pc", "<cmd>Lazy clean<cr>", desc = "Clean" },
  { "<leader>pd", "<cmd>Lazy debug<cr>", desc = "Debug" },
  { "<leader>pi", "<cmd>Lazy install<cr>", desc = "Install" },
  { "<leader>pl", "<cmd>Lazy log<cr>", desc = "Log" },
  { "<leader>pp", "<cmd>Lazy profile<cr>", desc = "Profile" },
  { "<leader>ps", "<cmd>Lazy sync<cr>", desc = "Sync" },
  { "<leader>pu", "<cmd>Lazy update<cr>", desc = "Update" },

  -- Visual Mode Line Moving
  { "<A-j>", ":m .+1<CR>==", desc = "Move Line Down", mode = "n" },
  { "<A-k>", ":m .-2<CR>==", desc = "Move Line Up", mode = "n" },
  { "<A-j>", ":m '>+1<CR>gv-gv", desc = "Move Block Down", mode = "v" },
  { "<A-k>", ":m '<-2<CR>gv-gv", desc = "Move Block Up", mode = "v" },
}
