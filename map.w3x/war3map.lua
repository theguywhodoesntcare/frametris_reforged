function InitGlobals()
end

--CUSTOM_CODE
FrameLib = {}

function FrameLib.HideDefaultUI()
    local gameui = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
    BlzFrameSetVisible(BlzFrameGetChild(gameui, 1), false)
    BlzFrameSetAbsPoint(BlzGetFrameByName("ConsoleUIBackdrop", 0), FRAMEPOINT_TOPRIGHT, 0, 0)

    for i = 0, 11 do
        BlzFrameSetVisible(BlzGetFrameByName("CommandButton_" .. i, 0), false)
    end

    BlzHideOriginFrames(true)
    BlzFrameSetScale(BlzFrameGetChild(BlzGetFrameByName("ConsoleUI", 0), 5), 0.001)
end

function FrameLib.CreateBackdropTwoPoints(parent, xmin, xmax, ymin, ymax, texture, name, lvl)
    local fr = BlzCreateFrameByType("BACKDROP", name, parent, "", 1)
    BlzFrameSetLevel(fr, lvl)
    BlzFrameSetAbsPoint(fr, FRAMEPOINT_TOPLEFT, xmin, ymax)
    BlzFrameSetAbsPoint(fr, FRAMEPOINT_BOTTOMRIGHT, xmax, ymin)
    BlzFrameSetTexture(fr, texture, 0, true)
    BlzFrameSetVisible(fr, false)
    return fr
end

function FrameLib.CreateBackdrop(parent, x, y, size, texture, name, lvl)
    local fr = BlzCreateFrameByType("BACKDROP", name, parent, "", 1)
    BlzFrameSetLevel(fr, lvl)
    BlzFrameSetAbsPoint(fr, FRAMEPOINT_CENTER, x, y)
    BlzFrameSetSize(fr, size, size)
    BlzFrameSetTexture(fr, texture, 0, true)
    BlzFrameSetVisible(fr, false)
    return fr
end


