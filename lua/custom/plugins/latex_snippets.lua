-- Auto-expanding math snippets for LaTeX (Gilles-Castel style).
-- Uses the Treesitter `latex` parser for math-zone detection, so VimTeX is not required.
return {
  'iurimateus/luasnip-latex-snippets.nvim',
  dependencies = { 'L3MON4D3/LuaSnip', 'nvim-treesitter/nvim-treesitter' },
  ft = 'tex',
  config = function()
    require('luasnip-latex-snippets').setup { use_treesitter = true }
    require('luasnip').config.setup { enable_autosnippets = true }
  end,
}
