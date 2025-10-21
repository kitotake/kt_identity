local cam

function OpenCharacterCamera()
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(cam, -268.0, -957.6, 33.5)
    PointCamAtCoord(cam, -268.0, -957.6, 31.2)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)
end

function CloseCharacterCamera()
    RenderScriptCams(false, true, 500, true, true)
    DestroyCam(cam)
end
