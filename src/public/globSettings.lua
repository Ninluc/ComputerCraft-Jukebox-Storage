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
settings.actionsFolder = settings.wd + "actions/"
-- Turtle position file location
settings.positionFileName = "turtlePos"
-- Turtle facing file
settings.facingFileName = "facing"



---- SERVER ---- 
-- The file where the connected clients Id's are stored
settings.connectedClientsIdFileName = "connectedIds"

-- The folder where the turtles files are stored
settings.turtlesManagerFolder = "turtles/"

return settings