local Nationalities = {
    'Américaine',
    'Française',
    'Britannique',
    'Allemande',
    'Italienne',
    'Espagnole',
    'Portugaise',
    'Belge',
    'Suisse',
    'Canadienne',
    'Australienne',
    'Japonaise',
    'Chinoise',
    'Russe',
    'Brésilienne',
    'Mexicaine',
    'Argentine',
    'Marocaine',
    'Algérienne',
    'Tunisienne'
}

function GetMaxCharactersForPlayer(identifier)
    if Config.MultiCharacterWhitelist[identifier] then
        return Config.MultiCharacterWhitelist[identifier]
    end
    
    if Config.LimitedCharacters == 1 then
        return 1
    end
    
    return Config.MaxCharacters
end

function CanCreateNewCharacter(identifier)
    local currentCount = GetCharacterCount(identifier)
    local maxAllowed = GetMaxCharactersForPlayer(identifier)
    
    if Config.Debug then
        print(string.format('^2[KT Identity]^7 Character check for %s: %d/%d', identifier, currentCount, maxAllowed))
    end
    
    return currentCount < maxAllowed
end

function FormatCharactersForNUI(characters)
    local formatted = {}
    
    for _, char in ipairs(characters) do
        table.insert(formatted, {
            id = char.id,
            firstname = char.firstname,
            lastname = char.lastname,
            dateofbirth = char.dateofbirth,
            gender = char.sex == 'm' and 'male' or 'female',
            height = char.height,
            nationality = char.nationality,
            addictions = {
                cigarette = char.cigarette_addiction or 0,
                alcohol = char.alcohol_addiction or 0,
                drugs = char.drugs_addiction or 0
            }
        })
    end
    
    return formatted
end

function ValidateCharacterData(data)
    if not data.firstname or not data.lastname or not data.dateofbirth or not data.gender or not data.height then
        return false, "Données manquantes"
    end

    if #data.firstname < 2 or #data.firstname > Config.MaxNameLength then
        return false, "Prénom invalide (2-" .. Config.MaxNameLength .. " caractères)"
    end

    if #data.lastname < 2 or #data.lastname > Config.MaxNameLength then
        return false, "Nom invalide (2-" .. Config.MaxNameLength .. " caractères)"
    end

    if data.height < Config.MinHeight or data.height > Config.MaxHeight then
        return false, "Taille invalide (" .. Config.MinHeight .. "-" .. Config.MaxHeight .. " cm)"
    end

    if data.gender ~= 'male' and data.gender ~= 'female' then
        return false, "Genre invalide"
    end

    local dob = os.time({
        year = tonumber(string.sub(data.dateofbirth, 1, 4)),
        month = tonumber(string.sub(data.dateofbirth, 6, 7)),
        day = tonumber(string.sub(data.dateofbirth, 9, 10))
    })

    local age = os.difftime(os.time(), dob) / (365.25 * 24 * 60 * 60)

    if age < Config.MinAge or age > Config.MaxAge then
        return false, "Âge invalide (" .. Config.MinAge .. "-" .. Config.MaxAge .. " ans)"
    end

    local validNationality = false
    for _, nat in ipairs(Nationalities) do
        if nat == data.nationality then
            validNationality = true
            break
        end
    end

    if not validNationality then
        return false, "Nationalité invalide"
    end

    if data.addictions then
        if data.addictions.cigarette < 0 or data.addictions.cigarette > 100 or
           data.addictions.alcohol < 0 or data.addictions.alcohol > 100 or
           data.addictions.drugs < 0 or data.addictions.drugs > 100 then
            return false, "Valeurs d'addiction invalides (0-100)"
        end
    end

    return true
end

function LoadESXCharacter(source, character)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return false
    end

    local dateofbirth = character.dateofbirth
    if Config.DateFormat == "DD/MM/YYYY" and dateofbirth:match("^%d%d%d%d%-%d%d%-%d%d$") then
        local year, month, day = dateofbirth:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
        dateofbirth = string.format("%s/%s/%s", day, month, year)
    end

    MySQL.update.await([[
        UPDATE users 
        SET firstname = ?, lastname = ?, dateofbirth = ?, sex = ?, height = ?
        WHERE identifier = ?
    ]], {
        character.firstname,
        character.lastname,
        dateofbirth,
        character.sex,
        character.height,
        xPlayer.identifier
    })

    UpdateLastPlayed(character.id)

    Citizen.CreateThread(function()
        Citizen.Wait(500)
        
        TriggerEvent('esx:playerLoaded', source, xPlayer)
        
        if Config.Debug then
            print('^2[KT Identity]^7 Character loaded for: ' .. xPlayer.identifier)
        end
    end)

    return true
end

function GetMenuData(identifier)
    local characters = GetPlayerCharacters(identifier)
    local formattedChars = FormatCharactersForNUI(characters)
    local maxChars = GetMaxCharactersForPlayer(identifier)
    
    return {
        characters = formattedChars,
        maxCharacters = maxChars,
        availableNationalities = Nationalities,
        canCreateMore = CanCreateNewCharacter(identifier)
    }
end

exports('FormatCharactersForNUI', FormatCharactersForNUI)
exports('ValidateCharacterData', ValidateCharacterData)
exports('LoadESXCharacter', LoadESXCharacter)
exports('GetMenuData', GetMenuData)
exports('GetNationalities', function() return Nationalities end)
exports('GetMaxCharactersForPlayer', GetMaxCharactersForPlayer)
exports('CanCreateNewCharacter', CanCreateNewCharacter)