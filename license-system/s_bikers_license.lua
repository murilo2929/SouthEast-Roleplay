mysql = exports.mysql

function giveBikeLicense(usingGC)
	if usingGC then
		local perk = exports.donators:getPerks(22)
		local success, reason = exports.donators:takeGC(client, perk[2])
		if success then
			exports.donators:addPurchaseHistory(client, perk[1], -perk[2])
		else
			exports.hud:sendBottomNotification(source, "Departamento de Veículos Motorizados", "Não foi possível retirar GCs de sua conta. Razão: "..reason.."." )
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
	
	exports.anticheat:changeProtectedElementDataEx(client, "license.bike", 1)
	dbExec(exports.mysql:getConn('mta'), "UPDATE characters SET bike_license='1' WHERE id = ?", getElementData(client, 'dbid'))
	exports.hud:sendBottomNotification(client, "Departamento de Veículos Motorizados", "Parabéns! Você passou no exame de motocicleta!" )
	exports.global:giveItem(client, 153, getPlayerName(client):gsub("_"," "))
	executeCommandHandler("stats", client, getPlayerName(client))
end
addEvent("acceptBikeLicense", true)
addEventHandler("acceptBikeLicense", getRootElement(), giveBikeLicense)

addEvent("theoryBikeComplete", true)
addEventHandler("theoryBikeComplete", getRootElement(), function( skipSQL )
	exports.anticheat:changeProtectedElementDataEx(client,"license.bike.cangetin",true, false)
	exports.anticheat:changeProtectedElementDataEx(client,"license.bike",3) -- Set data to "theory passed"

	if not skipSQL then
		dbExec( exports.mysql:getConn('mta'), "UPDATE characters SET bike_license='3' WHERE id=? ", getElementData( client, 'dbid' ) )
		if exports.global:giveItem(client, 90, 1) then
			outputChatBox( "Você recebeu um capacete do DMV para o teste prático.", client )
		end
	end
end)

function checkDoLBikes(player, seat)
	if getElementData(player, "owner") == -2 and getElementData(player, "faction") == -1 and getElementModel(player) == 468 then
		if exports.global:isPlayerScripter(player) or getElementData(player,"license.bike") == 3 then
			if getElementData(player, "license.bike.cangetin") then
				exports.hud:sendBottomNotification(player, "Departamento de Veículos Motorizados", "Você pode usar 'J' para ligar o motor e 'G' antes de dirigir." )
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
addEventHandler("onVehicleStartEnter", getRootElement(), checkDoLBikes)

addEvent("takeBackHelmet", true)
addEventHandler("takeBackHelmet", root, function ()
	if getElementData(client, "helmet") then
		exports.global:sendLocalMeAction(client, "tira um capacete da cabeça.")
		exports.anticheat:changeProtectedElementDataEx(client, "helmet", false, true)
	end

	exports.global:takeItem(client, 90, 1)

	exports['item-system']:doItemGiveawayChecks(client, 90)
end)