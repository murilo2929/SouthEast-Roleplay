
function getNearbyItems(thePlayer, commandName)
	if exports.integration:isPlayerTrialAdmin(thePlayer) or exports.global:isStaffOnDuty(thePlayer) or exports.global:isPlayerScripter(thePlayer) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Itens Proximos:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, theObject in ipairs(getElementsByType("object", getResourceRootElement(getResourceFromName("item-world")))) do
			local dbid = getElementData(theObject, "id")
			
			if dbid then
				local x, y, z = getElementPosition(theObject)
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				
				if distance <= 10 and getElementDimension(theObject) == getElementDimension(thePlayer) and getElementInterior(theObject) == getElementInterior(thePlayer) and getElementData(theObject, "itemID") ~= 169 then
					outputChatBox("   #" .. dbid .. (getElementData(theObject, "protected") and ("(" .. getElementData(theObject, "protected").. ")") or "") .. " by " .. ( exports['cache']:getCharacterName( getElementData(theObject, "creator"), true ) or "?" ) .. " - " .. ( getItemName( getElementData(theObject, "itemID"), getElementData(theObject, "itemValue"), getElementData(theObject, "metadata") ) or "?" ) .. "(" .. getElementData(theObject, "itemID") .. "): " .. tostring( getElementData(theObject, "itemValue") or 1 ), thePlayer, 255, 126, 0)
					count = count + 1
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   Nenhum.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyitems", getNearbyItems, false, false)
addCommandHandler("itensproximos", getNearbyItems, false, false)

