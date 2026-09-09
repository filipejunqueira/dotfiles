-- lua/plugins/aerial.lua — Symbol outline / table-of-contents sidebar
return {
	"stevearc/aerial.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		-- Prefer LSP symbols; fall back to treesitter, then markdown headings.
		backends = { "lsp", "treesitter", "markdown", "man" },
		layout = { default_direction = "right", min_width = 30 },
		highlight_on_jump = 150, -- flash the symbol you jump to
		show_guides = true, -- tree guide lines
		on_attach = function(bufnr)
			-- Jump between symbols from the *code* buffer itself.
			vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Aerial: previous symbol" })
			vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Aerial: next symbol" })
		end,
	},
	keys = {
		{ "<leader>o", "<cmd>AerialToggle<CR>", desc = "Toggle symbol [O]utline" },
		{ "<leader>O", "<cmd>AerialNavToggle<CR>", desc = "Symbol nav (floating [O]utline)" },
	},
}
