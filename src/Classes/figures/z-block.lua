ZShape = {}
ZShape.__index = ZShape
setmetatable(ZShape, {__index = Figure})
ZShape.color = "red"
ZShape.s1 = {x = 4, y = 20}
ZShape.s2 = {x = 5, y = 20}
ZShape.s3 = {x = 5, y = 19} --center
ZShape.s4 = {x = 6, y = 19}
ZShape.type = "matrix3"
table.insert(Figure.shapes, ZShape)

function ZShape:new()
    local zShape = Figure:new()
    setmetatable(zShape, ZShape)
    zShape.segments = {
        {x = ZShape.s3.x, y = ZShape.s3.y},
        {x = ZShape.s2.x, y = ZShape.s2.y},
        {x = ZShape.s1.x, y = ZShape.s1.y},
        {x = ZShape.s4.x, y = ZShape.s4.y}
    }
    return zShape
end

function ZShape:rotate(direction)
    --Type: matrix3
    local newSegments = Matrix3.rotate(self.segments, direction)

    Figure.rotate(self, newSegments)
end