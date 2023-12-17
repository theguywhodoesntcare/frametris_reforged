FrameLib = {}

function FrameLib.world()
    return BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0)
end

function FrameLib.HideDefaultUI()
    local gameui = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
    BlzFrameSetVisible(BlzFrameGetChild(gameui, 1), false)
    BlzFrameSetAbsPoint(BlzGetFrameByName("ConsoleUIBackdrop", 0), FRAMEPOINT_TOPRIGHT, 0, 0)

    for i = 0, 11 do
        BlzFrameSetVisible(BlzGetFrameByName("CommandButton_" .. i, 0), false)
    end

    BlzHideOriginFrames(true)
    BlzFrameSetScale(BlzFrameGetChild(BlzGetFrameByName("ConsoleUI", 0), 5), 0.001)
end

function FrameLib.CreateBackdropTwoPoints(parent, xmin, xmax, ymin, ymax, texture, name, lvl)
    local fr = BlzCreateFrameByType("BACKDROP", name, parent, "", 1)
    BlzFrameSetLevel(fr, lvl)
    BlzFrameSetAbsPoint(fr, FRAMEPOINT_TOPLEFT, xmin, ymax)
    BlzFrameSetAbsPoint(fr, FRAMEPOINT_BOTTOMRIGHT, xmax, ymin)
    BlzFrameSetTexture(fr, texture, 0, true)
    BlzFrameSetVisible(fr, false)
    return fr
end

function FrameLib.CreateBackdrop(parent, x, y, size, texture, name, lvl)
    local fr = BlzCreateFrameByType("BACKDROP", name, parent, "", 1)
    BlzFrameSetLevel(fr, lvl)
    BlzFrameSetAbsPoint(fr, FRAMEPOINT_CENTER, x, y)
    BlzFrameSetSize(fr, size, size)
    BlzFrameSetTexture(fr, texture, 0, true)
    BlzFrameSetVisible(fr, false)
    return fr
end


function FrameLib.CreateText(parent, centerX, centerY, size, text, lvl)
    local fr = BlzCreateFrameByType("TEXT", "", parent, "", 0)
    BlzFrameSetLevel(fr, lvl)
    BlzFrameSetAbsPoint(fr, FRAMEPOINT_CENTER, centerX, centerY)
    BlzFrameSetSize(fr, size, size)
    BlzFrameSetText(fr, text)
    BlzFrameSetEnable(fr, false)
    BlzFrameSetScale(fr, 1)
    BlzFrameSetTextAlignment(fr, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
    return fr
end

function FrameLib.CreateTextTwoPoints(parent, x1, y1, x2, y2, text, lvl)
    local fr = BlzCreateFrameByType("TEXT", "", parent, "", 0)
    BlzFrameSetLevel(fr, lvl)
    BlzFrameSetAbsPoint(fr, FRAMEPOINT_TOPLEFT, x1, y1)
    BlzFrameSetAbsPoint(fr, FRAMEPOINT_BOTTOMRIGHT, x2, y2)
    BlzFrameSetText(fr, text)
    BlzFrameSetEnable(fr, false)
    BlzFrameSetScale(fr, 1)
    BlzFrameSetTextAlignment(fr, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
    return fr
end

function FrameLib.ClickBlocker()
    local fr = FrameLib.CreateText(BlzGetFrameByName("ConsoleUIBackdrop", 0), 0.4, 0.3, 1.2, "", 1)
    BlzFrameSetEnable(fr, true)
end

function FrameLib.createSprite(model, cam, x, y, scale, parent, lvl)
    local fr = BlzCreateFrameByType("SPRITE", "", parent, "", 0)
    BlzFrameSetAbsPoint(fr, FRAMEPOINT_CENTER, x, y)
    BlzFrameSetLevel(fr, lvl)
    BlzFrameSetSize(fr, 0.001, 0.001)
    BlzFrameSetModel(fr, model, cam)
    BlzFrameSetScale(fr, scale)
    return fr
end

function FrameLib.flashEffect()
    DisplayCineFilter(false)

    local colorDuration = 0.25
    local t1, t2, t3, t4 = CreateTimer(), CreateTimer(), CreateTimer(), CreateTimer()
    local mask = "ReplaceableTextures\\CameraMasks\\White_mask"

    CinematicFilterGenericBJ( colorDuration, BLEND_MODE_BLEND, mask, 0.00, 0.00, 0.00, 0.00, 75.00, 75.00, 35.00, 0 )

    TimerStart(t1, colorDuration+0.05, false, function()
        CinematicFilterGenericBJ( colorDuration, BLEND_MODE_BLEND, mask, 75.00, 75.00, 35.0, 0.00, 35.00, 75.00, 35.00, 0 )
        DestroyTimer(t1)
    end)

    TimerStart(t2, (colorDuration+0.05)*2, false, function()
        CinematicFilterGenericBJ( colorDuration, BLEND_MODE_BLEND, mask, 35.00, 75.00, 35.00, 0.00, 35.00, 35.00, 75.00, 0 )
        DestroyTimer(t2)
    end)

    TimerStart(t3, (colorDuration+0.05)*3, false, function()
        local dur = 2
        CinematicFilterGenericBJ( dur, BLEND_MODE_BLEND, mask, 35.00, 35.00, 75.00, 0, 0, 0.00, 0.00, 100 )
        TimerStart(t4, false, dur, function()
            DisplayCineFilter(false)
            DestroyTimer(t4)
        end)
        DestroyTimer(t3)
    end)
end

