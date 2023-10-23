Cell = {} --экземпляры клеток не нужны, просто static обёртка над frame api

function Cell.get(x, y)
    return Field.cells[y][x]
end

function Cell.setColor(x, y, color)
    local frame = Cell.get(x, y)
    BlzFrameSetTexture(frame, color, 0, true)
    BlzFrameSetVisible(frame, true)
    Field.cellsColors[frame] = color
end

function Cell.getColor(x, y)
    local frame = Cell.get(x, y)
    return Field.cellsColors[frame]
end

function Cell.isFilled(x, y)
    local frame = Cell.get(x, y)
    return BlzFrameIsVisible(frame)
end

function Cell.setVisible(x, y, isVisible)
    local frame = Cell.get(x, y)
    BlzFrameSetVisible(frame, isVisible)
end

function Cell.setColorPreview(x, y, color, field)
    local frame = field[y][x]
    BlzFrameSetTexture(frame, color, 0, true)
    BlzFrameSetVisible(frame, true)
end