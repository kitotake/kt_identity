Config = {}

-- Nombre maximum de personnages par joueur
Config.MaxCharacters = 3

-- Limite de personnages (1 = un seul personnage autorisé, sauf whitelist)
Config.LimitedCharacters = 1

-- Whitelist des identifiers autorisés à avoir plusieurs personnages
-- Format: ["license:abc123"] = nombre_max_personnages
Config.MultiCharacterWhitelist = {
    -- Exemple:
    -- ["license:1234567890abcdef"] = 5,
    -- ["license:0987654321fedcba"] = 3,
}

-- Position de spawn par défaut
Config.DefaultSpawn = vector3(-268.0, -957.6, 31.2)

-- Format de date (DD/MM/YYYY | MM/DD/YYYY | YYYY/MM/DD)
Config.DateFormat = "DD/MM/YYYY"

-- Validation des données
Config.MaxNameLength = 16 -- Longueur maximale du nom/prénom (limite ESX)
Config.MinHeight = 150 -- Taille minimale en cm
Config.MaxHeight = 190 -- Taille maximale en cm
Config.MaxAge = 45 -- Âge maximum
Config.MinAge = 18 -- Âge minimum

-- Utilisation d'un système d'apparence
Config.UseAppearance = true -- Compatible avec fivem-appearance ou esx_skin

-- Charger automatiquement le dernier personnage utilisé
Config.AutoLoadLastCharacter = false -- Si false, demande toujours la sélection

-- Mode debug
Config.Debug = true