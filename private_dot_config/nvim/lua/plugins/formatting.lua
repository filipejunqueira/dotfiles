-- lua/plugins/formatting.lua — Auto-formatting via conform.nvim

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			-- Disable format-on-save for C/C++ (no standardised style)
			local disable_filetypes = { c = true, cpp = true }
			if disable_filetypes[vim.bo[bufnr].filetype] then
				return nil
			end
			return {
				timeout_ms = 500,
				lsp_format = "fallback",
			}
		end,

		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_format", "ruff_fix" },
			go = { "gofmt" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			zsh = { "shfmt" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			json = { "prettierd", "prettier", stop_after_first = true },
			yaml = { "prettierd", "prettier", stop_after_first = true },
			-- ── Phase 1 additions ──
			css = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "prettierd", "prettier", stop_after_first = true },
			sql = { "sqlfluff" },
			fortran = { "fprettify" },
			tex = { "latexindent" },
			odin = { "odinfmt" },
			-- xml: formatted by lemminx via the lsp_format fallback (no CLI formatter needed)
		},
		formatters = {
			odinfmt = { command = "odinfmt", args = { "-stdin" }, stdin = true },
			sqlfluff = { command = "sqlfluff", args = { "format", "-" }, stdin = true },
		},
	},
}
