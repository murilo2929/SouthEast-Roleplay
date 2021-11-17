FORUM_FACTION_DROPS = 175
FORUM_AMMUNATION = 285

--MAXIME
local purchaseLogs = {}
function factionDropCreateItem(npcID, itemID, itemValue, itemPrice, itemQuan, itemCaliber, itemDesc, itemRestock, selectedItem)
	if not npcID or not tonumber(npcID) then
		triggerClientEvent(source, "shop:factionDropResponseFromServer", source, false, "Não foi possível alocar ID NPC.")
		return false
	end

	if not itemID or not tonumber(itemID) then
		triggerClientEvent(source, "shop:factionDropResponseFromServer", source, false, "Não foi possível alocar ID Item.")
		return false
	else
		itemID = tonumber(itemID)
	end

	if not itemQuan or not tonumber(itemQuan) or tonumber(itemQuan) < 1 then
		triggerClientEvent(source, "shop:factionDropResponseFromServer", source, false, "A quantidade deve ser numérica e maior que 0.")
		return false
	end
	itemQuan = math.floor(itemQuan)

	if not itemPrice or not tonumber(itemPrice) or tonumber(itemPrice) < 1 then
		triggerClientEvent(source, "shop:factionDropResponseFromServer", source, false, "O preço deve ser numérica e maior que 0.")
		return false
	end
	itemPrice = math.floor(itemPrice)

	if not itemRestock or not tonumber(itemRestock) or tonumber(itemRestock) < 0 then
		triggerClientEvent(source, "shop:factionDropResponseFromServer", source, false, "O reabastecimento automático deve ser numérico, igual e maior que 0.")
		return false
	end

	local weaponList = exports.weapon:getFactionNpcItems()

	itemRestock = math.floor(itemRestock)

	if itemID == 116 then
		if not itemDesc or not tonumber(itemDesc) or tonumber(itemDesc) < 1 then
			triggerClientEvent(source, "shop:factionDropResponseFromServer", source, false, "Os marcadores / Mag devem ser numéricos e maiores que 0.")
			return false
		else
			itemDesc = math.floor(itemDesc)
		end
	else
		if string.len(itemDesc) <= 1 then
			itemDesc = weaponList[selectedItem][3] or "Arma Desconhecida"
		end
	end

	local finalItemValue = ""
	-- first set the serial as creator dbid. actual serial will be made upon item buy.
	local serial = getElementData(source, 'dbid')
	if itemID == 115 then
		finalItemValue = itemValue..":"..serial..":"..itemDesc..":0"
	else
		local pack = exports.weapon:getAmmo(tonumber(itemValue))
		finalItemValue = itemValue..":"..pack.rounds..":"..serial
	end

	if not dbExec( exports.mysql:getConn('mta'),
	"INSERT INTO `shop_products` SET `pItemID`=?, `pItemValue`=?, `pPrice`=?, `pQuantity`=?, `pSetQuantity`=?, `pRestockInterval`=?, `npcID`=?, `pRestockedDate`=NOW()",
	itemID, finalItemValue, itemPrice, itemQuan, itemQuan, itemRestock, npcID) then
		triggerClientEvent(source, "shop:factionDropResponseFromServer", source, false, "Não foi possível criar o item, erro de banco de dados.")
		return false
	end
	triggerClientEvent(source, "shop:factionDropResponseFromServer", source, true)
	refreshFactionDropWeaponList(source,npcID)
end
addEvent("shop:factionDropCreateItem", true )
addEventHandler("shop:factionDropCreateItem", root, factionDropCreateItem)

function refreshFactionDropWeaponList(thePlayer,id)
	local products = {}
	local shopProducts = mysql:query("SELECT `npcID`, `pItemID`, `pItemValue`, `pDesc`, `pPrice`, `pDate`, `pID`, `pQuantity`, `pSetQuantity`, `pRestockInterval`, `pRestockedDate`, DATEDIFF((`pRestockedDate` + interval `pRestockInterval` day),NOW()) AS `pRestockIn` FROM `shop_products` WHERE `npcID`='"..id.."' ORDER BY `pID` DESC")
	while true do
		local pRow = mysql:fetch_assoc(shopProducts)
		if not pRow then break end
		table.insert(products, pRow )
	end
	mysql:free_result(shopProducts)
	triggerClientEvent(thePlayer, "shop:factionDropUpdateWeaponList", thePlayer, products)
