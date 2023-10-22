Coords = {
	-- x       y       z     h
	{ -32.58,-1099.04,26.43,64.28 }
}

hashped = "a_m_y_business_03" -- Hash npc Que irá aparecer no jogo | Você pode encontrá-los aqui: https://docs.fivem.net/docs/game-references/ped-models/

cars = {
	{
		name = "LANCER EVOLUTION X", -- NOME QUE IRÁ APARECER NA NUI (NOME BONITO)
		spawn = "lancerevolutionx", -- Spawn do Carro 
		price = 500000, -- Preço que irá aparecer na nui
		image = "lancerevolutionx" -- Nome da Imagem que está na pasta web/images Exemplo: Lancer
	},
	{
		name = "R6", -- NOME QUE IRÁ APARECER NA NUI (NOME BONITO)
		spawn = "r6", -- Spawn do Carro 
		price = 500000, -- Preço que irá aparecer na nui
		image = "r6" -- Nome da Imagem que está na pasta web/images Exemplo: r6
	}
}

-- # functions

hoverfyText = function()
	local innerTable = {}
	for k,v in pairs(Coords) do
		table.insert(innerTable,{ v[1],v[2],v[3],2,"E","Aluguel de Veículos","Pressione E para Abrir." })
	end
	return innerTable
end

trypayment = function(userId,price)
	return vRP.tryPayment(userId, price)
end

notify = function(source,message)
	TriggerClientEvent("Notify",source,"aviso",message)
end

-- # notify messages 

languages = {
	["has_vehicle"] = "Você já possui este veículo em sua garagem.",
	["insuficient_money"] = "Você não possui dinheiro suficiente para alugar este veículo.",
	["sucess_car"] = "Sucesso ao alugar o veículo: ",
	["sucess_car2"] = " por um período de 1 dia.",
}