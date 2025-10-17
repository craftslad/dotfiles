local M = {}

function M.setup(group)
  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = { 'text', 'plaintext', 'typst', 'gitcommit', 'markdown' },
    callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.spell = true
    end,
  })
end

return M
