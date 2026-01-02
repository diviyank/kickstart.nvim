return {
  'nvim-treesitter/nvim-treesitter-context',
  event = 'VeryLazy',

  opts = {
    enable = true,
    max_lines = 2,
    trim_scope = 'outer',
    mode = 'cursor',
    line_numbers = true,
  },
}