function FrameLib.CreateText(parent, centerX, centerY, size, text, lvl)
    local fr = BlzCreateFrameByType("TEXT", "", parent, "", 0)
    BlzFrameSetLevel(fr, lvl)
    BlzFrameSetAbsPoint(fr, FRAMEPOINT_CENTER, centerX, centerY)
    BlzFrameSetSize(fr, size, size)
    BlzFrameSetText(fr, text)
    BlzFrameSetEnable(fr, false)
    BlzFrameSetScale(fr, 1)
    BlzFrameSetTextAlignment(fr, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
    return fr
end

function FrameLib.CreateTextTwoPoints(parent, x1, y1, x2, y2, text, lvl)
    local fr = BlzCreateFrameByType("TEXT", "", parent, "", 0)
    BlzFrameSetLevel(fr, lvl)
    BlzFrameSetAbsPoint(fr, FRAMEPOINT_TOPLEFT, x1, y1)
    BlzFrameSetAbsPoint(fr, FRAMEPOINT_BOTTOMRIGHT, x2, y2)
    BlzFrameSetText(fr, text)
    BlzFrameSetEnable(fr, false)
    BlzFrameSetScale(fr, 1)
    BlzFrameSetTextAlignment(fr, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
    return fr
end

function FrameLib.ClickBlocker()
    local fr = FrameLib.CreateText(BlzGetFrameByName("ConsoleUIBackdrop", 0), 0.4, 0.3, 1.2, "", 1)
    BlzFrameSetEnable(fr, true)
end

function FrameLib.createSprite(model, cam, x, y, scale, parent, lvl)
    local fr = BlzCreateFrameByType("SPRITE", "", parent, "", 0)
    BlzFrameSetAbsPoint(fr, FRAMEPOINT_CENTER, x, y)
    BlzFrameSetLevel(fr, lvl)
    BlzFrameSetSize(fr, 0.001, 0.001)
    BlzFrameSetModel(fr, model, cam)
    BlzFrameSetScale(fr, scale)
    return fr
end

Cell = {} --экземпляры клеток не нужны, просто static обёртка над frame api

function Cell.get(x, y)
    return BlzGetFrameByName(x.."_"..y, 1)
end

function Cell.setColor(x, y, color)
    local frame = Cell.get(x, y)
    BlzFrameSetTexture(frame, color, 0, true)
    BlzFrameSetVisible(frame, true)
    Field.cells[frame] = color
end

function Cell.getColor(x, y)
    local frame = Cell.get(x, y)
    return Field.cells[frame]
end

function Cell.isFilled(x, y)
    local frame = Cell.get(x, y)
    return BlzFrameIsVisible(frame)
end

function Cell.setVisible(x, y, isVisible)
    local frame = Cell.get(x, y)
    BlzFrameSetVisible(frame, isVisible)
end
Field = {}
Field.cells = {}
Field.rows = 20
Field.columns = 10
Field.cellsize = 0.025
Field.startPoint = {x = 0.275, y = 0.05}
Field.defThickness = 0.0045

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
            local cell = FrameLib.CreateBackdropTwoPoints(world, xmin, xmax, ymin, ymax, defColor, name, 2 )
            Field.cells[cell] = defColor
        end
    end
    Border.setBorder(Field, Field.defThickness, "textures\\white")
    Preview.create()
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
                --print("TETRIS!")
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
            Counter.rowsReward(#rows)
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

function Field.clear()
    for r = 1, Field.rows do
        for c = 1, Field.columns do
            Cell.setVisible(c, r, false)
        end
    end
end



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

Figure = {}
Figure.__index = Figure
Figure.shapes = {}
Figure.current = nil
Figure.next = nil

function Figure:new()
    local figure = {}
    setmetatable(figure, Figure)
    figure.t = CreateTimer()
    figure.softDropTimer = CreateTimer()
    figure.hardDropTimer = CreateTimer()
    figure.allowedToHardDrop = false
    return figure
end

function Figure:draw()
    local segments = self.segments
    local drawable = true
    for i = 1, #segments do
        if not Cell.isFilled(segments[i].x, segments[i].y) then
            Cell.setColor(segments[i].x, segments[i].y, self.color)
        else
            drawable = false
            --break --нарисует возможные сегменты
        end
    end
    if drawable then
        Figure.current = self
        self.allowedToHardDrop = true
    else
        Game.gameOver()
    end
end

function Figure:redraw(newSegments)
    local oldSegments = self.segments
    for i = 1, #oldSegments do --так проще
        local s = oldSegments[i]
        Cell.setVisible(s.x, s.y, false)
    end

    for i = 1, #newSegments do
        local s = newSegments[i]
        local x = s.x
        local y = s.y
        Cell.setColor(x, y, self.color)
        oldSegments[i].x, oldSegments[i].y = x, y
    end
    return
end

function Figure:rotate(rotatedSegments, direction)
    local oldSegments = self.segments
    local newSegments = rotatedSegments

    local canRotate = true

    local function isOldSegment(x, y, oldSegments)
        for i = 1, #oldSegments do
            if oldSegments[i].x == x and oldSegments[i].y == y then
                return true
            end
        end
        return false
    end

    for i = 1, #newSegments do
        local segment = newSegments[i]
        local x = segment.x
        local y = segment.y
        if (x < 1 or x > Field.columns or y < 1 or (Cell.isFilled(x, y) and not isOldSegment(x, y, oldSegments))) then
            canRotate = false
            break
        end
    end

    if canRotate then
        self:redraw(newSegments)
    end
end

function Figure:startTimer()
    local isStopped = false
    local t = self.t
    local softDropTimer = self.softDropTimer
    TimerStart(softDropTimer, 0.1, true, function()
        if not isStopped then
            if Triggers.keyState[Keys.softDropKey] then
                self:moveDown()
            end
        end
    end)
    TimerStart(t, 0.5, true, function()
        if not self:moveDown() then
            if not isStopped then
                isStopped = true
            else
                PauseTimer(t)
                PauseTimer(softDropTimer)
                Game.checkField()
                DestroyTimer(t)
            end
        else
            isStopped = false
        end
    end)
end

function Figure:hardDrop()
    if self.allowedToHardDrop then
        self.allowedToHardDrop = false
        DestroyTimer(self.t)
        DestroyTimer(self.softDropTimer)
        local isStopped = false
        local t = self.hardDropTimer
        TimerStart(t, 0.01, true, function()
            if not self:moveDown() then
                if not isStopped then
                    isStopped = true
                else
                    Game.checkField()
                    DestroyTimer(t)
                end
            else
                isStopped = false
            end
        end)
    end
end

function Figure:moveDown()
    local segments = self.segments
    local canMove = true
    local occupiedCells = {}
    for i = 1, #segments do
        local s = segments[i]
        occupiedCells[Cell.get(s.x, s.y)] = true
    end
    for i = 1, #segments do
        local s = segments[i]
        if s.y <= 1 or (not occupiedCells[Cell.get(s.x, s.y - 1)] and Cell.isFilled(s.x, s.y - 1)) then
            canMove = false
            break
        end
    end
    if canMove then
        local newSegments = {}
        for i = 1, #segments do
            local s = segments[i]
            local newSegment = {x = s.x, y = s.y - 1}
            table.insert(newSegments, newSegment)
        end
        self:redraw(newSegments)
        return true
    else
        return false
    end
end


function Figure:moveSide(direction)
    local segments = self.segments
    local occupiedCells = {}
    for i = 1, #segments do
        local s = segments[i]
        occupiedCells[Cell.get(s.x, s.y)] = true
    end
    local val = 0
    local canMove = true
    if direction == "left" then
        val = -1
        for i = 1, #segments do
            local s = segments[i]
            if segments[i].x <= 1 or (not occupiedCells[Cell.get(s.x - 1, s.y)] and Cell.isFilled(s.x - 1, s.y)) then
                canMove = false
                break
            end
        end
    elseif direction == "right" then
        val = 1
        for i = 1, #segments do
            local s = segments[i]
            if segments[i].x >= Field.columns or (not occupiedCells[Cell.get(s.x + 1, s.y)] and Cell.isFilled(s.x + 1, s.y)) then
                canMove = false
                break
            end
        end
    end
    if canMove then
        local newSegments = {}
        for i = 1, #segments do
            local s = segments[i]
            local newSegment = {x = s.x + val, y = s.y}
            table.insert(newSegments, newSegment)
        end
        self:redraw(newSegments)
    end
end

function Figure:preview()
    Preview.paint(self)
end

function Figure.createRandom()
    local index = math.random(#Figure.shapes)
    local shape = Figure.shapes[index]
    local figure = shape:new()
    return figure
end


IShape = {}
IShape.__index = IShape
setmetatable(IShape, {__index = Figure})
IShape.color = "turquoise"
IShape.s1 = {x = 4, y = 19}
IShape.s2 = {x = 5, y = 19}
IShape.s3 = {x = 6, y = 19}
IShape.s4 = {x = 7, y = 19}
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
    iShape.type = "matrix4"
    return iShape
end

function IShape:rotate(direction)
    --Type: line4
    local newSegments = Line4.rotate(self.segments, direction)

    Figure.rotate(self, newSegments, direction)
end


JShape = {}
JShape.__index = JShape
setmetatable(JShape, {__index = Figure})
JShape.color = "blue"
JShape.s1 = {x = 4, y = 20}
JShape.s2 = {x = 4, y = 19}
JShape.s3 = {x = 5, y = 19} --center
JShape.s4 = {x = 6, y = 19}
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
    jShape.type = "matrix3"
    return jShape
end

function JShape:rotate(direction)
    --Type: matrix3
    local newSegments = Matrix3.rotate(self.segments, direction)

    Figure.rotate(self, newSegments, direction)
end


LShape = {}
LShape.__index = LShape
setmetatable(LShape, {__index = Figure})
LShape.color = "orange"
LShape.s1 = {x = 4, y = 19}
LShape.s2 = {x = 5, y = 19} --center
LShape.s3 = {x = 6, y = 19}
LShape.s4 = {x = 6, y = 20}
table.insert(Figure.shapes, LShape)

function LShape:new()
    local lShape = Figure:new()
    setmetatable(lShape, LShape)
    lShape.segments = {
        {x = LShape.s2.x, y = LShape.s2.y},
        {x = LShape.s1.x, y = LShape.s1.y},
        {x = LShape.s3.x, y = LShape.s3.y},
        {x = LShape.s4.x, y = LShape.s4.y}
    }
    lShape.type = "matrix3"
    return lShape
end

function LShape:rotate(direction)
    --Type: matrix3
    local newSegments = Matrix3.rotate(self.segments, direction)

    Figure.rotate(self, newSegments, direction)
end

OShape = {}
OShape.__index = OShape
setmetatable(OShape, {__index = Figure})
OShape.color = "yellow"
OShape.s1 = {x = 5, y = 20}
OShape.s2 = {x = 6, y = 20}
OShape.s3 = {x = 5, y = 19}
OShape.s4 = {x = 6, y = 19}
table.insert(Figure.shapes, OShape)

function OShape:new()
    local oShape = Figure:new()
    setmetatable(oShape, OShape)
    oShape.segments = {
        {x = OShape.s1.x, y = OShape.s1.y},
        {x = OShape.s2.x, y = OShape.s2.y},
        {x = OShape.s3.x, y = OShape.s3.y},
        {x = OShape.s4.x, y = OShape.s4.y}
    }
    oShape.type = "matrix4"
    return oShape
end

function OShape:rotate(direction)
    --Type: non-rotatable
    return
end

SShape = {}
SShape.__index = SShape
setmetatable(SShape, {__index = Figure})
SShape.color = "green"
SShape.s1 = {x = 4, y = 19}
SShape.s2 = {x = 5, y = 19} --center
SShape.s3 = {x = 5, y = 20}
SShape.s4 = {x = 6, y = 20}
table.insert(Figure.shapes, SShape)

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
    --Type: matrix3
    local newSegments = Matrix3.rotate(self.segments, direction)

    Figure.rotate(self, newSegments, direction)
end
TShape = {}
TShape.__index = TShape
setmetatable(TShape, {__index = Figure})
TShape.color = "violet"
TShape.s1 = {x = 4, y = 19}
TShape.s2 = {x = 5, y = 19} --center
TShape.s3 = {x = 6, y = 19}
TShape.s4 = {x = 5, y = 20}
table.insert(Figure.shapes, TShape)

function TShape:new()
    local tShape = Figure:new()
    setmetatable(tShape, TShape)
    tShape.segments = {
        {x = TShape.s2.x, y = TShape.s2.y},
        {x = TShape.s1.x, y = TShape.s1.y},
        {x = TShape.s3.x, y = TShape.s3.y},
        {x = TShape.s4.x, y = TShape.s4.y}
    }
    tShape.type = "matrix3"
    return tShape
end

function TShape:rotate(direction)
    --Type: matrix3
    local newSegments = Matrix3.rotate(self.segments, direction)

    Figure.rotate(self, newSegments, direction)
end
ZShape = {}
ZShape.__index = ZShape
setmetatable(ZShape, {__index = Figure})
ZShape.color = "red"
ZShape.s1 = {x = 4, y = 20}
ZShape.s2 = {x = 5, y = 20}
ZShape.s3 = {x = 5, y = 19} --center
ZShape.s4 = {x = 6, y = 19}
table.insert(Figure.shapes, ZShape)

function ZShape:new()
    local zShape = Figure:new()
    setmetatable(zShape, ZShape)
    zShape.segments = {
        {x = ZShape.s3.x, y = ZShape.s3.y},
        {x = ZShape.s2.x, y = ZShape.s2.y},
        {x = ZShape.s1.x, y = ZShape.s1.y},
        {x = ZShape.s4.x, y = ZShape.s4.y}
    }
    zShape.type = "matrix3"
    return zShape
end

function ZShape:rotate(direction)
    --Type: matrix3
    local newSegments = Matrix3.rotate(self.segments, direction)

    Figure.rotate(self, newSegments, direction)
end
Border = {}

function Border.setBorder(class, thickness, color)
    local x2 = class.startPoint.x
    local y1 = class.startPoint.y
    local y2 = y1 + class.rows * class.cellsize
    local function drawLine(x1, x2, y1, y2)
        local world = BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0)
        local line = FrameLib.CreateBackdropTwoPoints(world, x1, x2, y1, y2, color, "border", 3 )
        BlzFrameSetVisible(line, true)
    end

    drawLine(x2 - thickness, x2, y1, y2)
    drawLine(x2 + class.columns * class.cellsize, x2 + class.columns * class.cellsize + thickness, y1, y2)
    drawLine(x2 - thickness, x2 + class.columns * class.cellsize + thickness, y1 - thickness, y1)
    drawLine(x2 - thickness, x2 + class.columns * class.cellsize + thickness, y2, y2 + thickness)
end
CustomFrames = {}
CustomFrames.musicTitle = nil
CustomFrames.lost = nil
CustomFrames.stats = nil
CustomFrames.score = nil
CustomFrames.defScoreString = "|cffffff00HIGH SCORE|r:  000000     |cffffff00SCORE|r:  000000"

function CustomFrames.init()
    FrameLib.ClickBlocker()
    CustomFrames.createMusicPanel()
    CustomFrames.createArt()
    CustomFrames.lostFrame()
    CustomFrames.createStatsFrame()
end

function CustomFrames.createMusicPanel()
    local world = BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0)
    local panel = FrameLib.CreateBackdropTwoPoints(world, 0, Field.startPoint.x - 0.01, Field.startPoint.y - Field.defThickness, 0.2, "transp", "name", 2)
    BlzFrameSetVisible(panel, true)

    local text = FrameLib.CreateText(panel, 0.105, Field.startPoint.y + 0.144, 0.2, "Now Playing:  ", 1)
    BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_BOTTOM, TEXT_JUSTIFY_LEFT)
    BlzFrameClearAllPoints(text)
    BlzFrameSetScale(text, 1.4)
    BlzFrameSetPoint(text, FRAMEPOINT_BOTTOMLEFT, panel, FRAMEPOINT_BOTTOMLEFT, 0, 0)
    CustomFrames.musicTitle = text

    local sprite = FrameLib.createSprite("dance", 1, 0.4, 0.3, 0.55, panel, 2)
    BlzFrameClearAllPoints(sprite)
    BlzFrameSetPoint(sprite, FRAMEPOINT_CENTER, panel, FRAMEPOINT_LEFT, 0.05, -0.05)
end

function CustomFrames.setMusicTitle(path)
    local filename = path:gsub("Music\\", "")
    local filename = filename:gsub("_", " ")

    BlzFrameSetText(CustomFrames.musicTitle, "Now Playing:  "..filename)
    CustomFrames.displayControls()
end

function CustomFrames.displayControls()
    local world = BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0)
    local text = "Controls:|n|n|cffffff00A|r — Move Left, |cffffff00D|r — Move Right|n|n|cffffff00Q|r — Rotate CCW, |cffffff00W|r — Rotate CW|n|n|cffffff00S (hold)|r — Soft Drop, |cffffff00SPACE|r — Hard Drop"
    local textFrame = FrameLib.CreateText(world, 0.11, 0.3, 0.2, text, 2)
    BlzFrameSetScale(textFrame, 1.20)
