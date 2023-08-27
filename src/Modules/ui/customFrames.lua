CustomFrames = {}
CustomFrames.musicTitle = nil
CustomFrames.lost = nil
CustomFrames.stats = nil
CustomFrames.score = nil

function CustomFrames.init()
    FrameLib.ClickBlocker()
    CustomFrames.createMusicPanel()
    CustomFrames.createArt()
    CustomFrames.lostFrame()
    CustomFrames.createStatsFrame()
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
    CustomFrames.displayControls()
end

function CustomFrames.displayControls()
    local world = BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0)
    local text = "Controls:|n|n|cffffff00A|r — Move Left, |cffffff00D|r — Move Right|n|n|cffffff00Q|r — Rotate CCW, |cffffff00W|r — Rotate CW|n|n|cffffff00S|r — Soft Drop, |cffffff00SPACE|r — Hard Drop"
    local textFrame = FrameLib.CreateText(world, 0.11, 0.3, 0.2, text, 2)
    BlzFrameSetScale(textFrame, 1.25)
end

function CustomFrames.createArt()
    local world = BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0)
    local texture = "ui\\glues\\scorescreen\\scorescreen-orcvictoryexpansion\\scorescreen-orcvictoryexpansion"
    local fr = FrameLib.CreateBackdropTwoPoints(world, 0.5, 0.8, 0.15, 0.45, texture, "", 2)
    BlzFrameSetVisible(fr, true)
end

function CustomFrames.lostFrame()
    local world = BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0)
    local background = FrameLib.CreateBackdrop(world, 0.4, 0.3, 0.2, "textures\\black32", "", 4)
    local text = "|cffff0000You lose!|nPress|r |cffffff00ESC|r |cffff0000to restart|r"
    local textFrame = FrameLib.CreateText(background, 0.4, 0.3, 0.25, text, 1)

    BlzFrameSetVisible(textFrame, true)
    BlzFrameSetScale(textFrame, 2.75)
    CustomFrames.lost = background
end

function CustomFrames.setLose(flag)
    BlzFrameSetVisible(CustomFrames.lost, flag)
end

function CustomFrames.createStatsFrame()
    local world = BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0)
    local x2 = Field.startPoint.x + Field.columns * Field.cellsize + Field.defThickness
    local x1 = Field.startPoint.x - Field.defThickness
    local y1 = Field.startPoint.y + Field.rows * Field.cellsize + Field.defThickness
    local y2 = y1 + 0.02
    local text = FrameLib.CreateTextTwoPoints(world, x1, y2, x2, y1, "|cffffff00SCORE|r:  000000", 5)
    BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_RIGHT)
    BlzFrameSetScale(text, 1.5)
    CustomFrames.score = text
end