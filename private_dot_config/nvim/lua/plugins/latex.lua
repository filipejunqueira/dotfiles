-- lua/plugins/latex.lua — LaTeX editing via vimtex (texlab + latexindent come from Phase 1)
return {
	"lervag/vimtex",
	ft = { "tex", "plaintex", "latex" },
	init = function()
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_compiler_method = "latexmk"
		vim.g.vimtex_quickfix_mode = 0
		vim.g.vimtex_syntax_enabled = 0 -- let Treesitter highlight (keeps your 8-colour scheme)
	end,
}
