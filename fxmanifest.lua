fx_version 'adamant'

game 'gta5'

description 'Adds the ability to get drunk'
lua54 'yes'
version '1.1'
legacyversion '1.9.1'

shared_scripts {
    '@es_extended/imports.lua',
    '@es_extended/locale.lua',
    'config.lua'
}

server_scripts {
    'server/main.lua'
}

client_scripts {
    'client/main.lua'
}

files {
    'locales/*.lua',
}