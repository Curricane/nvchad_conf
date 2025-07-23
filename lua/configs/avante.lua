-- lua/configs/avante.lua
-- Configuration for avante.nvim
-- NOTE: We use provider = "openai" as a compatibility layer,
-- even when connecting to DeepSeek, as this is the method
-- currently supported by the plugin.
return {
  provider = "openai",
  openai = {
    endpoint = "https://api.deepseek.com/v1",
    model = "deepseek-chat",
    timeout = 30000,
    temperature = 0,
    max_tokens = 4096,
  },
}