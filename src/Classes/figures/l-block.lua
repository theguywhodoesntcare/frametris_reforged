LShape = {}
LShape.__index = LShape
setmetatable(LShape, {__index = Figure})
LShape.color = "replaceabletextures\\commandbuttons\\btnamulet"
LShape.s1 = {x = 4, y = 19}
LShape.s2 = {x = 5, y = 19} --center
LShape.s3 = {x = 6, y = 19}
LShape.s4 = {x = 6, y = 20}
table.insert(Figure.shapes, LShape)

function LShape:new()
    local lShape = Figure:new()
    setmetatable(lShape, LShape)
    lShape.segments = {
        {x = LShape.s2.x, y = LShape.s2.y},
        {x = LShape.s1.x, y = LShape.s1.y},
        {x = LShape.s3.x, y = LShape.s3.y},
        {x = LShape.s4.x, y = LShape.s4.y}
    }
    lShape.type = "matrix3"
    return lShape
end

function LShape:rotate(direction)
    --Type: matrix3
    local newSegments = Matrix3.rotate(self.segments, direction)

    Figure.rotate(self, newSegments, direction)
end
