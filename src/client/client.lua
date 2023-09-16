local comT = require("tools.communication")
local set  = require("settings")
local log  = require("tools.logging")

local client = {}

function client.createConnection(--[[optional]]waitTime)
    local compId = os.getComputerID()
    if not waitTime then
        waitTime = 2
    end

    comT.broadcast(compId, set.connectionCreateProtocol)
    local id, msg, protocol = comT.receiveAndConfirm(comT.getProtocolName(compId), waitTime)
    if not msg then
        log.error("Couldn't initialize a connection with a server, did no received any response after " .. waitTime .. "s")
        -- printError("Couldn't initialize a connection with a server")
        return false
    else
        log.log("Succesfully created a connection with a server")
        return id, msg
    end
end

function client.sendError(errorMsg)
    local compId = os.getComputerID()
    comT.broadcast("Error : " .. errorMsg, comT.getProtocolName(compId))
end

return client