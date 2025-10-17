local M = {}

M.spec = {
  cmd = {
    'emmet-language-server',
    '--stdio',
  },

  filetypes = {
    'astro',
    'css',
    'html',
    'javascriptreact',
    'scss',
    'svelte',
    'typescriptreact',
  },

  init_options = {
    includeLanguages = {
      javascript = 'javascriptreact',
      typescript = 'typescriptreact',
    },
    showExpandedAbbreviation = 'always',
    showAbbreviationSuggestions = true,
    syntaxProfiles = {
      html = {
        selfClosingStyle = 'xhtml',
      },
    },
    options = {
      -- BEM methodology support
      ['bem.enabled'] = true,

      -- Output formatting
      ['output.selfClosingTag'] = true,
      ['output.indent'] = '  ',
      ['output.newline'] = '\n',
    },
  },

  single_file_support = true,
}

M.name = 'emmet_ls'

return M.spec