end

function factionDropWeaponBuy(proID, theShop, reasonToBuy)
	local valid, why = isPlayerUsingThisShop(source, theShop)
	if not valid or not proID or not tonumber(proID) then
		triggerClientEvent(source, "shop:factionDropResponseFromServer:2", source, false, why)
		return false
	end

	local npcID = getElementData(theShop,"dbid")
	local pedName = getPedName(theShop)
	local playerName = exports.global:getPlayerName(source)

	local product = mysql:query_fetch_assoc("SELECT * FROM `shop_products` WHERE `pID`='"..proID.."' AND `npcID`='"..npcID.."' LIMIT 1")
	if not product or not product["pID"] or not tonumber(product["pID"]) then
		triggerClientEvent(source, "shop:factionDropResponseFromServer:2", source, false, "Este produto não está mais disponível nesta loja.")
		return false
	end

	local pQuantity = tonumber(product["pQuantity"]) or 0
	if pQuantity <= 0 then
		triggerClientEvent(source, "shop:factionDropResponseFromServer:2", source, false, "Este produto está fora de estoque.")
		return false
	end

	local pPrice = tonumber(product["pPrice"])
	if not pPrice or not exports.global:hasMoney(source, pPrice) then
		triggerClientEvent(source, "shop:factionDropResponseFromServer:2", source, false, "Você não pode comprar este item.")
		return false
	end

	local pItemID = tonumber(product["pItemID"])
	local pItemValueTmp = product["pItemValue"]
	local values = exports.global:explode(":", pItemValueTmp)
	local pItemValue = ""

	-- check space
	if not exports.global:hasSpaceForItem( source, pItemID, pItemValueTmp ) then
		triggerClientEvent(source, "shop:factionDropResponseFromServer:2", source, false, 'Seu inventario esta cheio.')
		return false
	end

	if pItemID == 115 then --gun
		local serial = exports.global:createWeaponSerial( 4, tonumber(values[2]) or 6685, getElementData(source, "dbid") )
		pItemValue = exports.weapon:modifyWeaponValue(pItemValueTmp, 2, serial)
	else
		local serial = exports.global:createWeaponSerial( 4, tonumber(values[3]) or 6685, getElementData(source, "dbid") )
		pItemValue = exports.weapon:modifyWeaponValue(pItemValueTmp, 3, serial)
	end

	if exports.global:takeMoney(source, pPrice) and exports["item-system"]:giveItem( source, pItemID, pItemValue ) then
		playBuySound(theShop)

		local itemName = exports["item-system"]:getItemName( pItemID, pItemValue )
		local itemValue = exports["item-system"]:getItemValue( pItemID, pItemValue )

		exports.global:sendLocalText(source, "✪ "..pedName.." da para "..playerName.." um(a) "..itemName..".", 255, 51, 102, 30, {}, true)
		local prepared = "UPDATE `shop_products` SET `pQuantity`=`pQuantity`-1 WHERE `pID`='"..proID.."' AND `npcID`='"..npcID.."' "
		if tonumber(product["pRestockInterval"]) < 1 and pQuantity <= 1 then
			prepared = "DELETE FROM `shop_products` WHERE `pID`='"..proID.."' AND `npcID`='"..npcID.."'"
		end
		if not mysql:query_free(prepared) then
			destroyElement(theShop)
			exports.global:sendWrnToStaffOnDuty("Exploit detectado no NPC da faction drop ID#"..npcID.." e com "..exports.global:getPlayerFullIdentity(source)..". Notifique um criador de scripts o mais rápido possível!", "SHOP")
			triggerClientEvent(source, "shop:factionDropResponseFromServer:2", source, false, "Exploit detectado no NPC da faction drop ID#"..npcID.." e com "..exports.global:getPlayerFullIdentity(source)..". Staff foram alertados." )
			return false
		end

		addPurchaseLogs(npcID, source, itemName, itemValue, exports.global:formatMoney(pPrice), serial , reasonToBuy, FORUM_FACTION_DROPS)

		triggerClientEvent(source, "shop:factionDropResponseFromServer:2", source, true, "Adquirido com sucesso!" )
		refreshFactionDropWeaponList(source,npcID)
		return true
	else
		triggerClientEvent(source, "shop:factionDropResponseFromServer:2", source, false, 'Ocorreram erros ao finalizar a venda.')
		return false
	end
