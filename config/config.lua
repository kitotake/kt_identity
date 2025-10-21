Config = {}

-- Nombre maximum de personnages par joueur
Config.MaxCharacters = 3

-- Position de spawn par défaut (lorsqu’aucun spawn spécifique)
Config.DefaultSpawn = vector3(-268.0, -957.6, 31.2)

-- These values are for the date format in the registration menu
-- Choices: DD/MM/YYYY | MM/DD/YYYY | YYYY/MM/DD
Config.DateFormat = "DD/MM/YYYY"

-- These values are for the second input validation in server/main.lua
Config.MaxNameLength = 20 -- Max Name Length.
Config.MinHeight = 120 -- 120 cm lowest height
Config.MaxHeight = 220 -- 220 cm max height.
Config.MaxAge = 100 -- 100 years old is the oldest you can be.

-- Utilisation d’un système d’apparence
Config.UseAppearance = true -- compatible avec fivem-appearance ou esx_skin

-- Debug mode
Config.Debug = true
