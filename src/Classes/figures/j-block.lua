JShape = {}
JShape.__index = JShape
setmetatable(JShape, {__index = Figure})
JShape.color = "blue"
JShape.s1 = {x = 4, y = 20}
JShape.s2 = {x = 4, y = 19}
JShape.s3 = {x = 5, y = 19} --center
JShape.s4 = {x = 6, y = 19}
JShape.type = "matrix3"
table.insert(Figure.shapes, JShape)

function JShape:new()
    local jShape = Figure:new()
    setmetatable(jShape, JShape)
    jShape.segments = {
        {x = JShape.s3.x, y = JShape.s3.y},
        {x = JShape.s2.x, y = JShape.s2.y},
        {x = JShape.s1.x, y = JShape.s1.y},
        {x = JShape.s4.x, y = JShape.s4.y}
    }
    return jShape
end

function JShape:rotate(direction)
    --Type: matrix3
    local newSegments = Matrix3.rotate(self.segments, direction)

    Figure.rotate(self, newSegments)
end