end
addEvent("shop:factionDropWeaponBuy", true )
addEventHandler("shop:factionDropWeaponBuy", getRootElement(), factionDropWeaponBuy)

function getPlayerTeams(thePlayer)
	string = ""
	for k,v in pairs(getElementData(thePlayer, "faction")) do
		local team = exports.factions:getFactionFromID(k)
		if getElementData(team, "type") < 2 then
			string = string .. getTeamName(team) .. ", "
		end
	end
	return string ~= "" and string or "N/A"
end

function addPurchaseLogs(npcID, thePlayer, itemName, itemValue, price, serial, reason, forum)
	local r = getRealTime()
	local timeString = ("%02d/%02d/%04d %02d:%02d"):format(r.monthday, r.month + 1, r.year+1900, r.hour, r.minute)
	if not purchaseLogs[npcID] then
		purchaseLogs[npcID] = { forum = forum }
	end
	local buyerUsername = getElementData(thePlayer, "account:username")
	local buyerCharacter = exports.global:getPlayerName(thePlayer)
	local buyerFactions = getPlayerTeams(thePlayer)
	table.insert(purchaseLogs[npcID], {timeString, buyerUsername, buyerCharacter, buyerFactions, itemName, itemValue, price, serial, reason} )
end

function makePurchaseForumReports()
	local shops = getElementsByType("ped", getResourceRootElement ())
	local counter = 0
	for i, shop in pairs(shops) do
		local shoptype = getElementData(shop, "shoptype")
		if shoptype == 19 or shoptype == 2 then
			local npcID = getElementData(shop,"dbid")
			local npcName = getPedName(shop)
			if purchaseLogs[npcID] then
				local logs = purchaseLogs[npcID]
				createForumThread(logs, npcID, npcName, logs.forum)
				counter = counter + 1
				purchaseLogs[npcID] = nil
			end
		end
	end
	outputDebugString("[SHOP] A forum report has made for "..counter.." Faction Drop NPC(s).")
end

