addCommandHandler("spoiler",
	function(player, cmd)
			if player:getData("spoiler:mechanic") then 
				outputChatBox("Painel já está aberto", player, 255, 255, 255)
			return end  
			triggerClientEvent(player, "spoiler:gui", player, false, false, true)
		end
)

addEvent("mechanic:givespoiler", true)
addEventHandler("mechanic:givespoiler", root,	function(plr, upid,veh, price)

	exports.global:sendLocalMeAction(plr, "move-se para a parte traseira do veículo e lentamente comece a apertar os spoilers com uma chave de fenda.")
	exports.global:applyAnimation(plr, "CAR_CHAT", "car_talkm_loop", 6000, false, true, false)
	triggerClientEvent ( "play:drill", plr)
	--exports["ed_progressbar"]:drawProgressBar("Spoiler", "Sabitleniyor..",plr, 255, 255, 255, 6000)

	setTimer(function()
	if addVehicleUpgrade(veh, upid) then
	exports.global:takeMoney(plr, price)
	outputChatBox("Você instalou com sucesso o spoiler no veículo.", plr, 255, 255, 255)
	exports['vehicle']:saveVehicleMods(veh)
	else
		--exports["ed_infobox"]:addBox(plr, "error", "Bir şeyler ters gitti.")
	end
	end, 6000,1)
end)

