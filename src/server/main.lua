local log   = require("tools.logging")
log.init()
local srvr  = require("server")
local comT  = require("tools.communication")
comT.connectModem()
local protM = require("tools.protocolManager")
local set   = require("settings")
local fm    = require("tools.fileManager")
local stor  = require("storage")
local actM = require("tools.actionsManager")

local screen = peripheral.find("monitor")

local connectedClients = {}

while true do

    local event = {os.pullEvent()}
    if event[ 1 ] == "rednet_message" then
        local id = tonumber(event[2])
        local message = event[3]
        local protocol = event[4]

        log.log('Received "' .. message .. '" from user #' .. id .. ' on protocol "' .. protocol .. '"')
        
        local protocolType = protM.getId(protocol)

        if protocolType == "CONNECT" then
            srvr.connect(id)
            table.insert(connectedClients, id)
        elseif message == set.receiveConfirmationMsg then
            print("giving orders")
            local nexStep = mine.getNextStep(id)
            print("nexStep = " .. tostring(nexStep))
            if not (nexStep == nil) then
                actM.sendAction(id, nexStep)
            end
        end
    end

end
