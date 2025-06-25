return {
	"echasnovski/mini.animate",
	event = "VeryLazy",
  enabled = false,
	cond = vim.g.neovide == nil,
	opts = function(_, opts)
		-- Don't animate when scrolling with mouse
		local mouse_scrolled = false
		for _, scroll in ipairs({ "Up", "Down" }) do
			local key = "<ScrollWheel" .. scroll .. ">"
			vim.keymap.set({ "", "i" }, key, function()
				mouse_scrolled = true
				return key
			end, { expr = true })
		end

		-- Disable animation for certain filetypes
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "grug-far",
			callback = function()
				vim.b.minianimate_disable = true
			end,
		})

		local animate = require("mini.animate")
		return vim.tbl_deep_extend("force", opts, {
			cursor = {
				enable = true,
				timing = animate.gen_timing.linear({ duration = 40, unit = "total" }),
			},
			scroll = {
				enable = true,
				timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
				subscroll = animate.gen_subscroll.equal({
					predicate = function(total_scroll)
						if mouse_scrolled then
							mouse_scrolled = false
							return false
						end
						return total_scroll > 1
					end,
				}),
			},
			-- Disable other animations
			open = { enable = false },
			close = { enable = false },
			resize = { enable = false },
		})
	end,
}
