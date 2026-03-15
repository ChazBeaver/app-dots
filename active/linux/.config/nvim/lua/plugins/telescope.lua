return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    config = function()
      local builtin = require("telescope.builtin")

      -- File navigation
      vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Find git files" })
      vim.keymap.set("n", "<leader>pb", builtin.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>pr", builtin.oldfiles, { desc = "Recent files" })

      -- Search
      vim.keymap.set("n", "<leader>pg", builtin.live_grep, { desc = "Live grep" })

      vim.keymap.set("n", "<leader>ps", function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end, { desc = "Grep string" })

      -- Git
      vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
      vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })
      vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git status" })

      -- LSP / diagnostics
      vim.keymap.set("n", "<leader>pd", builtin.diagnostics, { desc = "Diagnostics" })

      -- Help
      vim.keymap.set("n", "<leader>ph", builtin.help_tags, { desc = "Help tags" })

      -- Enable extensions
      require("telescope").load_extension("ui-select")
    end,
  },

  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
}
