UI = {}


function UI.load()
    UI.hideDefault()
    UI.initCustomUI()
    UI.setMusic()
end

function UI.hideDefault()
    FrameLib.HideDefaultUI()
end

function UI.initCustomUI()
    Field.create()
    FrameLib.ClickBlocker()
end

function UI.setMusic()
    StopMusicBJ(false)
    ClearMapMusicBJ()
    local path = "Music\\BRD_-_Teleport_Prokg"
    local filename = path:gsub("Music\\", "")
    local filename = filename:gsub("_", " ")
    PlayMusic(path)
    UI.setMusicTitle(filename)
end

function UI.setMusicTitle(filename)
    local world = BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0)
    local text = FrameLib.CreateText(world, 0.105, Field.startPoint.y + 0.144, 0.2, "Playing Now:  "..filename, 5)
    BlzFrameSetScale(text, 1.5)
    BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_BOTTOM, TEXT_JUSTIFY_MIDDLE)
    UI.funnySprite(0.105, Field.startPoint.y + 0.05)
end

function UI.funnySprite(x, y)
    local world = BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0)
    local fr = BlzCreateFrameByType("SPRITE", "SpriteName", world, "", 0)
    BlzFrameSetAbsPoint(fr, FRAMEPOINT_CENTER, x, y)
    BlzFrameSetLevel(fr, 6)
    BlzFrameSetSize(fr, 0.001, 0.001)
    BlzFrameSetModel(fr, "dance", 1)
    BlzFrameSetScale(fr, 0.55)
end