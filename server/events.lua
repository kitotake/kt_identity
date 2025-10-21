ESX = exports["es_extended"]:getSharedObject()

---@param title string Log title
---@param description string Log description
---@param color number Embed color
local function SendDiscordLog(title, description, color)
    if not Config.DiscordLogs or Config.DiscordWebhook == "YOUR_WEBHOOK_URL_HERE" then
        return
    end

    PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({
        embeds = {{
            title = title,
            description = description,
            color = color,
            footer = {
                text = "KT Identity System • " .. os.date("%d/%m/%Y %H:%M:%S")
            }
        }}
    }), {['Content-Type'] = 'application/json'})
end

---@param playerId number Player source
function OpenCharacterMenu(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    
    if not xPlayer then
        if Config.Debug then
            print('^3[KT Identity]^7 ESX Player not found for source: ' .. playerId)
        end
        return
    end

    local menuData = GetMenuData(playerId)
    
    TriggerClientEvent('kt_identity:receiveMenuData', playerId, menuData)
    
    if Config.LogActions then
        print(string.format(
            '^2[KT Identity]^7 Menu opened for: %s (%s) - %d/%d characters - Group: %s',
            xPlayer.getName(),
            xPlayer.identifier,
            #menuData.characters,
            menuData.maxCharacters,
            menuData.playerGroup
        ))
    end
end

RegisterNetEvent('kt_identity:openMenu')
AddEventHandler('kt_identity:openMenu', function(targetSource)
    local source = targetSource or source
    OpenCharacterMenu(source)
end)

RegisterNetEvent('kt_identity:selectCharacter')
AddEventHandler('kt_identity:selectCharacter', function(characterId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then
        if Config.Debug then
            print('^3[KT Identity]^7 xPlayer not found for source: ' .. source)
        end
        return
    end

    local character = GetCharacter(characterId, xPlayer.identifier)
    
    if not character then
        TriggerClientEvent('esx:showNotification', source, Config.GetMessage('invalid_data', 'Personnage introuvable'))
        return
    end

    local success = LoadESXCharacter(source, character)
    
    if success then
        local message = Config.GetMessage('character_selected', character.firstname, character.lastname)
        TriggerClientEvent('esx:showNotification', source, message)
        
        Wait(1000)
        TriggerClientEvent('kt_identity:spawnPlayer', source, character)
        
        SendDiscordLog(
            "🎮 Personnage Sélectionné",
            string.format(
                "**Joueur:** %s (%s)\n**Personnage:** %s %s\n**ID:** %d\n**Groupe:** %s",
                xPlayer.getName(),
                xPlayer.identifier,
                character.firstname,
                character.lastname,
                character.id,
                xPlayer.getGroup()
            ),
            3066993 -- Vert
        )
    else
        TriggerClientEvent('esx:showNotification', source, '~r~Erreur lors du chargement du personnage')
    end
end)

RegisterNetEvent('kt_identity:createCharacter')
AddEventHandler('kt_identity:createCharacter', function(data)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then
        if Config.Debug then
            print('^3[KT Identity]^7 xPlayer not found for source: ' .. source)
        end
        return
    end

    local canCreate, reason = CanCreateNewCharacter(source)
    
    if not canCreate then
        TriggerClientEvent('esx:showNotification', source, '~r~' .. reason)
        
        if Config.LogActions then
            print(string.format(
                '^3[KT Identity]^7 Character creation denied for %s (%s): %s',
                xPlayer.getName(),
                xPlayer.getGroup(),
                reason
            ))
        end
        return
    end

    local valid, error = ValidateCharacterData(data, xPlayer.identifier)
    
    if not valid then
        TriggerClientEvent('esx:showNotification', source, '~r~' .. error)
        return
    end

    local characterId = CreateCharacter(xPlayer.identifier, data)
    
    if characterId then
        TriggerClientEvent('esx:showNotification', source, Config.GetMessage('character_created'))
        
        Wait(500)
        
        local menuData = GetMenuData(source)
        TriggerClientEvent('kt_identity:receiveMenuData', source, menuData)
        
        if Config.LogActions then
            print(string.format(
                '^2[KT Identity]^7 Character created: %s %s (ID: %s) by %s (%s) [%s]',
                data.firstname,
                data.lastname,
                characterId,
                xPlayer.getName(),
                xPlayer.identifier,
                xPlayer.getGroup()
            ))
        end
       
        SendDiscordLog(
            "✨ Nouveau Personnage",
            string.format(
                "**Joueur:** %s (%s)\n**Personnage:** %s %s\n**ID:** %d\n**Genre:** %s\n**Nationalité:** %s\n**Groupe:** %s",
                xPlayer.getName(),
                xPlayer.identifier,
                data.firstname,
                data.lastname,
                characterId,
                data.gender == 'male' and 'Homme' or 'Femme',
                data.nationality,
                xPlayer.getGroup()
            ),
            5763719 -- Bleu
        )
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
        TriggerClientEvent('esx:showNotification', source, Config.GetMessage('character_deleted'))
        
        Wait(500)
        
        local menuData = GetMenuData(source)
        TriggerClientEvent('kt_identity:receiveMenuData', source, menuData)
        
        if Config.LogActions then
            print(string.format(
                '^1[KT Identity]^7 Character deleted: %s %s (ID: %d) by %s (%s) [%s]',
                character.firstname,
                character.lastname,
                characterId,
                xPlayer.getName(),
                xPlayer.identifier,
                xPlayer.getGroup()
            ))
        end
        
        SendDiscordLog(
            "🗑️ Personnage Supprimé",
            string.format(
                "**Joueur:** %s (%s)\n**Personnage:** %s %s\n**ID:** %d\n**Groupe:** %s",
                xPlayer.getName(),
                xPlayer.identifier,
                character.firstname,
                character.lastname,
                characterId,
                xPlayer.getGroup()
            ),
            15158332 -- Rouge
        )
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
        Wait(100)
        local maxChars = GetMaxCharactersForPlayer(source)
        print(string.format(
            '^2[KT Identity]^7 Player connecting: %s (Max characters: %d)',
            identifier,
            maxChars
        ))
    end
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    if Config.Debug then
        local maxChars = GetMaxCharactersForPlayer(playerId)
        print(string.format(
            '^2[KT Identity]^7 ESX Player loaded: %s (%s) - Max: %d - Group: %s',
            xPlayer.getName(),
            xPlayer.identifier,
            maxChars,
            xPlayer.getGroup()
        ))
    end
    
    Wait(2000)
    
    local characters = GetPlayerCharacters(xPlayer.identifier)
    
    if #characters == 0 then
        if Config.LogActions then
            print('^2[KT Identity]^7 No characters found, opening menu for: ' .. xPlayer.getName())
        end
        OpenCharacterMenu(playerId)
    else
        local activeChar = GetActiveCharacter(xPlayer.identifier)
        
        if Config.AutoLoadLastCharacter and activeChar then
            if Config.LogActions then
                print('^2[KT Identity]^7 Auto-loading last character for: ' .. xPlayer.getName())
            end
            LoadESXCharacter(playerId, activeChar)
            TriggerClientEvent('kt_identity:spawnPlayer', playerId, activeChar)
        else
            if Config.LogActions then
                print('^2[KT Identity]^7 Opening character selection for: ' .. xPlayer.getName())
            end
            OpenCharacterMenu(playerId)
        end
    end
end)

RegisterCommand('identity', function(source, args)
    if source > 0 then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            OpenCharacterMenu(source)
        end
    end
end, false)

RegisterCommand('kt_identity_open', function(source, args)
    if source > 0 then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer and (xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin') then
            local targetId = tonumber(args[1]) or source
            OpenCharacterMenu(targetId)
        end
    end
end, true)

if Config.EnableTestCommands then
    RegisterCommand('kt_identity_info', function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer or (xPlayer.getGroup() ~= 'admin' and xPlayer.getGroup() ~= 'superadmin') then
            return
        end
        
        local targetId = tonumber(args[1]) or source
        local targetPlayer = ESX.GetPlayerFromId(targetId)
        
        if not targetPlayer then
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"[KT Identity]", "Joueur introuvable"}
            })
            return
        end
        
        local characters = GetPlayerCharacters(targetPlayer.identifier)
        local maxChars = GetMaxCharactersForPlayer(targetId)
        local canCreate, reason = CanCreateNewCharacter(targetId)
        
        local info = string.format([[
^3=== KT Identity Info ===^0
^2Joueur:^0 %s (%s)
^2Identifier:^0 %s
^2Groupe:^0 %s
^2Personnages:^0 %d/%d
^2Peut créer:^0 %s
%s
^3=====================^0
        ]], 
            targetPlayer.getName(),
            targetId,
            targetPlayer.identifier,
            targetPlayer.getGroup(),
            #characters,
            maxChars,
            canCreate and "Oui" or "Non",
            not canCreate and "^1Raison: " .. reason .. "^0" or ""
        )
        
        print(info)
        
        if #characters > 0 then
            print("^2Personnages:^0")
            for i, char in ipairs(characters) do
                print(string.format(
                    "  %d. %s %s (ID: %d) - %s",
                    i,
                    char.firstname,
                    char.lastname,
                    char.id,
                    char.is_active == 1 and "^2[ACTIF]^0" or ""
                ))
            end
        end
    end, true)
