require "Advanced_Tables"
require "Advanced_String"
util = require "Utilities"
local env = require "UCI_Environment"

main = Component.New("UCI Environment")
--layer = Component.New("Layer Comntrol")

function current_page()
  return Controls.Pages.String
end

function current_uci()
  return Controls.UCIs.String
end


function filter_contorls(ctls)
  filtered = {}
  prefix = "LAYER:"
  for name, ctl in pairs(ctls) do
    if string.find(name, prefix) then
      filtered[string.trim(string.sub(name, #prefix +1))] = ctl
    end
  end
  return filtered
end

function events()
  for name, ctl in pairs(Controls) do
    ctl.EventHandler = function()
        if ctl.Boolean then
          if table.contains(main.Layers.Choices, name) then
            main.Layers.String = name end
          else
            print("Unexpected Layer Request!")
        util.exclude(ctl, Controls)
    end
  end
end

Controls = filter_contorls(Controls)

main["Orphaned_Layer_Controls"].Choices = table.keys(Controls)

events()
