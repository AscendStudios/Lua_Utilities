require "Advanced_Tables"
require "Advanced_String"
util = require "Utilities"

main = Component.New("UCI Environment")

function filter_contorls(ctls)
  filtered = {}
  prefix = "LAYER:"
  for name, ctl in pairs(ctls) do
    if string.find(name, prefix) then
      filtered[string.sub(name, string.trim(#prefix +1))] = ctl
    end
  end
  return filtered
end

Controls = filter_contorls(Controls)

main["UCI_Buttons"].Choices = table.keys(Controls)

function events()
  for name, ctl in pairs(Controls) do
    ctl.EventHandler = function()
        if ctl.Boolean then main.UCI_Buttons.String = name end
        util.exclude(ctl, Controls)
    end
  end
end

events()
