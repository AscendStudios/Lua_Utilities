require "Advanced_String"
require "json"
util = require "Utilities"

main = Component.New("UCI Handler")
touch_timer = Timer.New()

function filter_controls(ctls, prefix)
  local filtered = {}
  for name, ctl in pairs(ctls) do
    if string.find(name, prefix) then
      filtered[string.trim(string.sub(name, #prefix +1))] = ctl
    end
  end
  return filtered
end

function other_controls(ctls)
  local filtered = {}
  for name, ctl in pairs(ctls) do
    if not string.find(name, "LAYERS:")  or not string.find(name, "PAGE:") then
    end
  end
end

function get_embedded_exlusion(name)
  --returns name, exclusion
  local i = string.find(name, "#")
  if i then
    exclusion = string.sub(name, i+1, -1)
    name = string.sub(name, 1, i-1)
  else
    exclusion = nil
  end
  return name, exclusion
end

function layer_events(ctls)
  for name, ctl in pairs(ctls) do
    ctl.EventHandler = function()
      name, exclusion = get_embedded_exlusion(name)
      local data = {['Name']=NAME, ['String'] = name, ['Boolean'] = ctl.Boolean}
      if exclusion then data['ExclusionGroup'] = exclusion end
      main.UCI_JSON.String = json.encode(data)
      --util.exclude(ctl, ctls)
    end
  end
end

function page_events(ctls)
  for name, ctl in pairs(ctls) do
    ctl.EventHandler = function()
      print('HANDLER\t', name, ctl, ctls[name].Boolean)
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


Layer_Controls = filter_controls(Controls, "LAYER:")
Page_Controls = filter_controls(Controls, "PAGE:")
Other_Controls = other_controls(Controls)


layer_events(Layer_Controls)
page_events(Page_Controls)

print(NAME)
