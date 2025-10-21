-- ====================================
-- COMMANDES DE TEST (À ajouter temporairement)
-- ====================================

-- Test 1: Forcer l'ouverture du NUI
RegisterCommand('testnui', function()
    print('^2[TEST]^7 Forcing NUI open...')
    
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        action = 'openMenu',
        data = {
            characters = {},
            maxCharacters = 5,
            availableNationalities = {'Française', 'Américaine'},
            canCreateMore = true,
            playerGroup = 'admin'
        }
    })
    
    print('^2[TEST]^7 NUI message sent')
    print('^3[TEST]^7 Ouvrez F12 pour voir les logs du NUI')
end, false)

-- Test 2: Vérifier si le NUI répond
RegisterCommand('testnuiresponse', function()
    print('^2[TEST]^7 Testing NUI callback...')
    
    -- Simuler un message du NUI
    ExecuteCommand('testnuicallback')
end, false)

RegisterNUICallback('test', function(data, cb)
    print('^2[TEST]^7 NUI callback received!')
    print('^2[TEST]^7 Data:', json.encode(data))
    cb('ok')
end)

-- Test 3: Afficher les infos de débogage
RegisterCommand('identitydebug', function()
    print('^3=== KT Identity Debug ===^0')
    print('^2ESX Status:^0', ESX ~= nil and 'Initialized' or 'Not initialized')
    
    if ESX then
        local xPlayer = ESX.GetPlayerData()
        if xPlayer then
            print('^2Player Name:^0', xPlayer.name or 'N/A')
            print('^2Player Identifier:^0', xPlayer.identifier or 'N/A')
        end
    end
    
    print('^2Menu Open:^0', tostring(exports['kt_identity']:IsMenuOpen()))
    print('^3========================^0')
end, false)

-- Test 4: Fermer le NUI
RegisterCommand('closenui', function()
    print('^2[TEST]^7 Closing NUI...')
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'closeMenu'
    })
end, false)

-- Test 5: Vérifier les fichiers NUI
RegisterCommand('checknui', function()
    print('^3=== NUI Files Check ===^0')
    print('^2Resource Name:^0', GetCurrentResourceName())
    print('^2Resource Path:^0', GetResourcePath(GetCurrentResourceName()))
    print('^3======================^0')
    print('^3Ouvrez F8 et tapez:^0 resmon')
    print('^3Vérifiez que "kt_identity" apparaît dans la liste^0')
end, false)