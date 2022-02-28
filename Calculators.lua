local calc = {}

calc.hex2rgb = function(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

calc.deci2hex = function(deci)
  return string.format("%x", deci)
end

calc.rgb2hex = function(r, g, b, string)
  if string then
    return string.format("#%02X%02X%02X", r, g, b)
  else
    return calc.deci2hex(r), calc.deci2hex(g), calc.deci2hex(b)
  end
end

calc.percent2hex = function(percent)

  --Avoid using the requirement of math.round
  function round(num, numDecimalPlaces)
    --Rounding Numbers to a given place value--
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
  end
  local deci = round(percent*255/100)
  return calc.deci2hex(deci)
end

return calc
