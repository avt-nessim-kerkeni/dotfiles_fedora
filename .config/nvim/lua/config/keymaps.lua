-- lua/config/keymaps.lua
local M = {}

function M.setup()
	local keymap = vim.keymap.set
	local opts = { noremap = true, silent = true }

	-- Colorscheme (unchanged)
	keymap(
		"n",
		"<leader>ct",
		"<cmd>lua require('config.colorscheme').set_theme(vim.fn.input('Theme: '))<CR>",
		{ desc = "Change theme" }
	)
	keymap("n", "<leader>cd", function()
		local theme = vim.fn.input("New default theme: ")
		require("config.colorscheme").set_default_theme(theme)
	end, { desc = "Change default theme" })

	-- Save and quit
	keymap("n", "<leader>w", ":update<CR>", { desc = "Save file" })
	keymap("n", "<leader>q", ":quit<CR>", { desc = "Quit window" })
	keymap("n", "<leader>x", ":qa<CR>", { desc = "Quit all" })

	-- Move to start/end of line
	keymap("n", "H", "^", { desc = "Move to start of line" })
	keymap("n", "L", "$", { desc = "Move to end of line" })

	-- Keymap to copy to clipboard in visual mode
	keymap("v", "<leader>y", '"+y', { desc = "Copy to clipboard" })
	-- Make delete not copy to default register
	keymap("n", "d", '"_d', opts)
	keymap("n", "D", '"_D', opts)
	keymap("v", "d", '"_d', opts)
	keymap("v", "D", '"_D', opts)
	keymap("n", "x", '"_x', opts)
	keymap("v", "x", '"_x', opts)
	keymap("n", "c", '"_c', opts)
	keymap("v", "c", '"_c', opts)
	-- Déplacements classiques avec hjkl
	keymap("i", "<C-h>", "<Left>", opts) -- Ctrl + h : Aller à gauche
	keymap("i", "<C-l>", "<Right>", opts) -- Ctrl + l : Aller à droite
	keymap("i", "<C-j>", "<Down>", opts) -- Ctrl + j : Descendre
	keymap("i", "<C-k>", "<Up>", opts) -- Ctrl + k : Monter

	-- Navigation mot par mot
	keymap("i", "<C-b>", "<S-Left>", opts) -- Ctrl + b : Aller au mot précédent
	keymap("i", "<C-w>", "<S-Right>", opts) -- Ctrl + w : Aller au mot suivant

	-- Aller au début et à la fin de la ligne
	keymap("i", "<C-a>", "<Home>", opts) -- Ctrl + a : Aller au début de la ligne
	keymap("i", "<C-e>", "<End>", opts) -- Ctrl + e : Aller à la fin de la ligne

	-- Suppression mot par mot et ligne entière
	keymap("i", "<C-Backspace>", "<C-w>", opts) -- Ctrl + Backspace : Supprimer le mot précédent
	keymap("i", "<C-d>", "<Del>", opts) -- Ctrl + d : Supprimer le caractère sous le curseur
	keymap("i", "<C-u>", "<C-o>d0", opts) -- Ctrl + u : Supprimer jusqu'au début de la ligne
	keymap("i", "<C-o>", "<Esc>o<Esc>i", opts)
	-- Alternative pour quitter le mode insert plus rapidement
	keymap("i", "<C-c>", "<Esc>", opts)
	keymap("n", "<leader><leader>", "<C-^>", { desc = "Switch to last file" })
	keymap("n", "<leader>b", ":b#<CR>", { desc = "Switch to previous buffer" })
	keymap("n", "<leader>n", ":bnext<CR>", { desc = "Next buffer" })
	keymap("n", "<leader>p", ":bprevious<CR>", { desc = "Previous buffer" })
	keymap("n", "<leader>bd", ":bd<CR>", { desc = "Close buffer" })
  local opts = { noremap = true, silent = true }
  -- Normal-mode commands
  keymap('n', '<A-j>', ':MoveLine(1)<CR>', opts)
  keymap('n', '<A-k>', ':MoveLine(-1)<CR>', opts)
  keymap('n', '<A-h>', ':MoveHChar(-1)<CR>', opts)
  keymap('n', '<A-l>', ':MoveHChar(1)<CR>', opts)
  keymap('n', '<leader>wf', ':MoveWord(1)<CR>', opts)
  keymap('n', '<leader>wb', ':MoveWord(-1)<CR>', opts)

  -- Visual-mode commands
  keymap('v', '<A-j>', ':MoveBlock(1)<CR>', opts)
  keymap('v', '<A-k>', ':MoveBlock(-1)<CR>', opts)
  keymap('v', '<A-h>', ':MoveHBlock(-1)<CR>', opts)
  keymap('v', '<A-l>', ':MoveHBlock(1)<CR>', opts)
end

return M
