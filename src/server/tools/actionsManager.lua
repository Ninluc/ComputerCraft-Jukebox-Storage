local comT  = require("tools.communication")
local set   = require("globSettings")
local turtM = require("tools.turtlesManager")
turtM.init()

local actionsManager = {}

function actionsManager.format(--[[required]]action, --[[optional]]parameters)
    if parameters then
        local parametersStr = ""
        for pos, param in pairs(parameters) do
            parametersStr = parametersStr .. tostring(param)
            -- If it's not last position
            if parameters[pos+1] then
                parametersStr = parametersStr .. set.actionsParametersSeparator
            end
        end
        print(parametersStr)
        return action .. set.actionsFieldSeparator .. parametersStr
    else
        return action
    end
end

function actionsManager.sendAction(clientId, action)
    comT.send(clientId, action, comT.getProtocolName(clientId))
    turtM.addAction(clientId, action)
end

function actionsManager.getLastAction(clientId)
    return turtM.getLastAction(clientId)
end

return actionsManager