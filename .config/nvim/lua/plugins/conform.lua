local M = {}

M.spec = {
  'stevearc/conform.nvim',
  version = 'v9.0.0',
  event = { 'BufReadPre', 'BufNewFile' },

  opts = {
    format_on_save = {
      lsp_format = 'fallback',
      timeout_ms = 2000,
    },

    formatters_by_ft = {
      ['_'] = { 'codespell', 'trim_whitespace' },
      -- astro = { 'prettier'},
      css = { 'prettier' },
      go = { 'goimports', 'gofmt' },
      graphql = { 'prettier' },
      html = { 'prettier' },
      javascript = { 'prettier' },
      javascriptreact = { 'prettier' },
      json = { 'prettier' },
      lua = { 'stylua' },
      markdown = { 'prettier' },
      python = { 'isort', 'black' },
      sh = { 'shfmt' },
      -- svelte = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      yaml = { 'prettier' },
    },

    log_level = vim.log.levels.ERROR,
    notify_no_formatters = true,
    notify_on_error = true,
  },

  config = function(_, opts)
    local conform = require 'conform'
    conform.setup(opts)

    -- Buffer-local mapping
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local ft = vim.bo[args.buf].filetype
        local formatters = opts.formatters_by_ft[ft]
          or opts.formatters_by_ft['_']
        if formatters and #formatters > 0 then
          vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
            conform.format {
              async = false,
              quiet = false,
              lsp_format = 'fallback',
            }
          end, {
            buffer = args.buf,
            desc = 'Format file or range (Conform)',
          })
        end
      end,
    })
  end,
}

return M.spec
