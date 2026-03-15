return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    config = function()
      local builtin = require("telescope.builtin")

      -- =========================
      -- Files / navigation
      -- =========================
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Find git files" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })

      -- Optional: keep Ctrl-p if you really like it
      vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Find git files" })

      -- =========================
      -- Search
      -- =========================
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Search by live grep" })
      vim.keymap.set("n", "<leader>ss", function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end, { desc = "Search for input string" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Search word under cursor" })

      -- =========================
      -- Git
      -- =========================
      vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
      vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })
      vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git status" })
      vim.keymap.set("n", "<leader>gh", builtin.git_bcommits, { desc = "Git history for current file" })
      vim.keymap.set("v", "<leader>gh", builtin.git_bcommits_range, { desc = "Git history for selected lines" })

      -- =========================
      -- Diagnostics / help
      -- =========================
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Search diagnostics" })
      -- vim.keymap.set("n", "<leader>hh", builtin.help_tags, { desc = "Help tags" })

      require("telescope").load_extension("ui-select")
    end,
  },

  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
}
