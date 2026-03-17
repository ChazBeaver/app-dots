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

    -- ============================================================
    -- Helpers
    -- ============================================================
    local function git_root_for_path(path)
      if not path or path == "" then
        return nil
      end

      local dir = vim.fn.fnamemodify(path, ":h")
      local result = vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--show-toplevel" })

      if vim.v.shell_error ~= 0 or not result[1] or result[1] == "" then
        return nil
      end

      return result[1]
    end

    local function current_file_path()
      local path = vim.api.nvim_buf_get_name(0)
      if not path or path == "" then
        return nil
      end
      return vim.fn.fnamemodify(path, ":p")
    end

    local function ensure_file_saved()
      if vim.bo.modified then
        vim.cmd("write")
      end
    end

    local function resolve_git_root()
      local filepath = current_file_path()
      local root = filepath and git_root_for_path(filepath)

      if root then
        return root
      end

      local cwd = vim.fn.getcwd()
      local result = vim.fn.systemlist({ "git", "-C", cwd, "rev-parse", "--show-toplevel" })

      if vim.v.shell_error ~= 0 or not result[1] or result[1] == "" then
        return nil
      end

      return result[1]
    end

    local function stage_current_file()
      local filepath = current_file_path()
      if not filepath then
        vim.notify("No current file to stage", vim.log.levels.WARN)
        return
      end

      ensure_file_saved()

      local root = git_root_for_path(filepath)
      if not root then
        vim.notify("Current file is not inside a Git repository", vim.log.levels.ERROR)
        return
      end

      vim.fn.system({ "git", "-C", root, "add", filepath })

      if vim.v.shell_error ~= 0 then
        vim.notify("git add failed for current file", vim.log.levels.ERROR)
        return
      end

      vim.notify("Staged current file", vim.log.levels.INFO)
    end

    local function stage_all_files()
      local root = resolve_git_root()
      if not root then
        vim.notify("Could not determine Git repository root", vim.log.levels.ERROR)
        return
      end

      vim.cmd("wall")
      vim.fn.system({ "git", "-C", root, "add", "-A" })

      if vim.v.shell_error ~= 0 then
        vim.notify("git add -A failed", vim.log.levels.ERROR)
        return
      end

      vim.notify("Staged all files", vim.log.levels.INFO)
    end

    local function quick_push_origin_head()
      local root = resolve_git_root()
      if not root then
        vim.notify("Could not determine Git repository root", vim.log.levels.ERROR)
        return
      end

      vim.notify("Pushing HEAD to origin...", vim.log.levels.INFO)
      vim.fn.system({ "git", "-C", root, "push", "origin", "HEAD" })

      if vim.v.shell_error ~= 0 then
        vim.notify("git push origin HEAD failed", vim.log.levels.ERROR)
        return
      end

      vim.notify("Pushed HEAD to origin", vim.log.levels.INFO)
    end

    -- ============================================================
    -- Floating preview from Neogit status
    -- ============================================================
    local function find_neogit_section(bufnr, row)
      for lnum = row, 1, -1 do
        local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or ""
        if line:match("Staged changes") then
          return "staged"
        end
        if line:match("Unstaged changes") then
          return "unstaged"
        end
      end
      return nil
    end

    local function extract_neogit_filepath(line)
      local patterns = {
        "^%s*[>v]?%s*modified%s+(.+)$",
        "^%s*[>v]?%s*new file%s+(.+)$",
        "^%s*[>v]?%s*deleted%s+(.+)$",
        "^%s*[>v]?%s*renamed%s+(.+)$",
        "^%s*[>v]?%s*copied%s+(.+)$",
        "^%s*[>v]?%s*both modified%s+(.+)$",
        "^%s*[>v]?%s*added%s+(.+)$",
      }

      for _, pat in ipairs(patterns) do
        local path = line:match(pat)
        if path and path ~= "" then
          return vim.trim(path)
        end
      end

      return nil
    end

    local function open_floating_git_preview()
      local bufnr = vim.api.nvim_get_current_buf()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local row = cursor[1]
      local line = vim.api.nvim_get_current_line()

      local filepath = extract_neogit_filepath(line)
      if not filepath then
        vim.notify("Cursor is not on a changed file line", vim.log.levels.WARN)
        return
      end

      local section = find_neogit_section(bufnr, row)
      if not section then
        vim.notify("Could not determine whether file is staged or unstaged", vim.log.levels.WARN)
        return
      end

      local cmd
      if section == "staged" then
        cmd = { "git", "--no-pager", "diff", "--cached", "--", filepath }
      else
        cmd = { "git", "--no-pager", "diff", "--", filepath }
      end

      local output = vim.fn.systemlist(cmd)
      if vim.v.shell_error ~= 0 then
        vim.notify("git diff failed for: " .. filepath, vim.log.levels.ERROR)
        return
      end

      if not output or vim.tbl_isempty(output) then
        output = { "No diff output for " .. filepath }
      end

      local float_buf = vim.api.nvim_create_buf(false, true)
      vim.bo[float_buf].bufhidden = "wipe"
      vim.bo[float_buf].filetype = "diff"
      vim.bo[float_buf].modifiable = true

      local header = {
        "File: " .. filepath,
        "Section: " .. section,
        "Command: " .. table.concat(cmd, " "),
        string.rep("─", 80),
      }

      vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, vim.list_extend(header, output))
      vim.bo[float_buf].modifiable = false

      local width = math.floor(vim.o.columns * 0.85)
      local height = math.floor(vim.o.lines * 0.80)
      local col = math.floor((vim.o.columns - width) / 2)
      local row_pos = math.floor((vim.o.lines - height) / 2)

      local win = vim.api.nvim_open_win(float_buf, true, {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row_pos,
        style = "minimal",
        border = "rounded",
        title = " Neogit Preview ",
        title_pos = "center",
      })

      vim.wo[win].wrap = false
      vim.wo[win].cursorline = true

      vim.keymap.set("n", "q", function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end, {
        buffer = float_buf,
        noremap = true,
        silent = true,
        nowait = true,
        desc = "Close floating git preview",
      })
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "NeogitStatus",
      callback = function(args)
        local buf_opts = {
          buffer = args.buf,
          noremap = true,
          silent = true,
          nowait = true,
        }

        vim.keymap.set("n", "zf", open_floating_git_preview, vim.tbl_extend("force", buf_opts, {
          desc = "Floating git preview",
        }))
      end,
    })

    -- ============================================================
    -- Global keymaps
    -- ============================================================
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    map("n", "<leader>ga", "<cmd>Neogit<CR>", vim.tbl_extend("force", opts, {
      desc = "Open Neogit",
    }))

    map("n", "<leader>gC", "<cmd>Neogit commit<CR>", vim.tbl_extend("force", opts, {
      desc = "Neogit commit (make) popup",
    }))

    map("n", "<leader>gL", "<cmd>Neogit log<CR>", vim.tbl_extend("force", opts, {
      desc = "Neogit log popup",
    }))

    map("n", "<leader>gl", "<cmd>Neogit pull<CR>", vim.tbl_extend("force", opts, {
      desc = "Neogit pull popup",
    }))

    map("n", "<leader>gP", "<cmd>Neogit push<CR>", vim.tbl_extend("force", opts, {
      desc = "Neogit push popup",
    }))

    map("n", "<leader>gsf", stage_current_file, vim.tbl_extend("force", opts, {
      desc = "Git stage file",
    }))

    map("n", "<leader>gsa", stage_all_files, vim.tbl_extend("force", opts, {
      desc = "Git stage all",
    }))

    map("n", "<leader>gp", quick_push_origin_head, vim.tbl_extend("force", opts, {
      desc = "Git quick push origin HEAD",
    }))

    map("n", "<leader>gm", function()
      local root = resolve_git_root()
      if not root then
        vim.notify("Could not determine Git repository root", vim.log.levels.ERROR)
        return
      end

      vim.ui.input({ prompt = "Commit message: " }, function(input)
        if not input or input == "" then
          vim.notify("Commit cancelled", vim.log.levels.INFO)
          return
        end

        vim.fn.system({ "git", "-C", root, "commit", "-m", input })

        if vim.v.shell_error ~= 0 then
          vim.notify("git commit failed", vim.log.levels.ERROR)
          return
        end

        vim.notify("Committed staged changes", vim.log.levels.INFO)
      end)
    end, vim.tbl_extend("force", opts, {
      desc = "Git quick commit staged changes",
    }))
  end,
  opts = {},
}
