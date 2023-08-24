Music = {}

function Music.setMusic()
    StopMusicBJ(false)
    ClearMapMusicBJ()
    local path = "Music\\BRD_-_Teleport_Prokg"
    PlayMusic(path)
    CustomFrames.setMusicTitle(path)
end