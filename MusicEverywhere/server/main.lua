QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('MusicEverywhere:GetMusic', function(source, cb)
    cb(Config.Zones)
end)

if Config.ItemInVehicle then
	QBCore.Functions.CreateUseableItem(Config.ItemInVehicle, function(playerId)
        local Player = QBCore.Functions.GetPlayer(playerId)  -- Replace "admin" with the required permission
		    TriggerClientEvent("MusicEverywhere:ShowNui", playerId)
        end
	end)
end

local xSound = exports.xsound

RegisterNetEvent("MusicEverywhere:ChangeVolume")
AddEventHandler("MusicEverywhere:ChangeVolume", function(vol, nome)
    local Player = QBCore.Functions.GetPlayer(source)  -- Replace "admin" with the required permission
        local somafter = false
        local rangeafter = false
        for i = 1, #Config.Zones do
            local v = Config.Zones[i]
            if nome == v.name then
                local vadi = v.volume + vol
                if vadi <= 1.01 and vadi >= -0.001 then
                    if vadi < 0.005 then
                        vadi = 0.0
                    end
                    if v.popo then
                        v.range = (v.volume * Config.DistanceToVolume)
                    else
                        if vadi >= 0.05 then
                            v.range = (vadi * v.range) / v.volume
                        end
                    end
                    v.volume = vadi
                    somafter = v.volume
                    rangeafter = v.range
                end
            end
        end
        if somafter and rangeafter then
            TriggerClientEvent("MusicEverywhere:ChangeVolume", -1, somafter, rangeafter, nome)
        end
    end
end)

RegisterNetEvent("MusicEverywhere:ChangeLoop")
AddEventHandler("MusicEverywhere:ChangeLoop", function(nome, tip)
    local Player = QBCore.Functions.GetPlayer(source)  -- Replace "admin" with the required permission
        local loopstate
        for i = 1, #Config.Zones do
            local v = Config.Zones[i]
            if nome == v.name then
                v.loop = tip
                loopstate = v.loop
            end
        end
        if loopstate ~= nil then
            TriggerClientEvent("MusicEverywhere:ChangeLoop", -1, loopstate, nome)
        end
    end
end)

RegisterNetEvent("MusicEverywhere:ChangeState")
AddEventHandler("MusicEverywhere:ChangeState", function(type, nome)
    local Player = QBCore.Functions.GetPlayer(source)-- Replace "admin" with the required permission
        for i = 1, #Config.Zones do
            local v = Config.Zones[i]
            if nome == v.name then
                v.isplaying = type
            end
        end
        TriggerClientEvent("MusicEverywhere:ChangeState", -1, type, nome)
    end
end)

RegisterNetEvent("MusicEverywhere:ChangePosition")
AddEventHandler("MusicEverywhere:ChangePosition", function(quanti, nome)
    local Player = QBCore.Functions.GetPlayer(source)  -- Replace "admin" with the required permission
        for i = 1, #Config.Zones do
            local v = Config.Zones[i]
            if nome == v.name then
                v.deftime = v.deftime + quanti
                if v.deftime < 0 then
                    v.deftime = 0
                end
            end
        end
        TriggerClientEvent("MusicEverywhere:ChangePosition", -1, quanti, nome)
    end
end)

RegisterNetEvent("MusicEverywhere:ModifyURL")
AddEventHandler("MusicEverywhere:ModifyURL", function(data)
    local Player = QBCore.Functions.GetPlayer(source)  -- Replace "admin" with the required permission
        local _data = data
        local zena = false
        for i = 1, #Config.Zones do
            local v = Config.Zones[i]
            if _data.name == v.name then
                v.deflink = _data.link
                if _data.popo then
                    v.popo = _data.popo
                end
                v.deftime = 0
                v.isplaying = true
                v.loop = _data.loop
                zena = v
            end
        end
        if zena then
            TriggerClientEvent("MusicEverywhere:ModifyURL", -1, zena)
        end
    end
end)

function countTime()
    SetTimeout(1000, countTime)
    for i = 1, #Config.Zones do
		local v = Config.Zones[i]
        if v.isplaying then
            v.deftime = v.deftime + 1
        end
    end
end

SetTimeout(1000, countTime)

RegisterNetEvent('MusicEverywhere:AddVehicle')
AddEventHandler("MusicEverywhere:AddVehicle", function(vehdata)
    local Player = QBCore.Functions.GetPlayer(source)  -- Replace "admin" with the required permission
        local Data = {}
        Data.name = vehdata.plate
        Data.coords = vehdata.coords
        Data.range = vehdata.volume * Config.DistanceToVolume
        Data.volume = vehdata.volume
        Data.deflink = vehdata.link
        Data.isplaying = true
        Data.loop = vehdata.loop
        Data.deftime = 0
        Data.popo = vehdata.popo
        table.insert(Config.Zones, Data)
        TriggerClientEvent('MusicEverywhere:AddVehicle', -1, Config.Zones[#Config.Zones])
    end
end)

RegisterNetEvent('MusicEverywhere:GetDate')
AddEventHandler('MusicEverywhere:GetDate', function()
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        TriggerClientEvent('MusicEverywhere:SendData', source, Config.Zones)
    end
end)
