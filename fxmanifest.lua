fx_version 'cerulean'
game 'gta5'

name "kt_identity"
description 'KT Identity - Multi Character System for ESX'
version '1.3.0'

lua54 'yes'

shared_scripts {
    '@es_extended/imports.lua',
    'config/config.lua',
}

client_scripts {
    'client/camera.lua',
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
    'nui/identity/assets/*.css',
    'nui/identity/assets/*.js',
}

dependencies {
    'es_extended',
    'oxmysql'
}