end

function CustomFrames.createArt()
    local world = BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0)
    local texture = "ui\\glues\\scorescreen\\scorescreen-orcvictoryexpansion\\scorescreen-orcvictoryexpansion"
    local fr = FrameLib.CreateBackdropTwoPoints(world, 0.5, 0.8, 0.15, 0.45, texture, "", 2)
    BlzFrameSetVisible(fr, true)
end

function CustomFrames.lostFrame()
    local world = BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0)
    local background = FrameLib.CreateBackdrop(world, 0.4, 0.3, 0.25, "textures\\black32", "", 4)
    local text = "|cffff0000You lose!|nPress|r |cffffff00ESC|r |cffff0000to restart|r"
    local textFrame = FrameLib.CreateText(background, 0.4, 0.3, 0.25, text, 1)

    BlzFrameSetVisible(textFrame, true)
    BlzFrameSetScale(textFrame, 2.75)
    CustomFrames.lost = background
end

function CustomFrames.setLose(flag)
    BlzFrameSetVisible(CustomFrames.lost, flag)
end

function CustomFrames.createStatsFrame()
    local world = BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0)
    local x2 = Field.startPoint.x + Field.columns * Field.cellsize + Field.defThickness
    local x1 = Field.startPoint.x - Field.defThickness
    local y1 = Field.startPoint.y + Field.rows * Field.cellsize + Field.defThickness
    local y2 = y1 + 0.0154
    local text = FrameLib.CreateTextTwoPoints(world, x1, y2, x2, y1, CustomFrames.defScoreString, 5)
    BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_RIGHT)
    BlzFrameSetScale(text, 1.15)
    CustomFrames.score = text
