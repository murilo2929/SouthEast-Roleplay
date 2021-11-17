local items = exports['item-system']
local fishItem = 273
local FishType = {
    [1] = {fishname = "Caranguejo-luva Chinês", fishweight = 0.5, zone = 1},
    [2] = {fishname = "Linguado estrelado", fishweight = 11, zone = 1},
    [3] = {fishname = "Camarão de Água Doce San Andreas", fishweight = 1, zone = 1},
    [4] = {fishname = "Lampreia do Pacífico", fishweight = 0.6, zone = 1},
    [5] = {fishname = "Western Brook Lamprey", fishweight = 0.1, zone = 1},
    [6] = {fishname = "Esturjão branco", fishweight = 99, zone = 1},
    [7] = {fishname = "Sável Americano", fishweight = 6, zone = 1},
    [8] = {fishname = "Salmão Chinook", fishweight = 74, zone = 1},
    [9] = {fishname = "Salmão Rosa", fishweight = 8, zone = 1},
    [10] = {fishname = "Truta arco-íris", fishweight = 26, zone = 1},
    [11] = {fishname = "Baixo listrado", fishweight = 68, zone = 1},
    [12] = {fishname = "Bagre azul", fishweight = 81, zone = 1},
    [13] = {fishname = "Albacora", fishweight = 72, zone = 2},
    [14] = {fishname = "Atum Skipjack", fishweight = 41, zone = 2},
    [15] = {fishname = "Atum Cavala", fishweight = 15, zone = 2},
    [16] = {fishname = "Salmão do Atlântico", fishweight = 101, zone = 2},
    [17] = {fishname = "Salmão Chinook", fishweight = 134, zone = 2},
    [18] = {fishname = "Black Sea Bass", fishweight = 5, zone = 2},
    [19] = {fishname = "Cabeça de Carneiro", fishweight = 25, zone = 2},
    [20] = {fishname = "Scup", fishweight = 4, zone = 2},
    [21] = {fishname = "Raio Elétrico Marmoreado", fishweight = 3, zone = 2},
    [22] = {fishname = "Peixe-espada Atlântico", fishweight = 19, zone = 2},
    [23] = {fishname = "Tambor Vermelho", fishweight = 55, zone = 2},
}

function giveCatch(ThePlayer)
    local x, y, z = getElementPosition(ThePlayer)
    local keyset = {}
    
    if ( y >= 3000 ) or ( y <= -3000 ) or ( x >= 3000 ) or ( x <= -3000) then
        whichZone = 2
    else 
        whichZone = 1
    end

    for i, v in ipairs(FishType) do
        if (v.zone == whichZone) then
            table.insert(keyset, i)
        end
    end

    ourFish = FishType[math.random(#keyset)] 

    if items:hasSpaceForItem(ThePlayer, fishItem, 1) then
        items:giveItem(ThePlayer, fishItem, tostring(ourFish.fishname) .. ":" .. tostring(ourFish.fishweight))
        outputChatBox("Você pegou um " .. tostring(ourFish.fishname) .. "!", ThePlayer, 0, 255, 0)
    end
end

-- Added this function due to item system not allowing items to be taken clientside.
function takeRod(ThePlayer)
    items:takeItem(ThePlayer, 49, 1)
end

function getPayRate(client, money)
	local hours = tonumber(getElementData(client, "hoursplayed"))
	local rate = money
	local hoursrate = math.floor(hours*(rate*0.03))

	if hours>=10 then
		rate = rate-hoursrate
		if rate < 10 then
			rate = 10
		end
	end
    return rate
end

function GenerateFishPayment(ThePlayer)
    local fishininventory = items:countItems(ThePlayer, fishItem)
    local fishCount = 0
    local perFishCost = 0
    local calculate = 0
    local fishPrice = 0

    if (fishininventory == 0) then
        return exports.global:sendLocalText(ThePlayer, "[English] Fisherman John diz: Eu não posso comprar nada, você precisa pegar um pouco de peixe mano.", 255, 255, 255, 10)
    end

    -- Checks their inventory for the fish items.

    for i, v in ipairs(items:getItems(ThePlayer)) do
        local ItemID, ItemValue = unpack(v)
        if ItemID == fishItem then
            fishCount = fishCount + 1
        end
    end

    --Generate a price 
    local perFishCost = math.random(20, 80)
    local calculate = perFishCost * fishCount
    local fishPrice = calculate

    fishPrice = getPayRate(ThePlayer, fishPrice)

    triggerClientEvent(ThePlayer, "fishing:SellFishGUI", ThePlayer, fishCount, fishPrice)
end

function sellTheFish(ThePlayer, price)
    for i, v in ipairs(items:getItems(ThePlayer)) do
        local ItemID, ItemValue = unpack(v)
        if ItemID == fishItem then
            items:takeItem(ThePlayer, fishItem)
        end
    end
    exports.global:sendLocalText(ThePlayer, "[English] Fisherman John diz: Obrigado pelo peixe, aqui está o dinheiro!", 255, 255, 255, 10)
    exports.global:giveMoney(ThePlayer, price)
end

-- Commands and Events
addEvent("fishing:giveCatch", true)
addEvent("fishing:takeRod", true)
addEvent("fishing:GeneratePayment", true)
addEvent("fishing:sellFish", true)
addEventHandler("fishing:giveCatch", root, giveCatch)
addEventHandler("fishing:takeRod", root, takeRod)
addEventHandler("fishing:GeneratePayment", root, GenerateFishPayment)
addEventHandler("fishing:sellFish", root, sellTheFish)
