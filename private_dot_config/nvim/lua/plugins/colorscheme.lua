-- lua/plugins/colorscheme.lua — Ember (matching Ghostty + Zellij + Starship theme stack)
return {
	{
		"ember-theme/nvim",
		name = "ember",
		priority = 1000,
		config = function()
			require("ember").setup({
				variant = "ember",
				styles = {
					comments = { italic = true },
					keywords = { bold = true },
					functions = {},
					types = { bold = true },
				},
				transparent = false,
			})
			vim.cmd.colorscheme("ember")
		end,
	},
}
