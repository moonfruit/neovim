local M = {}
local ts = vim.treesitter

function M.list_parsers()
  return vim.api.nvim_get_runtime_file('parser/*', true)
end

function M.check_health()
  local report_info = vim.fn['health#report_info']
  local report_ok = vim.fn['health#report_ok']
  local report_error = vim.fn['health#report_error']
  local parsers = M.list_parsers()

  report_info(string.format("Runtime ABI version : %d", ts.language_version))

  for _, parser in pairs(parsers) do
    local parsername = vim.fn.fnamemodify(parser, ":t:r")

    local is_loadable, ret = pcall(ts.language.require_language, parsername)

    if not is_loadable then
      report_error(string.format("Impossible to load parser for %s: %s", parsername, ret))
    elseif ret then
      report_ok(string.format("Loaded parser for %s", parsername))
    else
      report_error(string.format("Unable to load parser for %s", parsername))
    end
  end
end

return M

