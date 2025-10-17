-- LSP paths
local config_dir = vim.fn.stdpath 'config'
package.path = table.concat({
  config_dir .. '/?.lua',
  config_dir .. '/?/init.lua',
  package.path,
}, ';')

-- Inlay hints
local inlay_hints = {
  includeInlayParameterNameHints = 'all',
  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = true,
  includeInlayVariableTypeHintsWhenTypeMatchesName = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
}

-- LSP servers
vim.lsp.enable {
  'astro',
  'cssls',
  'emmet-language-server',
  'eslint',
  'gopls',
  'graphql',
  'html',
  'jsonls',
  'lua_ls',
  'marksman',
  'pyright',
  'svelte',
}

-- On LSP attach
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP setup',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    local bufnr = args.buf

    -- Capabilities (nvim-cmp)
    local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    if ok then
      client.server_capabilities = vim.tbl_deep_extend(
        'force',
        client.server_capabilities or {},
        cmp_nvim_lsp.default_capabilities() or {}
      )
    end

    -- Inlay hints (only for vtsls and lua_ls)
    if client.name == 'vtsls' or client.name == 'lua_ls' then
      -- Force advertise inlay hint capability
      client.server_capabilities.inlayHintProvider = true

      if client.name == 'vtsls' then
        -- Apply shared inlay hint preferences
        client.config.settings.typescript = client.config.settings.typescript
          or {}
        client.config.settings.javascript = client.config.settings.javascript
          or {}

        client.config.settings.typescript.inlayHints = inlay_hints
        client.config.settings.javascript.inlayHints = inlay_hints

        -- Send updated settings to vtsls (Neovim ≥0.11)
        client.rpc.notify('workspace/didChangeConfiguration', {
          settings = client.config.settings,
        })
      end

      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    -- Keymaps
    require('lsp.mappings').setup(bufnr)
  end,
})

-- Diagnostics
vim.diagnostic.config {
  virtual_lines = true,
  virtual_text = false,
  underline = true,
  update_in_insert = false,
  severity_sort = true,

  float = {
    border = 'rounded',
    source = true,
  },

  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
    },
  },
}
