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

return actionsManager