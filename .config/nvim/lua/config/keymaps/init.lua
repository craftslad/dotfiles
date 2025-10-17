local M = {}

local modules = {
  'config.keymaps.general',
  'config.keymaps.files',
  'config.keymaps.navigations',
  'config.keymaps.diagnostics',
}

function M.setup()
  for _, mod_name in ipairs(modules) do
    local ok, mod = pcall(require, mod_name)
    if ok and mod.setup then
      mod.setup()
    else
      vim.notify(
        'Failed to load keymaps module: ' .. mod_name,
        vim.log.levels.ERROR
      )
    end
  end
end

return M
