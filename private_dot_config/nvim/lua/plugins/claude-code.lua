-- lua/plugins/claude-code.lua — Claude Code WebSocket IDE integration
--
-- Runs a WebSocket server inside neovim that Claude Code auto-connects to.
-- Works with Zellij panes: nvim in one pane, ccode in another.
-- Loads at startup so the server is always available.
return {
  'coder/claudecode.nvim',
  lazy = false,
  dependencies = {
    'folke/snacks.nvim',
  },
  opts = {
    auto_start = true,
    log_level = 'info',
    terminal = {
      provider = 'none',
    },
  },
  keys = {
    { '<leader>a', nil, desc = 'AI/Claude Code' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = '[A]I: [S]end to Claude' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = '[A]I: Add [B]uffer to Claude' },
  },
}
