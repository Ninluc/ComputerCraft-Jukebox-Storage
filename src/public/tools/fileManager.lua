local set = require("globSettings")

local fileManager = {}



function fileManager.exists(fileName)
    return fs.exists(set.wd .. fileName)
end

function fileManager.createFile(fileName)
    local file, error = fs.open(set.wd .. fileName, "w")
    file.close()
    if error then
        printError(error)
    end
    return not error
end

function fileManager.createFolder(folderName)
    fs.makeDir(folderName)
    -- if success then
    --     return success
    -- end
    -- printError('Couldn\'t create folder "' .. folderName .. '"')
end

function fileManager.createIfNoFile(fileName)
    if not fileManager.exists(fileName) then
        fileManager.createFile(fileName)
        return false
    end
    return true
end

function fileManager.append(fileName, text)
    fileManager.createIfNoFile(fileName)
    local file, error = fs.open(set.wd .. fileName, "a")
    if error then
        printError(error)
    end
    file.write(text)
    file.close()
    return not error
end

function fileManager.write(fileName, text)
    fileManager.createIfNoFile(fileName)
    local file, error = fs.open(set.wd .. fileName, "w")
    if error then
        printError(error)
    end
    file.write(text)
    file.close()
    return not error
end

function fileManager.containsLine(fileName, line)
    local file, error = fs.open(set.wd .. fileName, "r")
    if error then
        printError(error)
    end

    while true do
        local fileLine = file.readLine()
      
        -- If line is nil then we've reached the end of the file and should stop
        if not fileLine then break end
        
        if fileLine == line then
            file.close()
            return true
        end
    end

    file.close()
    return false
end

function fileManager.getLastLine(fileName)
    local file, error = fs.open(set.wd .. fileName, "r")
    if error then
        printError(error)
    end

    local lastLine = ""

    while true do
        local fileLine = file.readLine()
      
        -- If line is nil then we've reached the end of the file and should stop
        if not fileLine then break end

        lastLine = fileLine
    end

    file.close()

    return lastLine
end

function fileManager.readLines(fileName)
    local file, error = fs.open(set.wd .. fileName, "r")
    if error then
        printError(error)
    end

    local lines = {}
    local lineNb = 1

    while true do
        local fileLine = file.readLine()
      
        -- If line is nil then we've reached the end of the file and should stop
        if not fileLine then break end

        lines[lineNb] = fileLine

        lineNb = lineNb + 1
    end

    file.close()

    return lines
end


return fileManager