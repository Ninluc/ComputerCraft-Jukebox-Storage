local set  = require("settings")
local fm = require("tools.fileManager")


local facingManager = {}

function facingManager.init()
    if not fm.createIfNoFile(set.memoryFilesFolder .. set.facingFileName) then
        facingManager.setFacing("N")
    end
end

function facingManager.setFacing(facing)
    local fileName = set.memoryFilesFolder .. set.facingFileName



    if type(facing) == "table" then
        local pos = {{"N"}, _, {"E"}}
        pos[1][-1] = "S"
        pos[3][-1] = "W"
        return fm.write(fileName, pos[facing[1]][facing[2]])

    elseif facing and tonumber(facing) then
        local pos = {"N", "E", "S", "W"}
        return fm.write(fileName, pos[facing])

    else
        return fm.write(fileName, facing)
    end


    
end

function facingManager.getFacing()
    local facing = fm.getLastLine(set.memoryFilesFolder .. set.facingFileName)
    if facing then
        if facing == "N" then
            return {1, 1}
        elseif facing == "E" then
            return {3, 1}
        elseif facing == "S" then
            return {1, -1}
        elseif facing == "W" then
            return {3, -1}
        end
        return facing
    end

    return false
end

function facingManager.rotateFacing(direction)
    local facing = facingManager.getFacing()
    local pos = {{1, 1}, {3, 1}, {1, -1}, {3, -1}}
    local newFacing = {}

    if facing[1] == 3 and direction == 1 then
        newFacing = {1, facingManager.invert(facing[2])}
    elseif facing[1] == 1 and direction == -1 then
        newFacing = {3, facingManager.invert(facing[2])}
    else
        local invertedAxis = {3, _, 1}
        newFacing = {invertedAxis[facing[1]], facing[2]}
    end

    return facingManager.setFacing(newFacing)
end



function facingManager.invert(nb)
    if nb < 0 then
        return math.abs(nb)
    else
        return 0 - nb
    end
end

return facingManager