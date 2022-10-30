--[[

Advanced Math functions that are not implemented in LUA
    This Module hot pathces the built in math module.
      To use:
        require("Math")
        Then call as expeted - math.round(num, numDecimalPlaces)

--]]

local math = math

local function math.round(num, numDecimalPlaces)
  --Rounding Numbers to a given place value--
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

local function math.sum(...)
  args = {...}
  local sum = 0
  for i=1, #args do
    sum = sum + args[i]
  end
  return sum
end


local function math.clamp(num, min, max)
  assert(min < max, "Min number must be less than the Max")
  if min <= num and max >= num then
    return num
  elseif num > max then
    return max
  else
    return min
  end
end

return math
