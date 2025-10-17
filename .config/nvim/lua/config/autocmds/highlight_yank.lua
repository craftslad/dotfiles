local M = {}

function M.setup(group)
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = group,
    callback = function()
      vim.hl.on_yank { timeout = 150 }
    end,
  })
end

return M
