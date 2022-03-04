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

function math.sum(...)
  args = {...}
  local sum = 0
  for i=1, #args do
    sum = sum + args[i]
  end
  return sum
end


function math.clamp(num, min, max)
  assert(min < max, "Min number must be less than the Max")
  if min <= num and max >= num then
    return num
  elseif num > max then
    return max
  else
    return min
  end
end
