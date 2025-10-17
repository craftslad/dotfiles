local M = {}

function M.setup(bufnr)
  local opts = { buffer = bufnr, silent = true }

  -- LSP keymaps
  vim.keymap.set(
    'n',
    'grn',
    vim.lsp.buf.rename,
    vim.tbl_extend('force', opts, { desc = 'LSP: Rename' })
  )
  vim.keymap.set(
    { 'n', 'v' },
    'gra',
    vim.lsp.buf.code_action,
    vim.tbl_extend('force', opts, { desc = 'LSP: Code Action' })
  )
  vim.keymap.set(
    'n',
    'grr',
    vim.lsp.buf.references,
    vim.tbl_extend('force', opts, { desc = 'LSP: References' })
  )
  vim.keymap.set(
    'n',
    'gri',
    vim.lsp.buf.implementation,
    vim.tbl_extend('force', opts, { desc = 'LSP: Implementations' })
  )
  vim.keymap.set(
    'n',
    'grt',
    vim.lsp.buf.type_definition,
    vim.tbl_extend('force', opts, { desc = 'LSP: Type Definition' })
  )
  vim.keymap.set(
    'n',
    'gO',
    vim.lsp.buf.document_symbol,
    vim.tbl_extend('force', opts, { desc = 'LSP: Document Symbols' })
  )
  vim.keymap.set(
    'i',
    '<C-s>',
    vim.lsp.buf.signature_help,
    vim.tbl_extend('force', opts, { desc = 'LSP: Signature Help' })
  )
  vim.keymap.set(
    'n',
    'K',
    vim.lsp.buf.hover,
    vim.tbl_extend('force', opts, { desc = 'LSP: Hover' })
  )
end

return M
