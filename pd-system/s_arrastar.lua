addCommandHandler("arrastar",
	function(thePlayer, commandName, targetPlayerNick)
		local logged = getElementData(thePlayer, "loggedin")
	
		if (logged==1) then
			if getElementData(thePlayer, "surukle") then
				outputChatBox("#f0f0f0Você não pode arrastar mais de uma pessoa ao mesmo tempo!", thePlayer, 255, 0, 0, true)
				return false
			end
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
		
			--if (factionType==2) or (factionType == 3) then
				if not (targetPlayerNick) then
					outputChatBox("KULLANIM: /" .. commandName .. " [Nome Jodador / ID]", thePlayer, 255, 194, 14)
				else
					local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerNick)

					--[[if targetPlayer == thePlayer then
						outputChatBox("#f0f0f0Você não pode se segurar.", thePlayer, 255, 0, 0, true)
						return
					end]]
				
					if targetPlayer then
						if getElementData(thePlayer, "isleme:durum") or getElementData(thePlayer, "kazma:durum") or getElementData(thePlayer, "tutun:durum") then
							outputChatBox("#f9f9f9 Você não pode usar este comando enquanto estiver neste estado..", thePlayer, 255, 0, 0, true)
						return end
							if getElementData(targetPlayer, "isleme:durum") or getElementData(targetPlayer, "kazma:durum") or getElementData(targetPlayer, "tutun:durum") then
							outputChatBox("#f9f9f9 Fique bom logo mano, você foi denunciado aos administradores. Você se acha inteligente.", thePlayer, 255, 0, 0, true)
							outputChatBox("#f9f9f9 Fique bom logo mano, você foi denunciado aos administradores. Você se acha inteligente.", targetPlayer, 255, 0, 0, true)
							outputChatBox("#f9f9f9 $300 apreendidos pelo sistema.", targetPlayer, 255, 0, 0, true)
							outputChatBox("#f9f9f9 $300 apreendidos pelo sistema.", thePlayer, 255, 0, 0, true)
							exports.global:takeMoney(thePlayer, 300)
							exports.global:takeMoney(targetPlayer, 300)
							exports.global:sendMessageToAdmins("[AVISO DE BUG] '" .. getPlayerName(thePlayer) .. "' jogador nomeado na profissão de mineração, '"..getPlayerName(targetPlayer).."' Tentei arrastar / para o jogador nomeado!")
						return end
						local x, y, z = getElementPosition(thePlayer)
						local tx, ty, tz = getElementPosition(targetPlayer)
						
						local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
						
						if (distance<=1) then
							exports.global:applyAnimation( targetPlayer, "CRACK", "crckidle4", -1, false, false, false)
							attachElements(targetPlayer, thePlayer, 0, 1, 0)
							setElementData(thePlayer, "surukle", targetPlayer)
							setElementFrozen(targetPlayer, true)
							exports.global:sendLocalMeAction(thePlayer, "agarra as mãos do(a) " ..targetPlayerName.." e começa a puxar.", false, true)
							outputChatBox("#f0f0f0Você está arrastando o jogador " .. targetPlayerName .. " para soltar digite /liberar.", thePlayer, 0, 255, 0, true)
							outputChatBox("#f0f0f0" .. getPlayerName(thePlayer) .. " está te arrastando.", targetPlayer, 0, 255, 0, true)
						else
							outputChatBox("#f0f0f0 Você está longe do jogador.", thePlayer, 255, 0, 0, true)
						end
					end
				end
			--end
		end
	end
)

addCommandHandler("liberar",
	function(thePlayer)
		local surukle = getElementData(thePlayer, "surukle")
		if surukle then
			detachElements(surukle, thePlayer)
			setElementFrozen(surukle, false)
			setElementData(thePlayer, "surukle", false)
			local targetPlayerName = getPlayerName(surukle)
			exports.global:sendLocalMeAction(thePlayer, "solta as mãos do(a) "..targetPlayerName, false, true)
			outputChatBox("#f0f0f0Você parou de arrastar o(a) ".. targetPlayerName, thePlayer, 0, 255, 0, true)
			exports.global:removeAnimation(surukle)
			outputChatBox("#f0f0f0O jogador " .. getPlayerName(thePlayer).. " parou de te arrastar.", surukle, 0, 255, 0, true)
		else
			outputChatBox("#f0f0f0Você não está arrastando ninguém no momento.", thePlayer, 255, 0, 0, true)
		end
	end
)