fx_version 'bodacious'

games { 'gta5' }

author 'Ft Scripts'

description 'Consumables with Effects'

client_scripts {
    'client/*.lua'
}
shared_scripts {
    '@ox_lib/init.lua',
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
    'config.lua'
}

server_scripts {
    'server/*.lua'
}

ui_page 'web/dist/index.html'

files {
	'web/dist/index.html',
	'web/dist/**/*',
}

lua54 'yes'