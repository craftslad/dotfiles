local M = {}

M.spec = {
  cmd = {
    'vscode-html-language-server',
    '--stdio',
  },

  filetypes = {
    'html',
  },

  root_markers = {
    '.git',
    'package.json',
    'pnpm-lock.yaml',
    'yarn.lock',
    'bun.lock',
  },

  settings = {
    html = {
      validate = true,
      format = {
        enable = true,
        wrapLineLength = 120,
        unformatted = 'b,em,strong,i,span',
        contentUnformatted = 'pre,code,textarea',
      },
      suggest = {
        html5 = true,
      },
    },
  },

  single_file_support = true,

  init_options = {
    provideFormatter = true,
  },

  log_level = vim.lsp.protocol.MessageType.Warning,
}

M.name = 'html'

return M.spec
