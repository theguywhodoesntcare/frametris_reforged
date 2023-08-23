Matrix3 =  {}

function Matrix3.rotate(segmentsWorld, direction)
    local centerX, centerY = segmentsWorld[1].x, segmentsWorld[1].y
    local newMatrix = {
        {x = centerX, y = centerY},
        {x = 0, y = 0},
        {x = 0, y = 0},
        {x = 0, y = 0}
    }

    for i = 2, #segmentsWorld do
        local localX, localY = segmentsWorld[i].x - centerX, segmentsWorld[i].y - centerY
        if direction == "clockwise" then
            localX, localY = localY, -localX
        elseif direction == "counter" then
            localX, localY = -localY, localX
        end
        newMatrix[i].x, newMatrix[i].y = localX + centerX, localY + centerY
    end
    return newMatrix
end
