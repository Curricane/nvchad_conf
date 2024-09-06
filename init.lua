vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

vim.g.rustaceanvim = {
  -- 其他配置...
  server = {
    ---@param project_root string Path to the project root
    settings         = function(project_root)
      local ra = require('rustaceanvim.config.server')
      local inner_settings = ra.load_rust_analyzer_settings(project_root, {
        settings_file_pattern = 'rust-analyzer.json'
      })
      -- print(vim.inspect(inner_settings)) -- debug
      return inner_settings
    end,
    default_settings = {
      ["rust-analyzer"] = {
        cargo = {
          -- allFeatures = true,
          loadOutDirsFromCheck = true,
          runBuildScripts = true,
          buildScripts = {
            enable = true,
          },
        },
        -- -- Add clippy lints for Rust.
        checkOnSave = {
          allFeatures = true,
          command = "clippy",
          extraArgs = { "--no-deps" },
        },
        procMacro = {
          enable = true,
        },
        -- diagnostics = {
        --   enable = true,
        --   level = "info", -- 添加日志级别配置
        -- },
        -- logging = {
        --   level = "info",
        -- },
      },
    },
    -- root_dir         = require('lspconfig').util.root_pattern("Cargo.toml", ".git")
  },
}


-- CUSTOM: clipboard set
local os_name = vim.loop.os_uname().sysname
local is_wsl = os.getenv("WSL_DISTRO_NAME") ~= nil

if os_name == "Linux" then
  if is_wsl then
    vim.g.clipboard = {
      name = "WslClipboard",
      copy = {
        ["+"] = "clip.exe",
        ["*"] = "clip.exe",
      },
      paste = {
        ["+"] = "powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace(\"`r\", \"\"))",
        ["*"] = "powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace(\"`r\", \"\"))",
      },
      cache_enabled = 0,
    }
  else
    if vim.fn.executable("clipboard-provider") then
      vim.g.clipboard = {
        name = "myClipboard",
        copy = {
          ["+"] = "clipboard-provider copy",
          ["*"] = "clipboard-provider copy",
        },
        paste = {
          ["+"] = "clipboard-provider paste",
          ["*"] = "clipboard-provider paste",
        },
      }
    end
  end
end
