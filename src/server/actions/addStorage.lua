local storM = require("tools.storageDBManager")
storM.init()

local addStorage = {}

function addStorage.run(--[[required]]param)
    storM.addStorage(param)
end

return addStorage