--[[

Advanced Math functions that are not implemented in LUA

  To use:
    require("Advanced_Math")
    Then call as expeted - math.round(num, numDecimalPlaces)

--]]

function math.round(num, numDecimalPlaces)
  --Rounding Numbers to a given place value--
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end
