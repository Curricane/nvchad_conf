return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },
  {
    'rust-lang/rust.vim',
    lazy = true,
    ft = 'rust'
  },
  {
    "simrat39/rust-tools.nvim",
    config = require("plugins.rust-tools").config,
    ft = { "rust", "rs" },
  },
  {
    -- A neovim plugin that helps managing crates.io dependencies.
    "saecki/crates.nvim",
    version = "v0.3.0",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup {
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
        popup = {
          border = "rounded",
        },
      }
    end,
  },
  -- nvim-lsp 进程独立应用
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    lazy = true,
    dependencies = { 'nvim-treesitter' }
  },
  {
    'romgrk/nvim-treesitter-context',
    lazy = true,
    dependencies = { 'nvim-treesitter' }
  },

  {
    'itchyny/vim-cursorword',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      vim.api.nvim_command('augroup user_plugin_cursorword')
      vim.api.nvim_command('autocmd!')
      vim.api.nvim_command(
        'autocmd FileType NvimTree,lspsagafinder,dashboard let b:cursorword = 0')
      vim.api.nvim_command(
        'autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif')
      vim.api.nvim_command('autocmd InsertEnter * let b:cursorword = 0')
      vim.api.nvim_command('autocmd InsertLeave * let b:cursorword = 1')
      vim.api.nvim_command('augroup END')
    end
  },
  {
    'ray-x/lsp_signature.nvim',
    lazy = true,
    dependencies = { 'nvim-lspconfig' },
  },
  {
    'folke/trouble.nvim',
    lazy = true,
    cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
    config = function()
      require("trouble").setup {}
    end
  },
  -- {
  --   'simrat39/symbols-outline.nvim',
  --   lazy = true,
  --   cmd = { 'SymbolsOutline', 'SymbolsOulineOpen' },
  --   config = require("user.plugins.symbols-outline").config,
  -- },
  {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {
        require("keybindings").set_goto_preview()
      }
    end
  },

  -- mark 侧边标记
  {
    'chentoast/marks.nvim',
    config = require("plugins.marks").config,
  },

  -- 滚动条
  { 'dstein64/nvim-scrollview' },
  {
    --quick move word
    'phaazon/hop.nvim',
    branch = 'v2',   -- optional but strongly recommended
    -- lazy = true,
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require("plugins.hop").config()
    end
  },
  {
    -- ranger
    'kevinhwang91/rnvimr',
  },
  -- java
  'mfussenegger/nvim-jdtls',
  -- 'rcarriga/nvim-dap-ui',
  -- 'github/copilot.vim',
  {
    'Exafunction/codeium.vim',
    config = function()
      -- Change '<C-g>' here to any keycode you like.
      vim.keymap.set('i', '<M-l>', function() return vim.fn['codeium#Accept']() end, { expr = true })
      vim.keymap.set('i', '<M-]>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
      vim.keymap.set('i', '<M-[>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
      vim.keymap.set('i', '<M-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
    end
  },

  -- These are some examples, uncomment them if you want to see them work!
  -- {
  --   "neovim/nvim-lspconfig",
  --   config = function()
  --     require("nvchad.configs.lspconfig").defaults()
  --     require "configs.lspconfig"
  --   end,
  -- },
  --
  -- {
  -- 	"williamboman/mason.nvim",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"lua-language-server", "stylua",
  -- 			"html-lsp", "css-lsp" , "prettier"
  -- 		},
  -- 	},
  -- },
  --
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
