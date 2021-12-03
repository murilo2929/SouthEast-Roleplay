addCommandHandler("tunar",
	function(player, cmd)
		if player:getData("job") == 5 then
			if player:getData("mechanic:gui:state") then 
				exports["ed_infobox"]:addBox(player, "error", "Bu panel zaten şu anda ekranında")
				outputChatBox( "Painel já está aberto", player, 255, 255, 255 )
			return end  
			triggerClientEvent(player, "mechanic:gui", player, false, false, true)
		end
	end
)