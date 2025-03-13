local time
local start = false
local pausetoggle = false

function Draw2DText(text, x, y, scale)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x, y)
    if pausetoggle then
        SetTextFont(0)
        SetTextProportional(1)
        SetTextScale(0.45, 0.45)
        SetTextColour(255, 255, 0, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextEntry('STRING')
        AddTextComponentString('PAUSE')
        DrawText(x, y + 0.05)
    end
end

function StartTimer()
    Citizen.CreateThread(function ()
        TimeVisible()
        while start do
            if time > 0 then
                Citizen.Wait(1000)
                if not pausetoggle then
                    time = time - 1
                end
            else
                PlaySound()
                Citizen.Wait(4000)
                start = false
            end
        end
    end)
end

function TimeVisible()
    Citizen.CreateThread(function ()
        while start do
            Citizen.Wait(0)
            local h = math.floor(time / 3600)
            local m = math.floor((time % 3600) / 60)
            local s = time % 60
            local formattime
            if h > 0 then
                formattime = string.format('%d:%02d:%02d', h, m, s)
            else
                formattime = string.format('%d:%02d', m, s)
            end
            Draw2DText(formattime, 0.91, 0.07, 0.9)
        end
    end)
end

RegisterNetEvent('rnl-timer:menu:timer', function (arg)
    pausetoggle = false
    start = not start
    time = arg.time
    StartTimer()
end)

RegisterNetEvent('rnl-timer:menu:pausetoggle', function ()
    pausetoggle = not pausetoggle
end)

lib.registerContext({
    id = 'timer_menu',
    title = 'RNL Timer Menu',
    options = {
        {
            title = 'RESUME / PAUSE',
            description = 'Timer Resume / Pause toggle',
            icon = 'fas fa-play',
            event = 'rnl-timer:menu:pausetoggle'
        },
        {
            title = '30s',
            description = 'Start/Stop a 30 seconds timer',
            icon = 'fas fa-play',
            event = 'rnl-timer:menu:timer',
            args = {
                time = 30
            }
        },
        {
            title = '1m',
            description = 'Start/Stop a 1 minutes timer',
            icon = 'fas fa-play',
            event = 'rnl-timer:menu:timer',
            args = {
                time = 60
            }
        },
        {
            title = '3m',
            description = 'Start/Stop a 3 minutes timer',
            icon = 'fas fa-play',
            event = 'rnl-timer:menu:timer',
            args = {
                time = 180
            }
        },
        {
            title = '5m',
            description = 'Start/Stop a 5 minutes timer',
            icon = 'fas fa-play',
            event = 'rnl-timer:menu:timer',
            args = {
                time = 300
            }
        },
        {
            title = 'Custom Time',
            description = 'Set the time and start the timer',
            icon = 'fas fa-clock',
            event = 'rnl-timer:menu:inputdialog'
        }
    }
})

RegisterNetEvent('rnl-timer:menu:inputdialog', function ()
    local input = lib.inputDialog('Set Custom Timer', {
        {
            type = 'number',
            label = 'hour',
            description = 'Set the "hour" unit of the timer',
            default = 0,
            min = 0,
            max = 12
        },
        {
            type = 'number',
            label = 'minute',
            description = 'Set the "minute" unit of the timer',
            default = 0,
            min = 0,
            max = 59
        },
        {
            type = 'number',
            label = 'second',
            description = 'Set the "second" unit of the timer',
            default = 10,
            min = 1,
            max = 59,
            required = true
        },
    })

    if not input then
        lib.showContext('timer_menu')
        return
    end
    local h = math.floor(input[1] * 3600)
    local m = math.floor(input[2] * 60)
    local s = math.floor(input[3])
    time = h + m + s
    local arg = {
        time = time
    }
    TriggerEvent('rnl-timer:menu:timer', arg)
end)

RegisterCommand('timer', function ()
    lib.showContext('timer_menu')
end)

function PlaySound()
    SendNUIMessage({})
end