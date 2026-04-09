-- lua/configs/avante.lua
-- Modern, multi-provider-ready configuration for avante.nvim
-- Based on official documentation.

-- =============================================================================
-- PREREQUISITES FOR ACP PROVIDERS
-- =============================================================================
-- claude-code ACP:
--   1. npm install -g @agentclientprotocol/claude-agent-acp
--   2. 确保环境变量已设置 (export 到 ~/.bashrc 并 source):
--      - ANTHROPIC_AUTH_TOKEN
--      - ANTHROPIC_BASE_URL
--      - ANTHROPIC_MODEL (可选)
--
-- gemini-cli ACP:
--   1. 确保 gemini CLI 已安装
--   2. 设置 GEMINI_API_KEY 环境变量
--
-- qwen-cli ACP:
--   1. 确保 qwen CLI 已安装
-- =============================================================================

---@type avante.Config
return {
  -- Set the default provider to use.
  -- We are using "openai" as a compatibility layer for DeepSeek.
  provider = "claude-code",

  -- A table to hold configurations for all providers.
  -- This structure makes it easy to add more providers in the future.
  providers = {
    deepseek_v3 = {
      -- This is for DeepSeek, but uses the OpenAI provider type
      endpoint = "https://api.deepseek.com/v1",
      model = "deepseek-chat",
      api_key_name = "OPENAI_API_KEY",
      __inherited_from = "openai",
      timeout = 30000,
      extra_request_body = {
        temperature = 0,
        max_tokens = 4096,
      },
    },
    deepseek_r1 = {
      -- This is for DeepSeek, but uses the OpenAI provider type
      endpoint = "https://api.deepseek.com/v1",
      model = "deepseek-reasoner",
      api_key_name = "OPENAI_API_KEY",
      __inherited_from = "openai",
      timeout = 30000,
      extra_request_body = {
        temperature = 0,
        max_tokens = 4096,
      },
    },
    deepseek_fim = {
      -- This is for DeepSeek, but uses the OpenAI provider type
      endpoint = "https://api.deepseek.com/beta",
      model = "deepseek-chat",
      __inherited_from = "openai",
      api_key_name = "OPENAI_API_KEY",
      timeout = 30000,
      extra_request_body = {
        temperature = 1,
        max_tokens = 4096,
      },
    },

    selector = {
      exclude_auto_select = { "NvimTree" },
    },

    -- Example for adding another provider (e.g., Anthropic's Claude)
    -- You would need to set the AVANTE_ANTHROPIC_API_KEY environment variable.
    --[[
    claude = {
      endpoint = "https://api.anthropic.com",
      model = "claude-3-sonnet-20240229",
      timeout = 30000,
      extra_request_body = {
        temperature = 0,
        max_tokens = 4096,
      },
    },
    ]]
  },
  auto_suggestions_provider = "deepseek_fim",
  acp_providers = {
    ["gemini-cli"] = {
      command = "gemini",
      args = { "--experimental-acp", "-m", "gemini-2.5-flash" },
      env = {
        NODE_NO_WARNINGS = "1",
        GEMINI_API_KEY = os.getenv("GEMINI_API_KEY"),
        HTTP_PROXY = os.getenv("HTTP_PROXY"),
        HTTPS_PROXY = os.getenv("HTTPS_PROXY"),
      },
      -- proxy = "http://127.0.0.1:7890",
    },
    ["claude-code"] = {
      command = "npx",
      args = { "-y", "-g", "@agentclientprotocol/claude-agent-acp" },
      env = {
        NODE_NO_WARNINGS = "1",
        ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_AUTH_TOKEN"),
        ANTHROPIC_BASE_URL = os.getenv("ANTHROPIC_BASE_URL"),
        ACP_PATH_TO_CLAUDE_CODE_EXECUTABLE = vim.fn.exepath("claude"),
        ACP_PERMISSION_MODE = "bypassPermissions",
      },
    },
    ["qwen-cli"] = {
      command = "qwen",
      args = { "--experimental-acp" },
      env = {
        NODE_NO_WARNINGS = "1",
      },
    },
  },

  -- Key mappings configuration
  mappings = {
    ask = "<M-2>", -- Ask AI
  },
}
