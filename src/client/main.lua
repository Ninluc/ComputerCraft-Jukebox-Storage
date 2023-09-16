local log   = require("tools.logging")
log.init()
local posM  = require("tools.positionManager")
posM.init()
local facM = require("tools.facingManager")
facM.init()
local clt   = require("client")
local comT  = require("tools.communication")
comT.connectModem()
local protM = require("tools.protocolManager")
local set   = require("settings")
local fm    = require("tools.fileManager")
local act   = require("tools.actionsManager")
local actions = act.getActions()
local strT  = require("tools.stringTools")



-- Create a connection
local servId, msg
while not msg do
    servId, msg = clt.createConnection()
end
print("Succesfully connected")



while true do

    local event = {os.pullEvent()}
    if event[ 1 ] == "rednet_message" then
        local id = tonumber(event[2])
        local message = event[3]
        local protocol = ""
        if event[4] then
            protocol = event[4]
        end

        log.log('Received "' .. comT.uncleanse(message) .. '" from user #' .. id .. ' on protocol "' .. protocol .. '"')

        if message == set.receiveConfirmationMsg then
            -- Received = true
        else
            print("received " .. message)

            local action, paramList = string.match(message, "(.*)%" .. set.actionsFieldSeparator .. "(.*)")

            if paramList == nil then
                actions[message]()
            else
                local param = strT.splitByChar(paramList, set.actionsParametersSeparator)
                for i = 1, #param, 1 do -- We uncleanse
                    param[i] = comT.uncleanse(param[i])
                end
                actions[action](param)
            end

            -- We send a confirmation to receive the next message
            comT.send(servId, set.receiveConfirmationMsg, protocol)
        end
    end

end