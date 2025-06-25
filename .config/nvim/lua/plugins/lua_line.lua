return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"f-person/git-blame.nvim",
	},
	config = function()
		local colors = {
			bg = "#1e1e2e",
			fg = "#cdd6f4",
			yellow = "#f9e2af",
			cyan = "#89dceb",
			green = "#a6e3a1",
			orange = "#fab387",
			violet = "#cba6f7",
			magenta = "#cba6f7",
			blue = "#89b4fa",
			red = "#f38ba8",
			overlay0 = "#6c7086",
			surface2 = "#585b70",
		}

		local mode_color = {
			n = colors.blue,
			i = colors.green,
			v = colors.magenta,
			[""] = colors.magenta,
			V = colors.magenta,
			c = colors.orange,
			no = colors.red,
			s = colors.violet,
			S = colors.violet,
			[""] = colors.violet,
			ic = colors.yellow,
			R = colors.red,
			Rv = colors.red,
			cv = colors.red,
			ce = colors.red,
			r = colors.cyan,
			rm = colors.cyan,
			["r?"] = colors.cyan,
			["!"] = colors.red,
			t = colors.green,
		}

		local function lsp_status()
			local clients = vim.lsp.get_clients()
			if next(clients) == nil then
				return ""
			end

			local client_names = {}
			for _, client in ipairs(clients) do
				if client.name ~= "null-ls" then
					table.insert(client_names, client.name)
				end
			end
			return "  " .. table.concat(client_names, ", ")
		end

		---@diagnostic disable-next-line: undefined-field
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = { "NvimTree", "Trouble", "dashboard" },
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				always_show_tabline = true,
				globalstatus = true,
				refresh = {
					statusline = 100,
					tabline = 100,
					winbar = 100,
				},
			},
			sections = {
				lualine_a = {
					{
						"mode",
						color = function()
							return { bg = mode_color[vim.fn.mode()], fg = colors.bg, gui = "bold" }
						end,
					},
				},
				lualine_b = {
					{ "branch", icon = "", color = { fg = colors.violet } },
					{
						"diff",
						symbols = { added = " ", modified = " ", removed = " " },
						diff_color = {
							added = { fg = colors.green },
							modified = { fg = colors.orange },
							removed = { fg = colors.red },
						},
						color = { fg = colors.fg },
					},
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = " ", warn = " ", info = " ", hint = " " },
						diagnostics_color = {
							error = { fg = colors.red },
							warn = { fg = colors.yellow },
							info = { fg = colors.blue },
							hint = { fg = colors.cyan },
						},
						color = { fg = colors.fg },
					},
				},
				lualine_c = {
					{
						"filename",
						file_status = true,
						path = 0,
						symbols = {
							modified = "[+]",
							readonly = "[RO]",
							unnamed = "[No Name]",
							newfile = "[New]",
						},
						color = { fg = colors.fg, gui = "bold" },
					},
				},
				lualine_x = {
					{ "encoding", color = { fg = colors.magenta } },
					{
						"fileformat",
						symbols = { unix = "", dos = "", mac = "" },
						color = { fg = colors.magenta },
					},
					{ "filetype", color = { fg = colors.fg } },
				},
				lualine_y = {
					{ lsp_status, color = { fg = colors.magenta } },
				},
				lualine_z = {
					{ "progress", color = { fg = colors.bg } },
					{ "location", color = { fg = colors.bg } },
				},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", color = { fg = colors.overlay0 } } },
				lualine_x = { { "location", color = { fg = colors.overlay0 } } },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {},
		})

		require("gitblame").setup({
			enabled = true,
			message_template = " <author> • <date> ",
			date_format = "%r",
		})
	end,
}
