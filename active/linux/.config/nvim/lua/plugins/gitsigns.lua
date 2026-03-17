return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  config = function()
    local ok, gitsigns = pcall(require, "gitsigns")
    if not ok then
      return
    end

    gitsigns.setup({})

    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    local function gs_call(method, ...)
      local args = { ... }
      return function()
        local ok_gs, gs = pcall(require, "gitsigns")
        if not ok_gs then
          vim.notify("gitsigns not available", vim.log.levels.ERROR)
          return
        end

        local fn = gs[method]
        if type(fn) ~= "function" then
          vim.notify("gitsigns method missing: " .. method, vim.log.levels.ERROR)
          return
        end

        fn(unpack(args))
      end
    end

    map("n", "<leader>ghn", gs_call("next_hunk"), vim.tbl_extend("force", opts, {
      desc = "Git next hunk",
    }))

    map("n", "<leader>ghN", gs_call("prev_hunk"), vim.tbl_extend("force", opts, {
      desc = "Git previous hunk",
    }))

    map("n", "<leader>ghp", gs_call("preview_hunk"), vim.tbl_extend("force", opts, {
      desc = "Git preview hunk",
    }))

    map("n", "<leader>gd", gs_call("diffthis"), vim.tbl_extend("force", opts, {
      desc = "Git diff current file vs HEAD",
    }))

    map("n", "<leader>gB", gs_call("blame_line"), vim.tbl_extend("force", opts, {
      desc = "Git blame line",
    }))

    map("n", "<leader>ghs", gs_call("stage_hunk"), vim.tbl_extend("force", opts, {
      desc = "Git stage hunk",
    }))

    map("n", "<leader>ghr", gs_call("reset_hunk"), vim.tbl_extend("force", opts, {
      desc = "Git reset hunk",
    }))
  end,
  opts = {},
}
