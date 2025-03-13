fx_version 'cerulean'
game 'gta5'

author 'RNL'
description 'Timer UI System'
version '1.0'

lua54 'yes'

client_script {
    'client.lua'
}

shared_script {
    '@ox_lib/init.lua'
}

files {
    'ui/index.html',
    'ui/script.js',
    'ui/sounds/*.ogg'
}

ui_page 'ui/index.html'