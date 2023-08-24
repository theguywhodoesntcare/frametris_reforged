UI = {}

function UI.load()
    UI.hideDefault()
    UI.initCustomUI()
    Music.setMusic()
end

function UI.hideDefault()
    FrameLib.HideDefaultUI()
    SetTimeOfDay(0.00)
    SuspendTimeOfDay(true)
end

function UI.initCustomUI()
    Field.create()
    CustomFrames.init()
end
