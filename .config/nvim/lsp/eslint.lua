local M = {}

-- Helper function to detect package manager
local function detect_package_manager()
  local root = vim.fn.getcwd()

  -- Check for lock files
  if vim.fn.filereadable(root .. '/pnpm-lock.yaml') == 1 then
    return 'pnpm'
  elseif vim.fn.filereadable(root .. '/yarn.lock') == 1 then
    return 'yarn'
  elseif
    vim.fn.filereadable(root .. '/bun.lockb') == 1
    or vim.fn.filereadable(root .. '/bun.lock') == 1
  then
    return 'bun'
  end
  return 'npm'
end

M.spec = {
  cmd = { 'vscode-eslint-language-server', '--stdio' },
  filetypes = {
    'astro',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'json',
    'svelte',
    'yaml',
  },
  root_markers = {
    '.eslintrc',
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.json',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    'eslint.config.js',
    'eslint.config.cjs',
    'eslint.config.mjs',
    'eslint.config.ts',
    'package.json',
    'pnpm-lock.yaml',
    'yarn.lock',
    'package-lock.json',
    'bun.lock',
    'bun.lockb',
    '.git',
  },
  settings = {
    validate = 'on',
    packageManager = detect_package_manager(),
    useESLintClass = false,
    experimental = {
      useFlatConfig = true,
    },
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = 'separateLine',
      },
      showDocumentation = {
        enable = true,
      },
    },
    format = false,
    quiet = false,
    onIgnoredFiles = 'off',
    run = 'onType',
    nodePath = '',
    workingDirectory = { mode = 'auto' },
  },
  single_file_support = false,
  log_level = vim.lsp.protocol.MessageType.Warning,
}
M.name = 'eslint'
return M.spec
