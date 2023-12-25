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
    if currentFigure ~= nil and KeyFunctions[currentKey] and not Triggers.keyState[currentKey] then
        KeyFunctions[currentKey](currentFigure)
        Triggers.keyState[currentKey] = true
        return
    end
    if currentKey == Keys.restartKey and Game.status == "lost" then
        Game.restartGame()
    end
end


function Triggers.ReleaseKeys()
    local currentKey = BlzGetTriggerPlayerKey()
    Triggers.keyState[currentKey] = false -- обновляем состояние клавиши при ее отжатии
end


function Triggers.enableControl(flag)
    if not flag then
        DisableTrigger(Triggers.keyTrigger)
    else
        EnableTrigger(Triggers.keyTrigger)
    end
end