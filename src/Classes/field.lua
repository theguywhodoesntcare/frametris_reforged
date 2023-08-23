Field = {}
Field.cells = {}
Field.rows = 20
Field.columns = 10
Field.cellsize = 0.025
Field.startPoint = {x = 0.275, y = 0.05}

function Field.create()
    local startX = Field.startPoint.x
    local startY = Field.startPoint.y
    local rows = Field.rows
    local columns = Field.columns
    local cellsize = Field.cellsize
    local defColor = "replaceabletextures\\commandbuttons\\btnakama"
    local world = BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0)
    for r = 1, rows do
        for c = 1, columns do
            local xmin = startX + cellsize*(c-1)
            local xmax = startX + cellsize+cellsize*(c-1)
            local ymin = startY + cellsize*(r-1)
            local ymax = startY + cellsize+cellsize*(r-1)
            local name = c.."_"..r
            local cell = FrameLib.CreateBackdropFourPoints(world, xmin, xmax, ymin, ymax, defColor, name, 2 )
            Field.cells[cell] = defColor
        end
    end
    Field.setBorder(0.0045)
    Preview.create()
end

function Field.setBorder(thickness)
    local x2 = Field.startPoint.x
    local y1 = Field.startPoint.y
    local y2 = y1 + Field.rows * Field.cellsize
    local function drawLine(x1, x2, y1, y2)
        local color = "textures\\white"
        local world = BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0)
        local line = FrameLib.CreateBackdropFourPoints(world, x1, x2, y1, y2, color, "border", 3 )
        BlzFrameSetVisible(line, true)
    end

    drawLine(x2 - thickness, x2, y1, y2)
    drawLine(x2 + Field.columns * Field.cellsize, x2 + Field.columns * Field.cellsize + thickness, y1, y2)
    drawLine(x2 - thickness, x2 + Field.columns * Field.cellsize + thickness, y1 - thickness, y1)
    drawLine(x2 - thickness, x2 + Field.columns * Field.cellsize + thickness, y2, y2 + thickness)
end

function Field.findRows()
    local rowsToDestroy = {}
    for r = 1, Field.rows do
        local isRowFilled = true
        for c = 1, Field.columns do
            if not Cell.isFilled(c, r) then
                isRowFilled = false
                break
            end
        end
        if isRowFilled then
            table.insert(rowsToDestroy, r)
            if #rowsToDestroy >= 4 then
                print("TETRIS!")
                break
            end
        end
    end
    if #rowsToDestroy > 0 then
        Field.destroyRows(rowsToDestroy)
        return true
    else
        return false
    end
end

function Field.destroyRows(rows)
    local x = math.floor(Field.columns / 2)
    local i = 1
    local t = CreateTimer()
    TimerStart(t, 0.08, true, function()
        for _, row in ipairs(rows) do
            Cell.setVisible(x-i+1, row, false)
            Cell.setVisible(x+i, row, false)
        end
        i = i + 1
        if i > x then
            PauseTimer(t)
            Field.shake()
            DestroyTimer(t)
        end
    end)
end

function Field.shake()
    local emptyRows = 0
    local currentFigureSegments = {}
    for i = 1, #Figure.current.segments do
        local s = Figure.current.segments[i]
        currentFigureSegments[Cell.get(s.x, s.y)] = true
    end
    for r = 1, Field.rows do
        local isRowEmpty = true
        for c = 1, Field.columns do
            if Cell.isFilled(c, r) then
                isRowEmpty = false
                break
            end
        end
        if isRowEmpty then
            emptyRows = emptyRows + 1
        else
            if emptyRows > 0 then
                for c = 1, Field.columns do
                    if Cell.isFilled(c, r) then
                        local color = Cell.getColor(c, r)
                        Cell.setColor(c, r - emptyRows, color)
                        Cell.setVisible(c, r, false)
                    end
                end
            end
        end
    end
    Game.launchFigure()
end


