local M = {}

M.spec = {
  cmd = { 'astro-ls', '--stdio' },

  filetypes = { 'astro' },

  root_markers = {
    'astro.config.mjs',
    'tsconfig.json',
    'package.json',
    '.git',
  },

  settings = {
    astro = {
      completions = true,
      diagnostics = true,
      format = { enable = true },
      plugins = {
        typescript = { enable = true },
        javascript = { enable = true },
        css = { enable = true },
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = 'always' },
      completions = { completeFunctionCalls = true },
    },
    javascript = {
      completions = { completeFunctionCalls = true },
    },
  },

  -- tsdk path (global TypeScript)
  init_options = {
    typescript = {
      tsdk = '/opt/homebrew/lib/node_modules/typescript/lib',
    },
  },

  single_file_support = true,
  log_level = vim.lsp.protocol.MessageType.Warning,
}

M.name = 'astro'

return M.spec
