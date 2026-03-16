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

    -- Commit popup / commit workflow
    map("n", "<leader>gC", "<cmd>Neogit commit<CR>", vim.tbl_extend("force", opts, {
      desc = "Neogit commit",
    }))

    -- Push / pull / log
    map("n", "<leader>gP", "<cmd>Neogit push<CR>", vim.tbl_extend("force", opts, {
      desc = "Neogit push",
    }))

    map("n", "<leader>gl", "<cmd>Neogit pull<CR>", vim.tbl_extend("force", opts, {
      desc = "Neogit pull",
    }))

    map("n", "<leader>gL", "<cmd>Neogit log<CR>", vim.tbl_extend("force", opts, {
      desc = "Neogit log",
    }))

    -- Quick commit staged changes
    map("n", "<leader>gq", function()
      vim.ui.input({ prompt = "Commit message: " }, function(input)
        if not input or input == "" then
          vim.notify("Commit cancelled", vim.log.levels.INFO)
          return
        end

        vim.fn.system({ "git", "commit", "-m", input })

        if vim.v.shell_error ~= 0 then
          vim.notify("git commit failed", vim.log.levels.ERROR)
          return
        end

        vim.notify("Committed staged changes", vim.log.levels.INFO)
      end)
    end, vim.tbl_extend("force", opts, {
      desc = "Quick commit staged changes",
    }))

    -- Stage all changes, then commit
    map("n", "<leader>gA", function()
      vim.ui.input({ prompt = "Commit all message: " }, function(input)
        if not input or input == "" then
          vim.notify("Commit cancelled", vim.log.levels.INFO)
          return
        end

        vim.fn.system({ "git", "add", "-A" })
        if vim.v.shell_error ~= 0 then
          vim.notify("git add -A failed", vim.log.levels.ERROR)
          return
        end

        vim.fn.system({ "git", "commit", "-m", input })
        if vim.v.shell_error ~= 0 then
          vim.notify("git commit failed", vim.log.levels.ERROR)
          return
        end

        vim.notify("Staged all changes and committed", vim.log.levels.INFO)
      end)
    end, vim.tbl_extend("force", opts, {
      desc = "Stage all and commit",
    }))
  end,
  opts = {},
}
