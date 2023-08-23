Triggers = {}
Triggers.keyTrigger = CreateTrigger()
Triggers.leftKey = OSKEY_A
Triggers.rightKey = OSKEY_D
Triggers.softDropKey = OSKEY_S
Triggers.hardDropKey = OSKEY_SPACE
Triggers.rotateRightKey = OSKEY_W
Triggers.rotateLeftKey = OSKEY_Q
Triggers.keyState = {}

function Triggers.init()

end

function Triggers.initKeyTrigger()
    local trigger = Triggers.keyTrigger
    BlzTriggerRegisterPlayerKeyEvent(trigger, GetLocalPlayer(), Triggers.leftKey, 0, true)
    BlzTriggerRegisterPlayerKeyEvent(trigger, GetLocalPlayer(), Triggers.rightKey, 0, true)
    BlzTriggerRegisterPlayerKeyEvent(trigger, GetLocalPlayer(), Triggers.softDropKey, 0, true)
    BlzTriggerRegisterPlayerKeyEvent(trigger, GetLocalPlayer(), Triggers.hardDropKey, 0, true)
    BlzTriggerRegisterPlayerKeyEvent(trigger, GetLocalPlayer(), Triggers.rotateRightKey, 0, true)
    BlzTriggerRegisterPlayerKeyEvent(trigger, GetLocalPlayer(), Triggers.rotateLeftKey, 0, true)

    TriggerAddCondition(trigger, Condition(Triggers.ControlKeys))

    local releaseTrigger = CreateTrigger()
    BlzTriggerRegisterPlayerKeyEvent(releaseTrigger, GetLocalPlayer(), Triggers.leftKey, 0, false)
    BlzTriggerRegisterPlayerKeyEvent(releaseTrigger, GetLocalPlayer(), Triggers.rightKey, 0, false)
    BlzTriggerRegisterPlayerKeyEvent(releaseTrigger, GetLocalPlayer(), Triggers.softDropKey, 0, false)
    BlzTriggerRegisterPlayerKeyEvent(releaseTrigger, GetLocalPlayer(), Triggers.hardDropKey, 0, false)
    BlzTriggerRegisterPlayerKeyEvent(releaseTrigger, GetLocalPlayer(), Triggers.rotateRightKey, 0,false)
    BlzTriggerRegisterPlayerKeyEvent(releaseTrigger, GetLocalPlayer(), Triggers.rotateLeftKey, 0,false)

    TriggerAddCondition(releaseTrigger, Condition(Triggers.ReleaseKeys))
end

function Triggers.ControlKeys()
    local currentFigure = Figure.current
    local currentKey = BlzGetTriggerPlayerKey()
    if currentFigure ~= nil then
        if currentKey == Triggers.leftKey then
            if not Triggers.keyState[currentKey] then -- проверяем состояние клавиши
                currentFigure:moveSide("left")
                Triggers.keyState[currentKey] = true -- обновляем состояние клавиши
            end
        end
        if currentKey == Triggers.rightKey then
            if not Triggers.keyState[currentKey] then
                currentFigure:moveSide("right")
                Triggers.keyState[currentKey] = true
            end
        end
        if currentKey == Triggers.softDropKey then
            if not Triggers.keyState[currentKey] then
                print("soft drop")
                Triggers.keyState[currentKey] = true
            end
        end
        if currentKey == Triggers.hardDropKey then
            if not Triggers.keyState[currentKey] then
                print("hard drop")
                currentFigure:hardDrop()
                Triggers.keyState[currentKey] = true
            end
        end
        if currentKey == Triggers.rotateRightKey then
            if not Triggers.keyState[currentKey] then
                currentFigure:rotate("clockwise")
                print("rotate clockwise")
                Triggers.keyState[currentKey] = true
            end
        end
        if currentKey == Triggers.rotateLeftKey then
            if not Triggers.keyState[currentKey] then
                print("rotate counter clockwise")
                currentFigure:rotate("counter")
                Triggers.keyState[currentKey] = true
            end
        end
    end
end

function Triggers.ReleaseKeys()
    local currentKey = BlzGetTriggerPlayerKey()
    Triggers.keyState[currentKey] = false -- обновляем состояние клавиши при ее отжатии
end