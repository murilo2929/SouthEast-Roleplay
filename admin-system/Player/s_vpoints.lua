function givedonPoint(thePlayer, commandName, targetPlayer, donPoints, ...)
	if exports.integration:isPlayerScripter( thePlayer, true ) then
		if (not targetPlayer or not donPoints or not (...)) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player] [GCs] [Razão]", thePlayer, 255, 194, 14)
		else
			local tplayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if (tplayer) then
				local loggedIn = getElementData(tplayer, "loggedin")
				if loggedIn == 1 then
					donPoints = tonumber(donPoints)
					if not donPoints or donPoints <= 0 then
						outputChatBox("Você não pode dar uma quantidade negativa de GCs.", thePlayer, 255, 0, 0)
						return false
					end
					donPoints = math.floor(donPoints)
					local reasonStr = table.concat({...}, " ")
					local accountID = getElementData(tplayer, "account:id")

					local playerName = exports.global:getPlayerFullIdentity(thePlayer,1)
					local targetName = exports.global:getPlayerFullIdentity(tplayer, 1)
					local targetNameFull = exports.global:getPlayerFullIdentity(tplayer)

					exports.achievement:awardPlayer(tplayer, "PRÊMIO GAMECOINS! ("..string.upper(playerName)..")", reasonStr, donPoints)

					outputChatBox("Você deu para "..targetName.." "..donPoints.." GameCoins para: ".. reasonStr, thePlayer)

					local targetUsername = string.gsub(getElementData(tplayer, "account:username"), "_", " ")
					local username = string.gsub(getElementData(thePlayer, "account:username"), "_", " ")
					targetUsername = mysql:escape_string(targetUsername)
					local targetCharacterName = mysql:escape_string(targetPlayerName)

					exports.logs:dbLog(thePlayer, 4, tplayer, commandName .. " GCs: " .. donPoints .. " Reason: " .. reasonStr)
					--exports.global:sendMessageToAdmins("[GAMECOINS] " .. playerName .. " deu "..donPoints.." GC para "..targetNameFull..".")
					--exports.global:sendMessageToAdmins("[GAMECOINS] Razão: "..reasonStr..".")
				else
					outputChatBox("Este jogador não está logado.", thePlayer)
				end
			else
				outputChatBox("Algo deu errado ao escolher o jogador.", thePlayer)
			end
		end
	end
end
addCommandHandler("givegc", givedonPoint, false, false)
addCommandHandler("givegamecoins", givedonPoint, false, false)
addCommandHandler("givegamecoin", givedonPoint, false, false)
