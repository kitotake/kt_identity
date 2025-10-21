RegisterNetEvent('kt_identity:openMenu')
AddEventHandler('kt_identity:openMenu', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then
        if Config.Debug then
            print('^3[KT Identity]^7 ESX Player not found for source: ' .. source)
        end
        return
    end

    local menuData = GetMenuData(xPlayer.identifier)
    
    TriggerClientEvent('kt_identity:receiveMenuData', source, menuData)
    
    if Config.Debug then
        print(string.format(
            '^2[KT Identity]^7 Menu opened for: %s (%d/%d characters) - Can create: %s',
            xPlayer.identifier,
            #menuData.characters,
            menuData.maxCharacters,
            menuData.canCreateMore and 'Yes' or 'No'
        ))
    end
end)

RegisterNetEvent('kt_identity:selectCharacter')
AddEventHandler('kt_identity:selectCharacter', function(characterId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then
        return
    end

    local character = GetCharacter(characterId, xPlayer.identifier)
    
    if not character then
        TriggerClientEvent('esx:showNotification', source, '~r~Erreur: Personnage introuvable')
        return
    end

    local success = LoadESXCharacter(source, character)
    
    if success then
        TriggerClientEvent('esx:showNotification', source, '~g~Bienvenue ' .. character.firstname .. ' ' .. character.lastname)
        
        Citizen.Wait(1000)
        
        TriggerClientEvent('kt_identity:spawnPlayer', source, character)
        
        if Config.Debug then
            print('^2[KT Identity]^7 Character loaded: ' .. character.firstname .. ' ' .. character.lastname .. ' (ID: ' .. character.id .. ')')
        end
    else
        TriggerClientEvent('esx:showNotification', source, '~r~Erreur lors du chargement du personnage')
    end
end)

RegisterNetEvent('kt_identity:createCharacter')
AddEventHandler('kt_identity:createCharacter', function(data)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then
        return
    end

    if not CanCreateNewCharacter(xPlayer.identifier) then
        local maxChars = GetMaxCharactersForPlayer(xPlayer.identifier)
        TriggerClientEvent('esx:showNotification', source, '~r~Vous avez atteint la limite de ' .. maxChars .. ' personnage(s)')
        
        if Config.Debug then
            print(string.format('^3[KT Identity]^7 Character creation denied for %s: limit reached', xPlayer.identifier))
        end
        return
    end

    local valid, error = ValidateCharacterData(data)
    
    if not valid then
        TriggerClientEvent('esx:showNotification', source, '~r~Erreur: ' .. error)
        return
    end

    local characterId = CreateCharacter(xPlayer.identifier, data)
    
    if characterId then
        TriggerClientEvent('esx:showNotification', source, '~g~Personnage créé avec succès!')
        
        Citizen.Wait(500)
        
        local menuData = GetMenuData(xPlayer.identifier)
        TriggerClientEvent('kt_identity:receiveMenuData', source, menuData)
        
        if Config.Debug then
            print(string.format(
                '^2[KT Identity]^7 Character created: %s %s (ID: %s) for %s',
                data.firstname,
                data.lastname,
                characterId,
                xPlayer.identifier
            ))
        end
    else
        TriggerClientEvent('esx:showNotification', source, '~r~Erreur lors de la création du personnage')
    end
end)

RegisterNetEvent('kt_identity:deleteCharacter')
AddEventHandler('kt_identity:deleteCharacter', function(characterId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then
        return
    end

    local character = GetCharacter(characterId, xPlayer.identifier)
    
    if not character then
        TriggerClientEvent('esx:showNotification', source, '~r~Personnage introuvable')
        return
    end

    local success = DeleteCharacter(xPlayer.identifier, characterId)
    
    if success then
        TriggerClientEvent('esx:showNotification', source, '~g~Personnage supprimé')
        
        Citizen.Wait(500)
        
        local menuData = GetMenuData(xPlayer.identifier)
        TriggerClientEvent('kt_identity:receiveMenuData', source, menuData)
        
        if Config.Debug then
            print('^2[KT Identity]^7 Character deleted: ' .. character.firstname .. ' ' .. character.lastname .. ' (ID: ' .. characterId .. ')')
        end
    else
        TriggerClientEvent('esx:showNotification', source, '~r~Erreur lors de la suppression')
    end
end)

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local source = source
    local identifiers = GetPlayerIdentifiers(source)
    local identifier = nil
    
    for _, id in ipairs(identifiers) do
        if string.match(id, 'license:') then
            identifier = id
            break
        end
    end
    
    if identifier and Config.Debug then
        local maxChars = GetMaxCharactersForPlayer(identifier)
        print(string.format('^2[KT Identity]^7 Player connecting: %s (Max characters: %d)', identifier, maxChars))
    end
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    if Config.Debug then
        local maxChars = GetMaxCharactersForPlayer(xPlayer.identifier)
        print(string.format('^2[KT Identity]^7 ESX Player loaded: %s (Max characters: %d)', xPlayer.identifier, maxChars))
    end
    
    local characters = GetPlayerCharacters(xPlayer.identifier)
    
    Citizen.Wait(2000)
    
    if #characters == 0 then
        TriggerEvent('kt_identity:openMenu', playerId)
    else
        local activeChar = GetActiveCharacter(xPlayer.identifier)
        
        if not activeChar then
            TriggerEvent('kt_identity:openMenu', playerId)
        else
            if Config.AutoLoadLastCharacter then
                LoadESXCharacter(playerId, activeChar)
                TriggerClientEvent('kt_identity:spawnPlayer', playerId, activeChar)
            else
                TriggerEvent('kt_identity:openMenu', playerId)
            end
        end
    end
end)