-- lua/configs/avante.lua
-- Modern, multi-provider-ready configuration for avante.nvim
-- Based on official documentation.

---@type avante.Config
return {
  -- Set the default provider to use.
  -- We are using "openai" as a compatibility layer for DeepSeek.
  provider = "deepseek_v3",

  -- A table to hold configurations for all providers.
  -- This structure makes it easy to add more providers in the future.
  providers = {
    deepseek_v3 = {
      -- This is for DeepSeek, but uses the OpenAI provider type
      endpoint = "https://api.deepseek.com/v1",
      model = "deepseek-chat",
      api_key_name = "OPENAI_API_KEY",
      __inherited_from = 'openai',
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
      __inherited_from = 'openai',
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
      __inherited_from = 'openai',
      api_key_name = "OPENAI_API_KEY",
      timeout = 30000,
      extra_request_body = {
        temperature = 1,
        max_tokens = 4096,
      },
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
}
