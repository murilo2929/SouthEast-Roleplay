local mysql = exports.mysql

factionsThatPayForFuel = { [1]=true, [2]=true, [3]=true, [4]=true, [47]=true, [59]=true, [50]=true, [64]=true, [164]=true }

function startTalkToPed ()

	thePed = source
	thePlayer = client


	if not (thePlayer and isElement(thePlayer)) then
		return
	end

	local posX, posY, posZ = getElementPosition(thePlayer)
	local pedX, pedY, pedZ = getElementPosition(thePed)
	if not (getDistanceBetweenPoints3D(posX, posY, posZ, pedX, pedY, pedZ)<=7) then
		return
	end

	if not (isPedInVehicle(thePlayer)) or (isPedInVehicle(thePlayer) and getVehicleType(getPedOccupiedVehicle(thePlayer)) == "BMX") then
		processMessage(thePed, "Olá, o que posso fazer por você?.")
 		setConvoState(thePlayer, 3)
		local responseArray = { "Você poderia encher minha lata de combustível?", "Eh .. nada na verdade", "Você tem um cigarro para mim?", "Gosto de sua roupa." }
		triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
	else
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if (exports.vehicle:isVehicleWindowUp(theVehicle)) then
			outputChatBox("Você pode querer abaixar sua janela primeiro, antes de falar com alguém fora do veículo", thePlayer, 255,0,0)
			return
		end
		-- processMeMessage(thePed, "leans against " .. getPlayerName(thePlayer):gsub("_"," ") .. "'s vehicle.", thePlayer )
		triggerEvent('sendAme', thePed, "se inclina contra o veículo de " .. getPlayerName(thePlayer):gsub("_"," "))
		processMessage(thePed, "Ei como eu poderia te ajudar?")
 		setConvoState(thePlayer, 1)
		local responseArray = { "Ehm, eu gostaria de um pouco de gasolina por favor.", "Não, obrigado.", "Você tem um cigarro para mim?", "Pare de se encostar no meu veículo." }
		triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
	end
end
addEvent( "fuel:startConvo", true )
addEventHandler( "fuel:startConvo", getRootElement(), startTalkToPed )

