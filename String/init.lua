--[[

Advanced string functions that are not implemented in LUA
This Module hot patches the string library with additional methods

  To use:
    require("String")
    Then call as expeted - string.split(string)

--]]
local string = string

function string.trim(s)
  return string.match(s, "^%s*(.*)")
end

function string.split(self, sep, regex)
  local list = {}
  local position = 1
  if not regex then mode = "plain" end
  local index, z = string.find(self, sep, 1, mode)
  while index do
    table.insert(list, string.sub(self, position, index -1))
    position = z + 1
    index, z = string.find(self, sep, position, mode)
  end
  table.insert(list, string.sub(self, position, -1))
  if #list == 0 then list = self end
  return list
end

return string
