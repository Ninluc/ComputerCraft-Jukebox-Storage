local turt = require("turtle")

local face = {}

function face.run(--[[required]]param)
    if not param then
        return nil
    end

    turt.face({param[1], param[2]})
end

return face