function talkToPed(answer, answerStr)
	thePed = source
	thePlayer = client

	if not (thePlayer and isElement(thePlayer)) then
		return
	end

	local posX, posY, posZ = getElementPosition(thePlayer)
	local pedX, pedY, pedZ = getElementPosition(thePed)
	if not (getDistanceBetweenPoints3D(posX, posY, posZ, pedX, pedY, pedZ) <= 7) then
		return
	end

	local convState = getElementData(thePlayer, "ped:convoState")
	local currSlot = getElementData(thePlayer, "languages.current") or 1
	local currLang = getElementData(thePlayer, "languages.lang" .. currSlot)
	processMessage(thePlayer, answerStr, currLang)
	if (convState == 1) then -- "Ei como eu poderia te ajudar?"
		local languageSkill = exports['language-system']:getSkillFromLanguage(thePlayer, 1)
		if (languageSkill < 60) or (currLang ~= 1) then
			processMessage(thePed, "Uh desculpe eu não entendi.")
			setConvoState(thePlayer, 0)
			return
		end

		if (answer == 1) then -- "Ehm, fill my tank up, please."
			if not (isPedInVehicle(thePlayer)) then
				processMessage(thePed, "Ehm...")
				setConvoState(thePlayer, 0)
				return
			end
			local theVehicle = getPedOccupiedVehicle(thePlayer)
			if (getElementData(theVehicle, "engine") == 1) then
				processMessage(thePed, "Você poderia por favor desligar o motor?")
				local responseArray = { "Claro, sem problemas.", "Você não pode fazer isso com o motor ligado?", "Eh, O QUE?" }
				triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
				setConvoState(thePlayer, 2)
				return
			elseif getElementData(theVehicle, 'fuel') > (getMaxFuel(getElementModel(theVehicle))-1) then
				processMessage(thePed, "Parece muito cheio para mim.")
			else
				processMessage(thePed, "Claro ... Como você gostaria de pagar?")
				if getATMCardFromATMMachine(thePlayer) then
					local responseArray = { "Dinheiro, por favor!", "Vou usar minha conta no banco.", "Desculpe o que?" }
					triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
				else
					local responseArray = { "Dinheiro, por favor!", false, "Desculpe o que?" }
					triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
				end
				setConvoState(thePlayer, 4)
				--processMessage(thePed, "Sure... we could arrange that.")
				--pedWillFillVehicle(thePlayer, thePed)
			end
		elseif (answer == 2) then -- "No thanks."
			processMessage(thePed, "Certo, tudo bem. Passe por aqui quando precisar de combustível.")
			setConvoState(thePlayer, 0)
		elseif (answer == 3) then -- "Do you have a sigarette for me?"
			processMessage(thePed, "Uhm, não. Você poderia verificar em um 24/7.")
			setConvoState(thePlayer, 0)
		elseif (answer == 4) then -- stop leaning against my car
			processMessage(thePed, "Okay, okay... Fique calmo.")
			--processMeMessage(thePed, "pushes himself up again, standing on his feet.", thePlayer )
			triggerEvent('sendAme', thePed, "se levanta novamente, ficando de pé.")
			processMessage(thePed, "Bem, devo encher ou não?.")
			local responseArray = {  "Vá em frente.", "Não, não mais." }
			triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
			setConvoState(thePlayer, 1)
		end
	elseif (convState == 2) then -- "Você poderia por favor desligar o motor?"
		if (answer == 1) then -- "Sure, no problemo." / "Ok, okay.."
			if not (isPedInVehicle(thePlayer)) then
				processMessage(thePed, "Ehm...")
				setConvoState(thePlayer, 0)
				return
			end
			local theVehicle = getPedOccupiedVehicle(thePlayer)
			-- processMeMessage(thePlayer, "shuts down the engine.",thePlayer )
			triggerEvent('sendAme', thePlayer, "desliga o motor.")
			setElementData(theVehicle, "engine", 0)
			setVehicleEngineState(theVehicle, false)
			
			if exports.global:hasItem(theVehicle, 3, getElementData(theVehicle, "dbid")) and exports.global:takeItem(theVehicle, 3, getElementData(theVehicle, "dbid")) then
				exports.global:giveItem(thePlayer, 3, getElementData(theVehicle, "dbid"))
			end

			processMessage(thePed, "Tudo bem, obrigado! Como você gostaria de pagar?")
			if getATMCardFromATMMachine(thePlayer) then
				local responseArray = { "Dinheiro, por favor!", "Vou usar minha conta no banco.", "Desculpe o que?" }
				triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
			else
				local responseArray = { "Dinheiro, por favor!", false, "Desculpe o que?" }
				triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
			end
			setConvoState(thePlayer, 4)
		elseif (answer == 2) then -- "Can't you do it with the engine running?"
			--processMeMessage(thePed, "sighs.",thePlayer )
			triggerEvent('sendAme', thePed, "suspiros.")
			processMessage(thePed, "Ehm... não. Eu não quero morrer. Então, vai desligar ou não?")
			local responseArray = {  "Vá em frente.", false, false, "Ugh, cala a boca então."  }
			triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
			setConvoState(thePlayer, 2)
		elseif (answer == 3) then -- "Eh, WHAT?"
			processMessage(thePed, "Eu perguntei: você poderia desligar seu motor?")
			local responseArray = {  "Ok, okay..", false,false, "Ugh, não."  }
			triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
			setConvoState(thePlayer, 2)
		elseif answer == 4 then -- "Ugh, shut up then." / "Ugh, no."
			processMessage(thePed, "Okay, okay... Vá com calma. Se perder.")
			setConvoState(thePlayer, 0)
		end
	elseif (convState == 3) then
		if answer == 1 then -- Could you fill my fuelcan?
			if (exports.global:hasItem(thePlayer, 57)) then
				processMessage(thePed, "Certo. Vamos bora lá!")
				--processMeMessage(thePed, "attaches the hose to the tanker, rolling it out.",thePlayer )
				--processMeMessage(thePed, "twists the cap of the fuelcan, hosing in and filling it slowly.",thePlayer )
				triggerEvent('sendAme', thePed, "conecta a mangueira ao caminhão-tanque, desenrolando-a.")
				triggerEvent('sendAme', thePed, "torce a tampa da lata de combustível, encaixando e enchendo lentamente.")
				setTimer(pedWillFillFuelCan, 3500, 1, thePlayer, thePed)
			else
				processMessage(thePed, "Uhm .. Você vai precisar de uma lata de combustível para isso ... Você pode comprar uma em um 24/7.")
				setConvoState(thePlayer, 0)
			end
		elseif answer == 2 then -- No thanks
			processMessage(thePed, "Okay, tenha um bom dia.")
			setConvoState(thePlayer, 0)
		elseif answer == 3 then -- Você tem um cigarro para mim?
			processMessage(thePed, "Uhm, não. Você poderia verificar na 24/7.")
			setConvoState(thePlayer, 0)
		elseif answer == 4 then -- I like your suit
			processMessage(thePed, "Eh, obrigado... Eu acho.")
			setConvoState(thePlayer, 0)
		end
	elseif (convState == 4) then -- How would you like to pay?
		if answer == 1 or answer == 2 then  -- Bank = 2 Cash = 1
			if answer == 2 and answerStr ~= "accepted" then
				triggerClientEvent(thePlayer, "fuel:requestATMInterfacePIN", thePed, thePlayer, exports.global:getElementZoneName(thePlayer))
				setConvoState(thePlayer, 4)
				return
			end
			processMessage(thePed, "Tudo bem então, quanto você quer?")
			local responseArray = { "$40", "$60", "$100", "Completa!" }
			triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
			exports.anticheat:changeProtectedElementDataEx(thePlayer, "ped:Type", answer, false)
			setConvoState(thePlayer, 5)
		elseif answer == 3 then
			processMessage(thePed, "Eu perguntei como você deseja pagar pelo seu gás.")
			if getATMCardFromATMMachine(thePlayer) then
				local responseArray = { "Dinheiro, por favor!", "Vou usar minha conta no banco.", "Desculpe o que?", "Esquece.." }
				triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
			else
				local responseArray = { "Dinheiro, por favor!", false, "Desculpe o que?", "Esquece.." }
				triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
			end
			setConvoState(thePlayer, 4)
		elseif answer == 4 then
			processMessage(thePed, "Tudo bem então..")
			setConvoState(thePlayer, 0)
		end
	elseif (convState == 5) then
		if answer == 1 then
			exports.anticheat:changeProtectedElementDataEx(thePlayer, "ped:amount", 40, false)
		elseif answer == 2 then
			exports.anticheat:changeProtectedElementDataEx(thePlayer, "ped:amount", 80, false)
		elseif answer == 3 then
			exports.anticheat:changeProtectedElementDataEx(thePlayer, "ped:amount", 100, false)
		elseif answer == 4 then
			exports.anticheat:changeProtectedElementDataEx(thePlayer, "ped:amount", 0, false)
		end
		if not (isPedInVehicle(thePlayer)) then
			processMessage(thePed, "Ehm...")
			setConvoState(thePlayer, 0)
			return
		end

		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if getElementData(theVehicle, 'fuel') > (getMaxFuel(getElementModel(theVehicle))-1) then
			processMessage(thePed, "Parece muito cheio para mim.")
		else
			pedWillFillVehicle(thePlayer, thePed)
		end
	end
