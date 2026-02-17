-- ~/.config/nvim/lua/themes/loader.lua
-- Parse key=value shell theme files into a color table

local M = {}

function M.parse(name)
  local colors = {}
  local path = vim.fn.stdpath("config") .. "/colors/" .. name .. ".sh"
  local file = io.open(path, "r")

  if not file then
    vim.notify("Color file not found: " .. path, vim.log.levels.ERROR)
    return colors
  end

  for line in file:lines() do
    if not line:match("^%s*#") and not line:match("^%s*$") then
      local key, value = line:match("^%s*(%S+)%s*=%s*#?([A-Fa-f0-9]+)")
      if key and value then
        colors[key] = "#" .. value
      end
    end
  end

  file:close()
  return colors
end

return M
