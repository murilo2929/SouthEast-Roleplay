armoredCars = { [427]=true, [528]=true, [432]=true, [601]=true, [428]=true } -- Enforcer, FBI Truck, Rhino, SWAT Tank, Securicar

local btrdiscountratio = 1.2

-- Full Service
function serviceVehicle(veh)
	local capoaberto = getVehicleDoorOpenRatio (veh, 0)
	if (veh) then
		if (capoaberto == 1) then
			local mechcost = 110
			if (getElementData(source,"faction")[4]) then
				mechcost = mechcost / btrdiscountratio
			end
			if not (exports.global:hasMoney(source, mechcost) or exports.integration:isPlayerTrialAdmin(source, true)) then
				outputChatBox("Você não pode pagar as peças para fazer a manutenção deste veículo.", source, 255, 0, 0)
			else
				if not exports.integration:isPlayerTrialAdmin(source, true) then 
					exports.global:takeMoney(source, mechcost)
				end

				local health = getElementHealth(veh)
				if health >= 1000 then
					return
				else
					health = 1000
				end

				exports.global:applyAnimation(source, "bomber", "BOM_Plant_Loop", 5000, true, false, true, false)

				local x,y,z 	= getElementPosition(source); --get your position
				local tx,ty,tz 	= getElementPosition(veh); --get the players position
				setPedRotation(source, findRotation(x,y,tx,ty) ); --let's set you facing them

				triggerClientEvent("somreparo", source, x,y,z)

				setTimer ( function()

					--outputChatBox ( "CONSERTADO!" )
					fixVehicle(veh)
					setElementHealth(veh, health)
					setVehicleDoorOpenRatio (veh, 0, 0)

				end, 5000, 1 )

				--fixVehicle(veh)
				--setElementHealth(veh, health)
				--exports.global:applyAnimation(source, "bomber", "BOM_Plant_Loop", -1, true, false, false)
				if not getElementData(veh, "Impounded") or getElementData(veh, "Impounded") == 0 then
					exports.anticheat:changeProtectedElementDataEx(veh, "enginebroke", 0, false)
					if armoredCars[ getElementModel( veh ) ] then
						setVehicleDamageProof(veh, true)
					else
						setVehicleDamageProof(veh, false)
					end
				end
				exports.global:sendLocalMeAction(source, "faz a manutenção do veículo.")
				exports.logs:dbLog(source, 31, {  veh }, "REPAIR QUICK-SERVICE")
			end
		else
			outputChatBox("Você precisa abrir o capô do veículo primeiro.", source, 255, 0, 0)
		end	
	else
		outputChatBox("Você deve estar no veículo que deseja consertar.", source, 255, 0, 0)
	end
end
addEvent("serviceVehicle", true)
addEventHandler("serviceVehicle", getRootElement(), serviceVehicle)

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

function changeTyre( veh, wheelNumber )
	if (veh) then
		local mechcost = 10
		if (getElementData(source,"faction")[4]) then
			mechcost = mechcost / btrdiscountratio
		end
		if not exports.global:takeMoney(source, mechcost) then
			outputChatBox("Você não pode comprar peças para trocar os pneus deste veículo.", source, 255, 0, 0)
		else
			local wheel1, wheel2, wheel3, wheel4 = getVehicleWheelStates( veh )

			if (wheelNumber==1) then -- front left
				outputDebugString("Pneu 1 trocado.")
				setVehicleWheelStates ( veh, 0, wheel2, wheel3, wheel4 )
			elseif (wheelNumber==2) then -- back left
				outputDebugString("Pneu 2 trocado.")
				setVehicleWheelStates ( veh, wheel1, wheel2, 0, wheel4 )
			elseif (wheelNumber==3) then -- front right
				outputDebugString("Pneu 3 trocado.")
				setVehicleWheelStates ( veh, wheel1, 0, wheel2, wheel4 )
			elseif (wheelNumber==4) then -- back right
				outputDebugString("Pneu 4 trocado.")
				setVehicleWheelStates ( veh, wheel1, wheel2, wheel3, 0 )
			end

			exports.logs:dbLog(source, 31, {  veh }, "REPAIR TIRESWAP")
			exports.global:sendLocalMeAction(source, "substitui o pneu do veículo.")
		end
	end
end
addEvent("tyreChange", true)
addEventHandler("tyreChange", getRootElement(), changeTyre)

function changePaintjob( veh, paintjob )
	if (veh) then
		local mechcost = 7500
		if (getElementData(source,"faction")[4]) then
			mechcost = mechcost / btrdiscountratio
		end
		if not exports.global:takeMoney(source, mechcost) then
			outputChatBox("Você não pode pagar para repintar este veículo.", source, 255, 0, 0)
		else
			triggerEvent( "paintjobEndPreview", source, veh )
			if setVehiclePaintjob( veh, paintjob ) then
				local col1, col2 = getVehicleColor( veh )
				if col1 == 0 or col2 == 0 then
					setVehicleColor( veh, 1, 1, 1, 1 )
				end
				exports.global:sendLocalMeAction(source, "repinta o veículo.")
				exports.logs:dbLog(source, 6, {  veh }, "MODDING PAINTJOB ".. paintjob)
				exports.vehicle:saveVehicleMods(veh)
			else
				outputChatBox("Este carro já tem essa pintura.", source, 255, 0, 0)
			end
		end
	end
