local log     = require("tools.logging")
local sDBM    = require("tools.storageDBManager")
log.init()
local srvr    = require("server")
local comT    = require("tools.communication")
comT.connectModem()
local protM   = require("tools.protocolManager")
local set     = require("settings")
local fm      = require("tools.fileManager")
local actM    = require("tools.actionsManager")
local strT    = require("tools.stringTools")
local inputT  = require("tools.inputTools")
local store   = require("storage")
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

        log.log('Received "' .. comT.uncleanse(message) .. '" from user #' .. id .. ' on protocol "' .. protocol .. '"')
        
        local protocolType = protM.getId(protocol)

        if protocolType == "CONNECT" then
            srvr.connect(id)
            table.insert(connectedClients, id)
        elseif comT.uncleanse(message) == set.receiveConfirmationMsg then
            print("giving orders")
            local nexStep = store.getNextStep(id)
            print("nexStep = " .. tostring(nexStep))
            if not (nexStep == nil) then
                actM.sendAction(id, nexStep)
            end

        -- If we receive an order from a client
        elseif protocol == comT.getProtocolName(os.computerID()) then
            print("received " .. comT.uncleanse(message))

            local action, paramList = string.match(message, "(.*)%" .. set.actionsFieldSeparator .. "(.*)")

            local response
            if paramList == nil then
                response = actions[message]()
            else
                local param = strT.splitByChar(paramList, set.actionsParametersSeparator)
                for i = 1, #param, 1 do -- We uncleanse
                    param[i] = comT.uncleanse(param[i])
                end
                response = actions[action](param)
            end

            -- Answer
            if (response) then
                -- Answer what the action gave
                comT.send(id, response, protocol)
            else
                -- We send a confirmation to receive the next message
                comT.send(id, set.receiveConfirmationMsg, protocol)
            end
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

        if command == "get" then
            local results = args[1]
            local requestedQuantity = args[2]
            print("TODO : envoyer les requêtes")
            print(textutils.serialise(args))
            actM.sendAction(nil, actM.format("get", args))
        end

        print("User asked command : " .. command)
    end

end
