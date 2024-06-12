return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
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


  -- CUSTOM:
  {
    'rust-lang/rust.vim',
    lazy = true,
    ft = 'rust'
  },
  {
    "simrat39/rust-tools.nvim",
    config = function()
      local rt = require("rust-tools")
      rt.setup({
        server = {
          on_attach = function(_, bufnr)
            -- Hover actions
            -- vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
            vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
          end,
        },
      })
    end
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
    config = function()
      require 'marks'.setup {
        -- whether to map keybinds or not. default true
        default_mappings = true,
        -- which builtin marks to show. default {}
        builtin_marks = { ".", "<", ">", "^" },
        -- whether movements cycle back to the beginning/end of buffer. default true
        cyclic = true,
        -- whether the shada file is updated after modifying uppercase marks. default false
        force_write_shada = false,
        -- how often (in ms) to redraw signs/recompute mark positions.
        -- higher values will have better performance but may cause visual lag,
        -- while lower values may cause performance penalties. default 150.
        refresh_interval = 250,
        -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
        -- marks, and bookmarks.
        -- can be either a table with all/none of the keys, or a single number, in which case
        -- the priority applies to all marks.
        -- default 10.
        sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
        -- disables mark tracking for specific filetypes. default {}
        excluded_filetypes = {},
        -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
        -- sign/virttext. Bookmarks can be used to group together positions and quickly move
        -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
        -- default virt_text is "".
        bookmark_0 = {
          sign = "p",
          virt_text = "hello world"
        },
        mappings = {}
      }
  end
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
      local status_ok, hop = pcall(require, "hop")
      if not status_ok then
        return
      end
      hop.setup()
      require("hop").setup { keys = 'etovxqpdygfblzhckisuran' }    
    end
  },
  {
    -- ranger
    'kevinhwang91/rnvimr',
  },
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
}
