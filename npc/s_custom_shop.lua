--CUSTOM SHOP / MAXIME

local mysql = exports.mysql

local warningDebtAmount, limitDebtAmount, wageRate = nil
settings = {}
function fetchSettings()
	settings.warningDebtAmount = tonumber(get( "warningDebtAmount" )) or 500
	settings.limitDebtAmount = tonumber(get( "limitDebtAmount" )) or 1000
	settings.wageRate = tonumber(get( "wageRate" )) or 5
end
addEventHandler("onResourceStart", resourceRoot, fetchSettings)

function requestSettings()
	triggerClientEvent(root, 'npc:receiveServerSettings', resourceRoot, settings)
end
addEvent('npc:requestSettings', true)
addEventHandler('npc:requestSettings', root, requestSettings)

addEvent("shop:saveContactInfo", true)
function saveContactInfo(shopElement, contactInfo)
	local npcID = getElementData(shopElement,"dbid")
	local sucessfullyUpdateToSQL = false
	if mysql:query_fetch_assoc("SELECT `npcID` FROM `shop_contacts_info` WHERE `npcID` = '"..tostring(npcID).."'") then
		if mysql:query_free("UPDATE `shop_contacts_info` SET `sOwner`='"..tostring(contactInfo[1]):gsub("'","''").."', `sPhone`='"..tostring(contactInfo[2]):gsub("'","''").."', `sEmail`='"..tostring(contactInfo[3]):gsub("'","''").."', `sForum`='"..tostring(contactInfo[4]):gsub("'","''").."' WHERE `npcID`='"..tostring(npcID).."'") then
			sucessfullyUpdateToSQL = true
		end
	else
		if mysql:query_free("INSERT INTO `shop_contacts_info` SET `sOwner`='"..tostring(contactInfo[1]):gsub("'","''").."', `sPhone`='"..tostring(contactInfo[2]):gsub("'","''").."', `sEmail`='"..tostring(contactInfo[3]):gsub("'","''").."', `sForum`='"..tostring(contactInfo[4]):gsub("'","''").."', `npcID`='"..tostring(npcID).."'") then
			sucessfullyUpdateToSQL = true
		end
	end
	if sucessfullyUpdateToSQL then
		setElementData(shopElement, "sContactInfo", contactInfo, true)
	end
	--outputDebugString(tostring(sucessfullyUpdateToSQL).. tostring(contactInfo[2]):gsub("'","''"))
	return sucessfullyUpdateToSQL
end
addEventHandler("shop:saveContactInfo", getRootElement(), saveContactInfo)


addEvent("shop:addItemToCustomShop", true)
function addItemToCustomShop(element, slot, event, worldItem)
	local id, itemID, itemValue, item = nil

	if slot ~= -1 then
		itemdata = exports['item-system']:getItems( source )[ slot ]
		itemID = itemdata[1]
		itemValue = itemdata[2]
		itemMetadata = itemdata[5]
		item = {}
		item['id'] = itemID
		item['value'] = itemValue
		item['metadata'] = itemMetadata
	elseif worldItem then
		item = {}
		id = getElementData( worldItem, "id" )
		itemID = getElementData( worldItem, "itemID" )
		item['id'] = itemID
		itemValue = getElementData( worldItem, "itemValue" )
		item['value'] = itemValue
		itemMetadata = getElementData( worldItem, "metadata" )
		item['metadata'] = itemMetadata
	else
		triggerClientEvent( source, event or "finishItemMove", source )
		return false
	end

	local dbid = getElementDimension(element)

	if exports.global:hasItem(source, 4, dbid) or exports.global:hasItem(source, 5, dbid) then
		if element then
			local npcID = getElementData(element, "dbid") or false
			triggerClientEvent( source, "shop:addItemToShop", source, source, item, slot, worldItem, npcID, element )
			triggerClientEvent( source, event or "finishItemMove", source )
			return true
		end
		outputChatBox("Você deve ter a chave para poder reabastecer.",source, 255,0,0)
		return false
	end

	triggerClientEvent( source, event or "finishItemMove", source )
	return false
