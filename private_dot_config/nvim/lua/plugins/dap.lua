-- lua/plugins/dap.lua — Debugging + variable inspector (feature #6)
return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio", -- required by dap-ui
		"jay-babu/mason-nvim-dap.nvim", -- installs adapters via Mason
		"mfussenegger/nvim-dap-python", -- Python helper
	},
	keys = {
		-- IDE-style stepping (familiar from PyCharm/VS Code)
		{
			"<F5>",
			function()
				require("dap").continue()
			end,
			desc = "Debug: continue / start",
		},
		{
			"<F10>",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: step over",
		},
		{
			"<F11>",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: step into",
		},
		{
			"<F12>",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: step out",
		},
		-- <leader>D group (capital D — your <leader>d is "delete without yanking")
		{
			"<leader>Db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Breakpoint",
		},
		{
			"<leader>DB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Condition: "))
			end,
			desc = "Conditional breakpoint",
		},
		{
			"<leader>Dr",
			function()
				require("dap").repl.open()
			end,
			desc = "Open REPL",
		},
		{
			"<leader>Dl",
			function()
				require("dap").run_last()
			end,
			desc = "Run last",
		},
		{
			"<leader>Dt",
			function()
				require("dap").terminate()
			end,
			desc = "Terminate",
		},
		{
			"<leader>Du",
			function()
				require("dapui").toggle()
			end,
			desc = "Toggle UI (inspector)",
		},
		{
			"<leader>De",
			function()
				require("dapui").eval()
			end,
			mode = { "n", "v" },
			desc = "Evaluate expression",
		},
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")

		require("mason-nvim-dap").setup({
			ensure_installed = { "python", "codelldb" }, -- debugpy + native (C/C++/Odin/Fortran)
			automatic_installation = true,
			handlers = {
				function(config)
					require("mason-nvim-dap").default_setup(config)
				end, -- codelldb etc.
				python = function() end, -- skip; nvim-dap-python configures Python below
			},
		})

		-- Python: uses Mason's debugpy (perfect for standalone scripts).
		-- For project code with third-party imports, point this at your venv's python.
		require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")

		dapui.setup()

		-- Auto-open/close the inspector with the session
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		-- Breakpoint signs (reusing your Ember diagnostic colours)
		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
		vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn" })
	end,
}