end
addEvent( "fuel:convo", true )
addEventHandler( "fuel:convo", getRootElement(), talkToPed )

function pedWillFillFuelCan(thePlayer, thePed)
	if not (thePlayer and isElement(thePlayer)) then
		return
	end
	local posX, posY, posZ = getElementPosition(thePlayer)
	local pedX, pedY, pedZ = getElementPosition(thePed)
	if not (getDistanceBetweenPoints3D(posX, posY, posZ, pedX, pedY, pedZ) <= 7) then
		exports['chat-system']:localShout(thePed, "do", "Tudo bem, sem combustível para você!")
		return
	end

	local hasItem, itemSlot, itemValue, itemUniqueID = exports.global:hasItem(thePlayer, 57)
	if not (hasItem) then
		processMessage(thePed, "Engraçado...")
		--processMeMessage(thePed, "sighs.",thePlayer )
		triggerEvent('sendAme', thePed, "suspiros.")
		return
	end

	if itemValue >= 25 then
		processMessage(thePed, "Eh... esse já está cheio.")
		return
	end

	local theLitres = 25 - itemValue

	local currentTax = exports.global:getTaxAmount()
	local fuelCost = math.floor(theLitres*(FUEL_PRICE + (currentTax*FUEL_PRICE)))

	local money = exports.global:getMoney(thePlayer)
	if tonumber(money) == 0 then
		processMessage(thePed, "Como você pensou em pagar por isso ?! Punk!")
		return
	else
		if not exports.global:takeMoney(thePlayer, fuelCost) then
			processMessage(thePed, "Sim, isso custa cerca de $" .. fuelCost .. ", sabe?")
			return
		end
		payShopOwner(thePed, fuelCost)
	end

	-- run the hasItem check again because the item slot could have changed
	-- since we originally checked because takeMoney rearranges items!
	local hasItem, itemSlot, itemValue, itemUniqueID = exports.global:hasItem(thePlayer, 57)
	if not (exports['item-system']:updateItemValue(thePlayer, itemSlot, itemValue + theLitres)) then
		outputChatBox("Algo deu errado por favor /report.", thePlayer)
		return
	end

	local info = {
			{"Recibo de posto de gasolina"},
			{""},
			{"    " .. math.ceil(theLitres) .. " Litros de gasolina    -    " .. fuelCost .. "$"},
		}
	triggerClientEvent(thePlayer, "hudOverlay:drawOverlayTopRight", thePlayer, info )