end
addEventHandler("shop:addItemToCustomShop", getRootElement(), addItemToCustomShop)

function updateItemToShop(source, item, price, desc, npcID, slot, worldItem, shopElement)
	setElementData(source, "shop:NoAccess", true, true )

	local pedName = getPedName(shopElement)

	local playerName = getPlayerName(source):gsub("_", " ")

	if tonumber(getElementData(shopElement, "sIncome")) < tonumber(getElementData(shopElement, "sPendingWage")) then
		storeKeeperSay(source, "E quanto ao meu salário??", pedName)
		setElementData(source, "shop:NoAccess", false, true )
		triggerClientEvent(source, "hideGeneralshopUI", source)
		return false
	end

	local allowedWeapons = {
	[15] = true, -- Cane
	[14] = true, -- Flowers
	[2] = true, -- Golf Club
	[5] = true, -- Bat
	[10] = true, -- Dildo
	[11] = true, -- Dildo
	[12] = true, -- Vibrator
	[13] = true, -- Vibrator
	}

	-- ban all weapons except the above, ban all kinds of ammo.
	if item['id'] == 116 or ( item['id'] == 115 and not allowedWeapons[tonumber( split( item['value'], ":")[1] )] ) then
		storeKeeperSay(source, "Holyshit! Não temos permissão para vender isso!", pedName)
		setElementData(source, "shop:NoAccess", false, true )
		triggerClientEvent(source, "hideGeneralshopUI", source)
		return false
	end

	if item['id'] == 3 or item['id'] == 4 or item['id'] == 5 then --Keys , to prevent alt->alt
		exports.global:sendLocalText(source, "* "..pedName.." ri da cara de "..playerName..".", 255, 51, 102, 30, {}, true)
		storeKeeperSay(source, "Haha, você realmente acha que as pessoas comprariam uma chave de baixa qualidade?", pedName)
		setElementData(source, "shop:NoAccess", false, true )
		triggerClientEvent(source, "hideGeneralshopUI", source)
		return false
	end

	local itemName = exports["item-system"]:getItemName(item['id'], item['value'], item['metadata'])
	if tonumber(price) < 0 then
		exports.global:sendLocalText(source, "* "..pedName.." não concorda com "..playerName.." sobre o preço do(a) "..itemName..".", 255, 51, 102, 30, {}, true)
		storeKeeperSay(source, "Não se vende simplesmente algo por um preço negativo, sim?", pedName)
		setElementData(source, "shop:NoAccess", false, true )
		triggerClientEvent(source, "hideGeneralshopUI", source)
		return false
	end
	local meta = null
	if type(item['metadata']) == 'table' then
		meta = toJSON(item['metadata'])
		if type(meta) ~= 'string' then
			meta = null
		else
			meta = "'" .. exports.mysql:escape_string(meta) .. "'"
		end
	end


	local addToShop = mysql:query_free("INSERT INTO `shop_products` SET `pItemID`='"..tostring(item['id']).."', `pItemValue`='"..tostring(item['value']):gsub("'","''").."', `pMetadata`="..(meta or 'NULL')..", `npcID`='"..tostring(npcID).."', `pPrice`='"..tostring(price).."', `pDesc`='"..tostring(desc):gsub("'","''").."' ") or false
	if addToShop then
		if slot == -1 and worldItem and isElement(worldItem) then
			local id = getElementData( worldItem, "id" )
			mysql:query_free("DELETE FROM `worlditems` WHERE `id`='" .. id .. "'")
			destroyElement(worldItem)
		else
			exports['item-system']:takeItemFromSlot( source, slot )
		end
		exports.logs:dbLog(source, 39, source, getPlayerName( source ) .. "-> PED: " .. pedName .. " - #" .. tostring(item['id']) .. " - " .. itemName .. " - " ..  tostring(item['value']))
		triggerEvent('sendAme', source, "entrega a "..pedName.." um(a) "..itemName..".")
		local playerGender = getElementData(source,"gender")
		if playerGender == 0 then
			storeKeeperSay(source, "Certo, entendi, senhor.", pedName)
		else
			storeKeeperSay(source, "Tudo bem, entendi, senhora.", pedName)
		end
		setElementData(source, "shop:NoAccess", false, true )
		local currentCap = tonumber(getElementData(shopElement, "currentCap")) + 1
		setElementData(shopElement, "currentCap", currentCap, true)
		triggerClientEvent(source, "hideGeneralshopUI", source)
		return true
	end
