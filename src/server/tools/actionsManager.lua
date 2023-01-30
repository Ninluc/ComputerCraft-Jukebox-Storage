local comT  = require("tools.communication")
local set   = require("settings")
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
    if clientId then
        turtM.addAction(clientId, action)
    end
end

function actionsManager.getLastAction(clientId)
    return turtM.getLastAction(clientId)
end

function actionsManager.getActions()
    local files = fs.list(set.actionsFolder)
    local actions = {}

    for _, fileName in pairs(files) do
        local moduleName, _ = string.match(fileName, "(.*)%.(.*)")
        local module = require(set.actionsFolder .. moduleName)

        actions[moduleName] = module.run
    end

    return actions
end

return actionsManager