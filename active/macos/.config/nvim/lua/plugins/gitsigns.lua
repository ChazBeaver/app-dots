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

    -- Preview current hunk
    map("n", "<leader>gp", gitsigns.preview_hunk, vim.tbl_extend("force", opts, {
      desc = "Preview git hunk",
    }))

    -- Diff current file vs HEAD
    map("n", "<leader>gd", gitsigns.diffthis, vim.tbl_extend("force", opts, {
      desc = "Diff current file vs HEAD",
    }))

    -- Navigate hunks
    map("n", "<leader>gn", gitsigns.next_hunk, vim.tbl_extend("force", opts, {
      desc = "Next git hunk",
    }))

    map("n", "<leader>gN", gitsigns.prev_hunk, vim.tbl_extend("force", opts, {
      desc = "Previous git hunk",
    }))

    -- Stage / reset hunk
    map("n", "<leader>gS", gitsigns.stage_hunk, vim.tbl_extend("force", opts, {
      desc = "Stage git hunk",
    }))

    map("n", "<leader>gR", gitsigns.reset_hunk, vim.tbl_extend("force", opts, {
      desc = "Reset git hunk",
    }))

    -- Blame current line
    map("n", "<leader>gB", gitsigns.blame_line, vim.tbl_extend("force", opts, {
      desc = "Blame current line",
    }))
  end,
  opts = {},
}
