-- lua/plugins/lint.lua — Linting via nvim-lint (the diagnostics layer)
return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			sh = { "shellcheck" },
			bash = { "shellcheck" },
			sql = { "sqlfluff" },
			-- python: already covered by the ruff LSP, so no entry needed
			-- zsh: shellcheck doesn't support zsh, so deliberately omitted
		}

		local grp = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
			group = grp,
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
