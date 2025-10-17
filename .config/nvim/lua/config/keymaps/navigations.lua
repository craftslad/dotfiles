local M = {}

function M.setup()
  -- Move between Neovim splits
  local function nvim_tmux_nav(direction, tmux_direction)
    local cur_win = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(direction)
    if vim.api.nvim_get_current_win() == cur_win then
      local handle
      handle = vim.uv.spawn(
        'tmux',
        { args = { 'select-pane', '-' .. tmux_direction } },
        function()
          handle:close()
        end
      )
    end
  end

  -- Keymaps for moving across splits/panes
  vim.keymap.set('n', '<C-h>', function()
    nvim_tmux_nav('h', 'L')
  end, { desc = 'Move left split/pane' })
  vim.keymap.set('n', '<C-j>', function()
    nvim_tmux_nav('j', 'D')
  end, { desc = 'Move down split/pane' })
  vim.keymap.set('n', '<C-k>', function()
    nvim_tmux_nav('k', 'U')
  end, { desc = 'Move up split/pane' })
  vim.keymap.set('n', '<C-l>', function()
    nvim_tmux_nav('l', 'R')
  end, { desc = 'Move right split/pane' })
end

return M
