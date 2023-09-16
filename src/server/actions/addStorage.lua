local storM = require("tools.storageDBManager")
storM.init()

local addStorage = {}

function addStorage.run(--[[required]]param)
    -- We give the storage id created so it can send itemInfo
    return storM.addStorage(param)
end

return addStorage