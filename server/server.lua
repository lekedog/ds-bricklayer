local RSGCore = exports['rsg-core']:GetCoreObject()
local PlayerDropCounts = {} -- Per-player drop tracking (keyed by source)

-- SERVER-SIDE DROP TRACKING: Increment drop count when player completes a drop --
RegisterNetEvent('ds-bricklayer:IncrementDrop', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end

    if not PlayerDropCounts[src] then
        PlayerDropCounts[src] = 0
    end

    -- Cap at configured max to prevent any overflow exploit
    if PlayerDropCounts[src] < Config.DropCount then
        PlayerDropCounts[src] = PlayerDropCounts[src] + 1
        if Config.Prints then
            print(('[ds-bricklayer] Player %s drop count: %d'):format(src, PlayerDropCounts[src]))
        end
    end
end)

-- CHECKS IF PLAYER WAS PAID TO PREVENT EXPLOITS --
RSGCore.Functions.CreateCallback('ds-bricklayer:CheckIfPaycheckCollected', function(source, cb)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then
        cb(false)
        return
    end

    local dropCount = PlayerDropCounts[src] or 0
    if dropCount <= 0 then
        cb(false)
        return
    end

    local payment = (dropCount * Config.PayPerDrop)
    if Player.Functions.AddMoney(Config.Moneytype, payment) then
        -- Award reputation based on server-tracked drop count
        exports['j-reputations']:addrep('masonry', dropCount, src)
        TriggerClientEvent('ox_lib:notify', src, {title = 'Pay', description = ('You received $%.2f'):format(payment), type = 'inform' })
        PlayerDropCounts[src] = 0
        cb(true)
    else
        cb(false)
    end
end)

-- Clean up player data on disconnect to prevent memory leaks --
AddEventHandler('playerDropped', function()
    PlayerDropCounts[source] = nil
end)
