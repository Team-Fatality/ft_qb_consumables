QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("webhook")
AddEventHandler("webhook", function(message)

    local data = {
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "Rotation Data",
            ["description"] = message,
            ["color"] = 0x00ff00
        }}
    }
    
    PerformHttpRequest(Config.webhook, function(err, text, headers)
        if err ~= 0 then
            print("Error sending webhook: " .. err)
        else
            print("Webhook sent successfully!")
        end
    end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end)

CreateThread(function()
    for k,v in pairs(Config.Items) do
        QBCore.Functions.CreateUseableItem(v.name, function(source)
            local event = "ft_qb_consumables:".. v.name
            local xPlayer = QBCore.Functions.GetPlayer(source)
            xPlayer.Functions.RemoveItem(v.name, 1)
            TriggerClientEvent(event, source)
        end)
    end
end)

RegisterNetEvent('ft_qb_consumables:addNeed', function(amount, type)
    local Player = QBCore.Functions.GetPlayer(source) if not Player then return end
    local hunger = Player.PlayerData.metadata['hunger']
    local thirst = Player.PlayerData.metadata['thirst']

	if type == "hunger" then
        newhunger = hunger + amount
        Player.Functions.SetMetaData('hunger', newhunger)
        TriggerClientEvent('hud:client:UpdateNeeds', source, newhunger, thirst)
    end
	if type == "thirst" then
        newthirst = thirst + amount
        Player.Functions.SetMetaData('thirst', newthirst)
        TriggerClientEvent('hud:client:UpdateNeeds', source, hunger, newthirst)
	end
end)
