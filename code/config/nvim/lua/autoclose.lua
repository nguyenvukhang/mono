-- m4xshen/autoclose.nvim

local autoclose = {}

local config = {
  keys = {
    ['('] = { escape = false, close = true, pair = '()' },
    ['['] = { escape = false, close = true, pair = '[]' },
    ['{'] = { escape = false, close = true, pair = '{}' },

    [')'] = { escape = true, close = false, pair = '()' },
    [']'] = { escape = true, close = false, pair = '[]' },
    ['}'] = { escape = true, close = false, pair = '{}' },

    ['"'] = { escape = true, close = true, pair = '""' },
    ['`'] = { escape = true, close = true, pair = '``' },

    ['<BS>'] = {},
    ['<C-H>'] = {},
    ['<C-W>'] = {},
    ['<CR>'] = {},
    ['<S-CR>'] = {},
  },
  options = {
    pair_spaces = false,
    auto_indent = true,
  },
}

local function get_pair()
  -- add "_" to let close function work in the first col
  local line = '_' .. vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  return line:sub(col, col + 1)
end

local function is_pair(pair)
  for _, info in pairs(config.keys) do
    if pair == info.pair then return true end
  end
  return false
end

local function is_disabled(info)
  local current_filetype = vim.api.nvim_buf_get_option(0, 'filetype')
  if info['enabled_filetypes'] ~= nil then
    for _, filetype in pairs(info.enabled_filetypes) do
      if filetype == current_filetype then return false end
    end
    return true
  elseif info['disabled_filetypes'] ~= nil then
    for _, filetype in pairs(info.disabled_filetypes) do
      if filetype == current_filetype then return true end
    end
  end
  return false
end

local function handler(key, info)
  if is_disabled(info) then return key end

  local pair = get_pair()

  if (key == '<BS>' or key == '<C-H>' or key == '<C-W>') and is_pair(pair) then
    return '<BS><Del>'
  elseif (key == '<CR>' or key == '<S-CR>') and is_pair(pair) then
    return '<CR><ESC>O' .. (config.options.auto_indent and '' or '<C-D>')
  elseif info.escape and pair:sub(2, 2) == key then
    return '<C-G>U<Right>'
  elseif info.close then
    -- don't pair spaces
    if key == ' ' then return key end
    return info.pair .. '<C-G>U<Left>'
  else
    return key
  end
end

function autoclose.setup()
  for key, info in pairs(config.keys) do
    vim.keymap.set(
      'i',
      key,
      function() return handler(key, info) end,
      { noremap = true, expr = true }
    )
  end
end

return autoclose
