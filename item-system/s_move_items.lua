local function canAccessElement( player, element )
	if isPedDead ( player ) then
		return false
	end

	if getElementDimension( player ) ~= getElementDimension( element ) then
		return getElementType(element) == 'interior' and getElementID(element) == getElementDimension(player)
	end

	if getElementType( element ) == "vehicle" then
		if not isVehicleLocked( element ) then
			return true
		else
			local veh = getPedOccupiedVehicle( player )
			local inVehicle = getElementData( player, "realinvehicle" )

			if veh == element and inVehicle == 1 then
				return true
			elseif veh == element and inVehicle == 0 then
				outputDebugString( "canAcccessElement failed (hack?): " .. getPlayerName( player ) .. " on Vehicle " .. getElementData( element, "dbid" ) )
				return false
			else
				outputDebugString( "canAcccessElement failed (locked): " .. getPlayerName( player ) .. " on Vehicle " .. getElementData( element, "dbid" ) )
				return false
			end
		end
	else
		return true
	end
end

--

local function openInventory( element, ax, ay )
	if canAccessElement( source, element ) then
		triggerEvent( "subscribeToInventoryChanges", source, element )
		triggerClientEvent( source, "openElementInventory", element, ax, ay )
	end
end

addEvent( "openFreakinInventory", true )
addEventHandler( "openFreakinInventory", getRootElement(), openInventory )

--

local function closeInventory( element )
	triggerEvent( "unsubscribeFromInventoryChanges", source, element )
end

addEvent( "closeFreakinInventory", true )
addEventHandler( "closeFreakinInventory", getRootElement(), closeInventory )

--

local function output(from, to, itemID, itemValue, evenIfSamePlayer, metadata)
	if from == to and not evenIfSamePlayer then
		return false
	end

	-- player to player
	if getElementType(from) == "player" and getElementType(to) == "player" then
		exports.global:sendLocalMeAction( from, "da para " .. getPlayerName( to ):gsub("_", " ") .. " um(a) " .. getItemName( itemID, itemValue, metadata ) .. "." )
	-- player to item
	elseif getElementType(from) == "player" then
		local name = getName(to)
		if itemID == 134 then
			triggerEvent('sendAme', from, "coloca $" .. exports.global:formatMoney(itemValue) .. " dentro de(a) ".. name .."." )
		elseif itemID == 150 then --ATM card / MAXIME
			triggerEvent('sendAme',  from, "coloca um cartão ATM no "..name.."." )
		else
			triggerEvent('sendAme',  from, "coloca um(a) " .. getItemName( itemID, itemValue, metadata ) .. " dentro de(a) ".. name .."." )
		end
	-- item to player
	elseif getElementType(to) == "player" then
		local name = getName(from)
		if itemID == 134 then
			triggerEvent('sendAme',  to, "tira $" .. exports.global:formatMoney(itemValue) .. " de ".. name .."." )
		elseif itemID == 150 then --ATM card / MAXIME
			triggerEvent('sendAme',  to, "tira o cartão ATM do "..name.."." )
		else
			triggerEvent('sendAme',  to, "tira um(a) " .. getItemName( itemID, itemValue, metadata ) .. " de ".. name .."." )
		end
	end

	if itemID == 2 then
		triggerClientEvent(to, "phone:clearAllCaches", to, itemValue)
		triggerClientEvent(from, "phone:clearAllCaches", from, itemValue)
	end

	return true
end
function x_output_wrapper( ... ) return output( ... ) end

--



