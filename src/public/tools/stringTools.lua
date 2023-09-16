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

function stringTools.joinByChar(list, char)
    local str = ""
    for i = 1, #list, 1 do
        if (i > 1) then
            str = str .. char
        end
        str = str .. list[i]
    end

    return str
end

--[[ Look for a match of `txt` in `str` ]]
function stringTools.contains(str, txt)
    return string.match(str, txt)
end

-- MISC
function stringTools.isMinecraftItemName(str)
    return string.match(str, "^[^ ]+:[^ ]+$")
end

return stringTools