end
addEvent("paintjobChange", true)
addEventHandler("paintjobChange", getRootElement(), changePaintjob)

function editVehicleHeadlights( veh, color1, color2, color3 )
	if (veh) then
		local mechcost = 1250
		if (getElementData(source,"faction")[4]) then
			mechcost = mechcost / btrdiscountratio
		end
		if not (exports.global:hasMoney(source, mechcost) or exports.integration:isPlayerTrialAdmin(source, true)) then
			outputChatBox("Você não pode se dar ao luxo de modificar este veículo.", source, 255, 0, 0)
		else
			triggerEvent( "headlightEndPreview", source, veh )
			if setVehicleHeadLightColor ( veh, color1, color2, color3) then
				if not exports.integration:isPlayerTrialAdmin(source, true) then 
					exports.global:takeMoney(source, mechcost)
				end
				exports.global:sendLocalMeAction(source, "substitui os faróis dos veículos.")
				exports.anticheat:changeProtectedElementDataEx(veh, "headlightcolors", {color1, color2, color3}, true)
				exports.vehicle:saveVehicleMods(veh)
				exports.logs:dbLog(source, 6, {  veh }, "MODDING HEADLIGHT ".. color1 .. " "..color2.." "..color3)
			else
				outputChatBox("Este carro já tem esses faróis.", source, 255, 0, 0)
			end
		end
	end
end
addEvent("editVehicleHeadlights", true)
addEventHandler("editVehicleHeadlights", getRootElement(), editVehicleHeadlights)

 --

function changeVehicleUpgrade( veh, upgrade )
	if (veh) then
		local item = false
		local u = upgrades[upgrade - 999]
		if not u then
			outputDebugString( getPlayerName( source ) .. " tried to add invalid upgrade #" .. upgrade )
			return
		end
		name = u[1]
		local mechcost = u[2]
		if (getElementData(source,"faction")[4]) then
			mechcost = mechcost / btrdiscountratio
		end
		if exports.global:hasItem( source, 114, upgrade ) then
			mechcost = 0
			item = true
		end

		if not item and not exports.global:hasMoney( source, mechcost ) then
			outputChatBox("Você não pode se dar ao luxo de adicionar " .. name .. " para este veículo.", source, 255, 0, 0)
		else
			for i = 0, 16 do
				if upgrade == getVehicleUpgradeOnSlot( veh, i ) then
					outputChatBox("Este carro já tem esse upgrade.", source, 255, 0, 0)
					return
				end
			end
			if addVehicleUpgrade( veh, upgrade ) then
				if item then
					exports.global:takeItem(source, 114, upgrade)
				else
					exports.global:takeMoney(source, mechcost)
				end
				exports.global:sendLocalMeAction(source, "adicionou " .. name .. " para o veículo.")
				exports.vehicle:saveVehicleMods(veh)
				exports.logs:dbLog(source, 6, {  veh }, "MODDING ADDUPGRADE "..name)
			else
				outputChatBox("Falha ao aplicar o upgrade do carro.", source, 255, 0, 0)
			end
		end
	end
end
addEvent("changeVehicleUpgrade", true)
addEventHandler("changeVehicleUpgrade", getRootElement(), changeVehicleUpgrade)

function changeVehicleColour(veh, col1, col2, col3, col4)
	if (veh) then
		local mechcost = 100
		if (getElementData(source,"faction")[4]) then
			mechcost = mechcost / btrdiscountratio
		end
		if not (exports.global:hasMoney(source, mechcost) or exports.integration:isPlayerTrialAdmin(source, true)) then
			outputChatBox("Você não pode pagar para repintar este veículo.", source, 255, 0, 0)
		else
			col = { getVehicleColor( veh, true ) }

			local color1 = col1 or { col[1], col[2], col[3] }
			local color2 = col2 or { col[4], col[5], col[6] }
			local color3 = col3 or { col[7], col[8], col[9] }
			local color4 = col4 or { col[10], col[11], col[12] }

			--outputChatBox("1. "..toJSON(color1), source)
			--outputChatBox("2. "..toJSON(color2), source)
			--outputChatBox("3. "..toJSON(color3), source)
			--outputChatBox("4. "..toJSON(color4), source)

			if setVehicleColor( veh, color1[1], color1[2], color1[3], color2[1], color2[2], color2[3],  color3[1], color3[2], color3[3], color4[1], color4[2], color4[3]) then
				if not exports.integration:isPlayerTrialAdmin(source, true) then 
					exports.global:takeMoney(source, mechcost) 
				end
				exports.global:sendLocalMeAction(source, "repinta o veículo.")
				exports.vehicle:saveVehicleMods(veh)
				exports.logs:dbLog(source, 6, {  veh }, "MODDING REPAINT "..toJSON(col))
			end
		end
	end
end
addEvent("repaintVehicle", true)
addEventHandler("repaintVehicle", getRootElement(), changeVehicleColour)
