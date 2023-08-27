Music = {}

function Music.setMusic()
    StopMusic(false)
    ClearMapMusic()
    local path = "Music\\BRD_-_Teleport_Prokg"
    PlayMusic(path)
    CustomFrames.setMusicTitle(path)
end
 function Music.ambientOff()
     VolumeGroupSetVolume( SOUND_VOLUMEGROUP_AMBIENTSOUNDS, 0.00 )
 end