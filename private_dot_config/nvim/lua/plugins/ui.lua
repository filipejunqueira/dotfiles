-- lua/plugins/ui.lua — UI enhancements

return {
  -- Indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      indent = {
        char = '│',
        tab_char = '│',
      },
      scope = { enabled = true },
      exclude = {
        filetypes = { 'help', 'lazy', 'mason', 'notify', 'checkhealth' },
      },
    },
  },

  -- Auto-close brackets, quotes, etc.
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },
}
