return {
	"rcarriga/nvim-notify",
	config = function()
		local notify = require("notify")

		-- Create a module-level variable to track notification state
		local notifications_enabled = true

		-- Store the original vim.notify function
		local original_notify = vim.notify

		-- Set up notify with your preferred settings
		notify.setup({
			-- Customize appearance
			background_colour = "#1e1e2e",
			fps = 120,
			icons = {
				DEBUG = "󰇚",
				ERROR = "󰅙",
				INFO = "󰋽",
				TRACE = "󰥔",
				WARN = "󰀪",
			},
			level = 2, -- Minimum log level (1=ERROR, 2=WARN, 3=INFO, 4=DEBUG, 5=TRACE)
			minimum_width = 50,
			render = "wrapped-compact",
			stages = "slide",
			timeout = 3000,

			-- Filter out unwanted notifications
			on_open = function(win)
				-- Get notification content
				local buf = vim.api.nvim_win_get_buf(win)
				local notif_text = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
				local full_text = table.concat(notif_text, " ")

				-- List of patterns to filter out
				local filtered_patterns = {
					"^%d+ lines? %a+$", -- Matches "1 line added", "5 lines yanked", etc.
					"^%d+ fewer lines?$", -- Matches "1 fewer line", etc.
					"^%d+ more lines?$", -- Matches "1 more line", etc.
					"^%d+ changes?;", -- Matches "1 change; after #...", etc.
					"Type.*to exit", -- Matches "Type :qa to exit", etc.
					"Press ENTER or type command to continue",
					"search hit BOTTOM",
					"search hit TOP",
					"Already at .*end",
					"Already at .*beginning",
					"Pattern not found",
					"E486: Pattern not found",
					"No lines in buffer",
					"No more lines to delete",
					"No changes to write",
					"No changes were made",
					"^%d+ substitutions? on %d+ lines?",
					"^W%d+:",
					"^E%d+:",
				}

				-- Check if notification matches any filtered pattern
				for _, pattern in ipairs(filtered_patterns) do
					if full_text:match(pattern) then
						-- Close the notification immediately
						vim.defer_fn(function()
							pcall(vim.api.nvim_win_close, win, true)
						end, 0)
						return
					end
				end
			end,
		})

		-- Function to toggle notifications on/off
		local function toggle_notifications()
			if notifications_enabled then
				-- Store current notify function to restore later
				original_notify = vim.notify

				-- Replace with dummy function that does nothing
				vim.notify = function(...)
					-- No-op function
					return ...
				end

				-- Dismiss any pending notifications
				notify.dismiss({ pending = true, silent = true })

				-- Show a final notification that notifications are disabled
				original_notify("Notifications disabled", "info", {
					title = "Notification System",
					icon = " ",
					timeout = 2000,
				})

				notifications_enabled = false
			else
				-- Restore the original notify function
				vim.notify = original_notify

				-- Show a notification that notifications are enabled
				vim.notify("Notifications enabled", "info", {
					title = "Notification System",
					icon = " ",
					timeout = 2000,
				})

				notifications_enabled = true
			end
		end

		-- Replace the default vim.notify with nvim-notify
		vim.notify = notify

		-- Create a command to dismiss all notifications
		vim.api.nvim_create_user_command("NotifyClear", function()
			notify.dismiss({ pending = true, silent = true })
		end, {})

		-- Create a command to toggle notifications
		vim.api.nvim_create_user_command("NotifyToggle", toggle_notifications, {})

		-- Shortcut to dismiss notifications
		vim.keymap.set("n", "<leader>nc", function()
			notify.dismiss({ pending = true, silent = true })
		end, { noremap = true, silent = true, desc = "Clear notifications" })

		-- Shortcut to toggle notifications on/off
		vim.keymap.set(
			"n",
			"<leader>ns",
			toggle_notifications,
			{ noremap = true, silent = true, desc = "Toggle notifications" }
		)
	end,
}
