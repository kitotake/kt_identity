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

--- Obtenir le nombre maximum de personnages pour un joueur
---@param source number Player source
---@return number maxCharacters
function GetMaxCharactersForPlayer(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return Config.DefaultMaxCharacters end

    if Config.ManualWhitelist[xPlayer.identifier] then
        return Config.ManualWhitelist[xPlayer.identifier]
    end

    local playerGroup = xPlayer.getGroup()
    
    if Config.GroupPermissions[playerGroup] then
        return Config.GroupPermissions[playerGroup]
    end

    return Config.DefaultMaxCharacters
end

--- Vérifier si un joueur peut créer un nouveau personnage
---@param source number Player source
---@return boolean canCreate
---@return string|nil reason
function CanCreateNewCharacter(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        return false, "Joueur introuvable"
    end

    local currentCount = GetCharacterCount(xPlayer.identifier)
    local maxAllowed = GetMaxCharactersForPlayer(source)
    
    if Config.StrictMode and currentCount >= 1 then
        local playerGroup = xPlayer.getGroup()
        local canBypass = false
        
        for _, group in ipairs(Config.BypassGroups) do
            if playerGroup == group then
                canBypass = true
                break
            end
        end
        
        if Config.ManualWhitelist[xPlayer.identifier] then
            canBypass = true
        end
        
        if not canBypass then
            return false, Config.GetMessage('no_permission')
        end
    end
    
    if currentCount >= maxAllowed then
        return false, Config.GetMessage('limit_reached', maxAllowed)
    end
    
    if Config.Debug then
        print(string.format(
            '^2[KT Identity]^7 Character check for %s (%s): %d/%d - Can create: YES',
            xPlayer.getName(),
            xPlayer.getGroup(),
            currentCount,
            maxAllowed
        ))
    end
    
    return true
end

--- Formater les personnages pour le NUI
---@param characters table
---@return table formatted
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

--- Valider les données d'un personnage
---@param data table Character data
---@param identifier string Player identifier
---@return boolean valid
---@return string|nil error
function ValidateCharacterData(data, identifier)
    if not data.firstname or not data.lastname or not data.dateofbirth or 
       not data.gender or not data.height then
        return false, Config.GetMessage('invalid_data', "Données manquantes")
    end

    if #data.firstname < 2 or #data.firstname > Config.MaxNameLength then
        return false, Config.GetMessage('invalid_data', 
            "Prénom invalide (2-" .. Config.MaxNameLength .. " caractères)")
    end

    if #data.lastname < 2 or #data.lastname > Config.MaxNameLength then
        return false, Config.GetMessage('invalid_data',
            "Nom invalide (2-" .. Config.MaxNameLength .. " caractères)")
    end

    local fullname = (data.firstname .. " " .. data.lastname):lower()
    for _, word in ipairs(Config.NameBlacklist) do
        if fullname:find(word:lower()) then
            return false, Config.GetMessage('blacklisted_name')
        end
    end

    if Config.PreventDuplicateNames then
        local exists = MySQL.scalar.await([[
            SELECT COUNT(*) 
            FROM kt_characters 
            WHERE identifier = ? 
            AND LOWER(firstname) = LOWER(?) 
            AND LOWER(lastname) = LOWER(?)
        ]], {identifier, data.firstname, data.lastname})

        if exists and exists > 0 then
            return false, Config.GetMessage('duplicate_name')
        end
    end

    if data.height < Config.MinHeight or data.height > Config.MaxHeight then
        return false, Config.GetMessage('invalid_data',
            "Taille invalide (" .. Config.MinHeight .. "-" .. Config.MaxHeight .. " cm)")
    end

    if data.gender ~= 'male' and data.gender ~= 'female' then
        return false, Config.GetMessage('invalid_data', "Genre invalide")
    end

    local dob = os.time({
        year = tonumber(string.sub(data.dateofbirth, 1, 4)),
        month = tonumber(string.sub(data.dateofbirth, 6, 7)),
        day = tonumber(string.sub(data.dateofbirth, 9, 10))
    })

    local age = os.difftime(os.time(), dob) / (365.25 * 24 * 60 * 60)

    if age < Config.MinAge or age > Config.MaxAge then
        return false, Config.GetMessage('invalid_data',
            "Âge invalide (" .. Config.MinAge .. "-" .. Config.MaxAge .. " ans)")
    end

    local validNationality = false
    for _, nat in ipairs(Nationalities) do
        if nat == data.nationality then
            validNationality = true
            break
        end
    end

    if not validNationality then
        return false, Config.GetMessage('invalid_data', "Nationalité invalide")
    end

    if data.addictions then
        if data.addictions.cigarette < 0 or data.addictions.cigarette > 100 or
           data.addictions.alcohol < 0 or data.addictions.alcohol > 100 or
           data.addictions.drugs < 0 or data.addictions.drugs > 100 then
            return false, Config.GetMessage('invalid_data',
                "Valeurs d'addiction invalides (0-100)")
        end
    end

    return true
end

--- Charger un personnage dans ESX
---@param source number Player source
---@param character table Character data
---@return boolean success
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

    if Config.LogActions then
        print(string.format(
            '^2[KT Identity]^7 %s (%s) loaded character: %s %s (ID: %d)',
            xPlayer.getName(),
            xPlayer.getGroup(),
            character.firstname,
            character.lastname,
            character.id
        ))
    end

    Citizen.CreateThread(function()
        Wait(500)
        TriggerEvent('esx:playerLoaded', source, xPlayer)
    end)

    return true
end

--- Obtenir les données du menu pour un joueur
---@param source number Player source
---@return table menuData
function GetMenuData(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        return {
            characters = {},
            maxCharacters = Config.DefaultMaxCharacters,
            availableNationalities = Nationalities,
            canCreateMore = false
        }
    end

    local characters = GetPlayerCharacters(xPlayer.identifier)
    local formattedChars = FormatCharactersForNUI(characters)
    local maxChars = GetMaxCharactersForPlayer(source)
    local canCreate, reason = CanCreateNewCharacter(source)
    
    return {
        characters = formattedChars,
        maxCharacters = maxChars,
        availableNationalities = Nationalities,
        canCreateMore = canCreate,
        playerGroup = xPlayer.getGroup(),
        restrictionReason = reason
    }
end


exports('FormatCharactersForNUI', FormatCharactersForNUI)
exports('ValidateCharacterData', ValidateCharacterData)
exports('LoadESXCharacter', LoadESXCharacter)
exports('GetMenuData', GetMenuData)
exports('GetNationalities', function() return Nationalities end)
exports('GetMaxCharactersForPlayer', GetMaxCharactersForPlayer)
exports('CanCreateNewCharacter', CanCreateNewCharacter)