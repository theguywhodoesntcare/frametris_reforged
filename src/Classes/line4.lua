Line4 = {}

function Line4.rotate(segmentsWorld, direction)
    local centerX, centerY = Line4.getCenter(segmentsWorld)
    local newMatrix = {
        {x = 0, y = 0},
        {x = 0, y = 0},
        {x = 0, y = 0},
        {x = 0, y = 0}
    }

    for i = 1, #segmentsWorld do
        local localX, localY = segmentsWorld[i].x - centerX, segmentsWorld[i].y - centerY
        if direction == "clockwise" then
            localX, localY = localY, -localX
        elseif direction == "counter" then
            localX, localY = -localY, localX
        end
        newMatrix[i].x, newMatrix[i].y = Line4.custom_round(localX + centerX, centerX), Line4.custom_round(localY + centerY, centerY)
    end
    return newMatrix
end

function Line4.custom_round(x, arg)
    if x > arg then
        return math.ceil(x)
    else
        return math.floor(x)
    end
end

function Line4.getCenter(segmentsWorld)
    local centerX, centerY = 0, 0
    if segmentsWorld[1].x < segmentsWorld[2].x then
        centerX = segmentsWorld[2].x + 0.5
        centerY = segmentsWorld[2].y - 0.5
    elseif segmentsWorld[1].x > segmentsWorld[2].x then
        centerX = segmentsWorld[2].x - 0.5
        centerY = segmentsWorld[2].y + 0.5
    else
        if segmentsWorld[1].y > segmentsWorld[2].y then
            centerX = segmentsWorld[2].x - 0.5
            centerY = segmentsWorld[2].y - 0.5
        else
            centerX = segmentsWorld[2].x + 0.5
            centerY = segmentsWorld[2].y + 0.5
        end
    end
    return centerX, centerY
end
