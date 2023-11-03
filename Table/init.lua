--[[

Advanced Table functions that are not implemented in LUA

  To use:
    require("Advanced_Tables")
    Then call as expeted - table.reverse(tbl)

--]]

local table = table

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
  local rj = require "rapidjson"
  print(rj.encode(self, {pretty=true}))
end

function table.keys(self)
  local keyset={}
  for key in pairs(self) do
    table.insert(keyset, key)
  end
  return keyset
end

function table.values(self)
  local valset = {}
  for i, v in pairs(self) do
    valset[v] = i
  end
  return valset
end

function table.test(self, func, ...)
  --[[
  This function will test if each item in a table return true given
  the provided condition. The condition should be given as a function
  that will return a boolean value. The function's first parameter
  must be the table variable. afterwards, additional arguments can be
  provided.
  --]]
  local counter = 0
  for key, value in pairs(self) do
    if func(value, ...) then
      counter = counter + 1
    else
      break
    end
  end
  return counter == #self
end

-- Function to count elements in a table.
-- Default uses values, but keys can be used by setting keys = true
function table.count(self, element, keys)
  local count = 0
  for idx, item in pairs(self) do
    if keys then item = idx end
    if item == element then count = count + 1 end
  end
  return count
end

return table
