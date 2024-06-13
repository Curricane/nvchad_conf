return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  -- OVERRIDE
  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      return require "configs.gitsigns"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "git")
      require("gitsigns").setup(opts)
    end,
  },


  -- CUSTOM:
  {
    'mrcjkb/rustaceanvim',
    version = '^4', -- Recommended
    lazy = false,   -- This plugin is already lazy
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
  {
    'simrat39/symbols-outline.nvim',
    lazy = true,
    cmd = { 'SymbolsOutline', 'SymbolsOulineOpen' },
    opts = function()
      return require "configs.symbols-outline"
    end,
    config = function(opts)
      require("symbols-outline").setup(opts)
    end,
  },
  {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {}
    end
  },


  -- mark 侧边标记
  {
    'chentoast/marks.nvim',
    lazy = false,
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
    branch = 'v2', -- optional but strongly recommended
    lazy = false,
    -- lazy = true,
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      local status_ok, hop = pcall(require, "hop")
      if not status_ok then
        return
      end
      hop.setup()
      require("hop").setup { keys = 'etovxqpdygfblzhckisuran' }
      vim.api.nvim_set_keymap('', 'f',
        "<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<cr>", {})
      vim.api.nvim_set_keymap('', 'F',
        "<cmd>lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<cr>", {})
    end
  },
  {
    -- ranger
    'kevinhwang91/rnvimr',
  },
  {
    'luozhiya/fittencode.nvim',
    lazy = false,
    config = function()
      require('fittencode').setup({
        keymaps = {
          inline = {
            ['<TAB>'] = 'accept_all_suggestions',
            ['<A-l>'] = 'accept_line',
            ['<C-UP>'] = 'revoke_line',
            ['<C-Left>'] = 'revoke_word',
            ['<A-\\>'] = 'triggering_completion',
          },
        }
      })
    end,
  },
}
