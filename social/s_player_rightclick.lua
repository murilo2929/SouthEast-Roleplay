mysql = exports.mysql

addEvent("addFriend", true)
addEventHandler("addFriend", getRootElement(), function(player) new_addFriend(client, player) end)


local function onVehicleStartEnter(player, other)
	local x, y, z = getElementPosition(player)
	local otherX, otherY, otherZ = getElementPosition(other)

	return getDistanceBetweenPoints3D(x, y, z, otherX, otherY, otherZ) < 20
end

local function isPlayerNearOther(player, other)
	local x, y, z = getElementPosition(player)
	local otherX, otherY, otherZ = getElementPosition(other)

	return getDistanceBetweenPoints3D(x, y, z, otherX, otherY, otherZ) < 20
end

-- FRISKING
function friskShowItems(player)
	--local items = exports['item-system']:getItems(player)
	--triggerClientEvent(source, "friskShowItems", player, items)
	triggerEvent("subscribeToInventoryChanges",source,player)
	triggerClientEvent(source,"showInventory",source,player, "frisk")
end
addEvent("friskShowItems", true)
addEventHandler("friskShowItems", getRootElement(), friskShowItems)

-- CUFFS
function toggleCuffs(cuffed, player)
	if (cuffed) then
		toggleControl(player, "fire", false)
		toggleControl(player, "sprint", false)
		toggleControl(player, "jump", false)
		toggleControl(player, "next_weapon", false)
		toggleControl(player, "previous_weapon", false)
		toggleControl(player, "accelerate", false)
		toggleControl(player, "brake_reverse", false)
		toggleControl(player, "aim_weapon", false)
	else
		toggleControl(player, "fire", true)
		toggleControl(player, "sprint", true)
		toggleControl(player, "jump", true)
		toggleControl(player, "next_weapon", true)
		toggleControl(player, "previous_weapon", true)
		toggleControl(player, "accelerate", true)
		toggleControl(player, "brake_reverse", true)
		toggleControl(player, "aim_weapon", true)
	end
end

function setPedAnimationSpeed(player,anim,speed)
	triggerClientEvent(player, "animSped", player, player,anim,speed)
end

function setCuffPlayer(player)
	setPedAnimation(player, nil)
	setPedAnimation(player,'ped', 'pass_Smoke_in_car', 0, false, true, true)
	setTimer(setPedAnimationSpeed,60,1,player, 'pass_Smoke_in_car', 0)
	local x, y, z = getElementPosition(player)
	local box = createObject(364, x, y, z)
	exports.bone_attach:attachElementToBone(box, player, 12, 0,0,0,   0,40,-10)
	setElementCollisionsEnabled(box, false)
	setElementData(player,'cuffOb', box)
end

-- RESTRAINING
function restrainPlayer(player, restrainedObj)
	if not isPlayerNearOther(client, player) then
		return
	end

	local username = getPlayerName(client)
	local targetPlayerName = getPlayerName(player)
	local dbid = getElementData( player, "dbid" )
	
	setTimer(toggleCuffs, 200, 1, true, player)
	
	outputChatBox("Você foi algemado por " .. username:gsub("_", " ") .. ".", player)
	outputChatBox("Você algemou " .. targetPlayerName:gsub("_", " ") .. ".", client)
	exports.anticheat:changeProtectedElementDataEx(player, "restrain", 1, true)
	exports.anticheat:changeProtectedElementDataEx(player, "restrainedObj", restrainedObj, true)
	exports.anticheat:changeProtectedElementDataEx(player, "restrainedBy", getElementData(client, "dbid"), true)
	setCuffPlayer(player)
	mysql:query_free("UPDATE characters SET cuffed = 1, restrainedby = " .. mysql:escape_string(getElementData(client, "dbid")) .. ", restrainedobj = " .. mysql:escape_string(restrainedObj) .. " WHERE id = " .. mysql:escape_string(dbid) )
	
	exports.global:takeItem(client, restrainedObj)

	if (restrainedObj==45) then -- If handcuffs.. give the key
		exports['item-system']:deleteAll(47, dbid)
		exports.global:giveItem(client, 47, dbid)
	end
end
addEvent("restrainPlayer", true)
addEventHandler("restrainPlayer", getRootElement(), restrainPlayer)

