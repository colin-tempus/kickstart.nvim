-- Toggle LSP diagnostics (linter/LSP alerts)
local diagnostics_active = true

-- Function to toggle all diagnostics
local function toggle_diagnostics()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.enable()
    vim.notify('Diagnostics enabled', vim.log.levels.INFO)
  else
    vim.diagnostic.disable()
    vim.notify('Diagnostics disabled', vim.log.levels.INFO)
  end
end

-- Main toggle keymap - <leader>td (toggle diagnostics)
vim.keymap.set('n', '<leader>td', toggle_diagnostics, {
  desc = '[T]oggle [D]iagnostics',
  silent = true,
})

-- Alternative: Toggle diagnostics display without disabling them completely
-- This just hides/shows the virtual text and signs
vim.keymap.set('n', '<leader>tD', function()
  local current_config = vim.diagnostic.config()
  vim.diagnostic.config {
    virtual_text = not current_config.virtual_text,
    signs = not current_config.signs,
    underline = not current_config.underline,
  }

  local status = current_config.virtual_text and 'hidden' or 'shown'
  vim.notify('Diagnostic display ' .. status, vim.log.levels.INFO)
end, {
  desc = '[T]oggle [D]iagnostic Display (keep active)',
  silent = true,
})

-- Additional keymaps for specific diagnostic levels
-- Toggle only error diagnostics
vim.keymap.set('n', '<leader>te', function()
  local ns = vim.diagnostic.get_namespace()
  local current = vim.diagnostic.config(ns).severity_sort
  if current and current.min == vim.diagnostic.severity.ERROR then
    vim.diagnostic.config { severity_sort = false }
    vim.notify('Showing all diagnostic levels', vim.log.levels.INFO)
  else
    vim.diagnostic.config {
      severity_sort = {
        min = vim.diagnostic.severity.ERROR,
      },
    }
    vim.notify('Showing only errors', vim.log.levels.INFO)
  end
end, {
  desc = '[T]oggle showing only [E]rrors',
  silent = true,
})

-- Quick navigation between diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })

-- Open diagnostic float window
vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float, {
  desc = '[D]iagnostic [F]loat window',
  silent = true,
})

-- Show diagnostics in location list
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, {
  desc = '[D]iagnostics [L]ocation list',
  silent = true,
})

return {}
