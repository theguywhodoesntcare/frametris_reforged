Preview = {}
Preview.cells = {}
Preview.cellsize = Field.cellsize
Preview.startPoint = {x = 0.15, y = 0.45}
Preview.ftable = {}

function Preview.create()
    local cellsize = Preview.cellsize
    local x = Preview.startPoint.x
    local y = Preview.startPoint.y
    Preview.setBorder(0.0045)
    Preview.build(cellsize, x, y, 4, 4, 3, "matrix4")
    Preview.build(cellsize,x + cellsize / 2, y + cellsize / 4, 3, 3, 4, "matrix3")
end

function Preview.build(cellsize, startX, startY, rows, columns, lvl, prefix)
    local defColor = "replaceabletextures\\commandbuttons\\btnakama"
    local world = BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0)
    for r = 1, rows do
        for c = 1, columns do
            local xmin = startX + cellsize*(c-1)
            local xmax = startX + cellsize+cellsize*(c-1)
            local ymin = startY + cellsize*(r-1)
            local ymax = startY + cellsize+cellsize*(r-1)
            local name = prefix..c.."_"..r
            local cell = FrameLib.CreateBackdropFourPoints(world, xmin, xmax, ymin, ymax, defColor, name, lvl )
            Preview.cells[cell] = defColor
            table.insert(Preview.ftable, cell)
        end
    end
end

function Preview.clear()
    local field = Preview.ftable
    for i = 1, #field do
        BlzFrameSetVisible(field[i], false)
    end
end

function Preview.paint(figure)
    Preview.clear()

    local prefix = figure.type
    local segments = figure.segments

    for i = 1, #segments do
        local x = segments[i].x - 3
        local y = segments[i].y - 17
        local fr = BlzGetFrameByName(prefix..x.."_"..y, 1)
        BlzFrameSetTexture(fr, figure.color, 0, true)
        BlzFrameSetVisible(fr, true)
    end
end

function Preview.setBorder(thickness)
    local rows = 4
    local columns = 4
    local x2 = Preview.startPoint.x
    local y1 = Preview.startPoint.y
    local y2 = y1 + rows * Preview.cellsize
    local world = BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0)
    local function drawLine(x1, x2, y1, y2)
        local color = "textures\\white"
        local line = FrameLib.CreateBackdropFourPoints(world, x1, x2, y1, y2, color, "border", 3 )
        BlzFrameSetVisible(line, true)
    end

    drawLine(x2 - thickness, x2, y1, y2)
    drawLine(x2 + columns * Preview.cellsize, x2 + columns * Preview.cellsize + thickness, y1, y2)
    drawLine(x2 - thickness, x2 + columns * Preview.cellsize + thickness, y1 - thickness, y1)
    drawLine(x2 - thickness, x2 + columns * Preview.cellsize + thickness, y2, y2 + thickness)

    local cX, cY = x2 + (columns * Preview.cellsize)/2, y2 + 0.062
    local text = FrameLib.CreateText(world, cX, cY, 0.08, "NEXT", 5)
    BlzFrameSetScale(text, 2)
end