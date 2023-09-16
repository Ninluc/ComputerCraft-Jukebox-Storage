local set  = require("settings")
local fm   = require("tools.fileManager")
local log  = require("tools.logging")
local strT = require("tools.stringTools")
local lstT = require("tools.listTools")

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
    local lastStorageId = storageManager.getLastStorageId()
    print("last id = " .. lastStorageId)
    if (lastStorageId) then
        storageId = lastStorageId + 1
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

    -- We give the storage id created
    return storageId
end

function storageManager.getLastStorageId()
    return fm.countLine(set.storageManagerInfoFileName)
end

--[[ Format some info about an item to be prepared to be put in storage file ]]
function storageManager.format(info)
    local str = ""
    for _, value in ipairs(info) do
        str = str .. value .. set.storageFileItemInfoSeparator
    end
    return str
end

function storageManager.addItem(displayName, name, idStorage, slot, count, maxCount)
    print("id storage = " .. idStorage .. " file = " .. set.storageManagerStorageFileName .. idStorage)
    fm.append(set.storageManagerStorageFileName .. idStorage, storageManager.format({displayName, name, slot, count, maxCount}) .. "\n")
end

--[[ Return informations values from a line.
The return format is `displayName`, `name`, `slot`, `count`, `maxCount` ]]
function storageManager.parse(line)
    local infos = strT.splitByChar(line, set.storageFileItemInfoSeparator)
    return infos[1], infos[2], infos[3], infos[4], infos[5]
end

-- SEARCH

--[[ Search into a specific storage. Assuming it exist.
return a table with all of the occurrences ]]
function searchInto(storageId, info, infoPlace)
    local fileLines = fm.readLines(set.storageManagerStorageFileName .. storageId)
    local lines = {}
    local lineI = 1

    for i, line in ipairs(fileLines) do
        local infos = {storageManager.parse(line)}
        if (string.find(string.lower(infos[infoPlace]), info)) then
            lines[lineI] = infos
            lineI = lineI + 1
        end
    end

    return lines
end

--[[ Search trough the database in every storage with the value given that can be
found in the #infoPlace place. 
TODO The returned table scheme can be found in the documentation  ]]
function search(info, infoPlace)
    local result = {}
    for i = 1, storageManager.getLastStorageId(), 1 do
        result[i] = searchInto(i, info, infoPlace)
    end
    return result
end

--[[ Return a table of the item requested present in the storage files.
TODO The returned table scheme can be found in the documentation ]]
function storageManager.search(displayName, name)
    -- We've got a display name
    if (displayName) then
        return search(string.lower(displayName), 1)
    -- We've got a name
    else
        return search(string.lower(name), 2)
    end
end

--[[ Return the quantity of item from a search result ]]
function storageManager.getQuantity(results)
    local sum = 0
    for storageId, storageItems in ipairs(results) do
        for index, item in ipairs(storageItems) do
            sum = sum + item[set.MINECRAFT_COUNT]
        end
    end
    return sum
end



return storageManager