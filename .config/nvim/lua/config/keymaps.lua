-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Remap E to move to the end of text (excluding trailing whitespace)
vim.keymap.set("n", "E", function()
  vim.cmd("normal! g_") -- g_ moves to the last non-blank character of the line
end, { desc = "Move to end of text (non-whitespace)" })

-- Remap B to move to the beginning of the line after leading whitespace
vim.keymap.set("n", "B", function()
  vim.cmd("normal! ^") -- ^ moves to the first non-blank character of the line
end, { desc = "Move to beginning of line after whitespace" })
