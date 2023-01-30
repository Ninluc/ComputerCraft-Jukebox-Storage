local settings = {
}

-- File manager
settings.wd = shell.dir()

-- Log file
settings.logFile = "logs"

-- Received confirmation message
settings.receiveConfirmationMsg = "RECEIVED"

-- First connection protocol name
settings.connectionCreateProtocol = "STORAGE-OP_CONNECT"

-- Default protocol name
--[[ 
    Some characters can be added by individuals
    ex : 
        The client will transmit with his
        own protocol name,
        ex : "MINING-OP_3" where 3 is the
        turtle ID
 ]]
settings.protocolName = "STORAGE-OP"

-- Memory files locations relative to the workingDirectory
settings.memoryFilesFolder = settings.wd .. "memory/"

-- Actions Parameters --
-- actions separator for the action and it's parameters
settings.actionsFieldSeparator = "|"
-- actions separator the diferent parameters
settings.actionsParametersSeparator = " "



---- CLIENT ----
-- Client actions folder location
settings.actionsFolder = settings.wd .. "actions/"
-- Turtle position file location
settings.positionFileName = "turtlePos"
-- Turtle facing file
settings.facingFileName = "facing"

--- Containers
-- Containers list, use regex
settings.containersNames = {
    "minecraft:chest",
    "minecraft:barrel",
    "minecraft:.*shulker_box"
}
-- The Y level where the storage column begin
settings.storageStartYLevel = 0




---- SERVER ---- 
-- The file where the connected clients Id's are stored
settings.connectedClientsIdFileName = "connectedIds"

-- The folder where the turtles files are stored
settings.turtlesManagerFolder = settings.wd .. "turtles/"

-- The input program file location
settings.inputProgramPath = settings.wd .. "input.lua"

--- Storages
-- The folder containing files about the storages
settings.storageManagerFolder = settings.wd .. "storages/"
-- The file name for informations about the storages
settings.storageManagerInfoFileName = settings.storageManagerFolder .. "storage_info"
-- Filename for storage file (has the id at the end)
settings.storageManagerStorageFileName = settings.storageManagerFolder .. "storage-"




return settings