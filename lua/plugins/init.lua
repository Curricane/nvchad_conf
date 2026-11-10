return {
  -- ==========================================================
  -- 补全引擎：nvim-cmp -> blink.cmp
  -- NvChad v2.5 自带的 blink 集成（BETA）：会 enabled=false 掉 nvim-cmp，
  -- 并带上 LuaSnip / friendly-snippets / nvim-autopairs
  -- ==========================================================
  { import = "nvchad.blink.lazyspec" },
  -- 本机到 github releases 的下载通路不通（443 到 github.com 超时），
  -- 所以禁掉 prebuilt binary 下载，改用 blink 自带的 Lua fuzzy matcher
  {
    "saghen/blink.cmp",
    opts = {
      fuzzy = { implementation = "lua" },
      prebuilt_binaries = { download = false },
    },
  },

  -- ==========================================================
  -- picker：Telescope -> fzf-lua
  -- ==========================================================
  { "nvim-telescope/telescope.nvim", enabled = false },
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    opts = require "configs.fzf-lua",
  },

  { "stevearc/conform.nvim", event = "BufWritePre", opts = require "configs.conform" },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = require "configs.gitsigns",
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "git")
      require("gitsigns").setup(opts)
    end,
  },

  -- CUSTOM:
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    event = "FileType rust",
    config = function()
      vim.g.rustaceanvim = require "configs.rustaceanvim"
    end,
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    config = function()
      require("fidget").setup()
    end,
  },

  -- ==========================================================
  -- treesitter（legacy master 分支）
  -- NvChad v2.5 只提供 ensure_installed，从未调用 configs.setup()，
  -- 所以高亮/缩进一直是关的，这里补上。
  -- （main 分支需要 tree-sitter-cli >= 0.26.1 且从 github.com 下载 grammar
  --   tarball，本机 443 到 github.com 被墙，暂不切）
  -- ==========================================================
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "rust", "lua", "luadoc", "printf", "vim", "vimdoc", "markdown", "markdown_inline" },
    },
    config = function()
      require("nvim-treesitter.configs").setup {
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
  },
  { "romgrk/nvim-treesitter-context", event = "BufReadPre", dependencies = { "nvim-treesitter" } },

  { "rmagatti/goto-preview", event = "BufEnter", config = true },
}
