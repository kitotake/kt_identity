
MySQL.ready(function()

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kt_characters (
            id INT AUTO_INCREMENT PRIMARY KEY,
            identifier VARCHAR(60) NOT NULL,
            firstname VARCHAR(16) NOT NULL,
            lastname VARCHAR(16) NOT NULL,
            dateofbirth VARCHAR(10) NOT NULL,
            sex VARCHAR(1) NOT NULL,
            height INT NOT NULL,
            nationality VARCHAR(50) NOT NULL DEFAULT 'Américaine',
            cigarette_addiction TINYINT UNSIGNED DEFAULT 0,
            alcohol_addiction TINYINT UNSIGNED DEFAULT 0,
            drugs_addiction TINYINT UNSIGNED DEFAULT 0,
            skin LONGTEXT DEFAULT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            last_played TIMESTAMP NULL,
            is_active TINYINT(1) DEFAULT 0,
            INDEX idx_identifier (identifier),
            FOREIGN KEY (identifier) REFERENCES users(identifier) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
    ]])

    if Config.Debug then
        print('^2[KT Identity]^7 Table "kt_characters" vérifiée/créée avec succès.')
    end
end)

function GetPlayerCharacters(identifier)
    local result = MySQL.query.await(
        'SELECT * FROM kt_characters WHERE identifier = ? ORDER BY last_played DESC',
        {identifier}
    )
    return result or {}
end
function CreateCharacter(identifier, data)
    local characterId = MySQL.insert.await([[
        INSERT INTO kt_characters 
        (identifier, firstname, lastname, dateofbirth, sex, height, nationality, cigarette_addiction, alcohol_addiction, drugs_addiction) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ]], {
        identifier,
        data.firstname,
        data.lastname,
        data.dateofbirth,
        data.gender == 'male' and 'm' or 'f',
        data.height,
        data.nationality or 'Américaine',
        data.addictions and data.addictions.cigarette or 0,
        data.addictions and data.addictions.alcohol or 0,
        data.addictions and data.addictions.drugs or 0
    })

    if Config.Debug and characterId then
        print(('[KT Identity] Nouveau personnage créé pour %s (ID: %s)'):format(identifier, characterId))
    end

    return characterId
end

function DeleteCharacter(identifier, characterId)
    local character = MySQL.single.await(
        'SELECT * FROM kt_characters WHERE id = ? AND identifier = ?',
        {characterId, identifier}
    )

    if not character then
        return false
    end

    MySQL.query.await(
        'DELETE FROM kt_characters WHERE id = ? AND identifier = ?',
        {characterId, identifier}
    )

    if Config.Debug then
        print(('[KT Identity] Personnage %s supprimé pour %s'):format(characterId, identifier))
    end

    return true
end

function UpdateLastPlayed(characterId)
    MySQL.update.await('UPDATE kt_characters SET last_played = NOW(), is_active = 1 WHERE id = ?', {characterId})
    MySQL.update.await([[
        UPDATE kt_characters 
        SET is_active = 0 
        WHERE id != ? AND identifier = (
            SELECT identifier FROM (SELECT identifier FROM kt_characters WHERE id = ?) AS temp
        )
    ]], {characterId, characterId})

    if Config.Debug then
        print(('[KT Identity] Personnage actif mis à jour (ID: %s)'):format(characterId))
    end
end

function GetCharacter(characterId, identifier)
    return MySQL.single.await(
        'SELECT * FROM kt_characters WHERE id = ? AND identifier = ?',
        {characterId, identifier}
    )
end

function GetCharacterCount(identifier)
    return MySQL.scalar.await(
        'SELECT COUNT(*) FROM kt_characters WHERE identifier = ?',
        {identifier}
    ) or 0
end

function GetActiveCharacter(identifier)
    return MySQL.single.await(
        'SELECT * FROM kt_characters WHERE identifier = ? AND is_active = 1 LIMIT 1',
        {identifier}
    )
end


exports('GetPlayerCharacters', GetPlayerCharacters)
exports('CreateCharacter', CreateCharacter)
exports('DeleteCharacter', DeleteCharacter)
exports('UpdateLastPlayed', UpdateLastPlayed)
exports('GetCharacter', GetCharacter)
exports('GetCharacterCount', GetCharacterCount)
exports('GetActiveCharacter', GetActiveCharacter)
