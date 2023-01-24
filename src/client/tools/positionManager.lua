local log   = require("tools.logging")
local fm = require("tools.fileManager")
local set = require("settings")

local positionManager = {}



function positionManager.init()
    fm.createIfNoFile(set.memoryFilesFolder .. set.positionFileName)
end

function positionManager.getPosition()
    local positions = fm.readLines(set.memoryFilesFolder .. set.positionFileName)
    local positionsInt = {}
    local linesNb = 0
    for lineNb, content in pairs(positions) do
        positionsInt[lineNb] = tonumber(content)
        linesNb = linesNb + 1
    end

    -- If not enough lines
    if linesNb < 3 then
        return {0, 0, 0}
    end

    return positionsInt
end

function positionManager.writePosition(position)
    local text = ""
    for _, position in pairs(position) do
        text = text .. tostring(position) .. "\n"
    end

    return fm.write(set.memoryFilesFolder .. set.positionFileName, text)
end

function positionManager.move(--[[required]]direction)
    -- We get the new position --
    local actPos = positionManager.getPosition()
    local newPos = {}

    -- Get the lenght of the position list
    local tableLenght = 0
    for _ in pairs(direction) do
        tableLenght = tableLenght + 1
        
        newPos[tableLenght] = actPos[tableLenght] + direction[tableLenght]
    end

    -- If the list is too short
    if tableLenght < 3 then
        printError("positionManager.move : Their must be 3 axis !")
        return false
    end

    -- logging
    local logPos = ""
    for posPos, pos in pairs(newPos) do
        logPos = logPos .. tostring(pos)
        if not (posPos == 3) then
            logPos = logPos .. ", "
        end
    end
    log.log('Moved to (' .. logPos .. ')')

    -- We update the position with the new one --
    return positionManager.writePosition(newPos)
end



return positionManager