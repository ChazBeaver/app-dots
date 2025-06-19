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
  set(0, "netrwExe", fg("color06"))

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

  -- Bash highlights
  set(0, "shSetOption", fg("color01"))         -- -euo pipefail
  set(0, "shSpecial", fg("color03"))           -- $$, $?, etc.
  set(0, "shCommandSub", fg("color04"))        -- $(...)
  set(0, "shDerefWordError", fg("color11"))    -- undefined vars
  set(0, "shCmdSubRegion", fg("color05"))      -- inner part of $(...)
  set(0, "shDerefSimple", fg("color06"))       -- $HOME, $PATH, etc.

  -- Lua punctuation & calls
  set(0, "luaFuncCall", fg("color04"))         -- require()
  set(0, "luaTable", fg("color05"))            -- tables
  set(0, "luaParen", fg("color09"))            -- ()
  set(0, "luaBraces", fg("color09"))           -- {}
  set(0, "luaComma", fg("color09"))            -- ,
  set(0, "luaDot", fg("color09"))              -- .
  set(0, "luaColon", fg("color09"))            -- :

  -- Delimiters for general syntax (e.g. (), {}, ., ,, :)
  set(0, "Delimiter", fg("color09"))

  -- Treesitter highlight groups for Lua, Bash, and others
  set(0, "@function.call", fg("color04"))           -- require()
  set(0, "@function.builtin", fg("color01"))        -- built-ins like `print`
  set(0, "@variable", fg("color05"))                -- local var, global var
  set(0, "@keyword", fg("color01"))                 -- if, end, local
  set(0, "@string", fg("color02"))                  -- normal strings
  set(0, "@string.special.path", fg("color06"))     -- paths like $HOME or /bin/bash
  set(0, "@type", fg("color03"))                    -- table, string, etc.
  set(0, "@number", fg("color03"))                  -- 42, 3.14
  set(0, "@punctuation.delimiter", fg("color09"))   -- , . ; :
  set(0, "@punctuation.bracket", fg("color09"))     -- ( ) [ ] { }
  set(0, "@punctuation.special", fg("color09"))     -- #, $, etc.
  set(0, "@boolean", fg("color03"))
  set(0, "@variable", fg("color05"))             -- local var, global var
  set(0, "@constant", fg("color03"))             -- SCREAMING_SNAKE_CASE, numbers, etc.

  -- Fallback for Non-Treesitter Files
  set(0, "luaFuncCall", fg("color04"))
  set(0, "luaBraces", fg("color09"))
  set(0, "luaComma", fg("color09"))
  set(0, "luaDot", fg("color09"))
  set(0, "luaColon", fg("color09"))

  vim.cmd [[
    highlight link @punctuation.bracket Delimiter
    highlight link @constructor Delimiter
  ]]

  vim.cmd [[
    highlight link @punctuation.delimiter Delimiter
    highlight link @punctuation.special Delimiter
  ]]

  vim.cmd [[
    highlight link @variable Identifier
    highlight link @constant Constant
  ]]

end

return M
