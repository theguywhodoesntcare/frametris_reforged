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