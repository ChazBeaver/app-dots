-- REMAPS FILE --
-- I don't think these need to be defined again, but it won't hurt
local global = vim.g
local o = vim.o
vim.scriptencoding = "utf-8"

-- ############################################################################
--                              Main Keymaps
-- ############################################################################
 
-- IMPORTANT KEYMAPS

-- Map <leader>
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
 
-- Return Current File Directory
vim.keymap.set("n", "<leader>e", vim.cmd.Ex,
  { desc = "Return to File Directory" })
 
-- Return to Working Directory
vim.keymap.set("n", "<leader>ER", [[:Explore .<CR>]],
  { desc = "Explore Current Working Directory" })
 
-- Explore Home Directory
vim.keymap.set("n", "<leader>EH", [[:Explore ~/.<CR>]],
{ desc = "Explore Home Root Directory" })
 
-- FUN KEYMAPS
 
-- Launch Lazy Menu
vim.keymap.set("n", "<leader>l", vim.cmd.Lazy,
  { desc = "Launch Lazy Menu" })
 
-- Clear Highlight Search
vim.keymap.set("n", "<leader>nh", vim.cmd.noh, -- short for nohlsearch
  { desc = "[P] No Highlight - Clear Highlight Search" })
 
-- Delete All Marks
vim.keymap.set("n", "<leader>mD", [[:delmarks!<CR>]],
{ desc = "Delete All Marks" })

-- Edit Highlighted Lines
vim.keymap.set("v", "<leader>n", [[:norm ]],
{ desc = "Edit Highlighted Lines with `:norm` " })

