TShape = {}
TShape.__index = TShape
setmetatable(TShape, {__index = Figure})
TShape.color = "replaceabletextures\\commandbuttons\\btnbandit"
TShape.s1 = {x = 4, y = 19}
TShape.s2 = {x = 5, y = 19} --center
TShape.s3 = {x = 6, y = 19}
TShape.s4 = {x = 5, y = 20}
table.insert(Figure.shapes, TShape)
--Type: matrix3

function TShape:new()
    local tShape = Figure:new()
    setmetatable(tShape, TShape)
    tShape.segments = {
        {x = TShape.s2.x, y = TShape.s2.y},
        {x = TShape.s1.x, y = TShape.s1.y},
        {x = TShape.s3.x, y = TShape.s3.y},
        {x = TShape.s4.x, y = TShape.s4.y}
    }
    tShape.type = "matrix3"
    return tShape
end

function TShape:rotate(direction)
    local newSegments = Matrix3.rotate(self.segments, direction)

    Figure.rotate(self, newSegments, direction)
end