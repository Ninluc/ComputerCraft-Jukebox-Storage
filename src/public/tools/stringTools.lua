local stringTools = {}

function stringTools.splitByChar(str, char)
    if char == nil then
        char = "%s"
    end
    local t={}
    for split in string.gmatch(str, "([^"..char.."]+)") do
        table.insert(t, split)
    end
    return t
end

return stringTools