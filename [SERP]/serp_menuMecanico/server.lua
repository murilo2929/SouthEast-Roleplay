addCommandHandler("tunar",
	function(player, cmd)
		if player:getData("job") == 5 then
			if player:getData("mechanic:gui:state") then 
				exports["serp_infobox"]:addBox(player, "error", "Painel já está aberto")
				--outputChatBox( "Painel já está aberto", player, 255, 255, 255 )
			return end  
			triggerClientEvent(player, "mechanic:gui", player, false, false, true)
		end
	end
)