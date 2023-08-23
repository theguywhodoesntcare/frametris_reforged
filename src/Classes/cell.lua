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