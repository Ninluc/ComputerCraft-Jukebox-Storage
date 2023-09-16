local turt  = require("turtle")
local listT = require("tools.listTools")
local posM  = require("tools.positionManager")
local facM  = require("tools.facingManager")
local actM  = require("tools.actionsManager")
local stoP  = require("tools.storagePeriph")
local comT  = require("tools.communication")
local set   = require("settings")

local item = {}

function item.run(--[[required]]param)
    local ID_SERVER = 1
    local STORAGE = 2
    local ID_STORAGE = 3

    item.sendItems(param[ID_SERVER], param[STORAGE], param[ID_STORAGE])
end

--[[ Get info about an item. The information are in the same
order as they will be in the database ]]
function item.getItemInfo(itemDetails, idStorage, slot)
    return {itemDetails.displayName, itemDetails.name, idStorage, slot, itemDetails.count, itemDetails.maxCount}
end

function item.sendItems(idServer, storage, idStorage)
    for slot = 1, storage.size(), 1 do
        local itemDetails = storage.getItemDetail(slot)
        if (itemDetails) then
            item.sendItem(idServer, item.getItemInfo(itemDetails, idStorage, slot))
        end
    end
end

--[[ Send inforamtion to the server about an item 
presummably present in a storage ]]
function item.sendItem(idServer, itemInfo)
    --                                   displayName  name         idStorage    slot         count        maxCount
    local text = actM.format("addItem", {itemInfo[1], itemInfo[2], itemInfo[3], itemInfo[4], itemInfo[5], itemInfo[6]})
    local id, msg = comT.sendAndWait(idServer, text, comT.getProtocolName(idServer), 50)
    return msg == set.receiveConfirmationMsg
end

return item