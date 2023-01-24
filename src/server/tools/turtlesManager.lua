local set = require("settings")
local fm  = require("tools.fileManager")

local turtlesManager = {}


function turtlesManager.init()
    if not fm.exists(set.turtlesManagerFolder) then
        fm.createFolder(set.turtlesManagerFolder)
    end
end

function turtlesManager.addAction(turtleId, action)
    fm.createIfNoFile(set.turtlesManagerFolder .. turtleId)

    fm.append(set.turtlesManagerFolder .. turtleId, action .. "\n")
end

function turtlesManager.getLastAction(turtleId)
    fm.createIfNoFile(set.turtlesManagerFolder .. turtleId)

    return fm.getLastLine(set.turtlesManagerFolder .. turtleId)
end


return turtlesManager