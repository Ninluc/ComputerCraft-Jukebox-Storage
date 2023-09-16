local set = require("settings")
local fm  = require("tools.fileManager")

local loggingTool = {}



function loggingTool.init()
    if not fm.exists(set.logFile) then
        if not fm.createFile(set.logFile) then
            printError("Couldn't open log file")
        end
    else
        fm.write(set.logFile, "")
    end
end

function loggingTool.log(msg)
    if fm.append(set.logFile, msg .. "\n") then
        return true
    else
        printError("Couldn't open log file")
    end
end

function loggingTool.error(error)
    if fm.append(set.logFile,"ERROR : " .. error .. "\n") then
        return true
    else
        printError("Couldn't open log file")
    end
end



return loggingTool