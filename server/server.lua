local RSGCore = exports['rsg-core']:GetCoreObject()
local DropCount = 0

-- SENDS DROP COUNT TO SERVER FOR CORRECT PAYMENT --
RegisterNetEvent('ds-bricklayer:GetDropCount', function(count)
    local source = src
    local Player = RSGCore.Functions.GetPlayer(src)

    DropCount = count
end)

-- CHECKS IF PLAYER WAS PAID TO PREVENT EXPLOITS --
RSGCore.Functions.CreateCallback('ds-bricklayer:CheckIfPaycheckCollected', function(source, cb)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src) 
    local dropCount = tonumber(amount)
    local payment = (DropCount * Config.PayPerDrop)
    if Player.Functions.AddMoney(Config.Moneytype, payment) then -- Removes money type and amount
        -- Award reputation based on drop count
        exports['j-reputations']:addrep('masonry', DropCount, source)
        DropCount = 0
        TriggerClientEvent('ox_lib:notify', source, {title = 'Pay', description = 'your recive $' ..payment, type = 'inform' })
        cb(true)
    else
        cb(false)
    end
end)
