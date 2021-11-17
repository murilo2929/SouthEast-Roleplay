-- cells
local cells = { }
cells[1] = createColSphere( 2686.54, 1110.04, 1308.47, 2 ) --1 LSPD
cells[2] = createColSphere( 223.5, 114.7, 999.02, 2 ) --2 LSPD
cells[3] = createColSphere( 219.5, 114.7, 999.02, 2 ) --3 LSPD
cells[4] = createColSphere( 215.5, 114.7, 999.02, 2 ) --4 LSPD
	
cells[5] = createColSphere( 1796.53, -1555.8, 74.251564025879, 2 )
cells[6] = createColSphere( 1800.77, -1555.8, 74.251564025879, 2 )
cells[7] = createColSphere( 1805.0, -1555.8, 74.251564025879, 2 )
	
cells[8] = createColSphere( 1796.53, -1534.8, 74.251564025879, 2 )
cells[9] = createColSphere( 1800.77, -1534.8, 74.251564025879, 2 )
cells[10] = createColSphere( 1805.0, -1534.8, 74.251564025879, 2 )

cells[11] = createColSphere( 388.16015625, 56.1650390625, 1085.8579101563, 2 )
cells[12] = createColSphere( 383.890625, 55.94140625, 1085.8515625, 2 )
cells[13] = createColSphere( 379.560546875, 56.2958984375, 1085.8515625, 2 )

--[[cells[14] = createColSphere( 227.435546875, 114.3193359375, 999.015625, 2 )
cells[15] = createColSphere( )
cells[16] = createColSphere( )
cells[17] = createColSphere( )]]

for k, v in pairs( cells ) do
	if k == 1 then
		setElementData(v, "spawnoffset", -5, false)
		setElementInterior(v, 1)
		setElementDimension(v, 8)
	elseif k == 5 or k == 6 or k == 7 then
		setElementData(v, "spawnoffset", 4, false)
		setElementInterior(v, 3)
		setElementDimension(v, 87)
	elseif k == 8 or k == 9 or k == 10 then
		setElementData(v, "spawnoffset", -4, false)
		setElementInterior(v, 3)
		setElementDimension(v, 87)
	elseif k == 11 or k == 12 or k == 13 then
		setElementData(v, "spawnoffset", -4, false)
		setElementInterior(v, 3)
		setElementDimension(v, 63)
	else
		setElementData(v, "spawnoffset", -5, false)
		setElementInterior(v, 10)
		setElementDimension(v, 1)
	end
end

function isInArrestColshape( thePlayer )
	for k, v in pairs( cells ) do
		if isElementWithinColShape( thePlayer, v ) and getElementDimension( thePlayer ) == getElementDimension( v ) then
			return k
		end
	end
	return false
end

function destroyJailTimer ( ) -- 0001290: PD /release bug
	local theMagicTimer = getElementData(source, "jail:timer") -- 0001290: PD /release bug
	if (isTimer(theMagicTimer)) then
		killTimer(theMagicTimer) 
		exports['anticheat']:changeProtectedElementDataEx(source, "jail_time_online", 0, false)
		exports['anticheat']:changeProtectedElementDataEx(source, "jail_time", 0, false)
		exports['anticheat']:changeProtectedElementDataEx(source, "jail:timer", false, false)
		exports['anticheat']:changeProtectedElementDataEx(source, "pd.jailstation", false, false)
	end
end
addEventHandler ( "onPlayerQuit", getRootElement(), destroyJailTimer )

