local M = {}

M.config = function()
  -- local lsp_installer_servers = require "nvim-lsp-installer.servers"
  -- local _, requested_server = lsp_installer_servers.get_server "rust_analyzer"
  -- require("rust-tools").setup({
  --   tools = {
  --     autoSetHints = true,
  --     hover_with_actions = true,
  --     runnables = {
  --       use_telescope = true,
  --     },
  --   },
  --   server = {
  --     -- cmd_env = requested_server._default_options.cmd_env,
  --     on_attach = require("lvim.lsp").common_on_attach,
  --     on_init = require("lvim.lsp").common_on_init,
  --     settings = {
  --       ["rust-analyzer"] = {
  --         assist = {
  --           importEnforceGranularity = true,
  --           importPrefix = "crate"
  --         },
  --         cargo = {
  --           features = "all",
  --         },
  --         checkOnSave = {
  --           -- default: `cargo check`
  --           command = "clippy"
  --         },
  --       },
  --     }
  --   },
  -- })
  --
  --
  local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
  local codelldb_adapter = {
    type = "server",
    port = "${port}",
    executable = {
      command = mason_path .. "bin/codelldb",
      args = { "--port", "${port}" },
      -- On windows you may have to uncomment this:
      -- detached = false,
    },
  }
  local opts = {
    tools = {
      executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
      reload_workspace_from_cargo_toml = true,
      runnables = {
        use_telescope = true,
      },
      inlay_hints = {
        auto = true,
        only_current_line = false,
        show_parameter_hints = false,
        parameter_hints_prefix = "<-",
        other_hints_prefix = "=>",
        max_len_align = false,
        max_len_align_padding = 1,
        right_align = false,
        right_align_padding = 7,
        highlight = "Comment",
      },
      hover_actions = {
        border = "rounded",
      },
      on_initialized = function()
        vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
          pattern = { "*.rs" },
          callback = function()
            local _, _ = pcall(vim.lsp.codelens.refresh)
          end,
        })
      end,
    },
    dap = {
      adapter = codelldb_adapter,
    },
    server = {
      on_attach = function(client, bufnr)
        require("lvim.lsp").common_on_attach(client, bufnr)
        local rt = require "rust-tools"
        vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
      end,

      capabilities = require("lvim.lsp").common_capabilities(),
      settings = {
        ["rust-analyzer"] = {
          lens = {
            enable = true,
          },
          checkOnSave = {
            enable = true,
            command = "clippy",
          },
        },
      },
    },
  }

  local rt = require("rust-tools")

  rt.setup(
  -- {
  --   server = {
  --     on_attach = function(_, bufnr)
  --       -- Hover actions
  --       vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
  --       -- Code action groups
  --       vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
  --     end,
  --   },
  -- }
    opts
  )
end

return M
