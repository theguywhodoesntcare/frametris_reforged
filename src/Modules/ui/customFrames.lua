CustomFrames = {}
CustomFrames.musicTitle = nil

function CustomFrames.init()
    FrameLib.ClickBlocker()
    BlzFrameSetVisible(BlzGetFrameByName("UpperButtonBarFrame",0), true)
    CustomFrames.createMusicPanel()
end

function CustomFrames.createMusicPanel()
    local world = BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0)
    local panel = FrameLib.CreateBackdropTwoPoints(world, 0, Field.startPoint.x - 0.01, Field.startPoint.y - Field.defThickness, 0.2, "transp", "name", 2)
    BlzFrameSetVisible(panel, true)

    local text = FrameLib.CreateText(panel, 0.105, Field.startPoint.y + 0.144, 0.2, "Now Playing:  ", 1)
    BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_BOTTOM, TEXT_JUSTIFY_LEFT)
    BlzFrameClearAllPoints(text)
    BlzFrameSetScale(text, 1.4)
    BlzFrameSetPoint(text, FRAMEPOINT_BOTTOMLEFT, panel, FRAMEPOINT_BOTTOMLEFT, 0, 0)
    CustomFrames.musicTitle = text

    local sprite = FrameLib.createSprite("dance", 1, 0.4, 0.3, 0.55, panel, 2)
    BlzFrameClearAllPoints(sprite)
    BlzFrameSetPoint(sprite, FRAMEPOINT_CENTER, panel, FRAMEPOINT_LEFT, 0.05, -0.05)
end

function CustomFrames.setMusicTitle(path)
    local filename = path:gsub("Music\\", "")
    local filename = filename:gsub("_", " ")

    BlzFrameSetText(CustomFrames.musicTitle, "Now Playing:  "..filename)
end