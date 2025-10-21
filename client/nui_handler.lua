RegisterCommand('openmenu', function()
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        action = 'openMenu',
        data = {
            characters = {
                {
                    id = 1,
                    firstname = 'John',
                    lastname = 'Doe',
                    dateofbirth = '1990-05-15',
                    gender = 'male',
                    height = 180
                },
                {
                    id = 2,
                    firstname = 'Jane',
                    lastname = 'Smith',
                    dateofbirth = '1995-08-22',
                    gender = 'female',
                    height = 165
                }
            },
            maxCharacters = 5
        }
    })
end)

RegisterNUICallback('selectCharacter', function(data, cb)
    print('Personnage sélectionné:', data.characterId)
    SetNuiFocus(false, false)
    
    TriggerServerEvent('kt_identity:selectCharacter', data.characterId)
    
    cb('ok')
end)

RegisterNUICallback('createCharacter', function(data, cb)
    print('Création personnage:', json.encode(data))
    
    TriggerServerEvent('kt_identity:createCharacter', data)
    
    cb('ok')
end)

RegisterNUICallback('deleteCharacter', function(data, cb)
    print('Suppression personnage:', data.characterId)
    
    TriggerServerEvent('kt_identity:deleteCharacter', data.characterId)
    
    cb('ok')
end)

RegisterNUICallback('closeMenu', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('escape', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)