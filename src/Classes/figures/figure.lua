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
        local x, y = s.x, s.y
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
        local x, y = segment.x, segment.y
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
                ---should block moving and rotating the piece here
                Triggers.enableControl(false)
                --
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
        Triggers.enableControl(false)
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
    Preview.draw(self)
end

function Figure.createRandom()
    local index = math.random(#Figure.shapes)
    local shape = Figure.shapes[index]
    local figure = shape:new()
    return figure
end
