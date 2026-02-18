return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = { "lua", "bash", "c", "javascript", "go" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}

-- -- BULLETPROOF VERSION --
-- return {
--   {
--     "nvim-treesitter/nvim-treesitter",
--     build = ":TSUpdate",
--     config = function()
--       local ok, ts = pcall(require, "nvim-treesitter.configs")
--       if not ok then
--         ts = require("nvim-treesitter.config")
--       end
--
--       ts.setup({
--         ensure_installed = { "lua", "bash", "c", "javascript", "go" },
--         highlight = { enable = true },
--         indent = { enable = true },
--       })
--     end,
--   },
-- }
