--[[

Advanced string functions that are not implemented in LUA

  To use:
    require("Advanced_Tables")
    Then call as expeted - table.reverse(tbl)

--]]
function string.trim (s)
  return s:match'^%s*(.*)'
end

return string
