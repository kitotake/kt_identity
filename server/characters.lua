ESX.RegisterServerCallback('kt_identity:getCharacters', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return cb({}) end

    local chars = GetPlayerCharacters(xPlayer.identifier)
    cb(chars)
end)

RegisterNetEvent('kt_identity:createCharacter', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local id = CreateCharacter(xPlayer.identifier, data)
    TriggerClientEvent('kt_identity:characterCreated', src, id)
end)

RegisterNetEvent('kt_identity:deleteCharacter', function(charId)
    DeleteCharacter(charId)
end)
