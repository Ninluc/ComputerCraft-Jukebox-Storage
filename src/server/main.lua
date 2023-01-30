local log   = require("tools.logging")
log.init()
local srvr  = require("server")
local comT  = require("tools.communication")
comT.connectModem()
local protM = require("tools.protocolManager")
local set   = require("settings")
local fm    = require("tools.fileManager")
local actM  = require("tools.actionsManager")
local strT  = require("tools.stringTools")
local store = require("storage")
local actions = actM.getActions()

-- WINDOWS
multishell.setTitle(multishell.getCurrent(), "Log")
-- Input window
local id = multishell.launch(_ENV, set.inputProgramPath)
multishell.setTitle(id, "Input")

-- local screen = peripheral.find("monitor")

local connectedClients = {}

while true do
    local event = {os.pullEvent()}
    -- print(event[1], event[2])

    -- REDNET MESSAGE
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
            local nexStep = store.getNextStep(id)
            print("nexStep = " .. tostring(nexStep))
            if not (nexStep == nil) then
                actM.sendAction(id, nexStep)
            end
        -- If we receive an order from a client
        elseif protocol == comT.getProtocolName(os.computerID()) then
            print("received " .. message)

            local action, paramList = string.match(message, "(.*)%" .. set.actionsFieldSeparator .. "(.*)")

            if paramList == nil then
                actions[message]()
            else
                local param = strT.splitByChar(paramList, set.actionsParametersSeparator)
                actions[action](param)
            end

            -- We send a confirmation to receive the next message
            comT.send(id, set.receiveConfirmationMsg, protocol)
        end
    -- USER INPUT
    elseif event[ 1 ] == "input" then
        local command = event[2]
        local args
        if event[3] then
            args = event[3]
        end

        -- MAP
        if command == "map" then
            actM.sendAction(nil, actM.format("map", args))
            print("sent mappage")
        end

        print("User asked command : " .. command)
    end

end
