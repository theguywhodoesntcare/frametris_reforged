Preview = {}
Preview.cells = {}
Preview.cellsize = Field.cellsize
Preview.rows = 4
Preview.columns = 4
Preview.startPoint = {x = 0.15, y = 0.45}
Preview.fTable = {}

function Preview.create()
    local cellsize = Preview.cellsize
    local x = Preview.startPoint.x
    local y = Preview.startPoint.y
    Border.setBorder(Preview, Field.defThickness, "textures\\white")
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
            local cell = FrameLib.CreateBackdropTwoPoints(world, xmin, xmax, ymin, ymax, defColor, name, lvl )
            Preview.cells[cell] = defColor
            table.insert(Preview.fTable, cell)
        end
    end
end

function Preview.clear()
    local field = Preview.fTable
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
        x = prefix..x
        Cell.setColor(x, y, figure.color)
    end
end