end
addEvent("shop:updateItemToShop", true )
addEventHandler("shop:updateItemToShop", getRootElement(), updateItemToShop)

function editItemToShop(source, price, desc, proID, itemName, shopElement)
	setElementData(source, "shop:NoAccess", true, true )

	local pedName = getPedName(shopElement)
	local playerName = getPlayerName(source):gsub("_", " ")

	if tonumber(getElementData(shopElement, "sIncome")) < tonumber(getElementData(shopElement, "sPendingWage")) then
		storeKeeperSay(source, "E quanto ao meu salário??", pedName)
		setElementData(source, "shop:NoAccess", false, true )
		triggerClientEvent(source, "hideGeneralshopUI", source)
		return false
	end

	if tonumber(price) < 0 then
		exports.global:sendLocalText(source, "* "..pedName.." não concorda com "..playerName.." sobre o preço do(a) "..itemName..".", 255, 51, 102, 30, {}, true)
		storeKeeperSay(source, "Não se vende simplesmente algo por um preço negativo, sim?", pedName)
		setElementData(source, "shop:NoAccess", false, true )
		triggerClientEvent(source, "hideGeneralshopUI", source)
		return false
	end

	local check = mysql:query_fetch_assoc("SELECT `pID` FROM `shop_products` WHERE `pID`='"..tostring(proID).."'") or false
	local checkingItem = false
	if check then
		checkingItem = check["pID"]
	end
	if checkingItem then
		local addToShop = mysql:query_free("UPDATE `shop_products` SET `pPrice`='"..tostring(price).."', `pDesc`='"..tostring(desc):gsub("'","''").."' WHERE `pID`='"..checkingItem.."'") or false
		if addToShop then
			triggerEvent("sendAme", source, "discute com "..pedName.." sobre o "..itemName..".")
			storeKeeperSay(source, "Claro, claro..", pedName)
			setElementData(source, "shop:NoAccess", false, true )
			triggerClientEvent(source, "hideGeneralshopUI", source)
		end
	else
		outputChatBox(" "..itemName.." não existe mais na loja.", source, 255,0, 0)
		setElementData(source, "shop:NoAccess", false, true )
		triggerClientEvent(source, "hideGeneralshopUI", source)
	end
end
addEvent("shop:EditItemToShop", true )
addEventHandler("shop:EditItemToShop", getRootElement(), editItemToShop)

