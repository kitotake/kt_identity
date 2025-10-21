--ESX = exports["es_extended"]:getSharedObject()
ESX = nil
local isMenuOpen = false
local currentCharacter = nil

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports['es_extended']:getSharedObject()
        Citizen.Wait(100)
    end
    
    if Config.Debug then
        print('^2[KT Identity Client]^7 ESX initialized')
    end
end)

RegisterNetEvent('kt_identity:receiveMenuData')
AddEventHandler('kt_identity:receiveMenuData', function(data)
    if Config.Debug then
        print('^2[KT Identity Client]^7 Received menu data with ' .. #data.characters .. ' characters')
    end
    
    Citizen.Wait(100)
    
    SetNuiFocus(true, true)
    isMenuOpen = true
    
    SendNUIMessage({
        action = 'openMenu',
        data = data
    })
end)

RegisterNetEvent('kt_identity:spawnPlayer')
AddEventHandler('kt_identity:spawnPlayer', function(character)
    if Config.Debug then
        print('^2[KT Identity Client]^7 Spawning player')
    end
    
    currentCharacter = character
    
    SetNuiFocus(false, false)
    isMenuOpen = false
    
    SendNUIMessage({
        action = 'closeMenu'
    })
    
    DoScreenFadeOut(500)
    Wait(500)
    
    local ped = PlayerPedId()
    
    SetEntityVisible(ped, true, false)
    SetEntityCollision(ped, true, false)
    FreezeEntityPosition(ped, false)
    
    SetEntityCoords(ped, Config.DefaultSpawn.x, Config.DefaultSpawn.y, Config.DefaultSpawn.z, false, false, false, true)
    SetEntityHeading(ped, 0.0)
    
    Wait(500)
    DoScreenFadeIn(500)
    
    Wait(1000)
    TriggerEvent('esx:onPlayerSpawn')
    TriggerServerEvent('esx:onPlayerSpawn')

    if Config.UseAppearance then
        Wait(1000)
        if GetResourceState('fivem-appearance') == 'started' then
            exports['fivem-appearance']:startPlayerCustomization(function(appearance)
                if appearance then
                    TriggerServerEvent('fivem-appearance:save', appearance)
                end
            end)
        elseif GetResourceState('esx_skin') == 'started' then
            local sex = character.sex == 'm' and 0 or 1
            TriggerEvent('skinchanger:loadSkin', {sex = sex})
            TriggerEvent('esx_skin:openSaveableMenu')
        end
    end
end)

RegisterNUICallback('selectCharacter', function(data, cb)
    if Config.Debug then
        print('^2[KT Identity Client]^7 Character selected: ' .. data.characterId)
    end
    
    TriggerServerEvent('kt_identity:selectCharacter', data.characterId)
    cb('ok')
end)

RegisterNUICallback('createCharacter', function(data, cb)
    if Config.Debug then
        print('^2[KT Identity Client]^7 Creating character: ' .. data.firstname .. ' ' .. data.lastname)
    end
    
    TriggerServerEvent('kt_identity:createCharacter', data)
    cb('ok')
end)

RegisterNUICallback('deleteCharacter', function(data, cb)
    if Config.Debug then
        print('^2[KT Identity Client]^7 Deleting character: ' .. data.characterId)
    end
    
    TriggerServerEvent('kt_identity:deleteCharacter', data.characterId)
    cb('ok')
end)

RegisterNUICallback('closeMenu', function(data, cb)
    if Config.Debug then
        print('^2[KT Identity Client]^7 Menu closed')
    end
    
    SetNuiFocus(false, false)
    isMenuOpen = false
    cb('ok')
end)

RegisterNUICallback('escape', function(data, cb)
    if Config.Debug then
        print('^2[KT Identity Client]^7 Menu closed via ESC')
    end
    
    SetNuiFocus(false, false)
    isMenuOpen = false
    cb('ok')
end)

RegisterCommand('identity', function()
    TriggerServerEvent('kt_identity:openMenu')
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if isMenuOpen then
            DisableAllControlActions(0)
            
            local ped = PlayerPedId()
            if not IsEntityVisible(ped) then
                SetEntityVisible(ped, false, false)
                SetEntityCollision(ped, false, false)
                FreezeEntityPosition(ped, true)
            end
        else
            Citizen.Wait(500)
        end
    end
end)

exports('GetCurrentCharacter', function()
    return currentCharacter
end)

exports('IsMenuOpen', function()
    return isMenuOpen
end)