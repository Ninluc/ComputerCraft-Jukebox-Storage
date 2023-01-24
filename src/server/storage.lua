local actM   = require("tools.actionsManager")
local strT   = require("tools.stringTools")
local uInput = require('tools.uInput')
local set    = require("settings")

local mining = {}


function mining.getNextStep(clientId)
    local lastStep, parameters
    local lastStepLine = actM.getLastAction(clientId)
    if not (lastStepLine == nil or lastStepLine == "") then
        lastStep, parameters = string.match(lastStepLine, "(.*)%" .. set.actionsFieldSeparator .. "(.*)")
        -- If no parameters
        if lastStep == nil then
            lastStep = lastStepLine
        elseif parameters then
            parameters = strT.splitByChar(parameters, set.actionsParametersSeparator)
        end
    else
        lastStep = nil
    end


    if (lastStep == nil) then
        if (uInput.ask("Êtes-vous certains que la tortue est bien positionnée (voir documentation)\n (y/n)") == "y") then
            return actM.format("map")
        else
            return nil
        end
    end

    -- return actM.format("go", {0, 0, 0, true})
    return actM.format("map", {os.getComputerID()})
end

return mining