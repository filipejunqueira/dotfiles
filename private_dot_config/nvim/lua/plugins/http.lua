-- lua/plugins/http.lua — REST client for .http files
return {
	"mistweaverco/kulala.nvim",
	ft = { "http", "rest" },
	opts = {
		global_keymaps = true, -- kulala wires its full keymap set...
		global_keymaps_prefix = "<leader>R", -- ...under <leader>R, scoped to http buffers
		kulala_keymaps_prefix = "",
	},
}
