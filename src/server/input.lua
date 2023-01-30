local uInputs = require('tools.uInput')
local strT    = require("tools.stringTools")
local listT   = require("tools.listTools")
local set     = require("settings")
local storM   = require("tools.storageDBManager")

-- FUNCTIONS

--[[ Execute or return a command based on user input ]]
function executeCommand(input)
    local args = strT.splitByChar(input, set.actionsParametersSeparator)
    local command = table.remove(args, 1)
    
    -- map command
    -- Will add others that don't require args
    if listT.contains({"map", "remap"}, command) and #args == 0 then
        if command == "remap" then
            fs.delete(set.storageManagerFolder)
            storM.init()
            command = "map"
        end
        print("Mappage en cours...")
        return command, os.getComputerID()
    end
end

-- MAIN
while true do
    local userCommand = {executeCommand(uInputs.ask("Commande"))}
    if userCommand then
        os.queueEvent("input", table.remove(userCommand, 1), userCommand)
    end
end