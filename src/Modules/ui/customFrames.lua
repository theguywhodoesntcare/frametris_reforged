CustomFrames = {}
CustomFrames.musicTitle = nil
CustomFrames.lost = nil
CustomFrames.stats = nil
CustomFrames.score = nil
CustomFrames.defScoreString = "|cffffff00HIGH SCORE|r:  000000     |cffffff00SCORE|r:  000000"

function CustomFrames.init()
    FrameLib.ClickBlocker()
    CustomFrames.createMusicPanel()
    CustomFrames.createArt()
    CustomFrames.lostFrame()
    CustomFrames.createStatsFrame()
end

function CustomFrames.createMusicPanel()
    local panel = FrameLib.CreateBackdropTwoPoints(FrameLib.world(), 0, Field.startPoint.x - 0.01, Field.startPoint.y - Field.defThickness, 0.2, "transp", "name", 2)
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
    local text = "Controls:|n|n" ..
            "|cffffff00" .. osKeys[Keys.leftKey] .. "|r — Move Left, " ..
            "|cffffff00" .. osKeys[Keys.rightKey] .. "|r — Move Right|n|n" ..
            "|cffffff00" .. osKeys[Keys.rotateLeftKey] .. "|r — Rotate CCW, " ..
            "|cffffff00" .. osKeys[Keys.rotateRightKey] .. "|r — Rotate CW|n|n" ..
            "|cffffff00" .. osKeys[Keys.softDropKey] .. " (hold)|r — Soft Drop, " ..
            "|cffffff00" .. osKeys[Keys.hardDropKey] .. "|r — Hard Drop"
    local textFrame = FrameLib.CreateText(FrameLib.world(), 0.11, 0.3, 0.2, text, 2)
    BlzFrameSetScale(textFrame, 1.20)
end

function CustomFrames.createArt()
    local texture = "ui\\glues\\scorescreen\\scorescreen-orcvictoryexpansion\\scorescreen-orcvictoryexpansion"
    local fr = FrameLib.CreateBackdropTwoPoints(FrameLib.world(), 0.5, 0.8, 0.15, 0.45, texture, "", 2)
    BlzFrameSetVisible(fr, true)
end

function CustomFrames.lostFrame()
    local background = FrameLib.CreateBackdrop(FrameLib.world(), 0.4, 0.3, 0.25, "textures\\black32", "", 4)
    local text = "|cffff0000You lose!|nPress|r |cffffff00"..osKeys[Keys.restartKey].."|r |cffff0000to restart|r"
    local textFrame = FrameLib.CreateText(background, 0.4, 0.3, 0.25, text, 1)

    BlzFrameSetVisible(textFrame, true)
    BlzFrameSetScale(textFrame, 2.25)
    CustomFrames.lost = background
end

function CustomFrames.setLose(flag)
    BlzFrameSetVisible(CustomFrames.lost, flag)
end

function CustomFrames.createStatsFrame()
    local x2 = Field.startPoint.x + Field.columns * Field.cellsize + Field.defThickness
    local x1 = Field.startPoint.x - Field.defThickness
    local y1 = Field.startPoint.y + Field.rows * Field.cellsize + Field.defThickness
    local y2 = y1 + 0.0154
    local text = FrameLib.CreateTextTwoPoints(FrameLib.world(), x1, y2, x2, y1, CustomFrames.defScoreString, 5)
    BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_RIGHT)
    BlzFrameSetScale(text, 1.15)
    CustomFrames.score = text
end