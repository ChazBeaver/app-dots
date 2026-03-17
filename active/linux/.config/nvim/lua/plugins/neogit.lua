    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Repo UI
    map("n", "<leader>gg", "<cmd>Neogit<CR>", opts)

    map("n", "<leader>gc", "<cmd>Neogit commit<CR>", opts)
    map("n", "<leader>gL", "<cmd>Neogit log<CR>", opts)
    map("n", "<leader>gl", "<cmd>Neogit pull<CR>", opts)
    map("n", "<leader>gP", "<cmd>Neogit push<CR>", opts)

    -- Stage actions
    map("n", "<leader>gsf", stage_current_file, opts)
    map("n", "<leader>gsa", stage_all_files, opts)

    -- Quick commit
    map("n", "<leader>gm", function()
      local root = resolve_git_root()
      if not root then
        vim.notify("No git repo found", vim.log.levels.ERROR)
        return
      end

      vim.ui.input({ prompt = "Commit message: " }, function(input)
        if not input or input == "" then return end

        vim.fn.system({ "git", "-C", root, "commit", "-m", input })

        if vim.v.shell_error ~= 0 then
          vim.notify("Commit failed", vim.log.levels.ERROR)
          return
        end

        vim.notify("Committed", vim.log.levels.INFO)
      end)
    end, opts)

    -- Optional: quick push alternative (if you still want it separate)
    map("n", "<leader>gpp", quick_push_origin_head, opts)
