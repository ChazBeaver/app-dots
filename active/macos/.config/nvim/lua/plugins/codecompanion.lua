-- lua/plugins/codecompanion.lua
return {
  "olimorris/codecompanion.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
  keys = {
    { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI chat" },
    { "<leader>ca", "<cmd>CodeCompanionActions<cr>",     desc = "AI actions" },
    { "<leader>ci", ":CodeCompanion ",  mode = "v",      desc = "AI inline edit" },
  },
  opts = {
    adapters = {
      http = {
        litellm = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "LITELLM_BASE_URL",      -- NAME, resolved from shell env
              api_key = "LITELLM_API_KEY",   -- NAME, never the value
              chat_url = "/v1/chat/completions",
              models_endpoint = "/v1/models",
            },
            schema = { model = { default = vim.env.LITELLM_MODEL or "my-model-alias" } },
          })
        end,
      },
    },
    interactions = {   -- older CodeCompanion versions call this key `strategies`
      chat   = { adapter = "litellm" },
      inline = { adapter = "litellm" },
      cmd    = { adapter = "litellm" },
    },
  },
}
