return {
  'stevearc/oil.nvim',
  opts = {
    -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
    -- Set to false if you still want to use netrw.
    default_file_explorer = true,
    -- Id is automatically added at the beginning, and name at the end
    -- See :help oil-columns
    columns = {
      'icon',
      'permissions',
      'size',
      'mtime',
    },
    keymaps = {
      ['<BS>'] = 'actions.parent',
    },
  },
  config = function()
    require('oil').setup {
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
      },
    }
  end,
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
