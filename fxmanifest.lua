fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
author 'LekedogTV'
description 'Converted construction job to lay bricks.
version '1.0.1'

shared_scripts {
    '@ox_lib/init.lua',
    '@rsg-core/shared/locale.lua',
    --'locales/es.lua',
    --'locales/*.lua',
    'config.lua',
}
client_scripts {
	'client/client.lua',
}

server_scripts {
	'server/server.lua',
    'server/versionchecker.lua'
}

dependency {
    'rsg-core',
    'ox_lib',
}

lua54 'yes'
