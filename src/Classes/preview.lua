Preview = {}
Preview.cellsMatrix3 = {}
Preview.cellsMatrix4 = {}
Preview.allCells = {}
Preview.cellsize = Field.cellsize
Preview.rows = 4
Preview.columns = 4
Preview.startPoint = {x = 0.15, y = 0.45}


function Preview.create()
    local cellsize = Preview.cellsize
    local x = Preview.startPoint.x
    local y = Preview.startPoint.y
    Border.setBorder(Preview, Field.defThickness, "textures\\white")
    Preview.build(cellsize, x, y, 4, 4, 3, Preview.cellsMatrix4)
    Preview.build(cellsize,x + cellsize / 2, y + cellsize / 4, 3, 3, 4, Preview.cellsMatrix3)
end

function Preview.build(cellsize, startX, startY, rows, columns, lvl, field)
    local defColor = "replaceabletextures\\commandbuttons\\btnakama"
    local world = BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0)
    for r = 1, rows do
        table.insert(field, {})
        for c = 1, columns do
            local xmin = startX + cellsize*(c-1)
            local xmax = startX + cellsize+cellsize*(c-1)
            local ymin = startY + cellsize*(r-1)
            local ymax = startY + cellsize+cellsize*(r-1)
            local cell = FrameLib.CreateBackdropTwoPoints(world, xmin, xmax, ymin, ymax, defColor, "", lvl )
            table.insert(field[r], cell)
            table.insert(Preview.allCells, cell)
        end
    end
end

function Preview.clear()
    for i = 1, #Preview.allCells do
        BlzFrameSetVisible(Preview.allCells[i], false)
    end
end

function Preview.draw(figure)
    Preview.clear()
    local type = figure.type
    local segments = figure.segments
    local field = nil

    if type == "matrix3" then
        field = Preview.cellsMatrix3
    else
        field = Preview.cellsMatrix4
    end

    for i = 1, #segments do
        local x = segments[i].x - 3
        local y = segments[i].y - 17

        Cell.setColorPreview(x, y, figure.color, field)
    end
end