function takeOffProductFromShop(source, proID, itemI, itemV, itemName, shopElement, metadata)
	itemI = tonumber(itemI)
	itemV = tostring(itemV)
	setElementData(source, "shop:NoAccess", true, true )

	local pedName = getPedName(shopElement)
	local playerName = getPlayerName(source):gsub("_", " ")

	if tonumber(getElementData(shopElement, "sIncome")) < tonumber(getElementData(shopElement, "sPendingWage")) then
		storeKeeperSay(source, "E quanto ao meu salário??", pedName)
		setElementData(source, "shop:NoAccess", false, true )
		triggerClientEvent(source, "hideGeneralshopUI", source)
		return false
	end


	if itemI == 115 or itemI == 116 then --weapons and ammo
		if getElementData( source, "license.gun" ) ~= 1 then
			storeKeeperSay(source, "Nah, desculpe. Eu não posso te dar isso a menos que você me mostre a licença..", pedName)
			setElementData(source, "shop:NoAccess", false, true )
			triggerClientEvent(source, "hideGeneralshopUI", source)
			return false
		end
	end



	local check = mysql:query_fetch_assoc("SELECT `pID` FROM `shop_products` WHERE `pID`='"..tostring(proID).."'") or false
	local checkingItem = false
	if check then
		checkingItem = check["pID"]
	end
	if checkingItem then
		local success, reason = exports["item-system"]:giveItem( source, itemI, itemV, false, false, metadata )
		if success then
			exports.global:sendLocalText(source, "* "..playerName.." pega um(a) "..itemName.." de "..pedName..".", 255, 51, 102, 30, {}, true)
			local playerGender = getElementData(source,"gender")
			if playerGender == 0 then
				storeKeeperSay(source, "Ai vai senhor.", pedName)
			else
				storeKeeperSay(source, "Ai vai senhora.", pedName)
			end
		else
			outputChatBox(reason,source, 255, 0, 0)
			setElementData(source, "shop:NoAccess", false, true )
			triggerClientEvent(source, "hideGeneralshopUI", source)
			return false
		end
		exports.logs:dbLog(source, 39, source, getPlayerName( source ) .. "<- PED: " .. pedName .. " - " .. itemName .. " - " ..  itemV)

		local addToShop = mysql:query_free("DELETE FROM `shop_products` WHERE `pID`='"..tostring(proID).."'") or false
		if addToShop then

			setElementData(shopElement, "currentCap", tonumber(getElementData(shopElement, "currentCap")) - 1, true)

			setElementData(source, "shop:NoAccess", false, true )
			triggerClientEvent(source, "hideGeneralshopUI", source)
		end
	else
		outputChatBox(" "..itemName.." não existe mais na loja.", source, 255,0, 0)
		setElementData(source, "shop:NoAccess", false, true )
		triggerClientEvent(source, "hideGeneralshopUI", source)
	end
end
addEvent("shop:takeOffProductFromShop", true )
addEventHandler("shop:takeOffProductFromShop", getRootElement(), takeOffProductFromShop)