function createForumThread(logs, npcID, npcName, createInForumID)
	if true then return end -- disabled for now

	local fTitle = tostring(#logs).." itens foram comprados da NPC "..tostring(npcName).." (ID #"..tostring(npcID)..")"
	local fContent = ""
	--{timeString 1, buyerUsername 2, buyerCharacter 3 , buyerFaction 4, itemName 5, itemValue 6, price 7, serial 8, reason 9}
	for i, record in ipairs(logs) do
		fContent = fContent.."[BR][BR][B]Compra #"..i.."[/B][INDENT]Nome Item:   [B]"..tostring(record[5]).." [/B](Serial: "..(record[8] and record[8] or "N/A")..")[/INDENT] [INDENT]Custo do Item:      [B]$"..tostring(record[7]).."[/B][/INDENT] [INDENT]Valor do Item:   [B]"..tostring(record[6]).."[/B][/INDENT] [INDENT]Quantidade:        [B]1[/B][/INDENT] [BR][B]Info do Comprador[/B][INDENT] Username:      [B]"..tostring(record[2]).."[/B][/INDENT] [INDENT]Personagem:       [B]"..tostring(record[3]).."[/B][/INDENT] [INDENT] Facção:            [B]"..tostring(record[4]).."[/B] [/INDENT] [B]Razão:[/B][INDENT]"..tostring(record[9]).." [/INDENT] [B]Data da Emissão:  [/B][INDENT]"..tostring(record[1]).."   [/INDENT] [HR]"
	end

	local url = exports["integration"]:createForumThread(nil, createInForumID, fTitle, fContent)
	exports.global:sendWrnToStaff(tostring(#logs).." itens foram comprados da NPC "..tostring(npcName).." (ID #"..tostring(npcID)..")"..". "..(url and ("Details at "..url) or ""), "NPC")
end

function factionDropTakeDown(proID, theShop)
	local valid, why = isPlayerUsingThisShop(client, theShop)
	if not valid or not proID or not tonumber(proID) then
		triggerClientEvent(client, "shop:factionDropResponseFromServer:2", client, false, why)
		return false
	end

	local npcID = getElementData(theShop,"dbid")
	local pedName = getPedName(theShop)
	local playerName = exports.global:getPlayerName(client)

	local product = mysql:query_fetch_assoc("SELECT * FROM `shop_products` WHERE `pID`='"..proID.."' AND `npcID`='"..npcID.."' LIMIT 1")
	if not product or not product["pID"] or not tonumber(product["pID"]) then
		triggerClientEvent(client, "shop:factionDropResponseFromServer:2", client, false, "Este produto não está mais disponível nesta loja.")
		return false
	end

	local prepared = "DELETE FROM `shop_products` WHERE `pID`='"..proID.."' AND `npcID`='"..npcID.."'"
	if not mysql:query_free(prepared) then
		triggerClientEvent(client, "shop:factionDropResponseFromServer:2", client, false, "Não foi possível retirar o item. Exploit detectado no NPC da faction drop ID#"..npcID.." e com "..exports.global:getPlayerFullIdentity(source).."." )
		return false
	end

	triggerClientEvent(client, "shop:factionDropResponseFromServer:2", client, true, "Item retirado com sucesso!" )
	refreshFactionDropWeaponList(client,npcID)
	return true
end
addEvent("shop:factionDropTakeDown", true )
addEventHandler("shop:factionDropTakeDown", root, factionDropTakeDown)

function saveFactionDropNPCConfigs(theShop, faction_belong, faction_access)
	if exports.anticheat:changeProtectedElementDataEx(theShop, "faction_belong", faction_belong, true) and exports.anticheat:changeProtectedElementDataEx(theShop, "faction_access", faction_access, true) then
		outputChatBox("As configurações do NPC de facção foram salvas com sucesso.", source)
	else
		outputChatBox("Falha ao salvar as configurações de NPC de facção.", source)
	end
end
addEvent("saveFactionDropNPCConfigs", true )
addEventHandler("saveFactionDropNPCConfigs", root, saveFactionDropNPCConfigs)

function saveShopChangesToSQL()
	local shops = getElementsByType("ped", getResourceRootElement ())
	local counter = 0
	for i, shop in pairs(shops) do
		local shoptype = getElementData(shop, "shoptype")
		if shoptype == 18 or shoptype == 19 then
			local faction_belong = getElementData(shop, "faction_belong") or 0
			local faction_access = getElementData(shop, "faction_access") or 0
			local shopID = getElementData(shop, "dbid")
			if shopID and exports.mysql:query_free("UPDATE `shops` SET `faction_belong`='"..exports.global:toSQL(faction_belong).."', `faction_access`='"..exports.global:toSQL(faction_access).."' WHERE `id`='"..exports.global:toSQL(shopID).."' ") then
				counter = counter + 1
			else
				outputDebugString("[SHOP] Could not save configs for a shop because no ID found or database error ("..tostring(shopID)..")")
			end
		end
	end
	outputDebugString("[SHOP] Saved "..counter.." shops configs to SQL successfully.")
	if mysql:query_free("UPDATE `shop_products` SET `pQuantity`=`pSetQuantity`, `pRestockedDate`=NOW() WHERE `pRestockedDate` IS NOT NULL AND `pRestockInterval`>0 AND (DATEDIFF((`pRestockedDate` + interval `pRestockInterval` day),NOW())=0)") then
		outputDebugString("[SHOP] Faction Drop - Restocked products")
	else
		outputDebugString("[SHOP] Faction Drop - Failed to Restock products")
	end
	exports.data:savePurchaseLogs(purchaseLogs)
end
addEventHandler("onResourceStop",resourceRoot,saveShopChangesToSQL)
addEventHandler("onResourceStart",resourceRoot,function()
	purchaseLogs = exports.data:loadPurchaseLogs()

	setTimer(function()
		saveShopChangesToSQL()
	end, 60*1000*60, 0) -- every 60 minutes

	setTimer(function()
		makePurchaseForumReports()
	end, 60*1000*30, 0) -- every 30 minutes
end)

function adminSaveShopChangesToSQL(thePlayer, cmd)
	if exports.integration:isPlayerAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer) then
		saveShopChangesToSQL()
		outputChatBox("Saving started..", thePlayer)
	end
end
addCommandHandler("saveshopconfigs", adminSaveShopChangesToSQL)
