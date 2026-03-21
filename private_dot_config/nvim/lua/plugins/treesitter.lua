-- lua/plugins/treesitter.lua — Syntax highlighting and code understanding

return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup {
      ensure_installed = {
        'bash', 'lua', 'luadoc', 'vim', 'vimdoc', 'query',
        'python', 'c', 'cpp', 'fortran', 'go', 'gomod', 'gosum',
        'javascript', 'typescript', 'tsx', 'html', 'css',
        'json', 'yaml', 'toml', 'kdl', 'xml',
        'markdown', 'markdown_inline', 'diff',
        'regex', 'dockerfile',
      },
      auto_install = true,
    }
  end,
}
