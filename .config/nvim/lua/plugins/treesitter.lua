return {
	-- nvim-treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"HiPhish/rainbow-delimiters.nvim",
			"nvim-treesitter/playground",
		},
		opts = {
			ensure_installed = {
				"php",
				"twig",
				"html",
				"css",
				"scss",
				"javascript",
				"typescript",
				"json",
				"yaml",
				"dockerfile",
				"bash",
				"python",
				"lua",
				"vim",
				"query",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)

			-- Configuration de l'indentation avec Tree-sitter
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
			vim.opt.foldenable = true
			vim.opt.foldlevel = 99
			vim.opt.foldlevelstart = 99
			vim.opt.foldcolumn = "1"
		end,
	},

	-- rainbow-delimiters.nvim
	{
		"HiPhish/rainbow-delimiters.nvim",
		config = function()
			local palette = require("catppuccin.palettes").get_palette("mocha")

			vim.g.rainbow_delimiters = {
				strategy = {
					[""] = "rainbow-delimiters.strategy.global",
					vim = "rainbow-delimiters.strategy.local",
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
				},
				highlight = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
			}
			-- Application des couleurs Catppuccin Mocha
			vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = palette.red })
			vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = palette.yellow })
			vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = palette.blue })
			vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = palette.peach })
			vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = palette.green })
			vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = palette.mauve })
			vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = palette.sky })
		end,
	},
}