-- Copy the entire file to clipboard
vim.keymap.set("n", "<leader>ya", [[ggVG"+y]],
  { desc = "Copy entire file to clipboard" })

-- Copy filepath to clipboard
vim.keymap.set("n", "<leader>yfp",
  function()
    vim.fn.setreg("+", vim.fn.expand("%:p"))
    print("📋 Copied full file path " )
  end,
  { desc = "Copy full file path to clipboard" }
)

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
 
-- When searching for stuff, search results show in the middle #NOTE
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
 
-- Switch back to the previous buffer you were just on (without using Harpoon)
vim.keymap.set("n", "<leader><Tab>", "<C-^>",
{ desc = "Switch to previous buffer" })
 
 
-- ############################################################################
--                         Begin of markdown section
-- ############################################################################
 
 
-- ############################################################################
--                         Begin of github section
-- ############################################################################
 
-- -- Function to get the GitHub URL of the current file
-- local function get_github_url_of_current_file()
--   local file_path = vim.fn.expand("%:p")
--   if file_path == "" then
--     vim.notify("No file is currently open", vim.log.levels.WARN)
--     return nil
--   end
--
--   local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
--   if not git_root or git_root == "" then
--     vim.notify("Could not determine the root directory for the GitHub repository", vim.log.levels.WARN)
--     return nil
--   end
--
--   local origin_url = vim.fn.systemlist("git config --get remote.origin.url")[1]
--   if not origin_url or origin_url == "" then
--     vim.notify("Could not determine the origin URL for the GitHub repository", vim.log.levels.WARN)
--     return nil
--   end
--
--   local branch_name = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]
--   if not branch_name or branch_name == "" then
--     vim.notify("Could not determine the current branch name", vim.log.levels.WARN)
--     return nil
--   end
--
--   local repo_url = origin_url:gsub(git@github.com[^:]*:, https://github.com/):gsub("%.git$", "")
--   local relative_path = file_path:sub(#git_root + 2)
--   return repo_url .. "/blob/" .. branch_name .. "/" .. relative_path
-- end
--
-- -- Open current file's GitHub repo link lamw25wmal
-- vim.keymap.set("n", "<leader>fG", function()
--   local github_url = get_github_url_of_current_file()
--   if github_url then
--     local command = "open " .. vim.fn.shellescape(github_url)
--     vim.fn.system(command)
--     print("Opened GitHub link: " .. github_url)
--   end
-- end, { desc = "[P]Open current file's GitHub repo link" })
--
-- -- Keymap to copy current file's GitHub URL to clipboard
-- vim.keymap.set({ "n", "v", "i" }, "<M-C>", function()
--   local github_url = get_github_url_of_current_file()
--   if github_url then
--     vim.fn.setreg("+", github_url)
--     vim.notify(github_url, vim.log.levels.INFO)
--     vim.notify("GitHub URL copied to clipboard", vim.log.levels.INFO)
--   end
-- end, { desc = "[P]Copy GitHub URL of file to clipboard" })
--
-- -- Function to copy file path to clipboard
-- local function copy_filepath_to_clipboard()
--   local filePath = vim.fn.expand("%:~") -- Gets the file path relative to the home directory
--   vim.fn.setreg("+", filePath) -- Copy the file path to the clipboard register
--   vim.notify(filePath, vim.log.levels.INFO)
--   vim.notify("Path copied to clipboard: ", vim.log.levels.INFO)
-- end
-- -- Keymaps for copying file path to clipboard
-- -- vim.keymap.set("n", "<leader>fp", copy_filepath_to_clipboard, { desc = "[P]Copy file path to clipboard" })
-- -- I couldn't use <M-p> because its used for previous reference
-- vim.keymap.set({ "n", "v", "i" }, "<M-c>", copy_filepath_to_clipboard, { desc = "[P]Copy file path to clipboard" })
--
-- -- Keymap to create a GitHub repository
-- -- It uses the github CLI, which in macOS is installed with:
-- -- brew install gh
-- vim.keymap.set("n", "<leader>gC", function()
--   -- Check if GitHub CLI is installed
--   local gh_installed = vim.fn.system("command -v gh")
--   if gh_installed == "" then
--     print("GitHub CLI is not installed. Please install it using 'brew install gh'.")
--     return
--   end
--   -- Get the current working directory and extract the repository name
--   local cwd = vim.fn.getcwd()
--   local repo_name = vim.fn.fnamemodify(cwd, ":t")
--   if repo_name == "" then
--     print("Failed to extract repository name from the current directory.")
--     return
--   end
--   -- Display the message and ask for confirmation
--   vim.ui.select({ "yes", "no" }, {
--     prompt = 'The name of the repo will be: "' .. repo_name .. '". Continue?',
--     default = "no",
--   }, function(choice)
--     if choice ~= "yes" then
--       print("Operation canceled.")
--       return
--     end
--     -- Check if the repository already exists on GitHub
--     local check_repo_command =
--       string.format("gh repo view %s/%s", vim.fn.system("gh api user --jq '.login'"):gsub("%s+", ""), repo_name)
--     local check_repo_result = vim.fn.systemlist(check_repo_command)
--     if not string.find(table.concat(check_repo_result), "Could not resolve to a Repository") then
--       print("Repository '" .. repo_name .. "' already exists on GitHub.")
--       return
--     end
--     -- Prompt for repository type
--     vim.ui.select({ "private", "public" }, {
--       prompt = "Select the repository type:",
--       default = "private",
--     }, function(repo_type)
--       if not repo_type then
--         print("Operation canceled.")
--         return
--       end
--       -- Set the repository type flag
--       local repo_type_flag = repo_type == "private" and "--private" or "--public"
--       -- Initialize the git repository and create the GitHub repository
--       local init_command = string.format("cd %s && git init", vim.fn.shellescape(cwd))
--       vim.fn.system(init_command)
--       local create_command =
--         string.format("cd %s && gh repo create %s %s --source=.", vim.fn.shellescape(cwd), repo_name, repo_type_flag)
--       local create_result = vim.fn.system(create_command)
--       -- Print the result of the repository creation command
--       if string.find(create_result, https://github.com) then
--         print("Repository '" .. repo_name .. "' created successfully.")
--       else
--         print("Failed to create the repository: " .. create_result)
--       end
--     end)
--   end)
-- end, { desc = "[P]Create GitHub repository" })
