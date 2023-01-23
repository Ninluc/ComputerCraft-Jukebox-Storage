local log   = require("tools.logging")
log.init()
local posM  = require("tools.positionManager")
posM.init()
local facM = require("tools.facingManager")
facM.init()
local clt   = require("client")
local comT  = require("tools.communication")
comT.connectModem()
local protM = require("tools.protocolManager")
local set   = require("globSettings")
local fm    = require("tools.fileManager")
local act   = require("tools.actionsManager")
local actions = act.getActions()
local strT  = require("tools.stringTools")

-- Create a connection
local servId, msg
while not msg do
    servId, msg = clt.createConnection()
end
print("Succesfully connected")
