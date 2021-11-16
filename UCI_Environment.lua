local rj = require("rapidjson")
local UCI_Environment = {}


function read_json(file_path)
  -- simply load the rapidjson as a tale and return
  return rj.load(file_path)
end


function get_uci_map()
  --Using the rapidjson list the Uci names
  local json_data = read_json('design/ucis.json')
  local user_interfaces = {}
  for _, uci in pairs(json_data.Ucis) do
    user_interfaces[uci.Name] = {}
    for _, page in pairs(uci.Pages) do
      user_interfaces[uci.Name][page.Name] = {}
      for index, layer in pairs(page.Layers) do
        user_interfaces[uci.Name][page.Name][index] = layer.Name
      end
    end
  end
  return user_interfaces
end

local uci_map = get_uci_map()

function get_ucis()
  local uci_list = {}
  for name, _ in pairs(uci_map) do
    table.insert(uci_list, name)
  end
  return uci_list
end

function get_panels()
  local panel_list = {}
  for _, name in pairs(Design.GetInventory()) do
    if name.Type == "Touch Screen" or name.Model == "UCI Viewer" then
      table.insert(panel_list, name.Name)
    end
  end
  return panel_list
end

function UCI_Environment.get_pages(uci_name)
  local page_list = {}
  for page, _ in pairs(uci_map[uci_name]) do
    table.insert(page_list, page)
  end
  table.sort(page_list)
  return page_list
end

function UCI_Environment.get_layers(uci_name, page_name)
  local layer_list = {}
  for page, layer in ipairs(uci_map[uci_name][page_name]) do
    table.insert(layer_list, layer)
  end
  table.sort(layer_list)
  return layer_list
end



UCI_Environment.UCIS = get_ucis()
UCI_Environment.PANELS = get_panels()




return UCI_Environment
