local comT  = require("tools.communication")
local protM = require("tools.protocolManager")
local set   = require("globSettings")

local server = {}

function server.connect(id)
    comT.send(id, set.receiveConfirmationMsg, comT.getProtocolName(id))

    --[[ Check if protocol already exists or not
    if not it append it to the file with it's id ]]
    if not protM.exists(tostring(id)) then
        protM.add(tostring(id))
    end
end

return server