local uInput = {}

--[[ Demande à l'utilisateur à l'aide d'un message et renvoye ce que l'usilisateur réponds --]]
function uInput.ask(--[[required]]message, char)
    write(message .. ' ? ')
    return read(char)
end

return uInput