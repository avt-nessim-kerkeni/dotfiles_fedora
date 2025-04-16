return {
	"norcalli/nvim-colorizer.lua",
	event = { "BufEnter", "BufReadPre" },
	config = function()
		require("colorizer").setup()
	end,
	keys = {
		{
			"<leader>ch",
			"<cmd>ColorizerToggle<CR>",
			desc = "Toggle Colorizer",
		},
	},
}
