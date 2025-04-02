-- REMAPS FILE --
 
-- I don't think these need to be defined again, but it won't hurt
local global = vim.g
local o = vim.o
vim.scriptencoding = "utf-8"
 
 
-- IMPORTANT KEYMAPS
 
-- Map <leader>
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
-- Return Keymap
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)


-- FUN KEYMAPS

-- Launch Lazy Menu
vim.keymap.set("n", "<leader>l", vim.cmd.Lazy,
  { desc = "Launch Lazy Menu" })

-- Clear Highlight Search
vim.keymap.set("n", "<leader>cl", vim.cmd.noh,
  { desc = "Clear Highlight Search" })

-- Delete All Marks
vim.keymap.set("n", "<leader>md", [[:delmarks!<CR>]], 
{ desc = "Delete All Marks" })
 
-- Edit Highlighted Lines
vim.keymap.set("v", "<leader>e", [[:norm ]], 
{ desc = "Edit Highlighted Lines" })
 
-- Copy the entire file to clipboard
vim.keymap.set("n", "<leader>ya", [[ggVG"+y]],
  { desc = "Copy entire file to clipboard" })
 
-- Copy the name of the file being worked on currently
vim.keymap.set("n", "<leader>fn", function()
  vim.fn.setreg("+", vim.fn.expand("%:t"))
  print("Copied: " .. vim.fn.expand("%:t"))
end, { desc = "Copy file name to clipboard" })
 
-- Copy the current date to clipboard (yyyy-mm-dd)
function CopyCurrentDate()
  local date = os.date("%Y-%m-%d")
  vim.fn.setreg("+", date)  -- Copy to system clipboard
  print("Copied to clipboard: " .. date)
end
-- Keybindings
vim.keymap.set("n", "<leader>cd", CopyCurrentDate, { desc = "Copy current date (YYYY-MM-DD)" })
