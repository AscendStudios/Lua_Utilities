local rj = require("rapidjson")
require "Advanced_Tables"


--------------------------------------------
--------------GLOBAL FUNCTIONS--------------
--------------------------------------------

function read_json(file_path)
  -- simply load the rapidjson as a tale and return
  return rj.load(file_path)
end

--------------------------------------------
--------------MODULE OBJECT-----------------
--------------------------------------------

local UCI_Environment = {}


---------------------------------------------------
--------------MODULE VARIABLE DECLARATION----------
---------------------------------------------------
UCI_Environment.MAP = {}
UCI_Environment.UCIS = {}
UCI_Environment.PANELS = {}
UCI_Environment.CONFIG = {}

--------------------------------------------
--------------MODULE FUNCTIONS--------------
--------------------------------------------

function UCI_Environment.get_uci_map()
  --Using the rapidjson list the Uci names
  local json_data = read_json('design/ucis.json')
  local user_interfaces = {}
  for _, uci in pairs(json_data.Ucis) do
    user_interfaces[uci.Name] = {}
    for _, page in pairs(uci.Pages) do
      user_interfaces[uci.Name][page.Name] = {}
      for index, layer in pairs(page.Layers) do
        user_interfaces[uci.Name][page.Name][index] = layer
        --print("HERE: ",  table.print(layer))
      end
    end
  end
  return user_interfaces
end

function UCI_Environment.get_ucis()
  local uci_list = {}
  for name, _ in pairs(UCI_Environment.MAP) do
    table.insert(uci_list, name)
  end
  return uci_list
end

function UCI_Environment.get_panels()
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
  for page, _ in pairs(UCI_Environment.MAP[uci_name]) do
    table.insert(page_list, page)
  end
  table.sort(page_list)
  return page_list
end

function UCI_Environment.get_layers(uci_name, page_name)
  local layer_list = {}
  for index, layer in ipairs(UCI_Environment.MAP[uci_name][page_name]) do
    print(index, layer)
    table.insert(layer_list, layer.Name)
  end
  table.sort(layer_list)
  return layer_list
end

function UCI_Environment.write_config(config_table)
  local config= {}
  config.path = "design/AS-Configs/layers.json"
  rj.dump(config_table, config.path, {pretty=true})
  return rj.load(config.path)
end

function UCI_Environment.read_config()
  local config= {}
  config.root = "design/AS-Configs/"
  config.filename = "layers.json"
  config.path = "design/AS-Configs/layers.json"

  --Create directory and file if needed--
  if not dir.get(config.root) then
    print("Creating AS Config directory")                                             --Create both directory and file
    dir.create(config.root)
    print("Creating layer.json")
    UCI_Environment.write_config({rj.null()})
  elseif not table.contains(dir.get(config.root), config.filename) then         --Create just the file, not the directory
    print("Creating layer.json")
    config.data = UCI_Environment.write_config({rj.null()})
  end
  return rj.load(config.path)
end


function UCI_Environment.write_default(layer_table)
  --TODO: Add in a meta tabel for optional args

  --Check to see if the control exists--
  if table.contains(Controls.Orphaned_Layer_Controls, layer_table.Name) then
      layer_table.IsControlable = true
      table.remove(Controls.Orphaned_Layer_Controls, layer_table.Name)
  else
    layer_table.IsControlable = false
  end
  layer_table.Transition = "None"
  layer_table.ExclusionGroup = 'Main'
  return layer_table
end

function UCI_Environment.reconcile_data()
  --Adds missing config data
  for uci_name, pages in pairs(UCI_Environment.MAP) do
    for page_name, layers in pairs(pages) do
      for index, layer in pairs(layers) do
        --Check to see if the data in the map is in the config
        if not UCI_Environment.CONFIG[uci_name][page_name][index].Name then
          UCI_Environment.CONFIG[uci_name][page_name][index] = UCI_Environment.write_default(layer)
          print("Updating json file")
        end
      end
    end
  end
  --Remove old data from CONFIG
  for uci_name, pages in pairs(UCI_Environment.CONFIG) do
    for page_name, layers in pairs(pages) do
      for index, layer in pairs(layers) do
        --Check to see if the data in the CONFIG is in the MAP
        if not UCI_Environment.MAP[uci_name][page_name][index].Name then
          print("Removing old data from json file")
          table.remove(
            UCI_Environment.CONFIG,
            UCI_Environment.CONFIG[uci_name][page_name][index]
          )
        end
      end
    end
  end
  UCI_Environment.CONFIG = UCI_Environment.write_config(UCI_Environment.CONFIG)
end

function layer_control()

end
---------------------------------------------------
--------------DEFINE MODULE VARIABLES--------------
---------------------------------------------------

UCI_Environment.MAP = UCI_Environment.get_uci_map()
UCI_Environment.UCIS = UCI_Environment.get_ucis()
UCI_Environment.PANELS = UCI_Environment.get_panels()
UCI_Environment.CONFIG = UCI_Environment.read_config()

---------------------------------------------------
--------------INIT MODULE Environment--------------
---------------------------------------------------
for uci_name, pages in pairs(UCI_Environment.MAP) do
  for page_name, layers in pairs(pages) do
    for index, layer in pairs(layers) do
      --print(index, layer)
    end
  end
end
--UCI_Environment.reconcile_data()


------------------------------------------
--------------MODULE TOOLBOX--------------
------------------------------------------

function UCI_Environment.TOOLBOX()
  --TODO: Make function print in order.
  for name in pairs(UCI_Environment) do
    if name ~= "TOOLBOX" then
      print(name, type(UCI_Environment[name]))
    end
  end
end

------------------------------------------
-------------- RETURN MODULE--------------
------------------------------------------

return UCI_Environment
