-- lua/plugins/ai.lua — AI inline completion (ghost text) via local Ollama + minuet
return {
	"milanglacier/minuet-ai.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		-- Toggle AI ghost text on/off (shows under your [T]oggle group in which-key)
		{ "<leader>ta", "<cmd>Minuet virtualtext toggle<cr>", desc = "Toggle [A]I ghost text" },
	},
	lazy = false, -- load at startup so virtualtext auto-trigger always arms
	opts = {
		-- Local FIM model served by Ollama's OpenAI-compatible endpoint
		provider = "openai_fim_compatible",
		n_completions = 1, -- one suggestion at a time (saves GPU on local models)
		context_window = 4096, -- how much surrounding code to send; raise if your GPU copes
		throttle = 500, -- min ms between requests
		debounce = 250, -- ms of idle typing before a request fires
		provider_options = {
			openai_fim_compatible = {
				api_key = "TERM", -- Ollama needs no key; "TERM" just points minuet at a harmless env var
				name = "Ollama",
				end_point = "http://localhost:11434/v1/completions",
				--model = "qwen2.5-coder:3b-base",
				model = "qwen2.5-coder:7b-base",
				optional = {
					max_tokens = 256,
					top_p = 0.9,
					stop = { "\n\n" },
				},
			},
		},
		-- Ghost-text (Copilot-style) display. blink keeps <Tab>; AI accepted on <C-CR> (Ctrl+Enter).
		virtualtext = {
			auto_trigger_ft = { "*" }, -- suggest in all filetypes; narrow to a list to limit GPU load
			keymap = {
				-- <C-a> is the insert-mode "AI" prefix; which-key shows the menu after it.
				accept = "<C-a>a", -- [a]ccept whole suggestion
				accept_line = "<C-a>l", -- accept one [l]ine
				next = "<C-a>n", -- [n]ext / summon suggestion
				prev = "<C-a>p", -- [p]revious
				dismiss = "<C-a>d", -- [d]ismiss
			},
		},
	},
}
