local fm  = require("tools.fileManager")
local set = require("settings")
local log = require("tools.logging")

local file = set.memoryFilesFolder .. set.connectedClientsIdFileName
local protocolManager = {}

function protocolManager.getId(--[[required]] protocol)
    local defaultProt, id = string.match(protocol, "(.*)%_(.*)")
    return id
end

function protocolManager.add(id)
    fm.createIfNoFile(file)
    fm.append(file, id .. "\n")
    log.log("added client #" .. id .. ' to the protocol manager file ("' .. file .. '")')
end

function protocolManager.exists(id)
    return fm.exists(file) and fm.containsLine(file, id)
end

function protocolManager.clear()
    fm.write(file, "")
    log.log('Cleared the protocol manager file ("' .. file .. '")')
end

return protocolManager