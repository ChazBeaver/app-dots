return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  event = "VeryLazy",
  config = function()
    local ok, neogit = pcall(require, "neogit")
    if not ok then
      return
    end

    neogit.setup({})

    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Open Neogit UI
    map("n", "<leader>gg", "<cmd>Neogit<CR>", vim.tbl_extend("force", opts, {
      desc = "Open Neogit",
    }))

    -- Common Git actions
    map("n", "<leader>gC", "<cmd>Neogit commit<CR>", vim.tbl_extend("force", opts, {
      desc = "Neogit commit",
    }))

    map("n", "<leader>gP", "<cmd>Neogit push<CR>", vim.tbl_extend("force", opts, {
      desc = "Neogit push",
    }))

    map("n", "<leader>gl", "<cmd>Neogit pull<CR>", vim.tbl_extend("force", opts, {
      desc = "Neogit pull",
    }))

    map("n", "<leader>gL", "<cmd>Neogit log<CR>", vim.tbl_extend("force", opts, {
      desc = "Neogit log",
    }))
  end,
  opts = {},
}
