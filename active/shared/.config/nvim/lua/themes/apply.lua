-- ~/.config/nvim/lua/themes/apply.lua
-- Applies highlight groups based on parsed color table

local M = {}

M.apply = function(colors)
  local set = vim.api.nvim_set_hl

  vim.cmd("highlight clear")
  vim.o.termguicolors = true
  vim.g.colors_name = "dynamic"

  local function fg(name) return { fg = colors[name] or "#ffffff" } end
  local function bg(name) return { bg = colors[name] or "#000000" } end
  local function fg_bg(fg_col, bg_col)
    return {
      fg = colors[fg_col] or "#ffffff",
      bg = colors[bg_col] or "#000000"
    }
  end

  -- FIND ITEM NAME
  -- hover over the thing you want the name of and run the following command
  -- :echo synIDattr(synID(line("."), col("."), 1), "name")

  -- Special
  set(0, "netrwExe", fg("color24"))

  -- Core UI
  set(0, "Normal", fg_bg("color14", "color10"))
  set(0, "Visual", bg("color16"))
  set(0, "CursorLine", bg("color13"))
  set(0, "LineNr", fg("color09"))
  set(0, "Comment", vim.tbl_extend("force", fg("color09"), { italic = true }))

  -- Syntax
  set(0, "Function", fg("color04"))
  set(0, "Statement", fg("color01"))
  set(0, "String", fg("color02"))
  set(0, "Number", fg("color03"))
  set(0, "Keyword", fg("color01"))
  set(0, "Identifier", fg("color05"))

  -- File manager UI (Ex mode / netrw)
  -- set(0, "Normal", fg_bg("color14", "color10"))           -- file names
  set(0, "Directory", fg("color04"))                      -- directory names
  -- set(0, "CursorLine", bg("color13"))                     -- highlight current line
  set(0, "NonText", fg("color09"))                        -- tilde rows (~)
  set(0, "Title", fg("color01"))                          -- banner line

  -- StatusLine
  set(0, "StatusLine", fg_bg("color14", "color17"))
  set(0, "StatusLineNC", fg_bg("color09", "color25"))
  set(0, "VertSplit", fg("color25"))

  -- Completion menu
  set(0, "Pmenu", fg_bg("color14", "color17"))
  set(0, "PmenuSel", fg_bg("color10", "color16"))

  -- Diagnostics
  set(0, "DiagnosticError", fg("color11"))
  set(0, "DiagnosticWarn", fg("color12"))
  set(0, "DiagnosticInfo", fg("color14"))
  set(0, "DiagnosticHint", fg("color05"))

  -- LSP highlights
  set(0, "LspReferenceText", bg("color17"))
  set(0, "LspReferenceRead", bg("color17"))
  set(0, "LspReferenceWrite", bg("color17"))

  -- Git
  set(0, "GitSignsAdd", fg("color02"))
  set(0, "GitSignsChange", fg("color05"))
  set(0, "GitSignsDelete", fg("color11"))

  -- Telescope UI
  set(0, "TelescopeBorder", fg("color17"))
  set(0, "TelescopePromptBorder", fg("color17"))
  set(0, "TelescopeResultsBorder", fg("color25"))
  set(0, "TelescopePreviewBorder", fg("color25"))
  set(0, "TelescopeSelection", fg_bg("color14", "color16"))

  -- Lualine compatibility (optional)
  set(0, "lualine_a_normal", fg_bg("color10", "color01"))
  set(0, "lualine_b_normal", fg_bg("color14", "color17"))
  set(0, "lualine_c_normal", fg_bg("color14", "color10"))
end

return M
