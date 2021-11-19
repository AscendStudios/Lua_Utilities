require "Advanced_Tables"
require "Advanced_String"
require "json"
util = require "Utilities"

main = Component.New("UCI Environment")

function filter_contorls(ctls, prefix)
  filtered = {}
  for name, ctl in pairs(ctls) do
    if string.find(name, prefix) then
      filtered[string.trim(string.sub(name, #prefix +1))] = ctl
    end
  end
  return filtered
end

function layer_events(ctls)
  for name, ctl in pairs(ctls) do
    ctl.EventHandler = function()
      local data = {['String'] = name, ['Boolean'] = ctl.Boolean}
      main.json_data.String = json.encode(data)
      util.exclude(ctl, ctls)
    end
  end
end

function page_events(ctls)
  for name, ctl in pairs(ctls) do
    ctl.EventHandler = function()
      if ctl.Boolean then main.Pages.String = name end
      util.exclude(ctl, ctls)
    end
  end
end




Layer_Controls = filter_contorls(Controls, "LAYER:")
Page_Controls = filter_contorls(Controls, "PAGE:")
main.Orphaned_Layer_Controls.Choices = table.keys(Layer_Controls)

layer_events(Layer_Controls)
page_events(Page_Controls)
