-- ~/.config/nvim/lua/themes/init.lua
-- Loads default theme and provides :Colortheme command

local loader = require("themes.loader")
local apply = require("themes.apply")

-- Load default theme on startup
local default_name = "kanagawa-dragon"
local colors = loader.parse(default_name)
apply.apply(colors)
vim.g.colors_name = default_name

-- Define :Colortheme <name> command
vim.api.nvim_create_user_command("Colortheme", function(opts)
  local name = opts.args
  local colors = loader.parse(name)
  if not next(colors) then return end
  apply.apply(colors)
  vim.g.colors_name = name
end, {
  nargs = 1,
  complete = function()
    local dir = vim.fn.stdpath("config") .. "/colors"
    local files = vim.fn.globpath(dir, "*.sh", false, true)
    return vim.tbl_map(function(f)
      return vim.fn.fnamemodify(f, ":t:r")
    end, files)
  end,
})