end
Game = {}
Game.status = "play"

function Game.start()
    local figure = Figure.createRandom()
    Figure.next = Figure.createRandom()
    Figure.next:preview()
    figure:draw()
    figure:startTimer()
end

function Game.checkField()
    Counter.pieceReward()
    if not Field.findRows() then
        Game.launchFigure()
    end
end

function Game.launchFigure()
    DestroyTimer(Figure.current.t)
    DestroyTimer(Figure.current.softDropTimer)
    DestroyTimer(Figure.current.hardDropTimer)
    Figure.current = nil
    Figure.next:draw()
    Figure.next = Figure.createRandom()
    Figure.next:preview()
    Figure.current:startTimer()
    return
end

function Game.load()
    do
        function MarkGameStarted()
            math.randomseed(os.time())
            Music.ambientOff()
            UI.load()
            Music.setMusic()
            Game.start()
            Triggers.initKeyTrigger()
        end
    end
end

function Game.gameOver()
    Figure.next = nil
    Figure.current = nil
    Game.status = "lost"
    CustomFrames.setLose(true)
end

function Game.restartGame()
    Counter.resetScore()
    CustomFrames.setLose(false)
    Field.clear()
    Preview.clear()

    Game.status = "play"
    Counter.resetScore()

    Game.start()
