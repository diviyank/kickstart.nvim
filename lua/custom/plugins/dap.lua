return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'mfussenegger/nvim-dap-python',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('dapui').setup()

    -- 1. Setup debugpy (Mason install)
    local debugpy_python = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python'
    require('dap-python').setup(debugpy_python)

    -- 2. Handle 'uv' and venvs: force DAP to use the project's venv
    -- This function looks for .venv/bin/python in the current directory
    require('dap-python').resolve_python = function()
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      elseif vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python'
      else
        return '/usr/bin/python3' -- Fallback
      end
    end

    -- 3. Update Keymaps to use <leader>d (Debug) to avoid conflict
    vim.keymap.set('n', '<F6>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F3>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F4>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F5>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<F7>', function()
      local dap = require 'dap'
      if dap.session() then
        dap.restart()
      else
        dap.run_last()
      end
    end, { desc = 'Debug: Restart / Run Last' })
    vim.keymap.set('n', '<F10>', dap.terminate, { desc = 'Debug: Terminate' })
    vim.keymap.set('n', '<F9>', dapui.toggle, { desc = 'Debug: Toggle UI' })
    vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = 'Debug: Terminate' })
    -- New mappings starting with <leader>d
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>dB', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Conditional Breakpoint' })
    vim.keymap.set('n', '<leader>de', dapui.eval, { desc = 'Debug: Eval under cursor' })
    vim.keymap.set('n', '<leader>dr', function()
      require('dap').repl.open()
    end, { desc = 'Debug: Open REPL' })
    -- 4. Auto-Open UI (but DO NOT Auto-Close)
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    -- Commented out the auto-close listeners so you can see errors:
    -- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    -- dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- 5. FastAPI Specific Configuration
    -- This adds a specific configuration to the menu when you press F5
    table.insert(dap.configurations.python, {
      type = 'python',
      request = 'launch',
      name = 'FastAPI (module)',
      module = 'uvicorn',
      args = { 'src.main:app', '--reload' },
      -- Change 'main:app' if your entry point is different
      pythonPath = function()
        return require('dap-python').resolve_python()
      end,
    })

    -- OPTION: Run Current File with Project Root in PYTHONPATH
    -- This fixes the "ModuleNotFoundError: No module named 'src'" issue
    table.insert(dap.configurations.python, {
      type = 'python',
      request = 'launch',
      name = 'Python: Current File (Root Path)',
      program = '${file}', -- Run the active file
      cwd = '${workspaceFolder}', -- Run from project root
      env = {
        -- This is the magic line. It adds the project root to python path.
        -- So 'from src.mod import func' works even if running a file inside src/
        PYTHONPATH = '${workspaceFolder}',
      },
      pythonPath = function()
        return require('dap-python').resolve_python()
      end,
    })
  end,
}