function customShopBuy(proID, itemI, itemV, itemPrice, itemName, payByBank, shopElement, metadata)
	setElementData(client, "shop:NoAccess", true, true )
	itemI = tonumber(itemI)
	itemV = tostring(itemV)
	local logString = false
	local ownerNoti = nil
	local r = getRealTime()
	local timeString = ("%02d/%02d/%04d %02d:%02d"):format(r.monthday, r.month + 1, r.year+1900, r.hour, r.minute)

	local pedName = getPedName(shopElement)
	local playerName = getPlayerName(client):gsub("_", " ")



	if itemI == 115 or itemI == 116 then --weapons and ammo
		if getElementData( client, "license.gun" ) ~= 1 then
			storeKeeperSay(client, "Nah, desculpe. Não posso te vender isso, a menos que você me mostre a licença..", pedName)
			setElementData(client, "shop:NoAccess", false, true )
			triggerClientEvent(client, "hideGeneralshopUI", client)
			return false
		end
	end

	local check = mysql:query_fetch_assoc("SELECT `pID`, `pPrice` FROM `shop_products` WHERE `pID`='"..tostring(proID).."'") or false
	local checkingItem, checkingPrice = false
	if check then
		checkingItem = check["pID"]
		checkingPrice = check["pPrice"]
	end
	if checkingItem and checkingPrice and (tonumber(checkingPrice) == tonumber(itemPrice) ) then
		--outputDebugString(itemI.."-"..itemV)
		local success, reason = exports["item-system"]:giveItem( client, itemI, itemV, false, false, metadata )
		if success then
			local playerGender = getElementData(client,"gender")
			if not payByBank then
				playBuySound(shopElement)
				if playerGender == 0 then
					triggerEvent('sendAme', client, "tira algumas notas de dólar de sua carteira e entrega para "..pedName)
				else
					triggerEvent('sendAme', client, "tira algumas notas de dólar de sua carteira e entrega para "..pedName)
				end

				if exports.global:takeMoney(client, itemPrice) then
					--
				else
					storeKeeperSay(client, "Bem, me desculpe, mas isso não parece o suficiente..", pedName)
					exports.global:takeItem( client, itemI, itemV )
					setElementData(client, "shop:NoAccess", false, true )
					triggerClientEvent(client, "hideGeneralshopUI", client)
					return false
				end
				ownerNoti = "Um cliente comprou um(a) "..itemName.." por $"..exports.global:formatMoney(itemPrice).."."
				logString = "- "..timeString.." : Um cliente comprou um(a) "..itemName.." por $"..exports.global:formatMoney(itemPrice)..".\n"
			else
				playBuySound(shopElement)
				if playerGender == 0 then
					triggerEvent('sendAme', client, "tira um cartão de crédito de sua carteira e entrega para "..pedName)
				else
					triggerEvent('sendAme', client, "tira um cartão de crédito de sua carteira e entrega para "..pedName)
				end

				if exports.bank:takeBankMoney(client, itemPrice) then
					exports.bank:addBankTransactionLog(getElementData(client, "dbid"), nil, itemPrice, 0, "Purchase", "Comprado "..itemName.." por "..itemPrice.."$ de "..getElementData(shopElement, "name"), nil, nil)
				else
					storeKeeperSay(client, "Bem, me desculpe, mas isso não parece o suficiente..", pedName)
					exports.global:takeItem( client, itemI, itemV )
					setElementData(client, "shop:NoAccess", false, true )
					triggerClientEvent(client, "hideGeneralshopUI", client)
					return false
				end
				ownerNoti = getPlayerName(client):gsub("_", " ").."(Cartão de Débito) comprei um(a) "..itemName.." por $"..exports.global:formatMoney(itemPrice).."."

				logString = "- "..timeString.." : "..getPlayerName(client):gsub("_", " ").."(Cartão de Débito) bought a "..itemName.." por $"..exports.global:formatMoney(itemPrice)..".\n"
			end

			local additionalText = ""
			if payByBank then
				additionalText = " e devolve o cartão de débito"
			end

			triggerEvent("sendAme", shopElement, "deu a "..playerName.." um(a) "..itemName..additionalText..".")

			storeKeeperSay(client, "Aqui esta. E..", pedName)
			if playerGender == 0 then
				storeKeeperSay(client, "Obrigado, senhor. Tenha um bom dia!", pedName)
			else
				storeKeeperSay(client, "Obrigado, senhora. Tenha um bom dia!", pedName)
			end

		else
			outputChatBox(reason, client, 255, 0, 0)
			setElementData(client, "shop:NoAccess", false, true )
			triggerClientEvent(client, "hideGeneralshopUI", client)
			return false
		end

		local addToShop = mysql:query_free("DELETE FROM `shop_products` WHERE `pID`='"..tostring(proID).."'") or false
		if addToShop then

			--notifyAllShopOwners(shopElement, ownerNoti.." Come and collect the money when you got time ;)")
			--outputDebugString(ownerNoti)



			local previousSales = getElementData(shopElement, "sSales") or ""
			logString = string.sub(logString..previousSales,1,5000)
			setElementData(shopElement, "sSales", logString, true)
			mysql:query_free("UPDATE `shops` SET `sIncome` = `sIncome` + '" .. tostring(itemPrice) .. "', `sSales` = '"..logString:gsub("'","''").."' WHERE `id` = '"..tostring(getElementData(shopElement,"dbid")).."'")

			exports.anticheat:setEld(shopElement, "sIncome", tonumber(getElementData(shopElement, "sIncome")) + tonumber(itemPrice), 'all')
			setElementData(shopElement, "currentCap", tonumber(getElementData(shopElement, "currentCap")) - 1, true)

			setElementData(client, "shop:NoAccess", false, true )
			triggerClientEvent(client, "hideGeneralshopUI", client)
		end
	else
		outputChatBox(" "..itemName.." não existe mais na loja.", client, 255,0, 0)
		setElementData(client, "shop:NoAccess", false, true )
		triggerClientEvent(client, "hideGeneralshopUI", client)
	end
end
addEvent("shop:customShopBuy", true )
addEventHandler("shop:customShopBuy", getRootElement(), customShopBuy)

function expandBiz(shopID, capacity)
	mysql:query_free("UPDATE `shops` SET `sCapacity`='"..tostring(capacity).."' WHERE `id`='"..tostring(shopID).."'")
end
addEvent("shop:expand", true )
addEventHandler("shop:expand", getRootElement(), expandBiz)

