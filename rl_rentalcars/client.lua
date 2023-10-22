local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

src = {}
Tunnel.bindInterface("rentalcars-client",src)
vServer = Tunnel.getInterface("rentalcars-server")

-- # Nui Callbacks

RegisterNUICallback("RentCars",function(data)
    vServer.buyrent(data.name)
end)    

RegisterNUICallback("Close",function()
    SetNuiFocus(false)
end)

-- # Peds Thread

local fixedPeds = {}

CreateThread(function()
    while true do
        local sleep = 1000
        for k,v in pairs(Coords) do
            local playerPed = PlayerPedId()
            local distance1 = GetEntityCoords(playerPed)
            local distance2 = vector3(v[1],v[2],v[3])
            local distance = #(distance1 - distance2)
            if distance <= 30 then
                if not fixedPeds[k] then
                    RequestModel(hashped)
                    while not HasModelLoaded(hashped) do
                        Wait(1)
                    end
                    ped = CreatePed(4,hashped,v[1],v[2],v[3]-1,v[4],false,false)
                    FreezeEntityPosition(ped,true)
                    SetEntityInvincible(ped,true)
                    SetBlockingOfNonTemporaryEvents(ped,true)
                    fixedPeds[k] = ped
                end
            else 
                if fixedPeds[k] then
                    DeletePed(ped)
                    fixedPeds[k] = false
                end
            end
        end
        Wait(sleep)
    end
end)

-- # Command

RegisterKeyMapping("rentalcars", "[Limirio]Abrir o rentalcars", "keyboard", "E") 

RegisterCommand("rentalcars",function()
    local playerPed = PlayerPedId()
    local distance1 = GetEntityCoords(playerPed)
    local distance2 = vector3(v[1],v[2],v[3])
    local distance = #(distance1 - distance2)
    if distance <= 1 then 
        for k,v in pairs(cars) do 
            SendNUIMessage({ open = true, name = v["name"], price = v["price"],image = v["image"] })
            SetNuiFocus(true,true)
        end
    end
end)

-- # Hoverfy

Citizen.CreateThread(function()
    local innerTable = hoverfyText()
	TriggerEvent("hoverfy:insertTable",innerTable)
end)