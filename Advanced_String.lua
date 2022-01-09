--[[

Advanced string functions that are not implemented in LUA

  To use:
    require("Advanced_Tables")
    Then call as expeted - table.reverse(tbl)

--]]
function string.trim (s)
  return s:match'^%s*(.*)'
end

function string.split(self, sep)
  list = {}
  position = 1
  index = string.find(self, sep)
  while index do
    table.insert(list, string.sub(self, position, index -1))
    position = index + 1
    index = string.find(self, sep, position)
  end
  table.insert(list, string.sub(self, position, -1))
  return list
end

return string
