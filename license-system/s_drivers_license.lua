mysql = exports.mysql

function giveCarLicense(usingGC)
	if usingGC then
		local perk = exports.donators:getPerks(22)
		local success, reason = exports.donators:takeGC(client, perk[2])
		if success then
			exports.donators:addPurchaseHistory(client, perk[1], -perk[2])
		else
			exports.hud:sendBottomNotification(client, "Departamento de Veículos Motorizados", "Não foi possível retirar GCs de sua conta. Razão: "..reason.."." )
			return false
		end
	end
	
	local theVehicle = getPedOccupiedVehicle(client)
	exports.anticheat:changeProtectedElementDataEx(client, "realinvehicle", 0, false)
	removePedFromVehicle(client)
	if theVehicle then 
		respawnVehicle(theVehicle)
		exports.anticheat:changeProtectedElementDataEx(theVehicle, "handbrake", 1, false)
		setElementFrozen(theVehicle, true)
	end
	exports.anticheat:changeProtectedElementDataEx(client, "license.car", 1)
	dbExec(exports.mysql:getConn('mta'), "UPDATE characters SET car_license='1' WHERE id = ?", getElementData(client, 'dbid'))
	exports.hud:sendBottomNotification(client, "Departamento de Veículos Motorizados", "Parabéns! Você passou no exame de direção!" )
	exports.global:giveItem(client, 133, getPlayerName(client):gsub("_"," "))
	executeCommandHandler("stats", client, getPlayerName(client))
end
addEvent("acceptCarLicense", true)
addEventHandler("acceptCarLicense", getRootElement(), giveCarLicense)

function passTheory( skipSQL )
	exports.anticheat:setEld( client, "license.car.cangetin", true, 'one' )
	exports.anticheat:setEld( client, "license.car", 3, 'one' ) -- Set data to "theory passed"
	if not skipSQL then
		dbExec( exports.mysql:getConn('mta'), "UPDATE characters SET car_license='3' WHERE id = ?", getElementData(client, 'dbid') )
	end
end
addEvent("theoryComplete", true)
addEventHandler("theoryComplete", getRootElement(), passTheory)

function checkDoLCars(player, seat)
	-- aka civilian previons
	if getElementData(source, "owner") == -2 and getElementData(source, "faction") == -1 and getElementModel(source) == 410 then
		if exports.global:isPlayerScripter(player) or getElementData(player,"license.car") == 3 then
			if getElementData(player, "license.car.cangetin") then
				exports.hud:sendBottomNotification(player, "Departamento de Veículos Motorizados", "Você pode usar 'J' para ligar o motor e 'G' para abaixar o freio de mão." )
				setVehicleLocked( source, false )
				setElementFrozen( source, false )
			else
				exports.hud:sendBottomNotification(player, "Departamento de Veículos Motorizados", "Este veículo é apenas para o Teste de Condução, por favor, veja o NPC dentro primeiro." )
				cancelEvent()
			end
		elseif seat > 0 then
			exports.hud:sendBottomNotification(player, "Departamento de Veículos Motorizados", "Este veículo é apenas para o teste de direção." )
			--cancelEvent()
		else
			exports.hud:sendBottomNotification(player, "Departamento de Veículos Motorizados", "Este veículo é apenas para o teste de direção." )
			cancelEvent()
		end
	end
end
addEventHandler( "onVehicleStartEnter", getRootElement(), checkDoLCars)