end

function pedWillFillVehicle(thePlayer, thePed)
	if not (thePlayer and isElement(thePlayer)) then
		return
	end
	local amount = getElementData(thePlayer, "ped:amount")
	local moneyType = getElementData(thePlayer, "ped:Type")

	setTimer(pedWillFuelTheVehicle, 5000, 1, thePlayer, thePed, amount, moneyType)
end

function pedWillFuelTheVehicle(thePlayer, thePed, amount, moneyType)
	if not (thePlayer and isElement(thePlayer)) then
		return
	end
	local posX, posY, posZ = getElementPosition(thePlayer)
	local pedX, pedY, pedZ = getElementPosition(thePed)
	if not (getDistanceBetweenPoints3D(posX, posY, posZ, pedX, pedY, pedZ) <= 7) then
		exports['chat-system']:localShout(thePed, "do", "EI IDIOTA, QUER MORRER? IDIOTA!")
		return
	end

	local theVehicle = getPedOccupiedVehicle(thePlayer)

	if (getVehicleEngineState(theVehicle) == true) then
		exports['chat-system']:localShout(thePed, "do", "EI IDIOTA, QUER MORRER? IDIOTA!")
		--processDoMessage(thePlayer, "The vehicle explodes", thePlayer)
		--blowVehicle (theVehicle, false )
		return
	end

	if not (isPedInVehicle(thePlayer) == true) then
		processMessage(thePed, "Ehm...")
		setConvoState(thePlayer, 0)
		return
	end



	local theLitres = calculateFuelPrice(thePlayer, thePed, amount, moneyType)
	local fuelCost = math.ceil(theLitres*(1 + exports.global:getTaxAmount())*FUEL_PRICE)

	if moneyType == 1 then
		money = exports.global:getMoney(thePlayer)
	else
		money = getElementData(thePlayer, "bankmoney")
	end
	local factionVehicle = getElementData(theVehicle, "faction")

	local factionPaid = false
	if exports.factions:isPlayerInFaction(thePlayer, factionVehicle) and factionsThatPayForFuel[factionVehicle] then
		local theTeam = exports.factions:getFactionFromID(factionVehicle)
		if exports.global:takeMoney(theTeam, fuelCost, true) then
			processMessage(thePed, "Vou enviar o recibo para o seu empregador.")
			mysql:query_free("INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. mysql:escape_string(( -getElementData( theTeam, "id" ) )) .. ", " .. mysql:escape_string(getElementData(thePlayer, "dbid")) .. ", " .. mysql:escape_string(fuelCost) .. ", '"..mysql:escape_string(math.ceil(theLitres) .. " Litres").."', 9)" )

			factionPaid = true
		end
	end

	if not factionPaid then
		if (fuelCost > 0 and money > 0) then
			if not exports.donators:hasPlayerPerk(thePlayer, 7) then
				if moneyType == 1 then
					if exports.global:takeMoney(thePlayer, fuelCost) then
						processMessage(thePed, "Aqui está o recibo.")
					else
						processMessage(thePed, "Como você pensou em pagar isso ?! Punk!")
						return
					end
				else
					if exports.bank:updateBankMoney(thePlayer, getElementData(thePlayer, "dbid"), fuelCost, "minus") then
						processMessage(thePed, "Aqui está o recibo.")
					else
						processMessage(thePed, "Seu cartão foi rejeitado...")
						return
					end
				end
			else
				processMessage(thePed, "Aqui está o recibo.")
			end
		else
			processMessage(thePed, "Como você pensou em pagar isso ?! Punk!")
			return
		end
	end

	local loldFuel = getElementData(theVehicle, "fuel")
	local newFuel = loldFuel+theLitres
	exports.anticheat:setEld(theVehicle, "fuel", newFuel )
	triggerClientEvent( thePlayer, "syncFuel", theVehicle, getElementData( theVehicle, 'fuel' ), getElementData( theVehicle, 'battery' ) or 100 )

	local info = {
			{"Recibo de posto de gasolina"},
			{""},
		}

	if exports.donators:hasPlayerPerk(thePlayer, 7) and not factionPaid then
		table.insert(info, {"    " .. math.ceil(theLitres) .. " litros de gasolina    - (( Gassolina Gratis ))"})
	else
		table.insert(info, {"    " .. math.ceil(theLitres) .. " litros de gasolina    -    " .. fuelCost .. "$"})
		if factionPaid then
			table.insert(info, {"    Pago pelo empregador "..tostring(exports.factions:getFactionName(factionVehicle))})
		end
	end
	table.insert(info, {"    "..exports.global:getVehicleName(theVehicle).." - "..exports.global:round(newFuel, 2).."/"..exports.global:round(getMaxFuel(theVehicle), 2).." litres"})
	triggerClientEvent(thePlayer, "hudOverlay:drawOverlayTopRight", thePlayer, info )

	payShopOwner(thePed, fuelCost)
