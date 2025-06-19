local apply = require("themes.apply")
local loader = require("themes.loader")
local colorizer = require("colorizer")

local M = {}

M.open = function()
  local theme_dir = vim.fn.stdpath("config") .. "/colors"
  local files = vim.fn.globpath(theme_dir, "*.sh", false, true)

  local themes = vim.tbl_map(function(path)
    return vim.fn.fnamemodify(path, ":t:r")
  end, files)

  require("telescope.pickers").new({}, {
    prompt_title = "Theme Picker",
    finder = require("telescope.finders").new_table {
      results = themes,
    },
    sorter = require("telescope.config").values.generic_sorter({}),
    previewer = require("telescope.previewers").new_buffer_previewer {
      define_preview = function(self, entry)
        local file = theme_dir .. "/" .. entry.value .. ".sh"
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.fn.readfile(file))
        vim.bo[self.state.bufnr].filetype = "sh"
        vim.schedule(function()
          colorizer.attach_to_buffer(self.state.bufnr)
        end)
      end,
    },
    attach_mappings = function(_, map)
      map("i", "<CR>", function(bufnr)
        local selection = require("telescope.actions.state").get_selected_entry()
        require("telescope.actions").close(bufnr)

        local name = selection[1]
        local colors = loader.parse(name)
        if not next(colors) then return end
        apply.apply(colors)
        vim.g.colors_name = name
      end)
      return true
    end,
  }):find()
end

return M
