-- Ouvrir le menu
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

-- Sélectionner un personnage
RegisterNUICallback('selectCharacter', function(data, cb)
    print('Personnage sélectionné:', data.characterId)
    SetNuiFocus(false, false)
    
    -- Votre logique ici
    TriggerServerEvent('kt_identity:selectCharacter', data.characterId)
    
    cb('ok')
end)

-- Créer un personnage
RegisterNUICallback('createCharacter', function(data, cb)
    print('Création personnage:', json.encode(data))
    
    -- Votre logique ici
    TriggerServerEvent('kt_identity:createCharacter', data)
    
    cb('ok')
end)

-- Supprimer un personnage
RegisterNUICallback('deleteCharacter', function(data, cb)
    print('Suppression personnage:', data.characterId)
    
    -- Votre logique ici
    TriggerServerEvent('kt_identity:deleteCharacter', data.characterId)
    
    cb('ok')
end)

-- Fermer le menu
RegisterNUICallback('closeMenu', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

-- Fermer avec ESC
RegisterNUICallback('escape', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)