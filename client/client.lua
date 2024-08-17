
CreateThread(function()
    for k, v in pairs(Config.Items) do
        local event = "ft_consumables:" .. v.name
        local playerPed = PlayerPedId()
        RegisterNetEvent(event)
        AddEventHandler(event, function()
            
            local notify = "You've used " .. v.label
            if Config.oxnotify then
                lib.notify({
                    description = notify,
                    position = 'top',
                })
            else
                ESX.ShowNotification(notify)
            end


            if v.anim then
                local animtable = v.anim
                SetAnim(animtable)
            else
                SetDefaultAnim()
            end

            -- Armor
            if v.armour then
                local currentarmour = GetPedArmour(playerPed)
                local maxarmour = 100
                local newarmour = currentarmour + v.armour 
                if newarmour > maxarmour then
                    newarmour = maxarmour
                end
                SetPedArmour(playerPed, newarmour)
            end

            -- Hunger
            if v.hunger then
                TriggerEvent('esx_status:add', 'hunger', v.hunger)
            end

            -- Thirst
            if v.thirst then
                TriggerEvent('esx_status:add', 'thirst', v.thirst)
            end

            -- Stress
            if v.removestress then
                TriggerEvent('esx_status:remove', 'stress', 100000)
            end

            if v.addstress then
                TriggerEvent('esx_status:add', 'stress', 100000)
            end

            if v.drunk then
                TriggerEvent('ft_consumables:SetPedIsDrunk')
            end

        end)
    end
end)



RegisterNetEvent('ft_consumables:SetPedIsDrunk')
AddEventHandler('ft_consumables:SetPedIsDrunk', function()
    SetDrunk()
end)

RegisterNetEvent('ft_consumables:SetPedStamina')
AddEventHandler('ft_consumables:SetPedStamina', function(duration)
    SetStaminaPerk(duration)
end)

function SetSprintPerk(duration)
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
    Wait(duration * 1000)
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

function SetStaminaPerk(duration)
    local times = duration / 10
    repeat
        ResetPlayerStamina(PlayerId())
        Wait(10000)
        times = times - 1
    until( times < 1.0 )
end

function SetSwimPerk(duration)
    SetSwimMultiplierForPlayer(PlayerId(), 1.49)
    Wait(duration * 1000)
    SetSwimMultiplierForPlayer(PlayerId(), 1.0)
end

function SetMeleePerk(duration)
    SetPlayerMeleeWeaponDamageModifier(PlayerId(), 2.0)
    Wait(duration * 1000)
    SetPlayerMeleeWeaponDamageModifier(PlayerId(), 1.0)
end


function SetAdrenalinePerk(duration)
    SetPlayerHealthRechargeLimit(PlayerId(), 1.0)
    SetPlayerHealthRechargeMultiplier(PlayerId(), 2.0)
    Wait(duration * 1000)
    SetPlayerHealthRechargeLimit(PlayerId(), 0.5)
    SetPlayerHealthRechargeMultiplier(PlayerId(), 1.0)
end

function SetDrunk()
    RequestAnimSet("move_m@drunk@slightlydrunk")
    while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do Citizen.Wait(0) end

    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_DRUG_DEALER_HARD", 0, 1)
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    ClearPedTasksImmediately(PlayerPedId())
    SetPedMotionBlur(PlayerPedId(), true)
    SetPedMovementClipset(PlayerPedId(), "move_m@drunk@slightlydrunk", true)
    RemoveAnimSet("move_m@drunk@slightlydrunk")
    SetPedIsDrunk(PlayerPedId(), true)
    SetTimecycleModifier("spectator5")
    DoScreenFadeIn(1000)
    ShakeGameplayCam('VIBRATE_SHAKE', 10.0)
    ShakeGameplayCam('DRUNK_SHAKE', 2.0)
    Wait(60000)
    ClearEffects()
end


function ClearEffects()
    DoScreenFadeOut(800)
    Wait(1000)

    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ShakeGameplayCam('DRUNK_SHAKE', 0.0)
    ResetPedMovementClipset(PlayerPedId(), 0)
    SetPedIsDrunk(PlayerPedId(), false)
    SetPedMotionBlur(PlayerPedId(), false)
    DoScreenFadeIn(800)
    ClearPedSecondaryTask(PlayerPedId())
end

function SetAnim(animtable)
    local playerPed  = PlayerPedId()
    local animatdict = animtable.animatdict
    local animation = animtable.animation
    local prop_name = animtable.prop_name
    local x,y,z = table.unpack(GetEntityCoords(playerPed))
    local prop = CreateObject(joaat(prop_name), x, y, z + 0.2, true, true, true)
    local boneIndex = GetPedBoneIndex(playerPed, animtable.bones)
    local rotate = animtable.prop_rotate



    AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, rotate.x, rotate.y, rotate.z, true, true, false, true, 1, true)

    ESX.Streaming.RequestAnimDict(animatdict, function()
        TaskPlayAnim(playerPed, animatdict, animation, 8.0, -8, -1, 49, 0, 0, 0, 0)
        RemoveAnimDict(animatdict)

        Wait(3000)
        IsAnimated = false
        ClearPedSecondaryTask(playerPed)
        DeleteObject(prop)
    end)

end

function SetDefaultAnim()
    local playerPed  = PlayerPedId()
    animatdict = 'mp_player_inteat@burger'
    animation = 'mp_player_int_eat_burger_fp'
    prop_name = 'prop_cs_burger_01'
    local x,y,z = table.unpack(GetEntityCoords(playerPed))
    local prop = CreateObject(joaat(prop_name), x, y, z + 0.2, true, true, true)
    local boneIndex = GetPedBoneIndex(playerPed, 18905)
    local rotate = vector3(10.0, 175.0, 0.0)



    AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, rotate.x, rotate.y, rotate.z, true, true, false, true, 1, true)

    ESX.Streaming.RequestAnimDict(animatdict, function()
        TaskPlayAnim(playerPed, animatdict, animation, 8.0, -8, -1, 49, 0, 0, 0, 0)
        RemoveAnimDict(animatdict)

        Wait(3000)
        IsAnimated = false
        ClearPedSecondaryTask(playerPed)
        DeleteObject(prop)
    end)

end
