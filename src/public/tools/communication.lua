local log   = require("tools.logging")
local set   = require("settings")
local protM = require("tools.protocolManager")
local strT  = require("tools.stringTools")

local communnicationTool = {}

function communnicationTool.connectModem()
    peripheral.find("modem", rednet.open)
    log.log("Modem connected")
end

function communnicationTool.send(--[[required]]recipient, --[[required]]message , --[[optional]]protocol)
    if not protocol then
        if recipient then
            rednet.send(recipient, message)
            log.log('Sent \"' .. message .. '" to computer #' .. recipient)
        else
            rednet.broadcast(message)
            log.log('Broadcasted \"' .. message .. '\"')
        end
    else
        if recipient then
            rednet.send(recipient, message, protocol)
            log.log('Sent \"' .. message .. '" to computer #' .. recipient .. ' with protocol "' .. protocol .. '"')
        else
            rednet.broadcast(message, protocol)
            log.log('Broadcasted \"' .. message .. '" with protocol "' .. protocol .. '"')
        end
    end
end

function communnicationTool.receive(--[[optional]]protocol_filter, --[[optional]]timeout)
    if not timeout and not protocol_filter then
        local id, msg = rednet.receive()
        if not msg then
            log.log("Didn't received anything...")
            return nil
        else
            log.log('Received "' .. msg .. '" from user #' .. id)
            return id, msg, nil
        end
    elseif not timeout then
        local id, msg, protocol = rednet.receive(protocol_filter)
        if not msg then
            log.log("Didn't received anything...")
            return nil
        else
            log.log('Received "' .. msg .. '" from user #' .. id .. ' with protocol "' .. protocol .. '"' )
            return id, msg, protocol
        end
    else
        local id, msg, protocol = rednet.receive(protocol_filter, timeout)
        if not msg then
            log.log("Didn't received anything...")
            return nil
        else
            log.log('Received "' .. msg .. '" from user #' .. id .. ' with protocol "' .. protocol .. '"' )
            return id, msg, protocol
        end
    end
end

function communnicationTool.broadcast(--[[required]]message, --[[optional]]protocol)
    rednet.broadcast(message, protocol)
    
    local protocolMsg = ""
    if protocol then
        protocolMsg = ' to protocol "' .. protocol .. '"'
    end
    log.log('Brodcasted "' .. message .. '"' .. protocolMsg)
end



-- Advanced functions --
function communnicationTool.receiveAndConfirm(--[[optional]]protocol, --[[optional]]receive_timeout)
    if not receive_timeout then
        receive_timeout = 10
    end

    local id, msg = communnicationTool.receive(protocol, receive_timeout)
    if not msg then
        return nil
    else
        communnicationTool.send(tonumber(id), set.receiveConfirmationMsg, protocol)
        return id, msg, protocol
    end
    
end

function communnicationTool.sendAndWait(--[[required]]recipient, --[[required]]message, --[[required]]protocol, --[[optional]]max_attempt)
    if not max_attempt then
        max_attempt = 10
    end
    
    local id, msg
    while not msg do
        communnicationTool.send(recipient, message, protocol)
        id, msg = communnicationTool.receive(protocol, 1)
        os.sleep(0.01)
    end
    return id, msg
end

--[[ Replace any character that could potentially break an action ]]
function communnicationTool.cleanse(text)
    -- We remove any character
    text = strT.joinByChar(strT.splitByChar(text, set.actionsFieldSeparator), set.actionsFieldSeparatorReplacement)
    text = strT.joinByChar(strT.splitByChar(text, set.actionsParametersSeparator), set.actionsParametersSeparatorReplacement)
    return text
end

--[[ Unreplace any character that could potentially break an action ]]
function communnicationTool.uncleanse(text)
    -- We remove any character
    text = strT.joinByChar(strT.splitByChar(text, set.actionsFieldSeparatorReplacement), set.actionsFieldSeparator)
    text = strT.joinByChar(strT.splitByChar(text, set.actionsParametersSeparatorReplacement), set.actionsParametersSeparator)
    return text
end



-- MISC --
function communnicationTool.getProtocolName(clientId)
    if not clientId then
        return nil
    end
    return set.protocolName .. "_" .. clientId
end

return communnicationTool