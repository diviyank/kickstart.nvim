-- File: custom/plugins/rustaceanvim.lua
return {
  'mrcjkb/rustaceanvim',
  version = '^5',
  lazy = false,
  config = function()
    -- local codelldb_path = ''
    -- local liblldb_path = ''
    --
    -- -- Safely get codelldb from Mason
    -- local codelldb_path = ''
    -- local liblldb_path = ''
    -- local liblldb = vim.fn.has 'mac' == 1 and 'liblldb.dylib' or 'liblldb.so'
    --
    -- local ok, mason_registry = pcall(require, 'mason-registry')
    -- if ok and mason_registry.has_package 'codelldb' then
    --   local pkg = mason_registry.get_package 'codelldb'
    --   if pkg:is_installed() then
    --     local extension_path = pkg:get_install_path() .. '/extension/'
    --     codelldb_path = extension_path .. 'adapter/codelldb'
    --     liblldb_path = extension_path .. 'lsp/lib/' .. liblldb
    --   end
    -- end

    -- If you are on macOS, use:
    -- local liblldb_path = extension_path .. 'lsp/lib/liblldb.dylib'

    vim.g.rustaceanvim = {
      server = {
        on_attach = function(client, bufnr)
          -- This ensures your default Kickstart LSP keymaps work for Rust
          -- Inlay hints are enabled by default here
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end,
        default_settings = {
          ['rust-analyzer'] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- pgrx often uses a lot of proc macros
            procMacro = {
              enable = true,
              ignored = {
                ['async-trait'] = { 'async_trait' },
                ['napi-derive'] = { 'napi' },
                ['async-recursion'] = { 'async_recursion' },
              },
            },
            checkOnSave = {
              command = 'clippy',
            },
          },
        },
      },
      dap = {
        adapter = (codelldb_path ~= '' and liblldb_path ~= '') and require('rustaceanvim.config').get_codelldb_adapter(codelldb_path, liblldb_path) or nil,
      },
    }
    vim.api.nvim_create_autocmd('User', {
      pattern = 'MasonReady',
      once = true,
      callback = function()
        local mason_registry = require 'mason-registry'
        if not mason_registry.has_package 'codelldb' then
          return
        end

        local pkg = mason_registry.get_package 'codelldb'
        if not pkg:is_installed() then
          return
        end

        local install_path = pkg:get_install_path()
        local extension_path = install_path .. '/extension/'
        local liblldb = vim.fn.has 'mac' == 1 and 'liblldb.dylib' or 'liblldb.so'

        vim.g.rustaceanvim.dap = {
          adapter = require('rustaceanvim.config').get_codelldb_adapter(extension_path .. 'adapter/codelldb', extension_path .. 'lsp/lib/' .. liblldb),
        }
      end,
    })
  end,
}
