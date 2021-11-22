require "Advanced_String"
require "json"
util = require "Utilities"

main = Component.New("UCI Environment")
touch_timer = Timer.New()

function filter_contorls(ctls, prefix)
  filtered = {}
  for name, ctl in pairs(ctls) do
    if string.find(name, prefix) then
      filtered[string.trim(string.sub(name, #prefix +1))] = ctl
    end
  end
  return filtered
end

function other_controls(ctls)
  filtered = {}
  for name, ctl in pairs(ctls) do
    if not string.find(name, "LAYERS:")  or not string.find(name, "PAGES:") then
      table.insert(filtered, ctl)
    end
  end
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

function other_events(ctls)
  for _, ctl in pairs(ctls) do
    ctl.EventHandler = function()
      print("Other Button Pressed")
    end
  end
end


Layer_Controls = filter_contorls(Controls, "LAYER:")
Page_Controls = filter_contorls(Controls, "PAGE:")
Other_Controls = other_controls(Controls)


layer_events(Layer_Controls)
page_events(Page_Controls)
