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

    local names = {
        "UpperButtonBarAlliesButton",
        "UpperButtonBarChatButton",
        "UpperButtonBarQuestsButton"
    }

    for _, v in ipairs(names) do
        BlzFrameSetVisible(BlzGetFrameByName(v,0), false)
    end

    local tooltip = BlzGetOriginFrame(ORIGIN_FRAME_UBERTOOLTIP, 0)
    BlzFrameClearAllPoints(tooltip)
    BlzFrameSetScale(tooltip, 0.001)
    BlzFrameSetAbsPoint(tooltip, FRAMEPOINT_BOTTOMRIGHT, 0.0, 0.0)
end

function UI.enableFPSFrame()
    local resourceBarFrame = BlzGetFrameByName("ResourceBarFrame", 0)
    BlzFrameSetVisible(resourceBarFrame, true)

    for i = 0, 3 do
        BlzFrameSetVisible(BlzFrameGetChild(resourceBarFrame, i), false)
    end

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