end


Keys = {}
Keys.leftKey = OSKEY_A
Keys.rightKey = OSKEY_D
Keys.softDropKey = OSKEY_S
Keys.hardDropKey = OSKEY_SPACE
Keys.rotateRightKey = OSKEY_W
Keys.rotateLeftKey = OSKEY_Q
Keys.restartKey = OSKEY_ESCAPE
Music = {}

function Music.setMusic()
    StopMusic(false)
    ClearMapMusic()
    local path = "Music\\BRD_-_Teleport_Prokg"
    PlayMusic(path)
    CustomFrames.setMusicTitle(path)
end
 function Music.ambientOff()
     VolumeGroupSetVolume( SOUND_VOLUMEGROUP_AMBIENTSOUNDS, 0.00 )
 end
Counter = {}
Counter.score = 0
Counter.highScore = 0
Counter.rowsRewards = {}
Counter.rowsRewards[1] = 50
Counter.rowsRewards[2] = 150
Counter.rowsRewards[3] = 350
Counter.rowsRewards[4] = 700
Counter.pieceRewardConst = 5

function Counter.pieceReward()
    local reward = Counter.pieceRewardConst
    Counter.update(reward)
end

function Counter.rowsReward(numb)
    local reward = Counter.rowsRewards[numb]
    Counter.update(reward)
