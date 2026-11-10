return {
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
  { "nvim-treesitter/nvim-treesitter-textobjects", event = "BufReadPre", dependencies = { "nvim-treesitter" } },
  { "romgrk/nvim-treesitter-context", event = "BufReadPre", dependencies = { "nvim-treesitter" } },
  { "rmagatti/goto-preview", event = "BufEnter", config = true },

  -- NvChad 默认的 cmp 源里带 cmp-async-path（上游 2024-02 已归档），这里关掉并从 sources 里摘掉
  { "cmp-async-path", enabled = false },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = vim.tbl_filter(function(s)
        return s.name ~= "async_path"
      end, opts.sources or {})
    end,
  },
}
