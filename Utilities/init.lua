local json = require("json")
local icons = require "icons"

local Utilities = {}

function Utilities.hello()
  print("Hello World!")
end


function Utilities.draw_icon(icon_name, color)
  local data = {
    DrawChrome = true,
    IconString = icons[icon_name]
  }
  if color then
    data.Color = color
  end
  return json.encode(data)
end



-- Updated to pairs instead of ipairs to handle string indexing--
function Utilities.exclude( ctl, ctl_table )
  if ctl.Boolean then
    for i, c in pairs( ctl_table ) do
      if c ~= ctl then c.Boolean = false end
    end
  end
end


return Utilities
