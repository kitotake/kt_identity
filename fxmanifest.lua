fx_version 'cerulean'
game 'gta5'

name "kt_identity"
author 'kitotake'
description 'Système de gestion multi-personnages pour ESX'
version '1.5.0'

lua54 'yes'

shared_scripts {
    '@es_extended/imports.lua',
    'config/config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/database.lua',
    'server/characters.lua',
    'server/events.lua',
    'server/main.lua'
}

client_scripts {
    'client/main.lua',
    'client/spawn.lua',
    'client/client_test.lua',
    'client/camera.lua'
}

ui_page 'nui/identity/index.html'

files {
    'nui/identity/index.html',
    'nui/identity/assets/*.js',
    'nui/identity/assets/*.css',
    'nui/identity/assets/*.svg',
    'nui/identity/assets/*.png',
    'nui/identity/assets/*.jpg'
}

dependencies {
    'es_extended',
    'oxmysql'
}