local function moveToElement( element, slot, ammo, event )
	if not canAccessElement( source, element ) then
		outputChatBox("Você não pode acessar este inventário no momento.", source, 255, 0, 0)
		triggerClientEvent( source, event or "finishItemMove", source )
		return
	end

	local name = getName(element)

	if not ammo then
		local item = getItems( source )[ slot ]
		if item then
			-- ANTI ALT-ALT FOR NON AMMO ITEMS, CHECK THIS FUNCTION FOR AMMO ITEM BELOW AND FOR WORLD ITEM CHECK s_world_items.lua/ MAXIME
			--31 -> 43  = DRUGS
			if ( (item[1] >= 31 and item[1] <= 43) or itemBannedByAltAltChecker[item[1]]) and not (getElementModel(element) == 2942 and item[1] == 150) then
				local hoursPlayedFrom = getElementData( source, "hoursplayed" )
				local hoursPlayedTo = 99
				if isElement(element) and getElementType(element) == "player" then
					hoursPlayedTo = getElementData( element, "hoursplayed" )
				end

				if not exports.global:isStaffOnDuty(source) and not exports.global:isStaffOnDuty(element) then
					if hoursPlayedFrom < 10 then
						outputChatBox("Você precisa de 10 horas de tempo de jogo para mover um(a) "..getItemName( item[1] ).." para um(a) "..name..".", source, 255, 0, 0)
						triggerClientEvent( source, event or "finishItemMove", source )
						return false
					end

					if hoursPlayedTo < 10 then
						outputChatBox(string.gsub(getPlayerName(element), "_", " ").." requer 10 horas de jogo para receber um(a) "..getItemName( item[1] ).." de você.", source, 255, 0, 0)
						outputChatBox("Você precisa de 10 horas de jogo para receber um(a) "..getItemName( item[1] ).." from "..string.gsub(getPlayerName(source), "_", " ")..".", element, 255, 0, 0)
						triggerClientEvent( source, event or "finishItemMove", source )
						return false
					end
				end
				--outputDebugString(hoursPlayedFrom.." "..hoursPlayedTo)
			end
			
			-- Attempted to put an item INTO their alternate characters vehicle (not really much need to make a warning, as long as it's prevented)
			if getElementType(element) == "vehicle" and getElementData(element, "faction") < 0 then 
				local accountID = exports.cache:getAccountFromCharacterId(getElementData(source, "account:character:id"))
				local vehicleAccountID = exports.cache:getAccountFromCharacterId(getElementData(element, "owner"))
				if vehicleAccountID and accountID.id == vehicleAccountID.id and getElementData(source, "account:character:id") ~= getElementData(element, "owner") then
					--exports.global:sendWrnToStaff(getPlayerName(source):gsub("_", " ") .. " (" .. getElementData(source, "account:username") .. ") has attempted to put a " .. getItemName(item[1]) .. " into their alternate characters vehicle (#" .. getElementData(element, "dbid") .. ").", "ALT>ALT")
					outputChatBox(" Você não tem permissão para colocar itens em veículos de personagens alternativos!", source, 255, 0, 0)
					triggerClientEvent( source, event or "finishItemMove", source )
					return false
				end
			end
		
			if (getElementType(element) == "ped") and getElementData(element,"shopkeeper") then
				--[[if item[1] == 121 and not getElementData(element,"customshop") then-- supplies box
					triggerEvent("shop:handleSupplies", source, element, slot, event)
					return true
				end]] -- Removed by MAXIME
				if getElementData(element,"customshop") then
					if item[1] == 134 then -- money
						triggerClientEvent( source, event or "finishItemMove", source )
						return false
					end
					local restricted = {[27] = true, [29] = true, [177] = true, [76] = true, [219] = true, [221] = true, [220] = true, [126] = true, [217] = true, [162] = true, [137] = true}
					if restricted[item[1]] then
						outputChatBox('Você não pode vender este item na loja.', source, 255, 100, 100)
						triggerClientEvent( source, event or "finishItemMove", source )
						return false
					end

					triggerEvent("shop:addItemToCustomShop", source, element, slot, event)
					return true
				end
				triggerClientEvent( source, event or "finishItemMove", source )
				return false
			end
			--outputDebugString(tostring(hasSpaceForItem(element, item[1], item[2]))	)
			if not (getElementModel( element ) == 2942) and not hasSpaceForItem( element, item[1], item[2] ) then --Except for ATM Machine
				outputChatBox( "Este inventario esta cheio.", source, 255, 0, 0 )
			else
				if (item[1] == 115) then -- Weapons
					local itemCheckExplode = exports.global:explode(":", item[2])
					-- itemCheckExplode: [1] = gta weapon id, [2] = serial number, [3] = weapon name
					local weaponDetails = exports.global:retrieveWeaponDetails( itemCheckExplode[2]  )
					if tonumber(weaponDetails[2]) then
						local gun_source = tonumber(weaponDetails[2])
						-- duty weapon
						if gun_source == 2  then
							outputChatBox("Você não pode colocar sua arma de serviço em um(a) " .. name .. ".", source, 255, 0, 0)
							triggerClientEvent( source, event or "finishItemMove", source )
							return
						-- bought from ammunation, it's ok, let them move/stash it. We block it when someone else is picking it up.
						--[[
						elseif gun_source == 3 then
							outputChatBox("(( This "..itemCheckExplode[3].." was bought  ))", source, 255, 0, 0)
							triggerClientEvent( source, event or "finishItemMove", source )
							return
						end
						]]
						end
					end
				--[[elseif (item[1] == 179 and getElementType(element) == "vehicle") then --vehicle texture
					outputDebugString("vehicle texture")
					local vehID = getElementData(element, "dbid")
					local veh = element
					if(exports.global:isStaffOnDuty(source) or exports.integration:isPlayerScripter(source) or exports.global:hasItem(source, 3, tonumber(vehID)) or (getElementData(veh, "faction") > 0 and exports.factions:isPlayerInFaction(source, getElementData(veh, "faction"))) ) then
						outputDebugString("access granted")
						local itemExploded = exports.global:explode(";", item[2])
						local url = itemExploded[1]
						local texName = itemExploded[2]
						if url and texName then
							local res = exports["item-texture"]:addVehicleTexture(source, veh, texName, url)
							if res then
								takeItemFromSlot(source, slot)
								outputDebugString("success")
								outputChatBox("success", source)
							else
								outputDebugString("item-system/s_move_items: Failed to add vehicle texture")
							end
							triggerClientEvent(source, event or "finishItemMove", source)
							return
						end
					end
				--]]
				end

				if (item[1] == 137 or item[1] == 162 or item[1] == 219 or item[1] == 220 or item[1] == 221 or item[1] == 262 or item[1] == 263) then -- Snake cam and armors
					outputChatBox("Você não pode mover este item.", source, 255, 0, 0)
					triggerClientEvent( source, event or "finishItemMove", source )
					return
				elseif item[1] == 138 then
					if not exports.integration:isPlayerTrialAdmin(source) and getElementType(element) == "Vehicle" then
						outputChatBox("Apenas um administrador pode instalar este item.", source, 255, 0, 0)
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end
				elseif item[1] == 139 then
					if not exports.integration:isPlayerTrialAdmin(source) then
						outputChatBox("Requer um administrador de avaliação para mover este item.", source, 255, 0, 0)
						triggerClientEvent(source, event or "finishItemMove", source)
						return
					end
				end

				if (item[1] == 134) then -- Money
					if not exports.global:isStaffOnDuty(source) and not exports.global:isStaffOnDuty(element) then
						local hoursPlayedFrom = getElementData( source, "hoursplayed" ) or 99
						local hoursPlayedTo = getElementData( element, "hoursplayed" ) or 99
						if (getElementType(element) == "player") and (getElementType(source) == "player") then
							if hoursPlayedFrom < 10 or hoursPlayedTo < 10 then
								outputChatBox("Você precisa de 10 horas de tempo de jogo para dar dinheiro a outro jogador.", source, 255, 0, 0)
								outputChatBox(exports.global:getPlayerName(source).." requer 10 horas de jogo para dar dinheiro a você.", element, 255, 0, 0)
								triggerClientEvent( source, event or "finishItemMove", source )

								outputChatBox("Você precisa de 10 horas de tempo de jogo para receber dinheiro de outro jogador.", element, 255, 0, 0)
								outputChatBox(exports.global:getPlayerName(element).." requer 10 horas de jogo para receber dinheiro de você.", source, 255, 0, 0)
								triggerClientEvent( source, event or "finishItemMove", source )
								return false
							end
						elseif (getElementType(element) == "vehicle") and (getElementType(source) == "player") then
							if hoursPlayedFrom < 10 then
								outputChatBox("Você precisa de 10 horas de jogo para armazenar dinheiro em um veículo.", source, 255, 0, 0)
								triggerClientEvent( source, event or "finishItemMove", source )
								return false
							end
						elseif (getElementType(element) == "object") and (getElementType(source) == "player") then
							if hoursPlayedFrom < 10 then
								outputChatBox("Você precisa de 10 horas de tempo de jogo para armazenar dinheiro nisso.", source, 255, 0, 0)
								triggerClientEvent( source, event or "finishItemMove", source )
								return false
							end
						end
					end

					if exports.global:takeMoney(source, tonumber(item[2])) then
						if getElementType(element) == "player" then
							if exports.global:giveMoney(element, tonumber(item[2])) then
								triggerEvent('sendAme', source, "da $" .. exports.global:formatMoney(item[2]) .. " para ".. exports.global:getPlayerName(element) .."." )
							end
						else
							if exports.global:giveItem(element, 134, tonumber(item[2])) then
								triggerEvent('sendAme', source, "coloca $" .. exports.global:formatMoney(item[2]) .. " dentro do(a) "..  name .."." )
							end
						end
					end
				else -- not money
					if getElementType( element ) == "object" then
						local elementModel = getElementModel(element)
						local elementItemID = getElementData(element, "itemID")
						if elementItemID then
							if elementItemID == 166 then --video player
								if item[1] ~= 165 then --if item being moved to video player is not a valid video item
									exports.hud:sendBottomNotification(source, "Video Player", "Este não é um disco válido.")
									triggerClientEvent( source, event or "finishItemMove", source )
									return
								end
							end
						end
						if ( getElementDimension( element ) < 19000 and ( item[1] == 4 or item[1] == 5 ) and getElementDimension( element ) == item[2] ) or ( getElementDimension( element ) >= 20000 and item[1] == 3 and getElementDimension( element ) - 20000 == item[2] ) then -- keys to that safe as well
							if countItems( source, item[1], item[2] ) < 2 then
								outputChatBox("Você não pode colocar sua única chave para aquele cofre no cofre.", source, 255, 0, 0)
								triggerClientEvent( source, event or "finishItemMove", source )
								return
							end
						end
					end

					local success, reason = moveItem( source, element, slot )
					if not success then
						if not elementItemID then elementItemID = getElementData(element, "itemID") end
						local fakeReturned = false
						if elementItemID then
							if elementItemID == 166 then --video system
								exports.hud:sendBottomNotification(source, "Video Player", "Já existe um disco dentro. Ejetar o disco antigo primeiro.")
								fakeReturned = true
							end
						end
						if not fakeReturned then --only check by model IDs if we didnt already find a match on itemID
							if getElementModel(element) == 2942 then
								exports.hud:sendBottomNotification(source, "ATM Machine", "Há outro cartão preso dentro do slot da máquina ATM. Clique com o botão direito para interagir.")
							end
						end
						outputDebugString( "Item Moving failed: " .. tostring( reason ))
					else
						if getElementModel(element) == 2942 then
							exports.bank:playAtmInsert(element)
						elseif item[1] == 165 then --video disc
							if exports.clubtec:isVideoPlayer(element) then
								--triggerEvent("sendAme",  source, "ejects a disc from the video player." )
								for key, value in ipairs(getElementsByType("player")) do
									if getElementDimension(value)==getElementDimension(element) then
										triggerEvent("fakevideo:loadDimension", value)
									end
								end
							end
						elseif getElementType(element) == "vehicle" and item[1] == 212 then  --snow tires
							if getResourceFromName("shader_snow_ground") and getResourceState(getResourceFromName("shader_snow_ground")) == "running" then
								local driver = getVehicleController(element)
								local hasSnowTires = true --hasItem(element, 212)
								triggerClientEvent(driver, "shader_snow_ground:applySlippery", root, element, hasSnowTires)
							end
						end
						--exports.logs:dbLog(source, 39, source, getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( item[1] ) .. " - " .. item[2] )
						doItemGiveawayChecks( source, item[1] )
						output(source, element, item[1], item[2], nil, item[5])
					end
				end
				exports.logs:dbLog(source, 39, source, getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - Item ID: " .. item[1] .. " - " .. getItemName(item[1], item[2], item[5]) .. " @ "..getCoordinates( element ))
			end
		end
	else -- IF AMMO
		if not ( ( slot == -100 and hasSpaceForItem( element, slot ) ) or ( slot > 0 and hasSpaceForItem( element, -slot ) ) ) then
			outputChatBox( "Este inventario esta cheio.", source, 255, 0, 0 )
		else
			if tonumber(getElementData(source, "duty")) > 0 then
				outputChatBox("Você não pode colocar suas armas em um(a) " .. name .. " enquanto estiver em serviço.", source, 255, 0, 0)
			elseif tonumber(getElementData(source, "job")) == 4 and slot == 41 then
				outputChatBox("Você não pode colocar esta lata de spray em um(a) " .. name .. ".", source, 255, 0, 0)
			else
				if slot == -100 then
					local ammo = math.ceil( getPedArmor( source ) )
					if ammo > 0 then
						setPedArmor( source, 0 )
						giveItem( element, slot, ammo )
						exports.logs:dbLog(source, 39, source, getPlayerName(source) .. " moveu " .. getItemName(slot) " - " .. ammo .. " #" .. getElementID(element) )
						output(source, element, -100)
					end
				else
					local getCurrentMaxAmmo = exports.global:getWeaponCount(source, slot)
					if ammo > getCurrentMaxAmmo then
						exports.global:sendMessageToAdmins("[items\moveToElement] Possível duplicação de arma de '"..getPlayerName(source).."' // " .. getItemName( -slot ) )
						exports.logs:dbLog(source, 39, source, getPlayerName(source) .. " moved " .. getItemName(-slot) " -  #" .. getElementID(element) .. " - BLOCKED DUE POSSIBLE DUPING" )
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end
					exports.global:takeWeapon( source, slot )
					if ammo > 0 then
						giveItem( element, -slot, ammo )
						exports.logs:dbLog(source, 39, source, getPlayerName(source) .. " moved " .. getItemName(-slot) " - " .. ammo .. " #" .. getElementID(element) )
						output(source, element, -slot)
					end
				end
			end
		end
	end
	--outputDebugString("moveToElement")
	triggerClientEvent( source, event or "finishItemMove", source )
end

addEvent( "moveToElement", true )
addEventHandler( "moveToElement", getRootElement(), moveToElement )

--

local function moveWorldItemToElement( item, element )
	if false then
		return outputDebugString("[ITEM] moveWorldItemToElement / Disabled ")
	end

	if not isElement( item ) or not isElement( element ) or not canAccessElement( source, element ) then
		return
	end

	local id = tonumber(getElementData( item, "id" ))
	if not id then
		outputChatBox("Error: No world item ID. Notify a scripter. (s_move_items)",source,255,0,0)
		destroyElement(element)
		return
	end
	local itemID = getElementData( item, "itemID" )
	local itemValue = getElementData( item, "itemValue" ) or 1
	local metadata = getElementData( item, "metadata" )
	local name = getName(element)

	-- ANTI ALT-ALT  MAXIME
	--31 -> 43  = DRUGS
	if ((itemID >= 31) and (itemID <= 43)) or itemBannedByAltAltChecker[itemID] or itemID == 223 then
		outputChatBox(getItemName(itemID).." só pode ser movido diretamente de seu inventário para este "..name..".", source, 255, 0, 0)
		return false
	end


	if (getElementType(element) == "ped") and getElementData(element,"shopkeeper") then
		return false
	end

	if not canPickup(source, item) then
		outputChatBox("Você não pode mover este item. Contate um administrador via F1.", source, 255, 0, 0)
		return
	end

	if itemID == 138 then
		if not exports.integration:isPlayerTrialAdmin(source) and getElementType(element) == "Vehicle" then
			outputChatBox("Apenas um administrador pode instalar este item.", source, 255, 0, 0)
			return
		end
	end

	if itemID == 169 or itemID == 262 or itemID == 263 then
		--outputChatBox("Nay.")
		return
	end

	if giveItem( element, itemID, itemValue, false, false, metadata ) then
		--[[
		if itemID == 166 then --video player
			local videoplayerDisc = exports.clubtec:getVideoPlayerCurrentVideoDisc(item) or 2
			local videoplayerObject = nil
			local dimensionPlayers = {}
			for key, value in ipairs(getElementsByType("player")) do
				if getElementDimension(value)==getElementDimension(item) then
					table.insert(dimensionPlayers,value)
				end
			end
			triggerClientEvent(dimensionPlayers, "fakevideo:removeOne", source, videoplayerDisc, itemValue, videoplayerObject)
		end
		--]]

		if getElementType(element) == "vehicle" then
			if itemID == 212 then --snow tires
				if getResourceFromName("shader_snow_ground") and getResourceState(getResourceFromName("shader_snow_ground")) == "running" then
					local driver = getVehicleController(element)
					local hasSnowTires = true --hasItem(element, 212)
					triggerClientEvent(driver, "shader_snow_ground:applySlippery", root, element, hasSnowTires)
				end
			end
		end

		output(source, element, itemID, itemValue, true, metadata)
		exports.logs:dbLog( source, 39, source, getPlayerName( source ) .. " put item #" .. id .. " (" .. itemID .. ":" .. getItemName( itemID ) .. ") - " .. itemValue .. " in " .. name .. " #" .. getElementID(element))
		mysql:query_free("DELETE FROM worlditems WHERE id='" .. id .. "'")

		while #getItems( item ) > 0 do
			moveItem( item, element, 1 )
		end
		destroyElement( item )

		if itemID == 166 then --video player
			for key, value in ipairs(getElementsByType("player")) do
				if getElementDimension(value)==getElementDimension(source) then
					triggerEvent("fakevideo:loadDimension", value)
				end
			end
		end
	else
		outputChatBox( "Este inventario esta cheio.", source, 255, 0, 0 )
	end
end

addEvent( "moveWorldItemToElement", true )
addEventHandler( "moveWorldItemToElement", getRootElement(), moveWorldItemToElement )

--

local function moveFromElement( element, slot, ammo, index )
	if false then
		return outputDebugString("[ITEM] moveFromElement / Disabled ")
	end

	if not canAccessElement( source, element ) then
		return false
	end
	local item = getItems( element )[slot]
	if not canPickup(source, item) then
		outputChatBox("Você não pode mover este item. Contate um administrador via F1.", source, 255, 0, 0)
		return
	end


	local name = getName(element)

	if item and tonumber(item[3]) == tonumber(index) then
		-- ANTI ALT-ALT FOR NON AMMO ITEMS, CHECK THIS FUNCTION FOR AMMO ITEM BELOW AND FOR WORLD ITEM CHECK s_world_items.lua
		--31 -> 43  = DRUGS
		if ( (item[1] >= 31 and item[1] <= 43) or itemBannedByAltAltChecker[item[1]]) and not (getElementModel(element) == 2942 and item[1] == 150) then
			local hoursPlayedTo = nil

			if isElement(source) and getElementType(source) == "player" then
				hoursPlayedTo = getElementData( source, "hoursplayed" )
			end

			if not exports.global:isStaffOnDuty(source) and not exports.global:isStaffOnDuty(element) then
				if hoursPlayedTo < 10 then
					if not (item[1] == 3 and getElementData(exports.pool:getElement("vehicle", item[2]), "owner") == getElementData(source, "dbid")) then -- Checks if they own the vehicle for the key
						outputChatBox("Você precisa de 10 horas de jogo para receber um(a) "..getItemName( item[1] ).." a partir de um(a) "..name..".", source, 255, 0, 0)
						triggerClientEvent( source, "forceElementMoveUpdate", source )
						triggerClientEvent( source, "finishItemMove", source )
						return false
					end
				end
			end
		end

		-- Attempted to take an item FROM their alternate characters vehicle
		if getElementType(element) == "vehicle" and getElementData(element, "faction") < 0 then 
			local accountID = exports.cache:getAccountFromCharacterId(getElementData(source, "account:character:id"))
			local vehicleAccountID = exports.cache:getAccountFromCharacterId(getElementData(element, "owner"))
			if vehicleAccountID and accountID.id == vehicleAccountID.id and getElementData(source, "account:character:id") ~= getElementData(element, "owner") then
				exports.global:sendWrnToStaff(getPlayerName(source):gsub("_", " ") .. " (" .. getElementData(source, "account:username") .. ") tentou pegar um(a) " .. getItemName(item[1]) .. " de seu veículo de personagens alternativos (#" .. getElementData(element, "dbid") .. ").", "ALT>ALT")
				outputChatBox(" Você não tem permissão para pegar itens do seu veículo de personagens alternativos!", source, 255, 0, 0)
				triggerClientEvent( source, event or "finishItemMove", source )
				return false
			end
		end
		
		-- now check if it's duty weapon or bought from ammunation and if player is authorized
		if item[1] == 115 or item[1] == 116 then
			local can, why = exports.weapon:canRetrieve(source, item[1], item[2])
			if not can then
				outputChatBox(why, source, 255,0,0)
				triggerClientEvent( source, "finishItemMove", source )
				return false
			end
		end

		if not hasSpaceForItem( source, item[1], item[2] ) then
			outputChatBox( "Este inventario esta cheio.", source, 255, 0, 0 )
		elseif not exports.integration:isPlayerTrialAdmin( source ) and getElementType( element ) == "vehicle" and ( item[1] == 61 or item[1] == 85  or item[1] == 117 or item[1] == 140) then
			outputChatBox( "Entre em contato com um administrador via F1 para mover este item.", source, 255, 0, 0 )
		elseif not exports.integration:isPlayerAdmin(source) and (item[1] == 138) then
			outputChatBox("Este item requer que um administrador regular seja movido.", source, 255, 0, 0)
		elseif not exports.integration:isPlayerTrialAdmin(source) and (item[1] == 139) then
			outputChatBox("Este item requer que um administrador seja movido.", source, 255, 0, 0)
		elseif item[1] > 0 then
			if moveItem( element, source, slot ) then
				output( element, source, item[1], item[2], nil, item[5])
				exports.logs:dbLog(source, 39, source, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1], item[2], item[5] ) .. " - " .. item[2])
				doItemGivenChecks(source, tonumber(item[1]))
				if getElementType(element) == "vehicle" then
					if item[1] == 3 then
						if getVehicleEngineState(element) and tonumber(item[2]) == tonumber(getElementData(element, "dbid")) then
							setVehicleEngineState(element, false)
							exports.anticheat:setEld(element, 'engine', 0)
						end
					elseif item[1] == 212 then --snow tires
						if getResourceFromName("shader_snow_ground") and getResourceState(getResourceFromName("shader_snow_ground")) == "running" then
							local driver = getVehicleController(element)
							local hasSnowTires = false --hasItem(element, 212)
							triggerClientEvent(driver, "shader_snow_ground:applySlippery", root, element, hasSnowTires)
						end
					end
				end
			end
		elseif item[1] == -100 then
			local faction = getElementData( source, "faction" )
			local armor = math.max( 0, ( ( faction[1] or ( faction[3] and ( (faction[1].rank == 4 or faction[3].rank == 4) or (faction[1].rank == 5 or faction[3].rank == 5) or (faction[1].rank == 13 or faction[3].rank == 13) ) ) ) and 100 or 50 ) - math.ceil( getPedArmor( source ) ) )

			if armor == 0 then
				outputChatBox( "Você não pode usar mais armadura.", source, 255, 0, 0 )
			else
				output( element, source, item[1], nil, nil, item[5])
				takeItemFromSlot( element, slot )

				local leftover = math.max( 0, item[2] - armor )
				if leftover > 0 then
					giveItem( element, item[1], leftover )
				end

				setPedArmor( source, math.ceil( getPedArmor( source ) + math.min( item[2], armor ) ) )
				exports.logs:dbLog(source, 39, source, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1], item[2], item[5] ) .. " - " .. ( math.min( item[2], armor ) ))
			end
			triggerClientEvent( source, "forceElementMoveUpdate", source )
		else
			takeItemFromSlot( element, slot )
			output( element, source, item[1], nil, nil, item[5])
			if ammo < item[2] then
				exports.global:giveWeapon( source, -item[1], ammo )
				giveItem( element, item[1], item[2] - ammo )
				exports.logs:dbLog(source, 39, source, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1], item[2], item[5] ) .. " - " .. ( item[2] - ammo ))
			else
				exports.global:giveWeapon( source, -item[1], item[2] )
				exports.logs:dbLog(source, 39, {source, element}, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1], item[2], item[5] ) .. " - " .. item[2])
			end
			triggerClientEvent( source, "forceElementMoveUpdate", source )
		end
	else
		outputDebugString( "Index mismatch: " .. tostring( item and item[3] or "nil" ) .. " " .. tostring( index ) )
	end

	--outputDebugString("moveFromElement")
	triggerClientEvent( source, "finishItemMove", source )
