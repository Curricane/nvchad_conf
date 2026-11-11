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
  -- treesitter：nvim-treesitter main 分支（为 Nvim 0.12 重写的版本）
  -- main 不支持懒加载，而且高亮/缩进不再自动开启，需要自己启。
  -- parser 安装需要 tree-sitter-cli >= 0.26.1（本机已 cargo install 0.27.2）。
  -- 安装时要从 github.com 拉 grammar tarball，而本机 github.com:443 不通，
  -- 所以把仓库内的 bin/curl 包到 PATH 最前面（把 /archive/ 重写到 codeload）。
  -- 细节见 TREESITTER.md
  -- ==========================================================
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- 让 nvim 内跑的 :TSInstall / :TSUpdate / lazy 的 build 都能拿到 curl 包装
      local shim_dir = vim.fn.stdpath "config" .. "/bin"
      if vim.uv.fs_stat(shim_dir .. "/curl") and not vim.env.PATH:find(shim_dir, 1, true) then
        vim.env.PATH = shim_dir .. ":" .. vim.env.PATH
      end

      require("nvim-treesitter").install {
        "rust",
        "lua",
        "luadoc",
        "printf",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
      }

      -- main 分支：高亮/缩进要显式开（有 parser 的 buffer 才开）
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("ts_start", { clear = true }),
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  { "romgrk/nvim-treesitter-context", event = "BufReadPre", dependencies = { "nvim-treesitter" } },

  { "rmagatti/goto-preview", event = "BufEnter", config = true },
}
