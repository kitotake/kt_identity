RegisterNetEvent('kt_identity:spawnCharacter', function(data)
    local ped = PlayerPedId()

    SetEntityCoords(ped, data.coords or Config.DefaultSpawn)
    SetEntityHeading(ped, data.heading or 0.0)

    if Config.UseAppearance then
        TriggerEvent('esx_skin:loadSkin', json.decode(data.skin))
    end
end)
