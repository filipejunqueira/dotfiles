-- lua/plugins/treesitter.lua — nvim-treesitter (MAIN branch, correct API)
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	config = function()
		local parsers = {
			"bash",
			"lua",
			"luadoc",
			"vim",
			"vimdoc",
			"query",
			"diff",
			"regex",
			"python",
			"c",
			"cpp",
			"fortran",
			"javascript",
			"typescript",
			"tsx",
			"html",
			"css",
			"json",
			"xml",
			"markdown",
			"markdown_inline",
			"http",
			"sql",
			"latex",
			"odin",
			"yaml",
			"toml",
			"go",
			"gomod",
			"gosum",
		}
		require("nvim-treesitter").install(parsers)

		-- Start highlighting on any buffer whose language has a parser
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter-highlight", { clear = true }),
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
				if lang then
					pcall(vim.treesitter.start, args.buf, lang)
				end
			end,
		})
	end,
}
