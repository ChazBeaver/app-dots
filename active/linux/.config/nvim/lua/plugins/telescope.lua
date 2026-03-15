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
      vim.keymap.set("n", "<leader>ff", function()
        require("telescope.builtin").find_files({
          hidden = true,
          no_ignore = true,
        })
      end, { desc = "Find ALL files in project" })

      vim.keymap.set("n", "<leader>fa", function()
        require("telescope.builtin").find_files({
          cwd = vim.fn.expand("~"),
          hidden = true,
          no_ignore = true,
        })
      end, { desc = "Find ALL files from $HOME" })

      vim.keymap.set("n", "<leader>fo", function()
        require("telescope.builtin").find_files({
          cwd = vim.fn.expand("~/.local/share/omarchy"),
          hidden = true,
          no_ignore = true,
        })
      end, { desc = "Find Omarchy files" })

      -- vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Find git files" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })

      -- Optional: keep Ctrl-p if you really like it
      -- vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Find git files" })

      -- =========================
      -- Search
      -- =========================
      vim.keymap.set("n", "<leader>sl", function()
        builtin.live_grep({
          additional_args = function()
            return { "--hidden", "--no-ignore" }
          end,
        })
      end, { desc = "Deep search (includes hidden)" })
      vim.keymap.set("n", "<leader>ss", function()
        require("telescope.builtin").grep_string({
          search = vim.fn.input("Grep > "),
          additional_args = function()
            return { "--hidden", "--no-ignore" }
          end,
        })
      end, { desc = "Search for input string (deep search)" })
      vim.keymap.set("n", "<leader>sw", function()
        require("telescope.builtin").grep_string({
          additional_args = function()
            return { "--hidden", "--no-ignore" }
          end,
        })
      end, { desc = "Search word under cursor (deep search)" })
      vim.keymap.set("n", "<leader>sg", function()
        require("telescope.builtin").live_grep({
          additional_args = function()
            return { "--hidden" }
          end,
          cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1],
        })
      end, { desc = "Search git repo" })

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
