IShape = {}
IShape.__index = IShape
setmetatable(IShape, {__index = Figure})
IShape.color = "turquoise"
IShape.s1 = {x = 4, y = 19}
IShape.s2 = {x = 5, y = 19}
IShape.s3 = {x = 6, y = 19}
IShape.s4 = {x = 7, y = 19}
IShape.type = "matrix4"
table.insert(Figure.shapes, IShape)

function IShape:new()
    local iShape = Figure:new()
    setmetatable(iShape, IShape)
    iShape.segments = {
        {x = IShape.s1.x, y = IShape.s1.y},
        {x = IShape.s2.x, y = IShape.s2.y},
        {x = IShape.s3.x, y = IShape.s3.y},
        {x = IShape.s4.x, y = IShape.s4.y}
    }
    return iShape
end

function IShape:rotate(direction)
    --Type: line4
    local newSegments = Line4.rotate(self.segments, direction)

    Figure.rotate(self, newSegments)
end

