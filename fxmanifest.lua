fx_version 'cerulean'
game 'gta5'

name "kt_identity"
description 'KT Identity - Multi Character System for ESX'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@es_extended/imports.lua',
    'config/config.lua',
}

client_scripts {
    'client/camera.lua',
    'client/nui_handler.lua',
    'client/spawn.lua',
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/database.lua',
    'server/characters.lua',
    'server/events.lua',
    'server/main.lua',
}

ui_page 'nui/identity/index.html'

files {
    'nui/identity/index.html',
    'nui/identity/style.css',
    'nui/identity/script.js',
    'nui/identity/img/*.png',
}

dependencies {
    'es_extended',
    'oxmysql'
}