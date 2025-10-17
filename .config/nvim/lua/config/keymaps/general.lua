local M = {}

function M.setup()
  -- Exit with 'jk'
  vim.keymap.set('i', 'jk', '<ESC>', { desc = 'Exit insert mode' })

  -- Increment/Decrement numbers
  vim.keymap.set('n', '<leader>+', '<C-a>', { desc = 'Increment number' })
  vim.keymap.set('n', '<leader>-', '<C-x>', { desc = 'Decrement number' })

  -- Buffer operations
  vim.keymap.set('n', '<leader>n', vim.cmd.enew, { desc = 'New buffer' })

  -- Clear search highlights
  vim.keymap.set(
    'n',
    '<leader>cs',
    vim.cmd.nohlsearch,
    { desc = 'Clear search highlights' }
  )

  -- Show message history
  vim.keymap.set(
    'n',
    '<leader>cm',
    '<cmd>messages<CR>',
    { desc = 'Show messages' }
  )

  -- Save & reload
  vim.keymap.set('n', '<leader>o', function()
    local file = vim.fn.expand '%:p'
    vim.cmd.update()

    if file:match(vim.fn.stdpath 'config') then
      local ok, err = pcall(function()
        for k in pairs(package.loaded) do
          if k:match '^config' or k:match '^core' then
            package.loaded[k] = nil
          end
        end
        dofile(file)
      end)
      if ok then
        vim.notify('Neovim config reloaded: ' .. file, vim.log.levels.INFO)
      else
        vim.notify('Error reloading config: ' .. err, vim.log.levels.ERROR)
      end
    else
      vim.cmd('source ' .. file)
      vim.notify('File sourced: ' .. file, vim.log.levels.INFO)
    end
  end, { desc = 'Save & reload file or Neovim config' })
end

return M
