local sql_ft = { 'sql', 'mysql', 'plsql' }

return {

  { 'jsborjesson/vim-uppercase-sql', ft = sql_ft },

  {
    'tpope/vim-dadbod',
    enabled = true,
    dependencies = {
      { 'kristijanhusak/vim-dadbod-ui' },
      { 'kristijanhusak/vim-dadbod-completion' },
      {
        'folke/edgy.nvim',
        optional = true,
        opts = function(_, opts)
          table.insert(opts.left, {
            title = 'Database',
            ft = 'dbui',
            pinned = true,
            open = function()
              vim.cmd 'DBUI'
            end,
          })

          table.insert(opts.bottom, {
            title = 'DB Query Result',
            ft = 'dbout',
          })
        end,
      },
    },
    cmd = { 'DBUI', 'DBUIFindBuffer' },
    config = function()
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_use_nvim_notify = true
      vim.g.db_ui_save_location = '~/fentech/dbui'
      vim.g.db_ui_tmp_query_location = '~/fentech/dbui-queries'

      local autocomplete_group = vim.api.nvim_create_augroup('vimrc_autocompletion', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = sql_ft,
        callback = function()
          local cmp = require 'cmp'
          cmp.setup.buffer {
            sources = {
              { name = 'vim-dadbod-completion' },
              { name = 'luasnip' },
            },
            mapping = cmp.mapping.preset.insert {
              ['<CR>'] = cmp.mapping.confirm { select = true },
              ['<C-n>'] = cmp.mapping.select_next_item(),
              ['<C-p>'] = cmp.mapping.select_prev_item(),
              ['<Tab>'] = cmp.mapping.select_next_item(),
              ['<S-Tab>'] = cmp.mapping.select_prev_item(),
              ['<C-Space>'] = cmp.mapping.complete {},
            },
          }
        end,
        group = autocomplete_group,
      })
    end,
  },
}
