return {
  'karb94/neoscroll.nvim',
  event = 'VeryLazy',
  config = function()
    local neoscroll = require 'neoscroll'

    -- Empty `mappings` so neoscroll doesn't hijack <C-u>/<C-d>/etc — keyboard
    -- scroll already feels fine and animating it would make it feel slower.
    neoscroll.setup {
      mappings = {},
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = false,
      cursor_scrolls_alongside = true,
      easing = 'linear',
    }

    -- Mouse wheel only: interpolate each tick into a short animation so a fast
    -- spin produces smooth motion instead of a queue of discrete redraws.
    local wheel_opts = { move_cursor = false, duration = 80, easing = 'linear' }
    vim.keymap.set({ 'n', 'v', 'x' }, '<ScrollWheelUp>', function()
      neoscroll.scroll(-0.20, wheel_opts)
    end)
    vim.keymap.set({ 'n', 'v', 'x' }, '<ScrollWheelDown>', function()
      neoscroll.scroll(0.20, wheel_opts)
    end)
  end,
}
