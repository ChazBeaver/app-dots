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

    -- Preview / inspect
    map("n", "<leader>gp", gitsigns.preview_hunk, vim.tbl_extend("force", opts, {
      desc = "Preview hunk",
    }))

    map("n", "<leader>gd", gitsigns.diffthis, vim.tbl_extend("force", opts, {
      desc = "Diff current file vs HEAD",
    }))

    map("n", "<leader>gb", gitsigns.blame_line, vim.tbl_extend("force", opts, {
      desc = "Blame line",
    }))

    -- Stage
    map("n", "<leader>gsh", gitsigns.stage_hunk, vim.tbl_extend("force", opts, {
      desc = "Stage hunk",
    }))

    -- Reset
    map("n", "<leader>grh", gitsigns.reset_hunk, vim.tbl_extend("force", opts, {
      desc = "Reset hunk",
    }))
  end,
}
