Config = {}

Config.DefaultMaxCharacters = 1

Config.StrictMode = true -- true = 1 seul personnage, false = utilise DefaultMaxCharacters

-- Nombre de personnages autorisés par groupe ESX
-- Format: ["groupe_esx"] = nombre_de_personnages
Config.GroupPermissions = {
    ['user'] = 1,           -- Joueurs normaux: 1 personnage
    ['helper'] = 2,         -- Helpers: 2 personnages
    ['mod'] = 3,            -- Modérateurs: 3 personnages
    ['admin'] = 5,          -- Admins: 5 personnages
    ['superadmin'] = 10,    -- SuperAdmins: 10 personnages
}

-- Autoriser les groupes à bypasser la limite stricte
-- Si StrictMode = true, seuls ces groupes peuvent avoir plus d'1 personnage
Config.BypassGroups = {
    'helper',
    'mod', 
    'admin',
    'superadmin'
}


-- Pour des cas très spécifiques (streamers, events spéciaux, etc.)
-- Cette whitelist OVERRIDE les permissions de groupe 
Config.ManualWhitelist = {
    -- Exemples:
    -- ["license:1234567890abcdef"] = 5,  -- Streamer spécial
    -- ["license:0987654321fedcba"] = 3,  -- Event manager
}


-- Position de spawn par défaut
Config.DefaultSpawn = vector3(-268.0, -957.6, 31.2)

-- Format de date (DD/MM/YYYY | MM/DD/YYYY | YYYY/MM/DD)
Config.DateFormat = "DD/MM/YYYY"



Config.MaxNameLength = 16 -- Longueur maximale du nom/prénom (limite ESX)
Config.MinHeight = 150    -- Taille minimale en cm
Config.MaxHeight = 190    -- Taille maximale en cm
Config.MaxAge = 45        -- Âge maximum
Config.MinAge = 18        -- Âge minimum

Config.UseAppearance = true

Config.ForceAppearanceOnCreate = true

Config.PreferredAppearance = 'fivem-appearance'

Config.AutoLoadLastCharacter = false 

Config.BlockEscapeInSelection = true

Config.DeleteCooldown = 5


Config.LogActions = true

Config.DiscordLogs = false
Config.DiscordWebhook = "YOUR_WEBHOOK_URL_HERE"

Config.PreventDuplicateNames = true


Config.NameBlacklist = {
    'admin',
    'moderator',
    'staff',
    'server',
    'fivem',
   
}


Config.Debug = true


Config.EnableTestCommands = true


Config.Messages = {
    ['no_permission'] = '🔒 Vous n\'avez pas la permission de créer plus de personnages.',
    ['limit_reached'] = '⚠️ Vous avez atteint la limite de %s personnage(s).',
    ['character_created'] = '✅ Personnage créé avec succès !',
    ['character_deleted'] = '🗑️ Personnage supprimé.',
    ['character_selected'] = '👋 Bienvenue %s %s !',
    ['invalid_data'] = '❌ Données invalides : %s',
    ['duplicate_name'] = '⚠️ Un personnage avec ce nom existe déjà.',
    ['blacklisted_name'] = '🚫 Ce nom contient des mots interdits.',
}


function Config.GetMessage(key, ...)
    local msg = Config.Messages[key] or key
    if ... then
        return string.format(msg, ...)
    end
    return msg
end