-- /arrest
function arrestPlayer(thePlayer, commandName, targetPlayerNick, fine, jailtime, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		
		if (jailtime) then
			jailtime = tonumber(jailtime)
		end
		
		local playerCol = isInArrestColshape(thePlayer)
		if exports.factions:isPlayerInFaction(thePlayer, 1) and playerCol then
			if not (targetPlayerNick) or not (fine) or not (jailtime) or not (...) or (jailtime<1) or (jailtime>30) then
				outputChatBox("SYNTAX: /prender [Nick Parcial Player / ID] [Multa] [Tempo Cadeia (Minutos 1->30)] [Crimes Cometidos]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
				
				if targetPlayer then
					local targetCol = isInArrestColshape(targetPlayer)
					
					if not targetCol then
						outputChatBox("O jogador não está dentro do alcance da cela.", thePlayer, 255, 0, 0)
					elseif targetCol ~= playerCol then
						outputChatBox("O jogador está na frente de outra cela.", thePlayer, 255, 0, 0)
					else
						local jailTimer = getElementData(targetPlayer, "jail:timer")
						local username  = getPlayerName(thePlayer)
						local reason = table.concat({...}, " ")
						
						if (jailTimer) then
							outputChatBox("Este jogador já está cumprindo uma sentença de prisão.", thePlayer, 255, 0, 0)
						else
							local finebank = false
							local targetPlayerhasmoney = exports.global:getMoney(targetPlayer, true)
							local amount = tonumber(fine)
							if not exports.global:takeMoney(targetPlayer, amount) then
								finebank = true
								exports.global:takeMoney(targetPlayer, targetPlayerhasmoney)
								local fineleft = amount - targetPlayerhasmoney
								local bankmoney = getElementData(targetPlayer, "bankmoney")
								exports['anticheat']:changeProtectedElementDataEx(targetPlayer, "bankmoney", bankmoney-fineleft, false)
							end
						
							exports['anticheat']:changeProtectedElementDataEx(targetPlayer, "jail_time_online", 0, false)
							exports['anticheat']:changeProtectedElementDataEx(targetPlayer, "jail_time", jailtime+1, false)
							
							
							toggleControl(targetPlayer,'next_weapon',false)
							toggleControl(targetPlayer,'previous_weapon',false)
							toggleControl(targetPlayer,'fire',false)
							toggleControl(targetPlayer,'aim_weapon',false)
							
							-- auto-uncuff
							local restrainedObj = getElementData(targetPlayer, "restrainedObj")
							if restrainedObj then
								toggleControl(targetPlayer, "sprint", true)
								toggleControl(targetPlayer, "jump", true)
								toggleControl(targetPlayer, "accelerate", true)
								toggleControl(targetPlayer, "brake_reverse", true)
								exports['anticheat']:changeProtectedElementDataEx(targetPlayer, "restrain", 0, true)
								exports['anticheat']:changeProtectedElementDataEx(targetPlayer, "restrainedBy", false, true)
								exports['anticheat']:changeProtectedElementDataEx(targetPlayer, "restrainedObj", false, true)
								if restrainedObj == 45 then -- If handcuffs.. take the key
									local dbid = getElementData(targetPlayer, "dbid")
									exports['item-system']:deleteAll(47, dbid)
								end
								exports.global:giveItem(thePlayer, restrainedObj, 1)
								mysql:query_free("UPDATE characters SET cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
							end
							setPedWeaponSlot(targetPlayer,0)
							toggleControl(targetPlayer,'next_weapon',false)
							toggleControl(targetPlayer,'previous_weapon',false)
							toggleControl(targetPlayer,'fire',false)
							toggleControl(targetPlayer,'aim_weapon',false)
							
							exports['anticheat']:changeProtectedElementDataEx(targetPlayer, "pd.jailstation", targetCol, false)
							
							mysql:query_free("UPDATE characters SET pdjail='1', pdjail_time='" .. mysql:escape_string(jailtime) .. "', pdjail_station='" .. mysql:escape_string(targetCol) .. "', cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
							outputChatBox("Você prendeu " .. targetPlayerNick .. " por " .. jailtime .. " Minuto(s).", thePlayer, 255, 0, 0)
							
							local x, y, z = getElementPosition(cells[targetCol])
							local offset = getElementData(cells[targetCol], "spawnoffset")
							setElementPosition(targetPlayer, 2692.9443359375, 1087.341796875, 1308.4709472656)
							setPedRotation(targetPlayer, 0)
							
							-- Show the message to the faction
							local theTeam = getPlayerTeam(thePlayer)
							local teamPlayers = getPlayersInTeam(theTeam)

							local factionID = getElementData(thePlayer, "faction")
							local factionRank = getElementData(thePlayer, "factionrank")
														
							local factionRanks = getElementData(theTeam, "ranks")
							local factionRankTitle = factionRanks[factionRank]
							
							outputChatBox("Você foi preso por " .. username .. " pelo tempo de " .. jailtime .. " minuto(s).", targetPlayer, 0, 102, 255)
							outputChatBox("Crimes Cometidos: " .. reason .. ".", targetPlayer, 0, 102, 255)
							if (finebank == true) then
								outputChatBox("O restante da multa foi retirado de sua conta bancária.", targetPlayer, 0, 102, 255)
							end
							
							for key, value in ipairs(teamPlayers) do
								outputChatBox(factionRankTitle .. " " .. username .. " prendeu " .. targetPlayerNick .. " por " .. jailtime .. " minuto(s).", value, 0, 102, 255)
								outputChatBox("Crimes Cometidos: " .. reason .. ".", value, 0, 102, 255)
							end
							timerPDUnjailPlayer(targetPlayer)
							setElementData (targetPlayer, "invincible", true)
							setElementData (targetPlayer, "preso", true)
							exports.logs:logMessage("[PD/PRISÂO] ".. factionRankTitle .. " " .. username .. " prendeu " .. targetPlayerNick .. " por " .. jailtime .. " minuto(s). Razão: "..reason , 30)
						end
					end
				end
			end
	     end
		
		if exports.factions:isPlayerInFaction(thePlayer, 87) and playerCol then -- FEDERAL
			if not (targetPlayerNick) or not (fine) or not (jailtime) or not (...) or (jailtime<1) or (jailtime>1441) then
				outputChatBox("SYNTAX: /prender [Nick Parcial Player / ID] [Multa] [Tempo Cadeia (Minutos 1->1441)] [Crimes Cometidos]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
				
				if targetPlayer then
					local targetCol = isInArrestColshape(targetPlayer)
					
					if not targetCol then
						outputChatBox("O jogador não está dentro do alcance da cela.", thePlayer, 255, 0, 0)
					elseif targetCol ~= playerCol then
						outputChatBox("O jogador está na frente de outra cela.", thePlayer, 255, 0, 0)
					else
						local jailTimer = getElementData(targetPlayer, "jail:timer")
						local username  = getPlayerName(thePlayer)
						local reason = table.concat({...}, " ")
						
						if (jailTimer) then
							outputChatBox("Este jogador já está cumprindo uma sentença de prisão.", thePlayer, 255, 0, 0)
						else
							local finebank = false
							local targetPlayerhasmoney = exports.global:getMoney(targetPlayer, true)
							local amount = tonumber(fine)
							if not exports.global:takeMoney(targetPlayer, amount) then
								finebank = true
								exports.global:takeMoney(targetPlayer, targetPlayerhasmoney)
								local fineleft = amount - targetPlayerhasmoney
								local bankmoney = getElementData(targetPlayer, "bankmoney")
								exports['anticheat']:changeProtectedElementDataEx(targetPlayer, "bankmoney", bankmoney-fineleft, false)
							end
						
							exports['anticheat']:changeProtectedElementDataEx(targetPlayer, "jail_time_online", 0, false)
							exports['anticheat']:changeProtectedElementDataEx(targetPlayer, "jail_time", jailtime+1, false)
							
							
							toggleControl(targetPlayer,'next_weapon',false)
							toggleControl(targetPlayer,'previous_weapon',false)
							toggleControl(targetPlayer,'fire',false)
							toggleControl(targetPlayer,'aim_weapon',false)
							
							-- auto-uncuff
							local restrainedObj = getElementData(targetPlayer, "restrainedObj")
							if restrainedObj then
								toggleControl(targetPlayer, "sprint", true)
								toggleControl(targetPlayer, "jump", true)
								toggleControl(targetPlayer, "accelerate", true)
								toggleControl(targetPlayer, "brake_reverse", true)
								exports['anticheat']:changeProtectedElementDataEx(targetPlayer, "restrain", 0, true)
								exports['anticheat']:changeProtectedElementDataEx(targetPlayer, "restrainedBy", false, true)
								exports['anticheat']:changeProtectedElementDataEx(targetPlayer, "restrainedObj", false, true)
								if restrainedObj == 45 then -- If handcuffs.. take the key
									local dbid = getElementData(targetPlayer, "dbid")
									exports['item-system']:deleteAll(47, dbid)
								end
								exports.global:giveItem(thePlayer, restrainedObj, 1)
								mysql:query_free("UPDATE characters SET cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
							end
							setPedWeaponSlot(targetPlayer,0)
							toggleControl(targetPlayer,'next_weapon',false)
							toggleControl(targetPlayer,'previous_weapon',false)
							toggleControl(targetPlayer,'fire',false)
							toggleControl(targetPlayer,'aim_weapon',false)
							
							exports['anticheat']:changeProtectedElementDataEx(targetPlayer, "pd.jailstation", targetCol, false)
							
							mysql:query_free("UPDATE characters SET pdjail='1', pdjail_time='" .. mysql:escape_string(jailtime) .. "', pdjail_station='" .. mysql:escape_string(targetCol) .. "', cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
							outputChatBox("Você prendeu " .. targetPlayerNick .. " por " .. jailtime .. " Minuto(s).", thePlayer, 255, 0, 0)
							
							local x, y, z = getElementPosition(cells[targetCol])
							local offset = getElementData(cells[targetCol], "spawnoffset")
							setElementPosition(targetPlayer, 2692.9443359375, 1087.341796875, 1308.4709472656)
							setPedRotation(targetPlayer, 0)
							
							-- Show the message to the faction
							local theTeam = getPlayerTeam(thePlayer)
							local teamPlayers = getPlayersInTeam(theTeam)

							local factionID = getElementData(thePlayer, "faction")
							local factionRank = getElementData(thePlayer, "factionrank")
														
							local factionRanks = getElementData(theTeam, "ranks")
							local factionRankTitle = factionRanks[factionRank]
							
							outputChatBox("Você foi preso por " .. username .. " pelo tempo de " .. jailtime .. " minuto(s).", targetPlayer, 0, 102, 255)
							outputChatBox("Crimes Cometidos: " .. reason .. ".", targetPlayer, 0, 102, 255)
							if (finebank == true) then
								outputChatBox("O restante da multa foi retirado de sua conta bancária.", targetPlayer, 0, 102, 255)
							end
							
							for key, value in ipairs(teamPlayers) do
								outputChatBox(factionRankTitle .. " " .. username .. " prendeu " .. targetPlayerNick .. " por " .. jailtime .. " minuto(s).", value, 0, 102, 255)
								outputChatBox("Crimes Cometidos: " .. reason .. ".", value, 0, 102, 255)
							end
							timerPDUnjailPlayer(targetPlayer)
							exports.logs:logMessage("[PD/PRISÂO] ".. factionRankTitle .. " " .. username .. " prendeu " .. targetPlayerNick .. " por " .. jailtime .. " minuto(s). Razão: "..reason , 30)
						end
					end
				end
			end
		end
	end
end
--addCommandHandler("prenderp", arrestPlayer)

function timerPDUnjailPlayer(jailedPlayer)
	if(isElement(jailedPlayer)) then
		local timeServed = tonumber(getElementData(jailedPlayer, "jail_time_online"))
		local timeLeft = getElementData(jailedPlayer, "jail_time")
		local username = getPlayerName(jailedPlayer)
		
		if ( timeServed ) then
			exports['anticheat']:changeProtectedElementDataEx(jailedPlayer, "jail_time_online", tonumber(timeServed)+1, false)
			local timeLeft = timeLeft - 1
			exports['anticheat']:changeProtectedElementDataEx(jailedPlayer, "jail_time", timeLeft, false)
			--setElementData (jailedPlayer, "invincible", false)

			if (timeLeft<=0) then
				theMagicTimer = nil
				--Fade disabled, being unneccesary and buggy
				--fadeCamera(jailedPlayer, false)
				if (getElementData(jailedPlayer, "pd.jailstation") <= 4) then
					-- LSPD
					mysql:query_free("UPDATE characters SET pdjail_time='0', pdjail='0', pdjail_station='0' WHERE id=" .. mysql:escape_string(getElementData(jailedPlayer, "dbid")))
					setElementDimension(jailedPlayer, 7)
					setElementInterior(jailedPlayer, 10)
					setCameraInterior(jailedPlayer, 10)
					setElementPosition(jailedPlayer, 240.4130859375, 114.70703125, 1003.21875)
					setPedRotation(jailedPlayer, 269)
				elseif (getElementData(jailedPlayer, "pd.jailstation") >= 11 and getElementData(jailedPlayer, "pd.jailstation") <= 13) then
					-- SASP
					mysql:query_free("UPDATE characters SET pdjail_time='0', pdjail='0', pdjail_station='0' WHERE id=" .. mysql:escape_string(getElementData(jailedPlayer, "dbid")))
					setElementDimension(jailedPlayer, 766)
					setElementInterior(jailedPlayer, 3)
					setCameraInterior(jailedPlayer, 3)
					setElementPosition(jailedPlayer, 354.7841796875, 137.9091796875, 1043.0075683594)
					setPedRotation(jailedPlayer, 239)
				else
					-- Prison
					mysql:query_free("UPDATE characters SET pdjail_time='0', pdjail='0', pdjail_station='0' WHERE id=" .. mysql:escape_string(getElementData(jailedPlayer, "dbid")))
					setElementDimension(jailedPlayer, 0)
					setElementInterior(jailedPlayer, 0)
					setCameraInterior(jailedPlayer, 0)
					setElementPosition(jailedPlayer, -1558.818359375, 1144.6630859375, 7.1845531463623)
					setPedRotation(jailedPlayer, 90)
				end
					
				exports['anticheat']:changeProtectedElementDataEx(jailedPlayer, "jail_time_online", 0, false)
				exports['anticheat']:changeProtectedElementDataEx(jailedPlayer, "jail_time", 0, false)
				exports['anticheat']:changeProtectedElementDataEx(jailedPlayer, "jail:timer", false, false)
				exports['anticheat']:changeProtectedElementDataEx(jailedPlayer, "pd.jailstation", false, false)
				
				--toggleControl(jailedPlayer,'next_weapon',true)
				--toggleControl(jailedPlayer,'previous_weapon',true)
				toggleControl(jailedPlayer,'fire',true)
				toggleControl(jailedPlayer,'aim_weapon',true)
				--Fade disabled, being unnecessary and buggy
				--fadeCamera(jailedPlayer, true)
				outputChatBox("Seu tempo foi cumprido.", jailedPlayer, 0, 255, 0)

			elseif (timeLeft>0) then
				mysql:query_free("UPDATE characters SET pdjail_time='" .. mysql:escape_string(timeLeft) .. "' WHERE id=" .. mysql:escape_string(getElementData(jailedPlayer, "dbid")))
				local theTimer = setTimer(timerPDUnjailPlayer, 60000, 1, jailedPlayer)
				exports['anticheat']:changeProtectedElementDataEx(jailedPlayer, "jail:timer", theTimer, false)
			end
		end
	end
end

-- 0000376: Fixed a bug for when you could only see admin jail time -Socialz 23/04/13
function showJailtime(thePlayer, commandName)
	local ajailtime = getElementData(thePlayer, "jailtime")
	if ajailtime then
		outputChatBox("Você tem " .. ajailtime .. " minuto(s) de prisão administrativa.", thePlayer, 255, 194, 14)
	else
		outputChatBox("Você não está preso na prisão de administrador.", thePlayer, 255, 0, 0)
	end
	
	local isJailed = getElementData(thePlayer, "jail:timer")
	if isJailed then
		local jailtime = getElementData(thePlayer, "jail_time")
		outputChatBox("Você tem " .. jailtime .. " minuto(s) de prisão.", thePlayer, 255, 194, 14)
	else
		outputChatBox("Você não esta preso.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("tempopreso", showJailtime, false, false)

function jailRelease(thePlayer, commandName, targetPlayerNick)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		local cargo = tonumber(getElementData(thePlayer, "factionrank"))
		
		if factionType == 2 and (cargo >= 14) and isInArrestColshape(thePlayer) or exports.integration:isPlayerAdmin(thePlayer) then
			if not (targetPlayerNick) then
				outputChatBox("SYNTAX: /soltar [Nome Parcial Player / ID]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
				
				if targetPlayer then
					local jailTimer = getElementData(targetPlayer, "jail:timer")
					local username  = getPlayerName(thePlayer)
						
					if (jailTimer) then
						exports['anticheat']:changeProtectedElementDataEx(targetPlayer, "jail_time", 1, false)
						timerPDUnjailPlayer(targetPlayer)
						exports.logs:logMessage("[PD/LIBERAÇÃO]" .. username .. " liberou "..targetPlayerNick , 30)
					else
						outputChatBox("Este jogador não está cumprindo uma sentença de prisão.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("soltar", jailRelease)