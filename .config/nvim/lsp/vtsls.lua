local M = {}

M.spec = {
  cmd = { 'vtsls', '--stdio' },

  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'json',
    'jsonc',
  },

  root_markers = {
    'tsconfig.json',
    'tsconfig.base.json',
    'tsconfig.app.json',
    'tsconfig.node.json',
    'jsconfig.json',
    'package.json',
    'package-lock.json',
    'pnpm-lock.yaml',
    'pnpm-workspace.yaml',
    'yarn.lock',
    'bun.lock',
    'bun.lockb',
    '.git',
  },

  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
          preferredPackageManager = 'npm',
        },
      },
    },
  },

  single_file_support = false,
  log_level = vim.lsp.protocol.MessageType.Warning,
}

M.name = 'vtsls'

return M.spec
