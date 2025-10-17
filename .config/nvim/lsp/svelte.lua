local M = {}

M.spec = {
  cmd = { 'svelteserver', '--stdio' },

  filetypes = { 'svelte' },

  root_markers = {
    'svelte.config.js',
    'tsconfig.json',
    'package.json',
    '.git',
  },

  settings = {
    svelte = {
      plugin = {
        css = { enable = true },
        typescript = { enable = true },
        javascript = { enable = true },
      },
    },
  },

  single_file_support = true,
  log_level = vim.lsp.protocol.MessageType.Warning,
}

M.name = 'svelte'

return M.spec
