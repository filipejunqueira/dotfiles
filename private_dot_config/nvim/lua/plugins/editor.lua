-- lua/plugins/editor.lua — Editor enhancement plugins

return {
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",

	-- Highlight todo, notes, etc. in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	-- Show pending keybinds (essential for discoverability)
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			delay = 0,
			icons = {
				mappings = vim.g.have_nerd_font,
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
				},
			},
			triggers = {
				{ "<auto>", mode = "nxso" }, -- which-key defaults (normal/visual/select/op-pending)
				{ "<c-a>", mode = "i" }, -- let the popup fire for the insert-mode AI menu
			},
			spec = {
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
				{ "<leader>b", group = "[B]uffer" },
				{ "<leader>a", group = "[A]I / Claude" },
				-- Insert-mode AI ghost-text menu (minuet): <C-a> then a/l/n/p/d
				{ "<c-a>", group = "AI", mode = "i" },
				{ "<c-a>a", desc = "Accept", mode = "i" },
				{ "<c-a>l", desc = "Accept line", mode = "i" },
				{ "<c-a>n", desc = "Next / summon", mode = "i" },
				{ "<c-a>p", desc = "Prev", mode = "i" },
				{ "<c-a>d", desc = "Dismiss", mode = "i" },
			},
		},
	},

	-- Collection of small independent modules
	{
		"echasnovski/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings
			require("mini.surround").setup()

			-- Statusline
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })

			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},
}