function delItem(thePlayer, commandName, targetID)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetID) then
			outputChatBox("SYNTAX: " .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			local object = nil
			targetID = tonumber( targetID )
			
			for key, value in ipairs(getElementsByType("object", getResourceRootElement(getResourceFromName("item-world")))) do
				local dbid = getElementData(value, "id")
				if dbid and dbid == targetID then
					object = value
					break
				end
			end
			
			if object and getElementData(object, "itemID") ~= 169 then
				local id = getElementData(object, "id")
				local result = mysql:query_free("DELETE FROM worlditems WHERE id='" .. id .. "'")
						
				outputChatBox("Item #" .. id .. " deletado.", thePlayer)
				destroyElement(object)
			else
				outputChatBox("ID do item invalido.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delitem", delItem, false, false)
addCommandHandler("removeritem", delItem, false, false)

function delNearbyItems(thePlayer, commandName)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Itens Proximos:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, theObject in ipairs(getElementsByType("object", getResourceRootElement(getResourceFromName("item-world")))) do
			local dbid = getElementData(theObject, "id")
			
			if dbid then
				local x, y, z = getElementPosition(theObject)
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				
				if distance <= 10 and getElementDimension(theObject) == getElementDimension(thePlayer) and getElementInterior(theObject) == getElementInterior(thePlayer) and getElementData(theObject, "itemID") ~= 169 then
					local id = getElementData(theObject, "id")
					mysql:query_free("DELETE FROM worlditems WHERE id='" .. id .. "'")
					destroyElement(theObject)
					count = count + 1
				end
			end
		end
		
		outputChatBox( count .. " Itens deletados.", thePlayer, 255, 126, 0)
	end
end
addCommandHandler("delnearbyitems", delNearbyItems, false, false)
addCommandHandler("removeritensproximos", delNearbyItems, false, false)

function setItemForMovement(thePlayer, commandName, targetID)
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)) or getElementData(thePlayer, "admin:tempmove") then
		if not (targetID) then
			outputChatBox("SYNTAX: " .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			local object = nil
			targetID = tonumber( targetID )
			
			for key, value in ipairs(getElementsByType("object", getResourceRootElement(getResourceFromName("item-world")))) do
				local dbid = getElementData(value, "id")
				if dbid and dbid == targetID then
					object = value
					break
				end
			end
			
			if object and getElementData(object, "itemID") ~= 169 then
				triggerClientEvent(thePlayer, 'item:move', root, object)
			else
				outputChatBox("ID item invalido.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("moveitem", setItemForMovement, false, false)
addCommandHandler("moveritem", setItemForMovement, false, false)

function delAllItemInstances(thePlayer,commandName, itemID, itemValue )
	if exports.integration:isPlayerHeadAdmin( thePlayer ) then
		if not tonumber(itemID) or tonumber(itemID)%1 ~=0 then
			outputChatBox( "SYNTAX: /" .. commandName .. " [Item ID] [Valor Item]", thePlayer, 255, 194, 14 )
			outputChatBox( "Exclui todas as instâncias de itens de todos os lugares do jogo.", thePlayer, 150, 150, 50 )
		else
			local deleted = deleteAll( itemID, itemValue )
			if deleted and deleted > 0 then
				exports.global:sendMessageToAdmins("[ITEM] "..exports.global:getPlayerFullIdentity( thePlayer ).." deletou "..exports.global:formatMoney( deleted ).." instâncias de item (Item ID #"..itemID..( itemValue and ( ", Item Valor: "..itemValue ) or "" )..") de todos os lugares no jogo.")
			end
		end
	end
end
addCommandHandler("delallitems", delAllItemInstances, false, false)
addCommandHandler("removerallitens", delAllItemInstances, false, false)

function deleteAllItemsFromAnInterior(thePlayer, commandName, intID , dayOld, restartRes)
	if exports.integration:isPlayerTrialAdmin( thePlayer ) then
		if not tonumber(intID) or tonumber(intID) < 0 or tonumber(intID)%1 ~=0 or  not tonumber(dayOld) or tonumber(dayOld) < 0 or tonumber(dayOld)%1 ~=0 then
			outputChatBox( "SYNTAX: /" .. commandName .. " [Int ID] [Dias atrás dos itens]", thePlayer, 255, 194, 14 )
			outputChatBox( "Exclui todos os itens de um interior especificado com mais de um intervalo do dia do item.", thePlayer, 150, 150, 50 )
			if exports.integration:isPlayerLeadAdmin( thePlayer ) then
				outputChatBox( "SYNTAX: /" .. commandName .. " [Int ID] [Day old of Items]", thePlayer, 255, 194, 14 )
				outputChatBox( "Exclui todos os itens em um interior especificado ou mapa-múndi com mais de um intervalo do dia do item.", thePlayer, 150, 150, 50 )
			end
		else
			if tonumber(intID) == 0 and not exports.integration:isPlayerLeadAdmin( thePlayer ) then
				outputChatBox("Apenas Head + Admins podem excluir todas as instâncias de itens do mapa mundial.", thePlayer, 255, 0, 0)
				return false
			end
			
			-- if tonumber(intID) == 0 and exports.integration:isPlayerLeadAdmin( thePlayer ) then
				-- restartRes = 1
			-- end
			
			if deleteAllItemsWithinInt(intID, dayOld) then
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				outputChatBox( "All the item instances that is older than "..dayOld.." days wthin interior ID #"..intID.." have been deleted.", thePlayer, 0, 255, 0)
				--outputChatBox( " However, the items still exist temporarily in game. It's strongly recommended to lock or delete this interior ASAP after executing this command.", thePlayer, 255, 255, 0)
				if restartRes == 1 and getResourceFromName("item-world") then
					executeCommandHandler("saveall", thePlayer)
					setTimer(function () 
						outputChatBox( " Server is cleaning up world items, please standby!", root)
						restartResource(getResourceFromName("item-world"))
					end, 10000, 1)
				end
				
				if hiddenAdmin == 0 then
					exports.global:sendMessageToAdmins("AdmWrn: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ") .. " has deleted all item instances that is older than "..dayOld.." days within interior ID #"..intID..".")
				else
					exports.global:sendMessageToAdmins("AdmWrn: A hidden admin has deleted all item instances that is older than "..dayOld.." days within interior ID #"..intID..".")
				end
				return true
			else
				outputChatBox( "Failed to delete items within a specified interior ID #"..intID..".", thePlayer, 255, 0, 0)
				return false
			end
		end
	end
end
addCommandHandler("delitemsfromint", deleteAllItemsFromAnInterior, false, false)

-- by Express
function gotoItem(thePlayer, commandName, itemID)
	if exports.integration:isPlayerTrialAdmin(thePlayer, true) and getElementData(thePlayer, 'loggedin') == 1 then
		if not (itemID) then
			outputChatBox("SYNTAX: /iritem [itemID]", thePlayer, 255, 194, 14)
			return
		end

		local objects = getElementsByType("object")
		for k, theObject in ipairs( objects ) do
			if (getElementData(theObject, "id") == tonumber(itemID)) then
				local x, y, z = getElementPosition(theObject)
				setElementPosition(thePlayer, x, y, z, true )
				setElementDimension(thePlayer, getElementDimension(theObject))
				setElementInterior(thePlayer, getElementInterior(theObject))
				
				exports.logs:dbLog(thePlayer, 4, thePlayer,commandName.." #"..itemID)
				return
			end
		end
		outputChatBox("ID do item invalido.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("gotoitem", gotoItem, false, false)
addCommandHandler("iritem", gotoItem, false, false)