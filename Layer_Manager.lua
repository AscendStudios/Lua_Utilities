require "Advanced_Tables"
require "Advanced_String"
require "json"
util = require "Utilities"


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
      local data = {['String'] = name, ['Boolean'] = ctl.Boolean}
      main.json_data.String = json.encode(data)
        util.exclude(ctl, Controls)
    end
  end
end

Controls = filter_contorls(Controls)

main["Orphaned_Layer_Controls"].Choices = table.keys(Controls)

events()
