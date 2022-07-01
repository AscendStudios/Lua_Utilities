local Utilities = {}
require "luaXML"
require "json"
local icons = require "icons"
local rj = require("rapidjson")


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

function read_file(file_path)
  local file = io.open(file_path, 'r')
  data = file:read("*a")
  file:close()
  return data
end

function Utilities.read_xml(file_path)
  return xml.eval(read_file(file_path))
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
