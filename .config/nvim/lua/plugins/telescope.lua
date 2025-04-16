return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",                                            -- Lazy load when calling Telescope
    dependencies = {
        { "nvim-lua/plenary.nvim" },                              -- Required dependency
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- Fast searching
        { "nvim-telescope/telescope-ui-select.nvim" },            -- Better UI select
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                prompt_prefix = "🔍 ",
                selection_caret = "➜ ",
                path_display = { "smart" },
                mappings = {
                    i = {
                        ["<C-n>"] = actions.cycle_history_next,          -- Next search history
                        ["<C-p>"] = actions.cycle_history_prev,          -- Previous search history
                        ["<C-j>"] = actions.move_selection_next,         -- Move down
                        ["<C-k>"] = actions.move_selection_previous,     -- Move up
                        ["<C-v>"] = actions.select_vertical,             -- Open in vertical split
                        ["<C-x>"] = actions.select_horizontal,           -- Open in horizontal split
                        ["<C-t>"] = actions.select_tab,                  -- Open in new tab
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- Send to Quickfix list
                        ["<Esc>"] = actions.close,                       -- Close Telescope
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

        -- Keymaps for launching Telescope
        local keymap = vim.keymap.set
        keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "🔍 Find Files" })
        keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "🔎 Live Grep" })
        keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "📂 Open Buffers" })
        keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "📖 Help Tags" })
        keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "⏳ Recent Files" })
        keymap("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "🛠 Commands" })

        -- Open files in a new buffer inside Telescope
        keymap("n", "<leader>fn", function()
            require("telescope.builtin").find_files({
                attach_mappings = function(_, map)
                    map("i", "<C-o>", function(prompt_bufnr)
                        local action_state = require("telescope.actions.state")
                        local actions = require("telescope.actions")
                        local entry = action_state.get_selected_entry()
                        actions.close(prompt_bufnr)
                        vim.cmd("edit " .. entry.path) -- Open in a new buffer
                    end)
                    return true
                end,
            })
        end, { desc = "📂 Find File in New Buffer" })
    end,
}

