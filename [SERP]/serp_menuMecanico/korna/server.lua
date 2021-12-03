addCommandHandler("buzina",
	function(player, cmd)
			if player:getData("korna:mechanic") then 
				exports["ed_infobox"]:addBox(player, "error", "Bu panel zaten şu anda ekranında")
				outputChatBox("Painel já está aberto", player, 255, 255, 255)
			return end  
			triggerClientEvent(player, "korna:gui", player, false, false, true)
		end
)

addEvent("mechanic:givekorna", true)
addEventHandler("mechanic:givekorna", root,	function(plr, upid,veh, price)

	exports.global:sendLocalMeAction(plr, "pega uma buzina de ar da prateleira.")
	if exports["item-system"]:giveItem(plr, upid, 1) then
	exports.global:takeMoney(plr, price)
	--exports["ed_infobox"]:addBox(plr, "buy", "Envanterinize bir adet Havalı Korna geldi.")
	else
		--exports["ed_infobox"]:addBox(plr, "error", "Envanterinde yeterli alan yok.")
	end
end)

