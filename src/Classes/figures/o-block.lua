OShape = {}
OShape.__index = OShape
setmetatable(OShape, {__index = Figure})
OShape.color = "replaceabletextures\\commandbuttons\\btntemp"
OShape.s1 = {x = 5, y = 20}
OShape.s2 = {x = 6, y = 20}
OShape.s3 = {x = 5, y = 19}
OShape.s4 = {x = 6, y = 19}
table.insert(Figure.shapes, OShape)

function OShape:new()
    local oShape = Figure:new()
    setmetatable(oShape, OShape)
    oShape.segments = {
        {x = OShape.s1.x, y = OShape.s1.y},
        {x = OShape.s2.x, y = OShape.s2.y},
        {x = OShape.s3.x, y = OShape.s3.y},
        {x = OShape.s4.x, y = OShape.s4.y}
    }
    oShape.type = "matrix4"
    return oShape
end

function OShape:rotate(direction)
    --Type: non-rotatable
    return
end
