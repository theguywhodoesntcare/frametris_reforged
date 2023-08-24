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
    UI.editMenu()
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