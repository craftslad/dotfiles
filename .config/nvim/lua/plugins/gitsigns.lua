local M = {}

M.spec = {
  'lewis6991/gitsigns.nvim',
  version = '*',
  event = { 'BufReadPre', 'BufNewFile' },

  opts = {
    signs_staged_enable = true,
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
      follow_files = false,
      interval = 15000,
    },
  },

  keys = {
    -- Blame
    {
      '<leader>gb',
      function()
        vim.schedule(function()
          require('gitsigns').blame_line { full = true }
        end)
      end,
      desc = 'Blame Line',
      noremap = true,
      silent = true,
    },
    {
      '<leader>gx',
      function()
        require('gitsigns').toggle_current_line_blame()
      end,
      desc = 'Toggle Current Line Blame',
      noremap = true,
      silent = true,
    },
    {
      '<leader>ga',
      function()
        require('gitsigns').blame()
      end,
      desc = 'Blame Buffer',
      noremap = true,
      silent = true,
    },

    -- Stage / unstage
    {
      '<leader>gs',
      function()
        require('gitsigns').stage_hunk()
      end,
      desc = 'Stage Hunk',
      noremap = true,
      silent = true,
    },
    {
      '<leader>gu',
      function()
        require('gitsigns').undo_stage_hunk()
      end,
      desc = 'Unstage Hunk',
      noremap = true,
      silent = true,
    },
    {
      '<leader>g.',
      function()
        require('gitsigns').stage_buffer()
      end,
      desc = 'Stage File',
      noremap = true,
      silent = true,
    },
    {
      '<leader>g,',
      function()
        require('gitsigns').reset_buffer()
      end,
      desc = 'Unstage File',
      noremap = true,
      silent = true,
    },

    -- Reset / discard
    {
      '<leader>gr',
      function()
        require('gitsigns').reset_hunk()
      end,
      desc = 'Reset Hunk',
      noremap = true,
      silent = true,
    },
    {
      '<leader>gf',
      function()
        require('gitsigns').reset_buffer()
      end,
      desc = 'Reset File',
      noremap = true,
      silent = true,
    },

    -- Highlight toggles
    {
      '<leader>gl',
      function()
        require('gitsigns').toggle_linehl()
      end,
      desc = 'Toggle Line Highlight',
      noremap = true,
      silent = true,
    },
    {
      '<leader>gn',
      function()
        require('gitsigns').toggle_numhl()
      end,
      desc = 'Toggle Number Highlight',
      noremap = true,
      silent = true,
    },

    -- Preview / diff
    {
      '<leader>gp',
      function()
        require('gitsigns').preview_hunk()
      end,
      desc = 'Preview Hunk',
      noremap = true,
      silent = true,
    },

    -- Hunk text object
    {
      '<leader>gh',
      function()
        require('gitsigns').select_hunk()
      end,
      desc = 'Git Hunk Text Object',
      mode = 'o',
      noremap = true,
      silent = true,
    },
  },
}

return M.spec