end

function payShopOwner(thePed, fuelCost)
	-- give shop owner a portion of fuel price
	local shopLink = tonumber( getElementData( thePed, 'shop_link') )
	outputDebugString( 'Shop Link: ' .. shopLink )
	if shopLink > 0 then
		local money = math.floor( tonumber( fuelCost ) * 0.4 ) -- give 40% to shop owner
		outputDebugString( 'Money: ' .. money )
		local findShop = exports.mysql:query('SELECT `id`, `sIncome` FROM `shops` WHERE `shoptype` = 15 AND `dimension` = ' .. getElementData( thePed, 'shop_link') .. ' LIMIT 1')

		local row = exports.mysql:fetch_assoc( findShop )
		if row then
			for index, shopPed in pairs( getElementsByType( 'ped')) do
				if tonumber( getElementData( shopPed, "dbid") ) == tonumber( row.id ) and getElementData( shopPed, "ped:type" ) == 'shop' then
					outputDebugString( 'Shop ID: ' .. row.id )
					exports.anticheat:changeProtectedElementDataEx( shopPed, "sIncome", tonumber( row.sIncome ) + money )
				end
			end
			exports.mysql:query_free( "UPDATE `shops` SET `sIncome` = `sIncome` + " .. money .. " WHERE `id` = " .. row.id )
		end
		mysql:free_result( findShop )
	end
end

function setConvoState(thePlayer, state)
	exports.anticheat:changeProtectedElementDataEx(thePlayer, "ped:convoState", state, false)
end

function processMessage(thePed, message, language)
	if not (language) then
		language = 1
	end
	exports['chat-system']:localIC(thePed, message, language)
end

function processMeMessage(thePed, message, source)
	local name = getElementData(thePed, "name") or getPlayerName(thePed)
	exports['global']:sendLocalText(source, " *" ..  string.gsub(name, "_", " ").. ( message:sub( 1, 1 ) == "'" and "" or " " ) .. message, 255, 51, 102)
end

function processDoMessage(thePed, message, source)
	local name = getElementData(thePed, "name") or getPlayerName(thePed)
	exports['global']:sendLocalText(source, " * " .. message .. " *      ((" .. name:gsub("_", " ") .. "))", 255, 51, 102)
end

