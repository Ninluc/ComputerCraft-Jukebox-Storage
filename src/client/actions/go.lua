local turt = require("turtle")

local go = {}

function go.run(--[[required]]param)
    if param[4] then
        turt.go({param[1], param[2], param[3]}, param[4])
    else
        turt.go({param[1], param[2], param[3]})
    end
end

return go