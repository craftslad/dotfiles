local M = {}

M.spec = {
  'kylechui/nvim-surround',
  version = 'v3.1.2',

  opts = {},

  keys = function()
    return {
      { 'ys', desc = 'Add surrounding', mode = 'n' },
      { 'yss', desc = 'Add surrounding to line', mode = 'n' },
      { 'ds', desc = 'Delete surrounding', mode = 'n' },
      { 'cs', desc = 'Change surrounding', mode = 'n' },
      { 'S', desc = 'Add surrounding (Visual)', mode = 'v' },
    }
  end,
}

return M.spec
