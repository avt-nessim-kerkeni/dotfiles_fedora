return {
	"nvim-telescope/telescope.nvim",
	lazy = false,
	cmd = "Telescope", -- Lazy load when calling Telescope
	dependencies = {
		{ "nvim-lua/plenary.nvim" }, -- Required dependency
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- Fast searching
		{ "nvim-telescope/telescope-ui-select.nvim" }, -- Better UI select
    { "rcarriga/nvim-notify" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				prompt_prefix = "🔍 ",
				selection_caret = "› ",
				path_display = { "smart" },
				borderchars = {
					prompt = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
					results = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
					preview = { "═", "║", "═", "║", "╔", "╗", "╝", "╚" },
				},
				mappings = {
					i = {
						["<C-n>"] = actions.cycle_history_next, -- Next search history
						["<C-p>"] = actions.cycle_history_prev, -- Previous search history
						["<C-j>"] = actions.move_selection_next, -- Move down
						["<C-k>"] = actions.move_selection_previous, -- Move up
						["<C-o"] = actions.select_vertical, -- Open in vertical split
						["<C-x>"] = actions.select_horizontal, -- Open in horizontal split
						["<C-t>"] = actions.select_tab, -- Open in new tab
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- Send to Quickfix list
						["<Esc>"] = actions.close, -- Close Telescope
						["<C-c>"] = actions.close,
					},
					n = {
						["q"] = actions.close,
					},
				},
			},
			pickers = {
				find_files = { hidden = true }, -- Show hidden files
				live_grep = { only_sort_text = true }, -- Grep text only, ignore filenames
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
			},
		})

		-- Load extensions
		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")
    telescope.load_extension("notify")
		-- Keymaps for launching Telescope
		local keymap = vim.keymap.set
		keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "🔍 Find Files" })
		keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "🔎 Live Grep" })
		keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "📂 Open Buffers" })
		keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "📖 Help Tags" })
		keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "⏳ Recent Files" })
		keymap("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "🛠 Commands" })
		-- LSP Keymaps
		keymap("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "📄 Document Symbols" })
		keymap("n", "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "📁 Workspace Symbols" })
		keymap("n", "<leader>fd", "<cmd>Telescope lsp_definitions<cr>", { desc = "➡️ Go to Definition" })
		keymap("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>", { desc = "🔗 References" })
		keymap("n", "<leader>fi", "<cmd>Telescope lsp_implementations<cr>", { desc = "⚙️ Implementations" })
		keymap("n", "<leader>ft", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "📐 Type Definitions" })
    -- notifs
    keymap('n', '<leader>fn', ':Telescope notify<CR>', { noremap = true, silent = true })
	end,
}
