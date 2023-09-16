local uInputs = require('tools.uInput')
local strT    = require("tools.stringTools")
local listT   = require("tools.listTools")
local inputT  = require("tools.inputTools")
local storM   = require("tools.storageDBManager")
local set     = require("settings")

-- FUNCTIONS

--[[ Execute or return a command based on user input ]]
function executeCommand(input)
    local args = strT.splitByChar(input, set.actionsParametersSeparator)
    local command = table.remove(args, 1)
    local argsStr = strT.joinByChar(args, set.actionsParametersSeparator)
    
    -- map command
    -- Will add others that don't require args
    if listT.contains({"map", "remap"}, command) and #args == 0 then
        if command == "remap" then
            fs.delete(set.storageManagerFolder)
            storM.init()
            command = "map"
        end
        print("\nMappage en cours...")
        return command, os.getComputerID()
    -- Search commands
    elseif listT.contains({"search"}, command) and args[1] then
        print("\nRecherche \"" .. argsStr .. "\"...")
        if (argsStr) then
            inputT.displaySearchFromInput(argsStr)
        end
    elseif listT.contains({"get"}, command) and args[1] then
        print("\nRecherche \"" .. argsStr .. "\"...")
        local results = inputT.getUserChosenInput(argsStr)
        if results then -- We ask the quantity requested
            print("\"" .. argsStr .. "\" trouvé :")
            local availibleQuantity = storM.getQuantity(results)
            print("Quantité disponible : " .. availibleQuantity)
            local requestedQuantity = tonumber(uInputs.ask("Quelle quantité souhaitez-vous"))

            if requestedQuantity > availibleQuantity then -- vérification
                print("Vous ne possédez pas cette quantité !")
                return nil
            end

            return command, results, requestedQuantity
        end
    end
end

-- MAIN
while true do
    local userCommand = {executeCommand(uInputs.ask("Commande"))}
    print() -- Carriage return
    if userCommand and #userCommand > 0 then
        os.queueEvent("input", table.remove(userCommand, 1), userCommand)
    end
end