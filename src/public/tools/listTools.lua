local listTools = {}

function listTools.contains(list, toSearch)
    for i, item in pairs(list) do
        if item == toSearch then
            return true
        end
    end

    return false
end

return listTools