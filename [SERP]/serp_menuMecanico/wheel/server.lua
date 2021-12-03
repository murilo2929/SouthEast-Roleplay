addCommandHandler("rodas",
	function(player, cmd)
			if player:getData("wheel:mechanic") then 
				outputChatBox("Painel já está aberto", player, 255, 255, 255)
			return end  
			triggerClientEvent(player, "jant:gui", player, false, false, true)
		end
)


addCommandHandler("jantbug",
	function(player)
		player:setData("wheel:mechanic", nil)
	end
)

addEvent("mechanic:givewheel", true)
addEventHandler("mechanic:givewheel", root,	function(plr, upid,veh, price)

	exports.global:sendLocalMeAction(plr, "inclinando-se, lentamente começa a montar os aros do veículo.")
	exports.global:applyAnimation(plr, "CAR", "Fixn_Car_Loop", 6000, false, true, false)
	triggerClientEvent ( "play:drill", plr)

	setTimer(function()
	if addVehicleUpgrade(veh, upid) then
	exports.global:takeMoney(plr, price)
	outputChatBox("Você instalou as rodas com sucesso.", plr, 255, 255, 255)
	exports.global:applyAnimation(plr, "CAR", "Fixn_Car_Out", 6000, false, true, false)
	
	exports['vehicle']:saveVehicleMods(veh)
	else
		--exports["ed_infobox"]:addBox(plr, "error", "Bir şeyler ters gitti.")
	end
	end, 6000,1)
end)

