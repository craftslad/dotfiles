local M = {}

function M.setup()
  -- Navigate to previous/next diagnostic
  vim.keymap.set(
    'n',
    '[d',
    vim.diagnostic.goto_prev,
    { desc = 'Go to previous diagnostic' }
  )
  vim.keymap.set(
    'n',
    ']d',
    vim.diagnostic.goto_next,
    { desc = 'Go to next diagnostic' }
  )

  -- Populate quickfix/location lists
  vim.keymap.set(
    'n',
    '<leader>xq',
    vim.diagnostic.setqflist,
    { desc = 'Send diagnostics to quickfix' }
  )
  vim.keymap.set(
    'n',
    '<leader>xl',
    vim.diagnostic.setloclist,
    { desc = 'Send diagnostics to location list' }
  )

  -- Open floating diagnostic window
  vim.keymap.set(
    'n',
    '<leader>xf',
    vim.diagnostic.open_float,
    { desc = 'Show diagnostics in floating window' }
  )

  -- Toggle diagnostics for the current buffer
  vim.keymap.set('n', '<leader>xd', function()
    if vim.diagnostic.is_disabled(0) then
      vim.diagnostic.enable(0)
      vim.notify 'Diagnostics enabled for this buffer'
    else
      vim.diagnostic.disable(0)
      vim.notify 'Diagnostics disabled for this buffer'
    end
  end, { desc = 'Toggle diagnostics for buffer' })

  -- Toggle virtual text display for diagnostics
  vim.keymap.set('n', '<leader>xt', function()
    local current = vim.diagnostic.config().virtual_text
    vim.diagnostic.config { virtual_text = not current }
    vim.notify('Diagnostics virtual text: ' .. (current and 'OFF' or 'ON'))
  end, { desc = 'Toggle virtual text for diagnostics' })
end

return M