function storeKeeperSay(thePlayer, content, pedName)
	local languageslot = getElementData(thePlayer, "languages.current") or 1
	local language = getElementData(thePlayer, "languages.lang" .. languageslot)
	local languagename = call(getResourceFromName("language-system"), "getLanguageName", language)
	pedName = string.gsub(pedName, "_" , " ")
	if languagename == "<Invalid/Bugged Language>" then
		outputDebugString("LANGUAGE " .. tostring(languageslot) .. " " .. tostring(language) )
	end
	exports.global:sendLocalText(thePlayer, "["..(languagename or 'Inglês').."] "..tostring(pedName).." diz: "..content, 255, 255, 255, 30, {}, true)
end
addEvent("shop:storeKeeperSay", true )
addEventHandler("shop:storeKeeperSay", getRootElement(), storeKeeperSay)

function updateSaleLogs(thePlayer, shopID, content)
	--outputDebugString(shopID.."-"..content)
	content = string.sub(content, 1, 5000)
	local update = mysql:query_free("UPDATE `shops` SET `sSales`='"..tostring(content).."' WHERE `id`='"..tostring(shopID).."' ") or false
	if update and thePlayer then
		outputChatBox("Updated SaleLogs.", thePlayer, 0, 255,0)
	end
end
addEvent("shop:updateSaleLogs", true )
addEventHandler("shop:updateSaleLogs", getRootElement(), updateSaleLogs)

function notifyAllShopOwners(shopElement, content)
	local maxDebt = exports.global:formatMoney(settings.limitDebtAmount)
	local warningDebt = exports.global:formatMoney(settings.warningDebtAmount)
	local contentList = {
		{	-- 1. Ask for money when debt exceeds $1500
			"Ei chefe, você me deve pelo menos $"..warningDebt.." agora quer me pagar ou não..?",
			"Bem, eu não quero ser um idiota, mas você me deve pelo menos $"..warningDebt.." agora..",
			"Venha aqui e resolva a porra do salário .. Você me deve pelo menos $"..warningDebt.." agora.",
			"Se você não vier e resolver meu maldito salário, eu desisto..",
			"Chefe! resolva meu salário agora!!!",
		},
		{ 	-- 2. Quit
			"Ei chefe, eu saí do meu emprego, divirta-se com sua loja vazia..",
			"Tchau tchau chefe e desculpe por sua loja vazia.. LOL",
			"Eu pedi demissão e você ainda me deve a porra do $"..maxDebt.."..",
			"Ei filho da puta, você me deve porra de $"..maxDebt.." e não quer pagar ?? Diga adeus às suas coisas então..",
			"Oi chefe, sinto muito ter que largar meu emprego, seu negócio simplesmente não é lucrativo..",
		},
	}
	local contentTemp = nil
	if tonumber(content) then
		contentTemp = tonumber(content)
		content = contentList[content][math.random( 1, 5 )]
		if contentTemp == 0 then -- Temporarily disabled / MAXIME
			shopLeaveNoteOnLeave(shopElement, content)
		end
	end

	local pedName = getPedName(shopElement)
	setTimer(function()
		--exports.global:sendLocalText(shopElement, "*"..pedName.." takes out a cellphone and starts sending text messages.", 255, 51, 102, 30, {}, true)

		local possibleOwners = getElementsByType("player")
		--local number = {"545683", "234233", "887563", "686831", "222323", "777887", "999870", "434666", "109583", "667233"}
		local effectedPlayers = 0
		for _, owner in ipairs(possibleOwners) do
			local bizKey = getElementDimension(shopElement)
			local isBizOwner, bizName = isBizOwner(owner, bizKey)
			if isBizOwner then
				if exports.global:hasItem(owner, 2) then
					local languageslot = getElementData(owner, "languages.current") or 1
					local language = getElementData(owner, "languages.lang" .. languageslot)
					local languagename = call(getResourceFromName("language-system"), "getLanguageName", language)
					local ownerName = getPlayerName(owner):gsub("_", " ")

					exports.global:sendLocalText(owner, "*"..ownerName.." recebe uma mensagem de texto.", 255, 51, 102, 30, {}, true)

					outputChatBox("["..languagename.."] SMS de "..pedName.." em "..bizName..": "..content, owner, 120, 255, 80)
					effectedPlayers = effectedPlayers + 1
				end
			end
		end
		if effectedPlayers == 0 then
			local r = getRealTime()
			local timeString = ("%02d/%02d/%04d %02d:%02d"):format(r.monthday, r.month + 1, r.year+1900, r.hour, r.minute)

			logString = "- "..timeString.." : "..content.." ("..pedName..")\n"
			local previousSales = getElementData(shopElement, "sSales") or ""
			logString = logString..previousSales
			logString = string.sub(logString, 1, 5000)
			setElementData(shopElement, "sSales", logString, true)
			mysql:query_free("UPDATE `shops` SET `sSales` = '"..logString:gsub("'","''").."' WHERE `id` = '"..tostring(getElementData(shopElement,"dbid")).."'")
		end
	end, 2000, 1)
