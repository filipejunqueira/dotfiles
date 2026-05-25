-- lua/plugins/lsp.lua — Language Server Protocol configuration

return {
	{
		-- lazydev configures Lua LSP for neovim config/runtime/plugins
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", opts = {} },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
					map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
					map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
					map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

					-- Highlight references under cursor
					local client = vim.lsp.get_client_by_id(event.data.client_id)

					---@param c vim.lsp.Client
					---@param method vim.lsp.protocol.Method
					---@param bufnr? integer
					---@return boolean
					local function supports(c, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return c:supports_method(method, bufnr)
						else
							return c.supports_method(method, { bufnr = bufnr })
						end
					end

					if
						client and supports(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
					then
						local hl_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = hl_group,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = hl_group,
							callback = vim.lsp.buf.clear_references,
						})
						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- Toggle inlay hints
					if client and supports(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Diagnostics
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
				},
			})

			-- Capabilities from blink.cmp, applied to *every* server via the '*' wildcard.
			-- Named server configs below merge on top of this and of nvim-lspconfig's
			-- bundled lsp/<name>.lua defaults (cmd / filetypes / root markers).
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			vim.lsp.config("*", { capabilities = capabilities })

			-- Language servers. Only per-server *overrides* go here.
			local servers = {
				lua_ls = {
					settings = {
						Lua = { completion = { callSnippet = "Replace" } },
					},
				},
				pyright = {
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "basic",
								autoImportCompletions = true,
							},
						},
					},
				},
				clangd = {},
				bashls = {},
				ts_ls = {},
				fortls = {}, -- Fortran
				gopls = {
					settings = {
						gopls = {
							analyses = { unusedparams = true },
							staticcheck = true,
						},
					},
				},
				-- ── Phase 1 additions ──
				jsonls = {}, -- JSON
				lemminx = {}, -- XML
				cssls = {}, -- CSS
				marksman = {}, -- Markdown
				texlab = {}, -- LaTeX
				sqls = {}, -- SQL
			}

			-- Register each server's overrides via the native vim.lsp.config API.
			for server_name, server_config in pairs(servers) do
				vim.lsp.config(server_name, server_config)
			end

			-- Tools to install via Mason (LSP servers + formatters + linters).
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
				"ruff",
				"shfmt",
				-- ── Phase 1 additions ──
				"prettierd", -- web / json / css / md / xml formatter
				"shellcheck", -- bash / zsh linter
				"latexindent", -- latex formatter
				"fprettify", -- fortran formatter
				"sqlfluff", -- sql linter + formatter
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			-- mason-lspconfig 2.x: the old `handlers` / `automatic_installation` API is gone.
			-- It now auto-enables (vim.lsp.enable) whatever servers Mason has installed, picking
			-- up the configs registered above. Installation is handled by mason-tool-installer.
			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_enable = true,
			})

			-- Odin: ols is installed system-wide (pacman), which Mason doesn't manage, so it
			-- won't be auto-enabled — enable it explicitly. Capabilities come from '*' above.
			vim.lsp.enable("ols")
		end,
	},
}