end
addEvent( "moveFromElement", true )
addEventHandler( "moveFromElement", getRootElement(), moveFromElement )

function getName(element)
	local elementType = getElementType(element)
	if elementType == "vehicle" then
		return exports.global:getVehicleName(element)
	elseif elementType == "interior" then
		return getElementData(element, "name").."'s Mailbox"
	elseif elementType == "player" then
		return "player"
	elseif elementType == "object" then
		local model = getElementModel(element)
		if model == 2942 then
			return "ATM Machine"
		elseif model == 2147 then
			return "fridge"
		elseif model == 3761 then
			return "shelf"
		elseif model == 2332 then
			return "safe"
		elseif getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("item-world")) then
			local itemID = tonumber(getElementData(element, "itemID")) or 0
			local itemValue = getElementData(element, "itemValue")
			if itemID == 166 then --video player
				return "video player"
			else
				return getItemName(itemID, itemValue):lower()
			end
		else
			return "storage"
		end
	else
		return "storage"
	end
end

function getCoordinates( element )
	if isElement( element ) then
		local x, y, z = getElementPosition( element )
		local int = getElementInterior( element )
		local dim = getElementDimension( element )
		return "("..x..", "..y..", "..z..") in (int "..int..", dim "..dim..")"
	else
		return ""
	end
end