function calculateFuelPrice(thePlayer, thePed, amount, moneyType)
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	local litresAffordable = getMaxFuel(getElementModel(theVehicle))
	local MAX_FUEL = getMaxFuel(getElementModel(theVehicle))
	local currFuel = tonumber(getElementData(theVehicle, "fuel"))
	local factionVehicle = getElementData(theVehicle, "faction")

	if exports.factions:isPlayerInFaction(thePlayer, factionVehicle) and factionsThatPayForFuel[factionVehicle] then
		litresAffordable = MAX_FUEL
		if (litresAffordable+currFuel>MAX_FUEL) then
			litresAffordable = MAX_FUEL - currFuel
		end
		return litresAffordable
	end

	if not (exports.donators:hasPlayerPerk(thePlayer, 7)) then
		if moneyType == 2 then
			local money = getElementData(thePlayer, "bankmoney")

			local tax = exports.global:getTaxAmount()
			local cost = FUEL_PRICE + (tax*FUEL_PRICE)
			if amount ~= 0 then
				litresAffordable = (amount/cost)
			else
				litresAffordable = math.floor(money/cost)
			end

			if (litresAffordable>MAX_FUEL) then
				litresAffordable=MAX_FUEL
			end
		else
			local money = exports.global:getMoney(thePlayer)

			local tax = exports.global:getTaxAmount()
			local cost = FUEL_PRICE + (tax*FUEL_PRICE)
			if amount ~= 0 then
				litresAffordable = (amount/cost)
			else
				litresAffordable = math.floor(money/cost)
			end

			if (litresAffordable>MAX_FUEL) then
				litresAffordable=MAX_FUEL
			end
		end
	else
		-- free fuel
	end

	if (litresAffordable+currFuel>MAX_FUEL) then
		litresAffordable = MAX_FUEL - currFuel
	end
	return litresAffordable
end

function createFuelPed(skin, posX, posY, posZ, rotZ, name, int, dim, id, shop_link)
	theNewPed = createPed (skin, posX, posY, posZ)
	exports.pool:allocateElement(theNewPed)
	setPedRotation (theNewPed, rotZ)
	setElementFrozen(theNewPed, true)
	--setPedAnimation(theNewPed, "FOOD", "FF_Sit_Loop",  -1, true, false, true)
	exports.anticheat:changeProtectedElementDataEx(theNewPed, "talk",1, true)
	exports.anticheat:changeProtectedElementDataEx(theNewPed, "name", name:gsub("_", " "), true)
	exports.anticheat:changeProtectedElementDataEx(theNewPed, "ped:type", "fuel", true)
	exports.anticheat:changeProtectedElementDataEx(theNewPed, "ped:fuelped",true, true)
	exports.anticheat:changeProtectedElementDataEx(theNewPed, "shop_link", shop_link, true)

	-- For the language system
	exports.anticheat:changeProtectedElementDataEx(theNewPed, "languages.lang1" , 1, false)
	exports.anticheat:changeProtectedElementDataEx(theNewPed, "languages.lang1skill", 100, false)
	exports.anticheat:changeProtectedElementDataEx(theNewPed, "languages.lang2" , 2, false)
	exports.anticheat:changeProtectedElementDataEx(theNewPed, "languages.lang2skill", 100, false)
	exports.anticheat:changeProtectedElementDataEx(theNewPed, "languages.current", 1, false)
	setElementInterior(theNewPed, int)
	setElementDimension(theNewPed, dim)
	exports.anticheat:changeProtectedElementDataEx(theNewPed, "dbid",id, true)
	--createBlip(posX, posY, posZ, 55, 2, 255, 0, 0, 255, 0, 300)
	return theNewPed
end

