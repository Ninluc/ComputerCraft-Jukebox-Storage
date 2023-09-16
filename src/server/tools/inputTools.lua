local set   = require("settings")
local lstT  = require("tools.listTools")
local strT    = require("tools.stringTools")
local storM   = require("tools.storageDBManager")

local inputTools = {}

--[[ Return a list of items that appears in the search result given ]]
function inputTools.regroupByItemInfo(results, searchIndex)
    local regroup = {}
    local regroupIndex = 1

    for _, storageResult in ipairs(results) do
        if (#storageResult > 0) then
            for _, result in ipairs(storageResult) do
                if not lstT.contains(regroup, result[searchIndex]) then
                    regroup[regroupIndex] = result[searchIndex]
                    regroupIndex = regroupIndex + 1
                end
            end
        end
    end

    return regroup
end

--[[ Prints all of the similar result from a search result ]]
function inputTools.displaySearchResult(results, searchIndex)
    if (not results or results[1] == nil) then
        return nil
    end

    local LIST_CHARACTER = " - "

    results = inputTools.regroupByItemInfo(results, searchIndex)
    print("#" .. tostring(#results) .. " résultats trouvés :")
    for _, value in ipairs(results) do
        print(LIST_CHARACTER .. value)
    end
end

--[[ Verify that the search result given isn't empty, return `nil` if empty, the result otherwise ]]
function verifyResultsOrPrintNoResults(results)
    for _, value in ipairs(results) do
        if (type(value[1]) == 'table') then
            return results
        end
    end

    print("Pas de résultats trouvés")
    return nil
end

--[[ Return `true` if the given search result is one, it may be empty tho ]]
function inputTools.verifyIsSearchResults(results)
    for _, value in ipairs(results) do
        if (type(value[1]) == 'table') then
            return true
        end
    end

    return false
end

--[[ Display a search result from a user input. ]]
function inputTools.displaySearchFromInput(input)
    if (strT.isMinecraftItemName(input)) then
        local results = verifyResultsOrPrintNoResults(storM.search(nil, input))
        inputTools.displaySearchResult(results, 2)
    else
        local results = verifyResultsOrPrintNoResults(storM.search(input, nil))
        inputTools.displaySearchResult(results, 1)
    end
end

--[[ Return a result from a user input. If there is no result, return `nil` ]]
function inputTools.searchFromInput(input)
    if (strT.isMinecraftItemName(input)) then
        return verifyResultsOrPrintNoResults(storM.search(nil, input))
    else
        return verifyResultsOrPrintNoResults(storM.search(input, nil))
    end
end

--[[ Return the index of the item info wich the input reference (minecraft name or display name ?) ]]
function inputTools.getItemInfoIndex(input)
    if (strT.isMinecraftItemName(input)) then
        return 2
    else
        return 1
    end
end

--[[ Return the item chosen by the user ]]
function inputTools.getUserChosenInput(firstInput)
    local results = inputTools.searchFromInput(firstInput)
    if results then
        local itemInfoIndex = inputTools.getItemInfoIndex(firstInput)
        if #inputTools.regroupByItemInfo(results, itemInfoIndex) > 1 then
            inputTools.displaySearchResult(results, itemInfoIndex)
            print("Veuillez être plus précis dans votre recherche")
            return nil
        else
            return results
        end
    end
end

return inputTools