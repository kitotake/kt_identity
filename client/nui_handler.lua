RegisterNUICallback('selectCharacter', function(data, cb)
    TriggerServerEvent('kt_identity:selectCharacter', data.charId)
    cb('ok')
end)

RegisterNUICallback('createCharacter', function(data, cb)
    TriggerServerEvent('kt_identity:createCharacter', data)
    cb('ok')
end)

RegisterNUICallback('deleteCharacter', function(data, cb)
    TriggerServerEvent('kt_identity:deleteCharacter', data.charId)
    cb('ok')
end)

RegisterCommand('reloadchar', function()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'openCharacterMenu' })
end)
