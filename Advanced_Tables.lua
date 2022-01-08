--[[

Advanced Table functions that are not implemented in LUA

  To use:
    require("Advanced_Tables")
    Then call as expeted - table.reverse(tbl)

--]]

function table.is_empty(self)
  return #self == 0
end

-- Adding a return on index as an option to grab --
function table.contains(self, element, ...)
  for index, value in pairs(self) do
    if ... then value = value[...] end
    if value == element then
      return true, index
    end
  end
  return false
end

function table.reverse(self)
  for i=1, math.floor(#self / 2) do
    self[i], self[#tbl - i + 1] = self[#tbl - i + 1], self[i]
  end
end

function table.print(self)
  local name = require "json"
  print(json.encode(self))
end

function table.keys(self)
  local keyset={}
  for key in pairs(self) do
    table.insert(keyset, key)
  end
  return keyset
end