function makeFuelPed(thePlayer, commandName, skin, ...)
	if (exports.integration:isPlayerLeadAdmin(thePlayer)) then
		outputChatBox("SYNTAX: /" .. commandName .. " [skin, default = 50, -1 = random] [Firstname Lastname, -1 = random]", thePlayer, 255, 194, 14)

		local skin = tonumber(skin)

		if not skin or skin == -1 then --Random
			skin = exports.global:getRandomSkin()
		end

		if skin then
			local ped = createPed(skin, 0, 0, 3)
			if not ped then
				outputChatBox("Invalid Skin.", thePlayer, 255, 0, 0)
				return
			else
				destroyElement(ped)
			end
		else
			skin = -1
		end

		local x, y, z = getElementPosition(thePlayer)
		local dimension = getElementDimension(thePlayer)
		local interior = getElementInterior(thePlayer)
		local rotation = getPedRotation(thePlayer)

		local pedName = table.concat({...}, "_") or false

		if not pedName or pedName== "" or (tonumber(pedName) and tonumber(pedName) == -1) then
			pedName = exports.global:createRandomMaleName()
			pedName = string.gsub(pedName, " ", "_")
		end

		local id = false
		id = mysql:query_insert_free("INSERT INTO `fuelpeds` SET `name`='"..exports.global:toSQL(pedName).."', `posX`='" .. mysql:escape_string(x) .. "', `posY`='" .. mysql:escape_string(y) .. "', `posZ`='" .. mysql:escape_string(z) .. "', dimension='" .. mysql:escape_string(dimension) .. "', interior='" .. mysql:escape_string(interior) .. "', `rotZ`='" .. mysql:escape_string(rotation) .. "', `skin`='".. mysql:escape_string(skin).."' ")

		if (id) then
			createFuelPed(skin ~= -1 and skin or 50, x,y,z,rotation,pedName,interior,dimension,id, 0)
		else
			outputChatBox("Error creating fuel ped.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("makefuelped", makeFuelPed, false, false)
addCommandHandler("makefuel", makeFuelPed, false, false)
addCommandHandler("makefuelnpc", makeFuelPed, false, false)

function onServerStart()
	local sqlHandler = mysql:query("SELECT * FROM fuelpeds WHERE `deletedBy` = 0 ")
	if (sqlHandler) then
		while true do
			local row = mysql:fetch_assoc( sqlHandler )
			if not row then break end
			local thePed = createFuelPed(tonumber(row["skin"]),tonumber(row["posX"]),tonumber(row["posY"]),tonumber(row["posZ"]), tonumber(row["rotZ"]), row["name"], tonumber(row["interior"]), tonumber(row["dimension"]), tonumber(row["id"]), tonumber( row["shop_link"]))
		end
	end
	mysql:free_result(sqlHandler)
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), onServerStart)


function getNearByFuelPeds(thePlayer, commandName) --maxime
	if (exports.integration:isPlayerLeadAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Fuel NPC(s):", thePlayer, 255, 126, 0)
		local count = 0

		local dimension = getElementDimension(thePlayer)

		for k, thePed in ipairs(getElementsByType("ped", resourceRoot)) do
			local pedType = getElementData(thePed, "ped:type")
			if (pedType) then
				if (pedType=="fuel") then
					local x, y = getElementPosition(thePed)
					local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
					local cdimension = getElementDimension(thePed)
					if (distance<=10) and (dimension==cdimension) then
						local dbid = getElementData(thePed, "dbid")
						local pedName = getElementData(thePed, "name")
						local shopLink = tonumber(  getElementData(thePed, "shop_link") )
						outputChatBox("   Fuel NPC ID #" .. dbid .. ", name: "..tostring(pedName):gsub("_", " ") .. ( shopLink > 0 and ' shop link: ' .. shopLink or ''), thePlayer, 255, 126, 0)
						count = count + 1
					end
				end
			end
		end

		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyfuels", getNearByFuelPeds, false, false)
addCommandHandler("nearbynpcs", getNearByFuelPeds, false, false)

function gotoFuelPed(thePlayer, commandName, shopID) --maxime
	if (exports.integration:isPlayerLeadAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)) then
		if not tonumber(shopID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Shop ID]", thePlayer, 255, 194, 14)
		else
			local possibleShops = getElementsByType("ped", resourceRoot)
			local foundShop = false
			for _, shop in ipairs(possibleShops) do
				if getElementData(shop,"ped:type") == "fuel" and (tonumber(getElementData(shop, "dbid")) == tonumber(shopID)) then
					foundShop = shop
					break
				end
			end

			if not foundShop then
				outputChatBox("No shop founded with ID #"..shopID, thePlayer, 255, 0, 0)
				return false
			end

			local x, y, z = getElementPosition(foundShop)
			local dim = getElementDimension(foundShop)
			local int = getElementInterior(foundShop)
			local rot = getElementRotation(foundShop)
			startGoingToShop(thePlayer, x,y,z,rot,int,dim,shopID)
		end
	end
end
addCommandHandler("gotofuel", gotoFuelPed, false, false)
addCommandHandler("gotofuelped", gotoFuelPed, false, false)
addCommandHandler("gotofuelnpc", gotoFuelPed, false, false)

