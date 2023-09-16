local storM = require("tools.storageDBManager")
storM.init()

local addItem = {}

function addItem.run(--[[required]]param)
    local DISPLAY_NAME = 1
    local NAME         = 2
    local ID_STORAGE   = 3
    local SLOT         = 4
    local COUNT        = 5
    local MAX_COUNT    = 6

    storM.addItem(param[DISPLAY_NAME], param[NAME], param[ID_STORAGE], param[SLOT], param[COUNT], param[MAX_COUNT])
end

return addItem