local M = {}

local group = vim.api.nvim_create_augroup('rj_autocmds', { clear = true })

local modules = {
  'config.autocmds.highlight_yank',
  'config.autocmds.text_wrap_spell',
}

function M.setup()
  for _, name in ipairs(modules) do
    local ok, mod = pcall(require, name)
    if ok and type(mod.setup) == 'function' then
      mod.setup(group)
    else
      vim.notify(
        ('Failed to load autocmd module: %s\n%s'):format(name, mod),
        vim.log.levels.ERROR
      )
    end
  end
end

return M
