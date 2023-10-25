Border = {}

function Border.setBorder(class, thickness, color)
    local x2 = class.startPoint.x
    local y1 = class.startPoint.y
    local y2 = y1 + class.rows * class.cellsize
    local function drawLine(x1, x2, y1, y2)
        local line = FrameLib.CreateBackdropTwoPoints(FrameLib.world(), x1, x2, y1, y2, color, "border", 3 )
        BlzFrameSetVisible(line, true)
    end

    drawLine(x2 - thickness, x2, y1, y2)
    drawLine(x2 + class.columns * class.cellsize, x2 + class.columns * class.cellsize + thickness, y1, y2)
    drawLine(x2 - thickness, x2 + class.columns * class.cellsize + thickness, y1 - thickness, y1)
    drawLine(x2 - thickness, x2 + class.columns * class.cellsize + thickness, y2, y2 + thickness)
end