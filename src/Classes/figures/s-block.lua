SShape = {}
SShape.__index = SShape
setmetatable(SShape, {__index = Figure})
SShape.color = "replaceabletextures\\commandbuttons\\btngem"
SShape.s1 = {x = 4, y = 19}
SShape.s2 = {x = 5, y = 19} --center
SShape.s3 = {x = 5, y = 20}
SShape.s4 = {x = 6, y = 20}
table.insert(Figure.shapes, SShape)
--Type: matrix3

function SShape:new()
    local sShape = Figure:new()
    setmetatable(sShape, SShape)
    sShape.segments = {
        {x = SShape.s2.x, y = SShape.s2.y},
        {x = SShape.s1.x, y = SShape.s1.y},
        {x = SShape.s3.x, y = SShape.s3.y},
        {x = SShape.s4.x, y = SShape.s4.y}
    }
    sShape.type = "matrix3"
    return sShape
end

function SShape:rotate(direction)
    local newSegments = Matrix3.rotate(self.segments, direction)

    Figure.rotate(self, newSegments, direction)
end