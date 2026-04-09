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
    version = "^9",
    lazy = true,
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
  {
    "itchyny/vim-cursorword",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.cursorword"
    end,
  },
  { "ray-x/lsp_signature.nvim", event = "LspAttach", dependencies = { "nvim-lspconfig" } },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
    config = function()
      require("trouble").setup {}
    end,
  },
  {
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline", "SymbolsOulineOpen" },
    opts = require "configs.symbols-outline",
    config = function(_, opts)
      require("symbols-outline").setup(opts)
    end,
  },
  { "rmagatti/goto-preview", event = "BufEnter", config = true },
  {
    "chentoast/marks.nvim",
    event = "BufReadPre",
    config = function()
      require "configs.marks"
    end,
  },
  { "dstein64/nvim-scrollview", event = "BufReadPre" },
  {
    "phaazon/hop.nvim",
    branch = "v2",
    keys = { "f", "F" },
    config = function()
      require "configs.hop"
    end,
  },
  { "kevinhwang91/rnvimr", cmd = "RnvimrToggle" },
  {
    "luozhiya/fittencode.nvim",
    event = "InsertEnter",
    config = function()
      require("fittencode").setup {
        inline = {
          enable = true,
          auto_trigger = true,
          disable_when_backspace = false,
          accept_mode = "commit", -- or "stage"
        },
        source = {
          enable = false, -- Disable source completion if it's a separate feature
        },
        keymaps = {
          inline = {
            ["<TAB>"] = "accept_all_suggestions",
            ["<A-l>"] = "accept_line",
            ["<A-Down>"] = "revoke_line",
            ["<C-Left>"] = "revoke_word",
            ["<A-j>"] = "triggering_completion",
          },
        },
      }
    end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    opts = require "configs.avante",
    build = "make",
    keys = {
      {
        "<leader>a+",
        function()
          local tree_ext = require "avante.extensions.nvim_tree"
          tree_ext.add_file()
        end,
        desc = "Select file in NvimTree",
        ft = "NvimTree",
      },
      {
        "<leader>a-",
        function()
          local tree_ext = require "avante.extensions.nvim_tree"
          tree_ext.remove_file()
        end,
        desc = "Deselect file in NvimTree",
        ft = "NvimTree",
      },
    },
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "HakonHarnes/img-clip.nvim",
        enabled = false, -- Disabled by default, toggle with :ToggleImagePaste
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = { insert_mode = true },
            use_absolute_path = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
  },
}

