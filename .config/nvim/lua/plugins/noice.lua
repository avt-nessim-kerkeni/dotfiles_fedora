-- noice.nvim configuration with Catppuccin Mocha theme integration
-- Dependencies: nvim-notify, nui.nvim, and catppuccin

return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
		"catppuccin/nvim",
	},
	config = function()
		local catppuccin = require("catppuccin.palettes").get_palette("mocha")

		-- Configure Noice
		require("noice").setup({
			cmdline = {
				enabled = true,
				view = "cmdline_popup",
				format = {
					cmdline = { pattern = "^:", icon = "❯", lang = "vim" },
					search_down = { kind = "search", pattern = "^/", icon = "󰍉", lang = "regex" },
					search_up = { kind = "search", pattern = "^%?", icon = "󰍉", lang = "regex" },
					filter = { pattern = "^:%s*!", icon = "󰻿", lang = "bash" },
					lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "󰢱", lang = "lua" },
					help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
					input = { icon = "󰛷" },
				},
				opts = {
					position = {
						row = -3,
						col = "50%",
					},
					size = {
						width = "auto",
						height = "auto",
					},
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
					win_options = {
						winhighlight = {
							Normal = "NoiceCmdlinePopup",
							FloatBorder = "NoiceCmdlinePopupBorder",
							IncSearch = "",
							Search = "",
						},
					},
				},
			},
			messages = {
				enabled = true,
				view = "notify",
				view_error = "notify",
				view_warn = "notify",
				view_history = "messages",
				view_search = "virtualtext",
			},
			popupmenu = {
				enabled = true,
				backend = "nui",
				kind_icons = {
					Class = "󰠱",
					Color = "󰏘",
					Constant = "󰏿",
					Constructor = "󰆧",
					Enum = "󰒻",
					EnumMember = "󰒻",
					Event = "",
					Field = "󰇽",
					File = "󰈙",
					Folder = "󰉋",
					Function = "󰊕",
					Interface = "󰜰",
					Keyword = "󰌋",
					Method = "󰆧",
					Module = "󰏓",
					Operator = "󰆕",
					Property = "󰜢",
					Reference = "󰈇",
					Snippet = "󰩫",
					Struct = "󰙅",
					Text = "󰉿",
					TypeParameter = "󰅲",
					Unit = "󰑭",
					Value = "󰎠",
					Variable = "󰂡",
				},
			},
			lsp = {
				progress = {
					enabled = true,
					format = "lsp_progress",
					format_done = "lsp_progress_done",
					throttle = 1000 / 30, -- frequency to update lsp progress message
					view = "mini",
				},
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				hover = {
					enabled = true,
					silent = false,
					view = nil, -- when nil, use defaults from documentation
					opts = {}, -- merged with defaults from documentation
				},
				signature = {
					enabled = true,
					auto_open = {
						enabled = true,
						trigger = true, -- automatically show signature help when typing a trigger character from the LSP
						luasnip = true, -- will open signature help when jumping to Luasnip insert nodes
						throttle = 50, -- debounce lsp signature help request by 50ms
					},
					view = nil, -- when nil, use defaults from documentation
					opts = {}, -- merged with defaults from documentation
				},
				message = {
					enabled = true,
					view = "notify",
					opts = {},
				},
				documentation = {
					view = "hover",
					opts = {
						lang = "markdown",
						replace = true,
						render = "plain",
						format = { "{message}" },
						win_options = { concealcursor = "n", conceallevel = 3 },
					},
				},
			},
			markdown = {
				hover = {
					["|(%S-)|"] = vim.cmd.help, -- vim help links
					["%[.-%]%((%S-)%)"] = require("noice.util").open, -- markdown links
				},
				highlights = {
					["|%S-|"] = "@text.reference",
					["@%S+"] = "@parameter",
					["^%s*(Parameters:)"] = "@text.title",
					["^%s*(Return:)"] = "@text.title",
					["^%s*(See also:)"] = "@text.title",
					["{%S-}"] = "@parameter",
				},
			},
			health = {
				checker = true,
			},
			smart_move = {
				enabled = true,
				excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = true,
				lsp_doc_border = true,
			},
			throttle = 1000 / 30,
			views = {
				mini = {
					win_options = {
						winblend = 0,
					},
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "written",
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = "msg_show",
						kind = "search_count",
					},
					opts = { skip = true },
				},
			},
		})

		-- Apply Catppuccin Mocha highlights to Noice
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = catppuccin.mantle })
				vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = catppuccin.blue, bg = catppuccin.mantle })
				vim.api.nvim_set_hl(0, "NoiceCmdlinePopupTitle", { fg = catppuccin.text, bg = catppuccin.mantle })
				vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = catppuccin.blue })
				vim.api.nvim_set_hl(0, "NoiceConfirmBorder", { fg = catppuccin.blue })
				vim.api.nvim_set_hl(0, "NoiceFormatTitle", { fg = catppuccin.lavender, bold = true })
				vim.api.nvim_set_hl(0, "NoiceFormatProgressDone", { bg = catppuccin.green, fg = catppuccin.base })
				vim.api.nvim_set_hl(0, "NoiceFormatProgressTodo", { bg = catppuccin.surface0 })
				vim.api.nvim_set_hl(0, "NoiceLspProgressClient", { fg = catppuccin.mauve })
				vim.api.nvim_set_hl(0, "NoiceLspProgressTitle", { fg = catppuccin.blue })
				vim.api.nvim_set_hl(0, "NoiceLspProgressSpinner", { fg = catppuccin.rosewater })
			end,
		})

		-- Key mappings for Noice
		vim.keymap.set("n", "<leader>nn", function()
			require("noice").cmd("dismiss")
		end, { desc = "Dismiss all Noice messages" })
		vim.keymap.set("n", "<leader>nh", function()
			require("noice").cmd("history")
		end, { desc = "Noice message history" })
		vim.keymap.set("n", "<leader>nl", function()
			require("noice").cmd("last")
		end, { desc = "Noice last message" })
		vim.keymap.set("n", "<leader>ne", function()
			require("noice").cmd("errors")
		end, { desc = "Noice errors" })
	end,
}
