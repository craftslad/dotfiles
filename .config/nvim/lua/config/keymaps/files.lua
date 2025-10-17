local M = {}

function M.setup()
  -- Find file using built-in :find
  vim.keymap.set('n', '<leader>ff', ':find ', { desc = 'Find file' })

  -- Grep project for a keyword across multiple filetypes
  vim.keymap.set('n', '<leader>fg', function()
    local keyword = vim.fn.input ':grep '
    if keyword == '' then
      return
    end

    vim.cmd 'cclose'

    local filetypes = { '.lua', '.ts', '.tsx', '.js', '.jsx', '.md', '.json' }
    local files = {}

    local function scan_dir(dir)
      for name, typ in vim.fs.dir(dir) do
        local path = dir .. '/' .. name
        if typ == 'file' then
          for _, ext in ipairs(filetypes) do
            if name:match(ext .. '$') then
              table.insert(files, path)
              break
            end
          end
        elseif typ == 'directory' then
          scan_dir(path)
        end
      end
    end

    scan_dir '.'

    if vim.tbl_isempty(files) then
      print 'No files found for the selected filetypes.'
      return
    end

    local vimgrep_cmd = 'vimgrep /'
      .. vim.fn.escape(keyword, '/')
      .. '/j '
      .. table.concat(files, ' ')
    if not pcall(vim.cmd, vimgrep_cmd) then
      print('No matches found for: ' .. keyword)
      return
    end

    if vim.fn.getqflist({ size = 0 }).size > 0 then
      vim.cmd 'copen'
    end
  end, { desc = 'Grep project (pure Lua, multi-filetype)' })

  -- Toggle Netrw file explorer
  vim.keymap.set('n', '\\', function()
    local netrw_open = false
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if
        vim.api.nvim_buf_is_loaded(buf)
        and vim.api.nvim_buf_get_name(buf):match 'NetrwTreeListing'
      then
        netrw_open = buf
        break
      end
    end

    if netrw_open then
      vim.api.nvim_buf_delete(netrw_open, { force = true })
    else
      vim.cmd.Ex()
    end
  end, { desc = 'Toggle Netrw file explorer' })

  -- Switch between loaded buffers
  vim.keymap.set('n', '<leader>fb', function()
    local bufs = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
        table.insert(
          bufs,
          { number = buf, name = vim.api.nvim_buf_get_name(buf) }
        )
      end
    end

    vim.ui.select(bufs, {
      prompt = 'Switch buffer:',
      format_item = function(item)
        return item.number .. ': ' .. vim.fn.fnamemodify(item.name, ':t')
      end,
    }, function(choice)
      if choice then
        vim.api.nvim_set_current_buf(choice.number)
      end
    end)
  end, { desc = 'Switch buffer (Lua-native)' })
end

return M
