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
        ESX.RegisterUsableItem(v.name, function(source)
            local event = "ft_consumables:".. v.name
            local xPlayer = ESX.GetPlayerFromId(source)
            xPlayer.removeInventoryItem(v.name, 1)
            TriggerClientEvent(event, source)
        end)
    end
end)