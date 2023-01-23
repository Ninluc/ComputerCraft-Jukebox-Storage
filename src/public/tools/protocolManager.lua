local fm  = require("tools.fileManager")
local set = require("globSettings")
local log = require("tools.logging")

local protocolManager = {}

function protocolManager.getId(--[[required]] protocol)
    local defaultProt, id = string.match(protocol, "(.*)%_(.*)")
    return id
end

function protocolManager.add(id)
    fm.createIfNoFile(set.memoryFilesFolder .. set.connectedClientsIdFileName)
    fm.append(set.memoryFilesFolder .. set.connectedClientsIdFileName, id .. "\n")
    log.log("added client #" .. id .. ' to the protocol manager file ("' .. set.memoryFilesFolder .. set.connectedClientsIdFileName .. '")')
end

function protocolManager.exists(id)
    return fm.containsLine(set.memoryFilesFolder .. set.connectedClientsIdFileName, id)
end

function protocolManager.clear()
    fm.write(set.memoryFilesFolder .. set.connectedClientsIdFileName, "")
    log.log('Cleared the protocol manager file ("' .. set.memoryFilesFolder .. set.connectedClientsIdFileName .. '")')
end

return protocolManager