end

if Config.EnableTestCommands then
    RegisterCommand('kt_identity_whitelist', function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer or xPlayer.getGroup() ~= 'superadmin' then
            return
        end
        
        if not args[1] or not args[2] then
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 165, 0},
                args = {"[KT Identity]", "Usage: /kt_identity_whitelist [player_id] [max_characters]"}
            })
            return
        end
        
        local targetId = tonumber(args[1])
        local maxChars = tonumber(args[2])
        
        if not targetId or not maxChars or maxChars < 1 or maxChars > 20 then
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                args = {"[KT Identity]", "Paramètres invalides"}
            })
            return
        end
        
        local targetPlayer = ESX.GetPlayerFromId(targetId)
        if not targetPlayer then
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                args = {"[KT Identity]", "Joueur introuvable"}
            })
            return
        end
        
        Config.ManualWhitelist[targetPlayer.identifier] = maxChars
        
        TriggerClientEvent('chat:addMessage', source, {
            color = {0, 255, 0},
            args = {"[KT Identity]", string.format(
                "%s ajouté à la whitelist avec %d personnage(s) max",
                targetPlayer.getName(),
                maxChars
            )}
        })
        
        print(string.format(
            '^2[KT Identity]^7 %s added %s to whitelist with %d max characters',
            xPlayer.getName(),
            targetPlayer.getName(),
            maxChars
        ))
        
        SendDiscordLog(
            "⚙️ Whitelist Modifiée",
            string.format(
                "**Admin:** %s\n**Joueur:** %s (%s)\n**Max Personnages:** %d",
                xPlayer.getName(),
                targetPlayer.getName(),
                targetPlayer.identifier,
                maxChars
            ),
            16776960 -- Orange
        )
    end, true)
end