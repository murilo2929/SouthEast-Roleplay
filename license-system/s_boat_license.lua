function giveBoatLicense(usingGC)
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
	
	dbExec(exports.mysql:getConn('mta'), "UPDATE characters SET boat_license='1' WHERE id = ?", getElementData(client, 'dbid'))
	exports.anticheat:changeProtectedElementDataEx(client, "license.boat", 1)
	exports.hud:sendBottomNotification(client, "Departamento de Veículos Motorizados", "Parabéns! Você agora está totalmente licenciado como capitão de um barco." )
	exports.global:giveItem(client, 155, getPlayerName(client):gsub("_"," "))
	executeCommandHandler("stats", client, getPlayerName(client))
end
addEvent("acceptBoatLicense", true)
addEventHandler("acceptBoatLicense", getRootElement(), giveBoatLicense)