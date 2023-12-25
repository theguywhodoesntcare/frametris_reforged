Keys = {}
Keys.leftKey = OSKEY_A
Keys.rightKey = OSKEY_D
Keys.softDropKey = OSKEY_S
Keys.hardDropKey = OSKEY_SPACE
Keys.rotateRightKey = OSKEY_W
Keys.rotateLeftKey = OSKEY_Q
Keys.restartKey = OSKEY_ESCAPE


KeyFunctions = {
    [Keys.leftKey] = function(figure) figure:moveSide("left") end,
    [Keys.rightKey] = function(figure) figure:moveSide("right") end,
    [Keys.softDropKey] = function() Triggers.keyState[Keys.softDropKey] = true end,
    [Keys.hardDropKey] = function(figure) figure:hardDrop() end,
    [Keys.rotateRightKey] = function(figure) figure:rotate("clockwise") end,
    [Keys.rotateLeftKey] = function(figure) figure:rotate("counter") end
}