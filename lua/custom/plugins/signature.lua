return {
  {
    'ray-x/lsp_signature.nvim',
    event = 'VeryLazy',
    opts = {
      bind = true,
      floating_window = true,
      hint_enable = true,
      handler_opts = {
        border = 'rounded',
      },
      toggle_key = '<M-x>', -- optional key to toggle signature display
    },
  },
}
