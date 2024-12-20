function marry(thePlayer, commandName, player1, player2)
	if exports.integration:isPlayerAdmin(thePlayer) then
		if not player1 or not player2 then
			outputChatBox( "SYNTAX: /" .. commandName .. " [player] [player]", thePlayer, 255, 194, 14 )
		else
			local player1, player1name = exports.global:findPlayerByPartialNick( thePlayer, player1 )
			if player1 then
				local player2, player2name = exports.global:findPlayerByPartialNick( thePlayer, player2 )
				if player2 then
					-- check if one of the players is already married
					local p1r = mysql:query_fetch_assoc("SELECT COUNT(*) as numbr FROM characters WHERE marriedto = " .. mysql:escape_string(getElementData( player1, "dbid" )) )
					if p1r then
						if tonumber( p1r["numbr"] ) == 0 then
							local p2r = mysql:query_fetch_assoc("SELECT COUNT(*) as numbr FROM characters WHERE marriedto = " .. mysql:escape_string(getElementData( player2, "dbid" )) )
							if p2r then
								if tonumber( p2r["numbr"] ) == 0 then
									mysql:query_free("UPDATE characters SET marriedto = " .. mysql:escape_string(getElementData( player1, "dbid" )) .. " WHERE id = " .. mysql:escape_string(getElementData( player2, "dbid" )) )
									mysql:query_free("UPDATE characters SET marriedto = " .. mysql:escape_string(getElementData( player2, "dbid" )) .. " WHERE id = " .. mysql:escape_string(getElementData( player1, "dbid" )) ) 
									
									outputChatBox( "Agora você é casado com " .. player2name .. ".", player1, 0, 255, 0 )
									outputChatBox( "Agora você é casado com " .. player1name .. ".", player2, 0, 255, 0 )
									
									exports['cache']:clearCharacterName( getElementData( player1, "dbid" ) )
									exports['cache']:clearCharacterName( getElementData( player2, "dbid" ) )
									
									outputChatBox( player1name .. " e " .. player2name .. " agora estão casados.", thePlayer, 255, 194, 14 )
								else
									outputChatBox( player2name .. " ja é casado.", thePlayer, 255, 0, 0 )
								end
							end
						else
							outputChatBox( player1name .. " ja é casado.", thePlayer, 255, 0, 0 )
						end
					end
				end
			end
		end
	end
end
addCommandHandler("marry", marry)
addCommandHandler("casar", marry)


function divorce(thePlayer, commandName, targetPlayer)
	if exports.integration:isPlayerAdmin(thePlayer) then
		if not targetPlayer then
			outputChatBox( "SYNTAX: /" .. commandName .. " [player]", thePlayer, 255, 194, 14 )
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick( thePlayer, targetPlayer )
			if targetPlayer then
				local marriedto = mysql:query_fetch_assoc("SELECT marriedto FROM characters WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
				if marriedto then
					local to = tonumber( marriedto["marriedto"] )
					if to > 0 then
						mysql:query_free("UPDATE characters SET marriedto = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
						mysql:query_free("UPDATE characters SET marriedto = 0 WHERE marriedto = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
						
						exports['cache']:clearCharacterName( getElementData( targetPlayer, "dbid" ) )
						exports['cache']:clearCharacterName( to )
						
						outputChatBox( targetPlayerName .. " agora está divorciado.", thePlayer, 0, 255, 0 )
					else
						outputChatBox( targetPlayerName .. " não é casado com ninguém.", thePlayer, 255, 194, 14 )
					end
				end
			end
		end
	end
end
addCommandHandler("divorce", divorce)
addCommandHandler("divorciar", divorce)