end

function Counter.update(additive)
    if Game.status == "play" then
        Counter.score = Counter.score + additive
        if Counter.highScore < Counter.score then
            Counter.highScore = Counter.score
        end

        local score = string.format("%06d", Counter.score)
        local highScore = string.format("%06d", Counter.highScore)
        local str = "|cffffff00HIGH SCORE|r:  "..highScore.."     |cffffff00SCORE|r:  "..score
        BlzFrameSetText(CustomFrames.score, str)
    end
end

function Counter.resetScore()
    Counter.score = 0
    BlzFrameSetText(CustomFrames.score, CustomFrames.defScoreString)
    Counter.update(0)
end
Triggers = {}
Triggers.keyTrigger = CreateTrigger()
Triggers.releaseTrigger = CreateTrigger()
Triggers.keyState = {}

function Triggers.initKeyTrigger()
    local trigger = Triggers.keyTrigger
    local releaseTrigger = Triggers.releaseTrigger

    for key, value in pairs(Keys) do
        BlzTriggerRegisterPlayerKeyEvent(trigger, GetLocalPlayer(), value, 0, true)
        BlzTriggerRegisterPlayerKeyEvent(releaseTrigger, GetLocalPlayer(), value, 0, false)
    end

    TriggerAddCondition(trigger, Condition(Triggers.ControlKeys))
    TriggerAddCondition(releaseTrigger, Condition(Triggers.ReleaseKeys))
end

function Triggers.ControlKeys()
    local currentFigure = Figure.current
    local currentKey = BlzGetTriggerPlayerKey()
    if currentFigure ~= nil then
        if currentKey == Keys.leftKey then
            if not Triggers.keyState[currentKey] then --проверяем состояние клавиши
                currentFigure:moveSide("left")
                Triggers.keyState[currentKey] = true --обновляем состояние клавиши
            end
        end
        if currentKey == Keys.rightKey then
            if not Triggers.keyState[currentKey] then
                currentFigure:moveSide("right")
                Triggers.keyState[currentKey] = true
            end
        end
        if currentKey == Keys.softDropKey then
            if not Triggers.keyState[currentKey] then
                Triggers.keyState[currentKey] = true
            end
        end
        if currentKey == Keys.hardDropKey then
            if not Triggers.keyState[currentKey] then
                currentFigure:hardDrop()
                Triggers.keyState[currentKey] = true
            end
        end
        if currentKey == Keys.rotateRightKey then
            if not Triggers.keyState[currentKey] then
                currentFigure:rotate("clockwise")
                Triggers.keyState[currentKey] = true
            end
        end
        if currentKey == Keys.rotateLeftKey then
            if not Triggers.keyState[currentKey] then
                currentFigure:rotate("counter")
                Triggers.keyState[currentKey] = true
            end
        end
    end
    if currentKey == Keys.restartKey and Game.status == "lost" then
        Game.restartGame()
    end