end
addEvent("shop:notifyAllShopOwners", true )
addEventHandler("shop:notifyAllShopOwners", getRootElement(), notifyAllShopOwners)

function isBizOwner(player, bizKey)
	local key = bizKey
	local possibleInteriors = getElementsByType("interior")
	local isOwner = false
	local interiorName = false
	for _, interior in ipairs(possibleInteriors) do
		if tonumber(key) == getElementData(interior, "dbid") then
			interiorName = getElementData(interior, "name") or ""
			local status = getElementData(interior, "status")
			interiorSupplies = status.supplies or 0
			if status.type ~= 2 then
				if status.owner == getElementData(player, "dbid") then
					isOwner = true
					break
				end
			end
		end
	end
	if not interiorName then
		return false, false
	end
	return isOwner, interiorName
end

function resetPendingWage(thePlayer)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		local adminUsername = getElementData(thePlayer, "account:username")
		local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
		local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)

		outputDebugString("BIZ-SYSTEM SETTINGS: wageRate="..settings.wageRate..", limitDebtAmount="..settings.limitDebtAmount..", warningDebtAmount="..settings.warningDebtAmount.."")
		outputChatBox("BIZ-SYSTEM SETTINGS: wageRate="..settings.wageRate..", limitDebtAmount="..settings.limitDebtAmount..", warningDebtAmount="..settings.warningDebtAmount.."", thePlayer)
		outputDebugString("------------START RESETING SHOP WAGES------------")
		outputChatBox("------------START RESETING SHOP WAGES------------", thePlayer)
		local count = 0
		local possibleShops = getElementsByType("ped")
		for _, shop in ipairs(possibleShops) do
			if getElementData(shop, "customshop") then
				local shopID = getElementData(shop, "dbid") or false
				if shopID then
					local sPendingWage = tonumber(getElementData(shop, "sPendingWage")) or 0
					local update = mysql:query_free("UPDATE `shops` SET `sPendingWage`='0' WHERE `id`='"..tostring(shopID).."' ") or false
					if update then
						outputDebugString("Shop ID#"..shopID.." Reset Staff Wage "..sPendingWage.." -> 0")
						outputChatBox("Shop ID#"..shopID.." Reset Staff Wage "..sPendingWage.." -> 0", thePlayer)
						if hiddenAdmin == 0 then
							notifyAllShopOwners(shop, "(("..adminTitle.." "..adminUsername.." has reset this shop's wage to $0.))")
						else
							notifyAllShopOwners(shop, "((A hidden admin has reset this shop's wage to $0.))")
						end
						count = count + 1
						exports.anticheat:setEld(shop, "sPendingWage", 0, 'all')
					else
						outputDebugString("Shop ID#"..shopID.." Reset Staff Wage Failed.")
						outputChatBox("Shop ID#"..shopID.." Reset Staff Wage Failed.", thePlayer)
					end
				end
			end
		end
		outputDebugString("------------RESET "..count.." SHOP WAGES------------")
		outputChatBox("------------RESET "..count.." SHOP WAGES------------", thePlayer)

		if hiddenAdmin == 0 then
			exports.global:sendMessageToAdmins("[BIZ-SYSTEM]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " ("..adminUsername..") has reset "..count.." custom shop wages to $0.")
		else
			exports.global:sendMessageToAdmins("[BIZ-SYSTEM]: A hidden admin has reset "..count.." custom shop wages to $0.")
		end
	end
end
addCommandHandler("resetshopwage", resetPendingWage)

function shopLeaveNoteOnLeave(shopElement, content)
	local itemID = 72 -- note
	local itemValue = content
	local x, y, z = getElementPosition(shopElement)
	local dimension = getElementDimension(shopElement)
	local interior = getElementInterior(shopElement)
	local rz2 = -1
	local creator = 14652 -- The Storekeeper
	local protected = 0
	local modelid = exports['item-system']:getItemModel(itemID, itemValue)
	local rx, ry, rz, zoffset = exports['item-system']:getItemRotInfo(itemID)
	local id = SmallestID()
	local insert = mysql:query_free("INSERT INTO `worlditems` SET `id` = '"..tostring(id).."', `itemid`='"..tostring(itemID).."',`itemvalue`='"..tostring(itemValue):gsub("'","''").."', `x`='"..tostring(x).."', `y`='"..tostring(y).."', `z`='"..tostring(z).."', `dimension`='"..tostring(dimension).."', `interior`='"..tostring(interior).."', `rz`='"..tostring(rz2).."', `creator`='"..tostring(creator).."' ") or false

	if insert then
		local obj = exports["item-world"]:createItem(id, itemID, itemValue, modelid, x, y, z + ( zoffset or 0 ), rx, ry, rz+rz2)
		exports.pool:allocateElement(obj)
		setElementDimension(obj, dimension)
		setElementInterior(obj, interior)
		setElementData(obj, "creator", creator, false)
	end
end

function showCustomShopStatus(thePlayer)
	outputDebugString("BIZ-SYSTEM SETTINGS: wageRate="..settings.wageRate..", limitDebtAmount="..settings.limitDebtAmount..", warningDebtAmount="..settings.warningDebtAmount.."")
	outputDebugString("------------START------------")
	if thePlayer then
		outputChatBox("BIZ-SYSTEM SETTINGS: wageRate="..settings.wageRate..", limitDebtAmount="..settings.limitDebtAmount..", warningDebtAmount="..settings.warningDebtAmount.."", thePlayer)
		outputChatBox("------------START------------", thePlayer)
	end
	local count = 0
	local possibleShops = getElementsByType("ped", resourceRoot)
	for _, shop in ipairs(possibleShops) do
		if getElementData(shop, "customshop") then
			local shopID = getElementData(shop, "dbid") or false
			if shopID then
				local sCapacity = tonumber(getElementData(shop, "sCapacity")) or 0
				local sPendingWage = tonumber(getElementData(shop, "sPendingWage")) or 0
				local sNewPendingWage = math.floor((sCapacity/wageRate)) + sPendingWage
				local sIncome = tonumber(getElementData(shop, "sIncome")) or 0
				local sProfit = sIncome-sNewPendingWage
				local currentCap = tonumber(getElementData(shop, "currentCap")) or 0

				outputDebugString("CShop ID#"..shopID..": Cap: "..currentCap.."/"..sCapacity..", Income: $"..sIncome..", Wage: $"..sPendingWage.." (->$"..sNewPendingWage.."), Profit: $"..sProfit..".")
				if thePlayer then
					outputChatBox("CShop ID#"..shopID..": Cap: "..currentCap.."/"..sCapacity..", Income: $"..sIncome..", Wage: $"..sPendingWage.." (->$"..sNewPendingWage.."), Profit: $"..sProfit..".", thePlayer)
				end
				count = count + 1
			end
		end
	end
	outputDebugString("------------SHOWED "..count.." CSHOPS------------")
	if thePlayer then
		outputChatBox("------------SHOWED "..count.." CSHOPS------------", thePlayer)
	end
end

function forceShowAllCustomShop(thePlayer)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		showCustomShopStatus(thePlayer)
	end
end
addCommandHandler("showallcustomshops", forceShowAllCustomShop)