function unrestrainPlayer(player, restrainedObj)
	if not isPlayerNearOther(client, player) then
		return
	end

	local username = getPlayerName(client)
	local targetPlayerName = getPlayerName(player)
	
	outputChatBox("Você foi desalgemado por " .. username:gsub("_", " ") .. ".", player)
	outputChatBox("Você removeu as algemas de " .. targetPlayerName:gsub("_", " ") .. ".", client)
	
	setTimer(toggleCuffs, 200, 1, false, player)
	
	exports.anticheat:changeProtectedElementDataEx(player, "restrain", 0)
	exports.anticheat:changeProtectedElementDataEx(player, "restrainedBy")
	exports.anticheat:changeProtectedElementDataEx(player, "restrainedObj")
	
	local dbid = getElementData(player, "dbid")
	if (restrainedObj==45) then -- If handcuffs.. take the key
		exports['item-system']:deleteAll(47, dbid)
	end
	exports.global:giveItem(client, restrainedObj, 1)
	mysql:query_free("UPDATE characters SET cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. mysql:escape_string(dbid) )
	
	exports.global:removeAnimation(player)
	destroyElement(getElementData(player,'cuffOb'))
	removeElementData(player, 'cuff')
	setPedAnimation(player, 'ped', 'pass_Smoke_in_car', 0, false, false, false, false)
end
addEvent("unrestrainPlayer", true)
addEventHandler("unrestrainPlayer", getRootElement(), unrestrainPlayer)

-- BLINDFOLDS
function blindfoldPlayer(player)
	if not isPlayerNearOther(client, player) or not exports.global:takeItem(client, 66) then -- take their blindfold
		return
	end

	local username = getPlayerName(client):gsub("_", " ")
	local targetPlayerName = getPlayerName(player):gsub("_", " ")

	outputChatBox("Você foi vendado por " .. username .. ".", player)
	outputChatBox("Você vendou " .. targetPlayerName .. ".", client)

	exports.anticheat:changeProtectedElementDataEx(player, "blindfold", 1)
	mysql:query_free("UPDATE characters SET blindfold = 1 WHERE id = " .. mysql:escape_string(getElementData( player, "dbid" )) )
	fadeCamera(player, false)
end
addEvent("blindfoldPlayer", true)
addEventHandler("blindfoldPlayer", getRootElement(), blindfoldPlayer)

function removeblindfoldPlayer(player)
	local username = getPlayerName(source):gsub("_", " ")
	local targetPlayerName = getPlayerName(player):gsub("_", " ")
	
	outputChatBox("Sua venda foi removida por " .. username .. ".", player)
	outputChatBox("Você removeu a venda de " .. targetPlayerName .. ".", source)
	
	exports.global:giveItem(source, 66, 1) -- give the remove the blindfold
	exports.anticheat:changeProtectedElementDataEx(player, "blindfold")
	mysql:query_free("UPDATE characters SET blindfold = 0 WHERE id = " .. mysql:escape_string(getElementData( player, "dbid" )) )
	fadeCamera(player, true)
end
addEvent("removeBlindfold", true)
addEventHandler("removeBlindfold", getRootElement(), removeblindfoldPlayer)

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

-- STABILIZE
function stabilizePlayer(player)
	if not isPlayerNearOther(client, player) then
		return
	end

	local found, slot, itemValue = exports.global:hasItem(client, 70)
	if found then
		if itemValue > 1 then
			exports['item-system']:updateItemValue(client, slot, itemValue - 1)
		else
			exports.global:takeItem(client, 70, itemValue)
		end
		
		local username = getPlayerName(client)
		local targetPlayerName = getPlayerName(player)

		--exports.global:applyAnimation(client, "bomber", "BOM_Plant_Loop", 10000, true, false, true, false)
		exports.global:applyAnimation(client, "MEDIC", "CPR", 10000, true, false, true, false)

		local x,y,z 	= getElementPosition(client); --get your position
		local tx,ty,tz 	= getElementPosition(player); --get the players position
		setPedRotation(client, findRotation(x,y,tx,ty) ); --let's set you facing them
	
	
		outputChatBox("Você foi estabilizado por " .. username .. ".", player)
		outputChatBox("Você estabilizou " .. targetPlayerName .. ".", client)

		setTimer ( function()

			triggerEvent("onPlayerStabilize", player)

		end, 10000, 1 )

		--triggerEvent("onPlayerStabilize", player)
	end
end
addEvent("stabilizePlayer", true)
addEventHandler("stabilizePlayer", getRootElement(), stabilizePlayer)

addEventHandler('onPlayerQuit', root,function()
	if getElementData(source, "restrain") == 1 then
		destroyElement(getElementData(source,'cuffOb'))
		removeElementData(source, 'cuff')
	end
end)

addEventHandler('onPlayerWasted',root,function()
	if getElementData(source, "restrain") == 1 then
		destroyElement(getElementData(source,'cuffOb'))
		removeElementData(source, 'cuff')
	end
end)



--[[function bloqcomandos (nomecomando)
	if (nomecomando ~= 'say' )  then
		cancelEvent()	
	end
end]]

function parteNick(nomejog)
	local jog = getPlayerFromName(nomejog)
	if jog then
		return jog
	end
	for _,jog in ipairs(getElementsByType('player')) do
		if string.find(string.gsub(getPlayerName(jog):lower(),'#%x%x%x%x%x%x', ''), nomejog:lower(), 1, true) then
			return jog
		end
	end
return false
end

function getNearestVehicle(player,distance)
	local lastMinDis = distance-0.0001
	local nearestVeh = false
	local px,py,pz = getElementPosition(player)
	local pint = getElementInterior(player)
	local pdim = getElementDimension(player)

	for _,v in pairs(getElementsByType("vehicle")) do
		local vint,vdim = getElementInterior(v),getElementDimension(v)
		if vint == pint and vdim == pdim then
			local vx,vy,vz = getElementPosition(v)
			local dis = getDistanceBetweenPoints3D(px,py,pz,vx,vy,vz)
			if dis < distance then
				if dis < lastMinDis then 
					lastMinDis = dis
					nearestVeh = v
				end
			end
		end
	end
	return nearestVeh
end


function colocanavtr (pol, cmdo, pnick)	
	
	local preso = parteNick (pnick)
	local px, py, pz = getElementPosition (pol)
	local bx, by, bz = getElementPosition (preso)
	local dist = getDistanceBetweenPoints3D (px, py, pz, bx, by, bz)
	local vtr = getNearestVehicle(pol, 2)

	if exports.factions:isPlayerInFaction(pol, 1) then

		if getElementData(preso, "restrain") == 1 then

			if dist <=2 and preso ~= pol then

				if (vtr) then

				 	if getPedOccupiedVehicle(preso) == false then

				 		if getPedOccupiedVehicle(pol) == false then

							--addEventHandler('onPlayerCommand', preso, bloqcomandos)              	
							warpPedIntoVehicle (preso, vtr, 2)
							
						end

					else
						removePedFromVehicle( preso )
						setElementPosition(preso, getElementPosition(pol))	
					end

				else
					outputChatBox('Você deve estar mais próximo do veículo.', pol, 255, 255, 255, true)
				end

			end
		else
			outputChatBox('Este jogador não esta algemado.', pol, 255, 255, 255, true)
		end 

	end

	if ( getPedOccupiedVehicle(preso) == false  and  getPedOccupiedVehicle(pol) == false and dist >=2 and preso ~=pol  ) then
		--outputChatBox('#bebebeVocê precisa chegar mais perto para prender.', pol, 255, 255, 255, true)
	end 	

	if ( getPedOccupiedVehicle(preso) == false  and  getPedOccupiedVehicle(pol) == false and preso ==pol   ) then
		--outputChatBox('#bebebeVocê não pode prender a si mesmo.', pol, 255, 255, 255, true)
	end 

	if ( getPedOccupiedVehicle(preso)  ) then
		--outputChatBox('#bebebeVocê não pode prender um bandido dentro do carro.', pol, 255, 255, 255, true)
	end 

	if ( getPedOccupiedVehicle(pol)  ) then
		--outputChatBox('#bebebeVocê não pode prender de dentro da viatura.', pol, 255, 255, 255, true)
	end
	

end
addCommandHandler ('deter', colocanavtr)

--[[function tirarvtr (pol, cmdo, pnick)	
	
	local preso = parteNick (pnick)
	local px, py, pz = getElementPosition (pol)
	local bx, by, bz = getElementPosition (preso)
	local dist = getDistanceBetweenPoints3D (px, py, pz, bx, by, bz)	 	

	if ( getElementData(preso, "restrain") == 1 and exports.factions:isPlayerInFaction(pol, 1) and getPedOccupiedVehicle(preso) == true  and  getPedOccupiedVehicle(pol) == false and dist <=2 and preso ~= pol  ) then	                     
		removePedFromVehicle( preso )
		setElementPosition(preso, getElementPosition(pol))		
	end 
	

end
addCommandHandler ('testetirar', tirarvtr)]]
