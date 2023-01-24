local turt  = require("turtle")
local listT = require("tools.listTools")
local posM  = require("tools.positionManager")
local facM  = require("tools.facingManager")
local actM  = require("tools.actionsManager")
local stoP  = require("tools.storagePeriph")
local comT  = require("tools.communication")
local set   = require("settings")

local map = {}

function map.run(--[[required]]param)
    map.map(tonumber(param[1]))
    -- turt.go({0, 0, 0})
    os.sleep(5)
end

---------------------

function map.map(idServer)
    -- Get at the correct level
    turt.go({nil, set.storageStartYLevel, nil}, false)

    -- left side
    turt.face({3, -1})
    map.getToWall()
    map.mapWall(1, idServer)
    turt.face({3, 1})
    map.getToWall()
    map.mapWall(-1, idServer)
    turt.go({0, 0, 0}, false)
end

--[[ Scan a wall from the bottom and get back in the original position.
The turtle qhould be facing the wall to scan
@param side The side to go to, left = -1, right = 1
]]
function map.mapWall(side, idServer)
    -- We move laterally
    local latI = 0
    while map.inspect() do
        map.mapColumn(idServer)

        turt.rotate(side)
        turt.moveForward()
        latI = latI + 1
        turt.rotate(-side)
    end

    -- We get back where we started
    turt.rotate(-side)
    for _ = 1, latI, 1 do
        turt.moveForward()
    end
end

--[[ Scan a column from the bottom the get back down ]]
function map.mapColumn(idServer)
    -- We move up
    local upI = 0
    while map.inspect() do
        map.sendContainer(idServer)
        turt.moveUp()
        upI = upI + 1
    end

    -- We get back down
    for _ = 1, upI, 1 do
        turt.moveDown()
    end
end

function map.getToWall()
    while turt.moveForward() and not map.inspect() do
    end
end

function map.sendContainer(idServer)
    local container = stoP.connectStorage()
    --                                      Position                                      Facing                                    Storage size           Container slots nb
    local text = actM.format("addStorage", {posM.getPosition()[1], posM.getPosition()[2], posM.getPosition()[3], facM.getFacing()[1], facM.getFacing()[2], stoP.getStorageSize(), container.size()})
    local id, msg = comT.sendAndWait(idServer, text, comT.getProtocolName(idServer), 50)
    return msg == set.receiveConfirmationMsg
end

--- Locating containers ---
function map.inspect()
    local has_block, data = turtle.inspect()
    if (has_block) then
        return map.isContainer(data)
    else
        return false
    end
end

function map.isContainer(blockData)
    return listT.testRegexes(set.containersNames, blockData.name)
end

return map