local set  = require("settings")
local fm   = require("tools.fileManager")
local log  = require("tools.logging")
local strT = require("tools.stringTools")

--[[
    Two main file : one for each storage containing the items in that storage
    And another one conataining informations about each storages
 ]]

local storageManager = {}

function storageManager.init()
    if not fm.exists(set.storageManagerFolder) then
        fm.createFolder(set.storageManagerFolder)
    end

    fm.createIfNoFile(set.storageManagerInfoFileName)
end

---------

--[[ Get all of the informations for each storage ]]
function storageManager.getInfos()
    return fm.readLines(set.storageManagerInfoFileName)
end

--[[ Get all of the informations of a specific storage ]]
function storageManager.getInfo(storageId)
    return storageManager.getInfos()[storageId]
end

--[[ Find if a storage already exist based on his location ]]
function storageManager.exist(location)
    local infos = storageManager.getInfos()
    for _, info in ipairs(infos) do
        local infoLst = strT.splitByChar(info, set.actionsParametersSeparator)
        if (infoLst[1] == location[1] and infoLst[2] == location[2] and infoLst[3] == location[3]) then
            return true
        end
    end

    return false
end

--[[ Add a new storage. Create storage file and add informations to 
the storages info file
@param info List af all the informations to put in the info file (see documentation)
]]
function storageManager.addStorage(info)
    local storageId = 1
    if (storageManager.getLastId()) then
        storageId = storageManager.getLastId() + 1
    end

    if (storageManager.exist({info[1], info[2], info[3]})) then
        log.log("storage already exist in db")
        return nil
    end

    -- Info file
    local informations = ""
    for i, value in ipairs(info) do
        informations = informations .. value .. set.actionsParametersSeparator
    end
    fm.append(set.storageManagerInfoFileName, informations .. "\n")

    -- Storage file
    fm.createIfNoFile(set.storageManagerStorageFileName .. storageId)

    log.log("Storage #" .. storageId .. " added")
end

function storageManager.getLastId()
    return fm.countLine(set.storageManagerInfoFileName)
end


return storageManager