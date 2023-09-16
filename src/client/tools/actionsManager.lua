local comT  = require("tools.communication")
local set = require("settings")

local actionsManager = {}

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

function actionsManager.sendAction(clientId, action)
    comT.send(clientId, action, comT.getProtocolName(clientId))
end

function actionsManager.format(--[[required]]action, --[[optional]]parameters)
    if parameters then
        local parametersStr = ""
        for pos, param in pairs(parameters) do
            parametersStr = parametersStr .. comT.cleanse(tostring(param))
            -- If it's not last position
            if parameters[pos+1] then
                parametersStr = parametersStr .. set.actionsParametersSeparator
            end
        end
        print("Sent : " .. parametersStr)
        return comT.cleanse(action) .. set.actionsFieldSeparator .. parametersStr
    else
        return action
    end
end

return actionsManager