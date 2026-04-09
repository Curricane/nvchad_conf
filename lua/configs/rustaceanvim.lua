-- lua/configs/rustaceanvim.lua
return {
  autostart = false,
  server = {
    settings = function(project_root)
      local ra = require('rustaceanvim.config.server')
      local inner_settings = ra.load_rust_analyzer_settings(project_root, {
        settings_file_pattern = 'rust-analyzer.json'
      })
      return inner_settings
    end,
    default_settings = {
      ["rust-analyzer"] = {
        cargo = {
          loadOutDirsFromCheck = true,
          runBuildScripts = true,
          buildScripts = {
            enable = true,
          },
        },
        checkOnSave = {
          allFeatures = true,
          command = "clippy",
          extraArgs = { "--no-deps" },
        },
        procMacro = {
          enable = true,
        },
      },
    },
  },
}