function startGoingToShop(thePlayer, x,y,z,r,interior,dimension,shopID) --maxime
	-- Maths calculations to stop the player being stuck in the target
	x = x + ( ( math.cos ( math.rad ( r ) ) ) * 2 )
	y = y + ( ( math.sin ( math.rad ( r ) ) ) * 2 )

	setCameraInterior(thePlayer, interior)

	if (isPedInVehicle(thePlayer)) then
		local veh = getPedOccupiedVehicle(thePlayer)
		setElementAngularVelocity(veh, 0, 0, 0)
		setElementInterior(thePlayer, interior)
		setElementDimension(thePlayer, dimension)
		setElementInterior(veh, interior)
		setElementDimension(veh, dimension)
		setElementPosition(veh, x, y, z + 1)
		warpPedIntoVehicle ( thePlayer, veh )
		setTimer(setElementAngularVelocity, 50, 20, veh, 0, 0, 0)
	else
		setElementPosition(thePlayer, x, y, z)
		setElementInterior(thePlayer, interior)
		setElementDimension(thePlayer, dimension)
	end
	outputChatBox(" You have teleported to Fuel NPC ID#"..shopID, thePlayer)
end

function deleteFuelPed(thePlayer, commandName, id) -- maxime
	if (exports.integration:isPlayerLeadAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			local counter = 0
			for k, thePed in ipairs(getElementsByType("ped", resourceRoot)) do
				local pedType = getElementData(thePed, "ped:type")
				if (pedType) then
					if (pedType=="fuel") then
						local dbid = getElementData(thePed, "dbid")
						if (tonumber(id)==dbid) then
							destroyElement(thePed)
							local adminID = getElementData(thePlayer,"account:id")
							mysql:query_free("UPDATE `fuelpeds` SET `deletedBy` = '"..tostring(adminID).."' WHERE id='" .. mysql:escape_string(dbid) .. "' LIMIT 1")
							outputChatBox("      Deleted fuel npc with ID #" .. id .. ".", thePlayer, 0, 255, 0)
							counter = counter + 1
							setElementData(thePlayer, "fuel:mostRecentDeleteFuelPed",dbid )
						end
					end
				end
			end

			if (counter==0) then
				outputChatBox("No fuel ped with such an ID exists.", thePlayer, 255, 0, 0)
				return false
			end
			return true
		end
	end
end
addCommandHandler("delfuel", deleteFuelPed, false, false)
addCommandHandler("deletefuel", deleteFuelPed, false, false)
addCommandHandler("delfuelped", deleteFuelPed, false, false)
addCommandHandler("deletefuelped", deleteFuelPed, false, false)



addCommandHandler( 'setfuelpedlink',
	function ( player, command, fuelped, shopID )
		if exports.integration:isPlayerAdmin( player ) then
			-- make sure the player actually filled in the data
			if tonumber( fuelped ) and tonumber( shopID ) then
				-- determine if the fuel ped exists.
				local findFuelPed = exports.mysql:query('SELECT `name` FROM `fuelpeds` WHERE `id` = ' .. exports.mysql:escape_string( fuelped ))
				if exports.mysql:num_rows( findFuelPed ) > 0 then
					-- determine if shop exists.
					local findShop = exports.mysql:query( 'SELECT `name` FROM `interiors` WHERE `id` = ' .. exports.mysql:escape_string( shopID ))
					if exports.mysql:num_rows( findShop ) > 0 then
						local findShopPed = exports.mysql:query( 'SELECT `id` FROM `shops` WHERE `shoptype` = 15 AND `dimension` = ' .. exports.mysql:escape_string( shopID ) )
						if exports.mysql:num_rows( findShopPed ) > 0 then
							exports.mysql:update( 'fuelpeds', { shop_link = shopID }, { id = fuelped } )

							for i, ped in pairs( getElementsByType('ped')) do
								if getElementData(ped, "ped:type" ) == "fuel" and getElementData( ped, "dbid") == tonumber( fuelped ) then
									exports.anticheat:changeProtectedElementDataEx( ped, "shop_link", tonumber( shopID ), true )
								end
							end

							outputChatBox( 'That interior has been linked to the fuel ped.', player, 155, 255, 155 )
						else
							outputChatBox( 'That interior does not have a shop type 15.', player, 255, 155, 155 )
						end
						exports.mysql:free_result( findShopPed )
					else
						outputChatBox( 'No such interior found.', player, 255, 155, 155 )
					end
					mysql:free_result( findShop )
				else
					outputChatBox( 'No such fuel ped found.', player, 255, 155, 155 )
				end
				mysql:free_result( findFuelPed )
			else
				outputChatBox( "SYNTAX: /" .. command .. " [fuel ped ID] [shop interior ID]", player, 255, 255, 255 )
			end
		end
	end
)
