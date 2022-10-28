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

function write_file(file_path, data)
  local file = io.open(file_path, 'w+')
  file:write(data)
  file:close()
 end

function Utilities.read_xml(file_path)
  return xml.eval(read_file(file_path))
end


-- Add the dir library to Utilites
Utilities.dir = dir
-- Function will get or create and get a directory
Utilities.dir.getCreate = function(path)
  if not dir.get(path) then
    dir.create(path)
  end
  return dir.get(path)
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
