-- lua/plugins/colorscheme.lua — Ember (8-colour syntax, matching Ghostty/Zellij/Starship)
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

			-- Ember palette (from ember.conf) + two added hues to reach the full 8
			local c = {
				coral = "#e08060", -- 1  keywords          (theme default)
				green = "#8a9868", -- 2  strings           (theme default)
				gold = "#c8b468", -- 3  numbers           (theme default)
				blue = "#7890a0", -- 4  decorators / keys
				rose = "#b07878", -- 5  booleans / None / null
				sage = "#80a090", -- 6  builtins
				amber = "#c89060", -- 7  user functions    (added)
				mauve = "#a288a8", -- 8  types             (added)
			}

			-- Recolour a capture group while PRESERVING its existing bold/italic
			local function recolor(group, fg)
				local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
				hl.fg = fg
				hl.force = true
				vim.api.nvim_set_hl(0, group, hl)
			end

			local function ember_overrides()
				recolor("@boolean", c.rose) -- True / False
				recolor("@constant.builtin", c.rose) -- None / null
				recolor("@function.builtin", c.sage) -- print / len / range ...
				recolor("@property.json", c.blue) -- JSON keys
				recolor("@function", c.amber) -- your functions
				recolor("@function.call", c.amber)
				recolor("@type", c.mauve) -- types (keeps theme bold)
				recolor("@type.builtin", c.mauve)
			end

			vim.cmd.colorscheme("ember")
			ember_overrides()

			-- re-apply whenever the colorscheme (re)loads
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "ember",
				callback = ember_overrides,
			})
		end,
	},
}
