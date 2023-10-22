local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

src = {}
Tunnel.bindInterface("rentalcars-server",src)

vRP._prepare("limirio/DeleteRentedCar", "DELETE FROM vrp_user_vehicles WHERE user_id = @user_id AND alugado = 1 AND data_alugado = 0")
vRP._prepare("limirio/CheckAlugado", "SELECT alugado FROM vrp_user_vehicles WHERE user_id = @user_id")
vRP._prepare("limirio/CheckHours", "SELECT data_alugado FROM vrp_user_vehicles WHERE user_id = @user_id")
vRP._prepare("limirio/InsertHours", "UPDATE vrp_user_vehicles SET data_alugado = @data_alugado WHERE alugado = 1 AND user_id = @user_id")
vRP.prepare("limirio/AddRentedCar",[[
	INSERT IGNORE INTO vrp_user_vehicles(user_id,vehicle,detido,time,engine,body,fuel,ipva,alugado,data_alugado) 
	VALUES(@user_id,@vehicle,@detido,@time,@engine,@body,@fuel,@ipva,1,@data_alugado);
]])

Citizen.CreateThread(function()
    vRP._prepare("limirio/createDB",[[
        ALTER TABLE vrp_user_vehicles ADD IF NOT EXISTS alugado TINYINT(4) NOT NULL DEFAULT 0;
        ALTER TABLE vrp_user_vehicles ADD IF NOT EXISTS data_alugado TEXT;
    ]])
    vRP.execute("limirio/createDB")
end)

Citizen.CreateThread(function()
    local users = vRP.getUsers()
    while true do 
        Wait(1000 * 60)
        for k,v in pairs(users) do
            local id = vRP.getUserSource(parseInt(k))
            local userId = vRP.getUserId(id)
            local query = vRP.query("limirio/CheckHours",{ user_id = userId })
            for k,v in pairs(query) do
                if CheckAlugado(userId) then 
                    local time = parseInt(v.data_alugado) 
                    if time <= 1 then 
                        vRP.execute("limirio/DeleteRentedCar",{ user_id = userId })
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    local users = vRP.getUsers()
    while true do 
        Wait(1000 * 60 * 60)
        for k,v in pairs(users) do
            local id = vRP.getUserSource(parseInt(k))
            local userId = vRP.getUserId(id)
            local query = vRP.query("limirio/CheckHours",{ user_id = userId })
            for k,v in pairs(query) do
                if Checkrent(userId) then 
                    local hours = parseInt(v.data_alugado) 
                    if hours > 2 then 
                        hours = hours - 1 
                        vRP.execute("limirio/InsertHours",{ user_id = userId, data_alugado = hours })
                    end
                end
            end
        end
    end
end)

function Checkrent(userId)
    local query = vRP.query("limirio/CheckAlugado",{ user_id = userId })
    for k,v in pairs(query) do  
        if v.alugado == 1 then 
            return true
        end
    end
end

function src.buyrent(name)
    local source = source 
    local userId = vRP.getUserId(source)
    for k,v in pairs(cars) do 
        if name == v.name then
            local consult = vRP.query("creative/get_vehicles",{ user_id = userId, vehicle = v.spawn })
            if not consult[1] then 
                if trypayment(userId,v.price) then 
                    vRP.execute("limirio/AddRentedCar", {user_id = userId, vehicle = v.spawn, detido = 0, time = 0, engine = 1000, body = 1000, fuel = 100, ipva = os.time(),alugado = 1, data_alugado = 24})
                    notify(source,languages["sucess_car"]..name..languages["sucess_car2"])
                else
                    notify(source,languages["insuficient_money"])
                end
            else
                notify(source,languages["has_vehicle"])
            end
        end
    end
end