end

function Triggers.ReleaseKeys()
    local currentKey = BlzGetTriggerPlayerKey()
    Triggers.keyState[currentKey] = false -- обновляем состояние клавиши при ее отжатии
end
UI = {}

function UI.load()
    UI.hideDefault()
    UI.initCustomUI()
end

function UI.hideDefault()
    FrameLib.HideDefaultUI()
    SetTimeOfDay(0.00)
    SuspendTimeOfDay(true)
end

function UI.initCustomUI()
    Field.create()
    CustomFrames.init()
    UI.editMenu()
    UI.enableFPSFrame()
end

function UI.editMenu()
    BlzFrameSetVisible(BlzGetFrameByName("UpperButtonBarFrame",0), true)
    BlzFrameSetVisible(BlzGetFrameByName("UpperButtonBarAlliesButton",0), false)
    BlzFrameSetVisible(BlzGetFrameByName("UpperButtonBarChatButton",0), false)
    BlzFrameSetVisible(BlzGetFrameByName("UpperButtonBarQuestsButton",0), false)

    local tooltip = BlzGetOriginFrame(ORIGIN_FRAME_UBERTOOLTIP, 0)
    BlzFrameClearAllPoints(tooltip)
    BlzFrameSetScale(tooltip, 0.001)
    BlzFrameSetAbsPoint(tooltip, FRAMEPOINT_BOTTOMRIGHT, 0.0, 0.0)
end

function UI.enableFPSFrame()
    local resourceBarFrame = BlzGetFrameByName("ResourceBarFrame", 0)
    BlzFrameSetVisible(resourceBarFrame, true)

    BlzFrameSetVisible(BlzFrameGetChild(resourceBarFrame, 0), false)
    BlzFrameSetVisible(BlzFrameGetChild(resourceBarFrame, 1), false)
    BlzFrameSetVisible(BlzFrameGetChild(resourceBarFrame, 2), false)
    BlzFrameSetVisible(BlzFrameGetChild(resourceBarFrame, 3), false)

    local ResourseBarTextFrames = {
        BlzGetFrameByName("ResourceBarGoldText", 0),
        BlzGetFrameByName("ResourceBarLumberText", 0),
        BlzGetFrameByName("ResourceBarSupplyText", 0),
        BlzGetFrameByName("ResourceBarUpkeepText", 0)
    }

    BlzFrameClearAllPoints(resourceBarFrame)
    BlzFrameSetAbsPoint(resourceBarFrame, FRAMEPOINT_CENTER, 1.0, 0.617)

    for f = 1, 4 do
        BlzFrameClearAllPoints(ResourseBarTextFrames[f])
        BlzFrameSetScale(ResourseBarTextFrames[f], 0.0001)
        BlzFrameSetAbsPoint(ResourseBarTextFrames[f], FRAMEPOINT_CENTER, -0.2, 0.0)
    end
end

Game.load()
--CUSTOM_CODE
function InitCustomPlayerSlots()
SetPlayerStartLocation(Player(0), 0)
ForcePlayerStartLocation(Player(0), 0)
SetPlayerColor(Player(0), ConvertPlayerColor(0))
SetPlayerRacePreference(Player(0), RACE_PREF_HUMAN)
SetPlayerRaceSelectable(Player(0), false)
SetPlayerController(Player(0), MAP_CONTROL_USER)
end

function InitCustomTeams()
SetPlayerTeam(Player(0), 0)
end

function main()
SetCameraBounds(-3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), -3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), -3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), -3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
NewSoundEnvironment("Default")
SetAmbientDaySound("LordaeronSummerDay")
SetAmbientNightSound("LordaeronSummerNight")
SetMapMusic("Music", true, 0)
InitBlizzard()
InitGlobals()
end

function config()
SetMapName("TRIGSTR_001")
SetMapDescription("TRIGSTR_003")
SetPlayers(1)
SetTeams(1)
SetGamePlacement(MAP_PLACEMENT_USE_MAP_SETTINGS)
DefineStartLocation(0, 192.0, -3072.0)
InitCustomPlayerSlots()
InitCustomTeams()
end

