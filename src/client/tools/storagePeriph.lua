local set = require("settings")

local storage = {}

function storage.connectStorage()
    return peripheral.wrap("front")
end

function storage.getStorageSize()
    local container = storage.connectStorage()
    if (container == nil) then
        return nil
    end
    
    local sum = 0
    for i = 1, container.size(), 1 do
        sum = sum + container.getItemLimit(i)
    end
    return sum
end

return storage