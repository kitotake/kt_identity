-- Initialisation ESX
ESX = exports["es_extended"]:getSharedObject()


-- Vérification au démarrage
Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(100)
    end
    
    if Config.Debug then
        print('^2[KT Identity]^7 ESX initialized successfully')
        print('^2[KT Identity]^7 Version: 1.5.0')
        print('^2[KT Identity]^7 Max Characters: ' .. Config.DefaultMaxCharacters)
        print('^2[KT Identity]^7 Limited Mode: ' .. (Config.LimitedCharacters == 1 and 'Yes' or 'No'))
    end
end)

-- Export pour vérifier si le script fonctionne
exports('IsReady', function()
    return ESX ~= nil
end)