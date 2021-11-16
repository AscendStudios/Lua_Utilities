--[[

Advanced Table functions that are not implemented in LUA

  To use:
    require("Advanced_Tables")
    Then call as expeted - table.reverse(tbl)

--]]

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function table.reverse(tbl)
  for i=1, math.floor(#tbl / 2) do
    tbl[i], tbl[#tbl - i + 1] = tbl[#tbl - i + 1], tbl[i]
  end
end

function table.print(tbl)
  local name = require "json"
  print(json.encode(tbl))
end

function table.keys(tbl)
  local keyset={}
  for key in pairs(tbl) do
    table.insert(keyset, key)
  end
  return keyset
end
