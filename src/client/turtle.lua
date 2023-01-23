local fm   = require("tools.fileManager")
local set  = require("globSettings")
local log  = require("tools.logging")
local posM = require("tools.positionManager")
local facM = require("tools.facingManager")
local clt  = require("client")
local lstT = require("tools.listTools")

local turtleMovement = {}



---- BASIC MOVEMENTS ----
function turtleMovement.moveDown()
    local result, err = turtle.down()
    if not result then
        log.error('Could not go down : "' .. err .. '"')
        return result
    end

    posM.move({0, -1, 0})
    
    return result
end

function turtleMovement.moveUp()
    local result, err = turtle.up()
    if not result then
        log.error('Could not go up : "' .. err .. '"')
        return result
    end

    posM.move({0, 1, 0})
    
    return result
end

function turtleMovement.moveForward()
    local result, err = turtle.forward()
    if not result then
        log.error('Could not go forward : "' .. err .. '"')
        return result
    end


    local facing = facM.getFacing()
    local pos = {}
    if facing[1] == 1 then
        pos = {facing[2], 0, 0}
    else
        pos = {0, 0, facing[2]}
    end
    posM.move(pos)
    
    return result
end

function turtleMovement.moveBackward()
    local result, err = turtle.back()
    if not result then
        log.error('Could not go backward : "' .. err .. '"')
        return result
    end


    local facing = facM.getFacing()
    local pos = {}
    if facing[1] == 1 then
        pos = {facM.invert(facing[2]), 0, 0}
    else
        pos = {0, 0, facM.invert(facing[2])}
    end
    posM.move(pos)
    
    return result
end



---- DIGGING ----
function turtleMovement.mineSurroundings()
    local actions = {{turtle.inspect, turtle.inspectUp, turtle.inspectDown}, {{turtle.dig, turtleMovement.moveForward, turtleMovement.moveBackward}, {turtle.digUp, turtleMovement.moveUp, turtleMovement.moveDown}, {turtle.digDown, turtleMovement.moveDown, turtleMovement.moveUp}}, {turtleMovement.rotate}}
    local whiteList = set.wantedRessource

    for i=4, 1, -1 do
        if i == 4 then
            for actI, action in pairs(actions[1]) do
                local result, block = action()
                if result then
                    if lstT.contains(whiteList, block.name) then
                        actions[2][actI][1]()
                        actions[2][actI][2]()
                        turtleMovement.mineSurroundings()
                        actions[2][actI][3]()
                    end 
                end
            end
        else
            local result, block = turtle.inspect()
            if result then
                if lstT.contains(whiteList, block.name) then
                    turtleMovement.digForwardAndGo()
                    turtleMovement.mineSurroundings()
                    turtleMovement.moveBackward()
                end 
            end
        end

        actions[3][1](-1)
    end
end

function turtleMovement.digForward()
    if turtle.detect() then
        if not turtle.dig() then
            clt.sendError("Couldn't break the block in front")
            return false
        end
    end
    return true
end

function turtleMovement.digForwardAndGo()
    if not turtleMovement.digForward() then
        return false
    end
    turtleMovement.moveForward()
end

function turtleMovement.digUp()
    if turtle.detectUp() then
        if not turtle.digUp() then
            clt.sendError("Couldn't break the block above")
            return false
        end
    end
    return true
end

function turtleMovement.digUpAndGo()
    if not turtleMovement.digUp() then
        return false
    end
    turtleMovement.moveUp()
end

function turtleMovement.digDown()
    if turtle.detectDown() then
        if not turtle.digDown() then
            clt.sendError("Couldn't break the block above")
            return false
        end
    end
    return true
end

function turtleMovement.digDownAndGo()
    if not turtleMovement.digDown() then
        return false
    end
    turtleMovement.moveDown()
end



---- ROTATION MOVEMENTS ----
function turtleMovement.rotate(direction)
    facM.rotateFacing(direction)
    if direction > 0 then
        assert(turtle.turnRight())
    else
        assert(turtle.turnLeft())
    end
end

function turtleMovement.face(target)
    local facing = facM.getFacing()

    -- If they are the same
---@diagnostic disable-next-line: need-check-nil
    if facing[1] == target[1] and facing[2] == target[2] then
        return nil
    end

    if facing[1] == target[1] then
        turtleMovement.rotate(-1)
        turtleMovement.rotate(-1)

    elseif facing[1] == 1 then
        if facing[2] == target[2] then
            turtleMovement.rotate(1)
        else
            turtleMovement.rotate(-1)
        end
    elseif facing[1] == 3 then
        if facing[2] == target[2] then
            turtleMovement.rotate(-1)
        else
            turtleMovement.rotate(1)
        end
    end
end



---- ADVANCED MOVEMENTS ----
function turtleMovement.go(target, --[[optional]]mine)
    local pos = posM.getPosition()

    -- Check parameters and change to numbers
    for i, coord in pairs(target) do
        if coord then
            local intCoord = tonumber(coord)
            if intCoord then
                target[i] = intCoord
            else
                return nil
            end
        else
            target[i] = pos[i]
        end
    end

    local coordOrder = {3, 1, 2}

    for _, coord in pairs(coordOrder) do
        if coord == 2 then
            for i=math.abs(pos[coord] - target[coord]), 1, -1 do
                if pos[coord] < target[coord] then
                    turtleMovement.digUpAndGo()
                else
                    turtleMovement.digDownAndGo()
                end
                if (mine) then
                    turtleMovement.mineSurroundings()
                end
            end
            
        else
            if pos[coord] - target[coord] < 0 then
                turtleMovement.face({coord, 1})
            else
                turtleMovement.face({coord, -1})
            end
            for i=math.abs(pos[coord] - target[coord]), 1, -1 do
                turtleMovement.digForwardAndGo()
                if (mine) then
                    turtleMovement.mineSurroundings()
                end
            end
        end
    end
end



return turtleMovement