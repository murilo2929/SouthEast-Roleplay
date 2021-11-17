-- cells
local cells = { }
cells[1] = createColSphere( 2686.54, 1110.04, 1308.47, 2 ) --1 LSPD
cells[2] = createColSphere( 223.5, 114.7, 999.02, 2 ) --2 LSPD
cells[3] = createColSphere( 219.5, 114.7, 999.02, 2 ) --3 LSPD
cells[4] = createColSphere( 215.5, 114.7, 999.02, 2 ) --4 LSPD

cells[5] = createColSphere( 227.5, 114.7, 999.02, 2 ) --1 LSPD
cells[6] = createColSphere( 223.5, 114.7, 999.02, 2 ) --2 LSPD
cells[7] = createColSphere( 219.5, 114.7, 999.02, 2 ) --3 LSPD
cells[8] = createColSphere( 215.5, 114.7, 999.02, 2 ) --4 LSPD



for k, v in pairs( cells ) do
	if k == 1 then
		setElementData(v, "spawnoffset", -5, false)
		setElementInterior(v, 1)
		setElementDimension(v, 8)
	elseif k == 5 or k == 6 or k == 7 or k == 7 then
		setElementData(v, "spawnoffset", -5, false)
		setElementInterior(v, 10)
		setElementDimension(v, 18)
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
	local theMagicTimer = getElementData(source, "pd.jailtimer") -- 0001290: PD /release bug
	if (isTimer(theMagicTimer)) then
		killTimer(theMagicTimer)
		exports.anticheat:changeProtectedElementDataEx(source, "pd.jailserved", 0, false)
		exports.anticheat:changeProtectedElementDataEx(source, "pd.jailtime", 0, false)
		exports.anticheat:changeProtectedElementDataEx(source, "pd.jailtimer", false, false)
		exports.anticheat:changeProtectedElementDataEx(source, "pd.jailstation", false, false)
	end
end
addEventHandler ( "onPlayerQuit", getRootElement(), destroyJailTimer )

-- /arrest
function arrestPlayer(thePlayer, commandName, targetPlayerNick, fine, jailtime, ...)
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = exports.factions:isInFactionType(thePlayer, 2)

		if (jailtime) then
			jailtime = tonumber(jailtime)
		end

		local playerCol = isInArrestColshape(thePlayer)
		if factionType and playerCol then
			if not (targetPlayerNick) or not (fine) or not (jailtime) or not (...) or (jailtime<1) or (jailtime>20) then
				outputChatBox("SYNTAX: /prenderp [Nome Parcial Jogador / ID] [Multa] [Tempo Prisão (Minutos 1->20)] [Crimes Cometidos]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerNick)

				if targetPlayer then
					local targetCol = isInArrestColshape(targetPlayer)

					if not targetCol then
						outputChatBox("O jogador não está dentro do alcance do balcão de reservas.", thePlayer, 255, 0, 0)
					elseif targetCol ~= playerCol then
						outputChatBox("O jogador está na frente de outra cela.", thePlayer, 255, 0, 0)
					else
						local jailTimer = getElementData(targetPlayer, "pd.jailtimer")
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
								exports.anticheat:changeProtectedElementDataEx(targetPlayer, "bankmoney", bankmoney-fineleft, false)
							end

							exports.anticheat:changeProtectedElementDataEx(targetPlayer, "pd.jailserved", 0, false)
							exports.anticheat:changeProtectedElementDataEx(targetPlayer, "pd.jailtime", jailtime+1, false)

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
								exports.anticheat:changeProtectedElementDataEx(targetPlayer, "restrain", 0, true)
								exports.anticheat:changeProtectedElementDataEx(targetPlayer, "restrainedBy", false, true)
								exports.anticheat:changeProtectedElementDataEx(targetPlayer, "restrainedObj", false, true)
								if restrainedObj == 45 then -- If handcuffs.. take the key
									local dbid = getElementData(targetPlayer, "dbid")
									exports['item-system']:deleteAll(47, dbid)
								end
								exports.global:giveItem(thePlayer, restrainedObj, 1)
								mysql:query_free("UPDATE characters SET cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
							end
							setPedWeaponSlot(targetPlayer,0)

							exports.anticheat:changeProtectedElementDataEx(targetPlayer, "pd.jailstation", targetCol, false)

							mysql:query_free("UPDATE characters SET pdjail='1', pdjail_time='" .. mysql:escape_string(jailtime) .. "', pdjail_station='" .. mysql:escape_string(targetCol) .. "', cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
							outputChatBox("Você prendeu " .. targetPlayerNick .. " por " .. jailtime .. " Minutos.", thePlayer, 255, 0, 0)

							local x, y, z = getElementPosition(cells[targetCol])
							local offset = getElementData(cells[targetCol], "spawnoffset")

							--setElementPosition(targetPlayer, x, y + offset, z)
							--setPedRotation(targetPlayer, 0)
							setElementPosition(targetPlayer, 2692.9443359375, 1087.341796875, 1308.4709472656)
							setPedRotation(targetPlayer, 0)

							-- Show the message to the faction
							local theTeam = getPlayerTeam(thePlayer)
							local teamPlayers = getPlayersInTeam(theTeam)

							local factionID = getElementData(thePlayer, "faction")
							local factionRank = getElementData(thePlayer, "factionrank")

							local factionRanks = getElementData(theTeam, "ranks")
							local factionRankTitle = factionRanks[factionRank]

							outputChatBox("Você foi preso por " .. username .. " por " .. jailtime .. " minuto(s).", targetPlayer, 0, 102, 255)
							outputChatBox("Crimes cometidos: " .. reason .. ".", targetPlayer, 0, 102, 255)
							if (finebank == true) then
								outputChatBox("O restante da multa foi retirado de sua conta bancária.", targetPlayer, 0, 102, 255)
							end

							for key, value in ipairs(teamPlayers) do
								outputChatBox(factionRankTitle .. " " .. username .. " prendeu " .. targetPlayerNick .. " por " .. jailtime .. " minuto(s).", value, 0, 102, 255)
								outputChatBox("Crimes cometidos: " .. reason .. ".", value, 0, 102, 255)
							end
							timerPDUnjailPlayer(targetPlayer)
					end
				end
			end
		end
	end
end
end
addCommandHandler("prenderp", arrestPlayer)

function timerPDUnjailPlayer(jailedPlayer)
	if(isElement(jailedPlayer)) then
		local timeServed = tonumber(getElementData(jailedPlayer, "pd.jailserved"))
		local timeLeft = getElementData(jailedPlayer, "pd.jailtime")
		local username = getPlayerName(jailedPlayer)

		if ( timeServed ) then
			exports.anticheat:changeProtectedElementDataEx(jailedPlayer, "pd.jailserved", tonumber(timeServed)+1, false)
			local timeLeft = timeLeft - 1
			exports.anticheat:changeProtectedElementDataEx(jailedPlayer, "pd.jailtime", timeLeft, false)

			if (timeLeft<=0) then
				theMagicTimer = nil
				--Fade disabled, being unneccesary and buggy
				--fadeCamera(jailedPlayer, false)
				if (getElementData(jailedPlayer, "pd.jailstation") <= 4) and not (getElementData(jailedPlayer, "adminjailed")) then
					-- LSPD
					mysql:query_free("UPDATE characters SET pdjail_time='0', pdjail='0', pdjail_station='0' WHERE id=" .. mysql:escape_string(getElementData(jailedPlayer, "dbid")))
					setElementDimension(jailedPlayer, 1158)
					setElementInterior(jailedPlayer, 10)
					setCameraInterior(jailedPlayer, 10)
					setElementPosition(jailedPlayer, 240.4130859375, 114.70703125, 1003.21875)
					setPedRotation(jailedPlayer, 269)
				elseif (getElementData(jailedPlayer, "pd.jailstation") >= 5 and getElementData(jailedPlayer, "pd.jailstation") <= 8) then
					-- SASP
					mysql:query_free("UPDATE characters SET pdjail_time='0', pdjail='0', pdjail_station='0' WHERE id=" .. mysql:escape_string(getElementData(jailedPlayer, "dbid")))
					setElementDimension(jailedPlayer, 18)
					setElementInterior(jailedPlayer, 10)
					setCameraInterior(jailedPlayer, 10)
					setElementPosition(jailedPlayer, 240.880859375, 112.7431640625, 1003.21875)
					setPedRotation(jailedPlayer, 270)
				else
					-- Prison
					mysql:query_free("UPDATE characters SET pdjail_time='0', pdjail='0', pdjail_station='0' WHERE id=" .. mysql:escape_string(getElementData(jailedPlayer, "dbid")))
					setElementDimension(jailedPlayer, 0)
					setElementInterior(jailedPlayer, 0)
					setCameraInterior(jailedPlayer, 0)
					setElementPosition(jailedPlayer, -1558.818359375, 1144.6630859375, 7.1845531463623)
					setPedRotation(jailedPlayer, 90)
				end



				exports.anticheat:changeProtectedElementDataEx(jailedPlayer, "pd.jailserved", 0, false)
				exports.anticheat:changeProtectedElementDataEx(jailedPlayer, "pd.jailtime", 0, false)
				exports.anticheat:changeProtectedElementDataEx(jailedPlayer, "pd.jailtimer", false, false)
				exports.anticheat:changeProtectedElementDataEx(jailedPlayer, "pd.jailstation", false, false)

				toggleControl(jailedPlayer,'next_weapon',true)
				toggleControl(jailedPlayer,'previous_weapon',true)
				toggleControl(jailedPlayer,'fire',true)
				toggleControl(jailedPlayer,'aim_weapon',true)
				--Fade disabled, being unnecessary and buggy
				--fadeCamera(jailedPlayer, true)
				outputChatBox("Seu tempo foi cumprido.", jailedPlayer, 0, 255, 0)

			elseif (timeLeft>0) then
				mysql:query_free("UPDATE characters SET pdjail_time='" .. mysql:escape_string(timeLeft) .. "' WHERE id=" .. mysql:escape_string(getElementData(jailedPlayer, "dbid")))
				local theTimer = setTimer(timerPDUnjailPlayer, 60000, 1, jailedPlayer)
				exports.anticheat:changeProtectedElementDataEx(jailedPlayer, "pd.jailtimer", theTimer, false)
			end
		end
	end
end

-- 0000376: Fixed a bug for when you could only see admin jail time -Socialz 23/04/13
function showJailtime(thePlayer, commandName)
	local ajailtime = getElementData(thePlayer, "jailtime")
	if ajailtime then
		outputChatBox("Você tem " .. ajailtime .. " minutos restantes na sua prisão de administrador.", thePlayer, 255, 194, 14)
	else
		outputChatBox("Você não está preso na prisão de administrador.", thePlayer, 255, 0, 0)
	end

	local isJailed = getElementData(thePlayer, "pd.jailtimer")
	if isJailed then
		local jailtime = getElementData(thePlayer, "pd.jailtime")
		outputChatBox("Você tem " .. jailtime .. " minuto(s) de prisão.", thePlayer, 255, 194, 14)
	else
		outputChatBox("Você não esta preso.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("jailtime", showJailtime, false, false)
addCommandHandler("tempoprisao", showJailtime, false, false)

function jailRelease(thePlayer, commandName, targetPlayerNick)
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")

		if factionType == 2 and isInArrestColshape(thePlayer) or exports.integration:isPlayerTrialAdmin(thePlayer) and getElementData(thePlayer, "duty_admin") == 1 then
			if not (targetPlayerNick) then
				outputChatBox("SYNTAX: /soltar [Nome Parcial Jogador / ID]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerNick)

				if targetPlayer then
					local jailTimer = getElementData(targetPlayer, "pd.jailtimer")
					local username  = getPlayerName(thePlayer)

					if (jailTimer) then
						exports.anticheat:changeProtectedElementDataEx(targetPlayer, "pd.jailtime", 1, false)
						timerPDUnjailPlayer(targetPlayer)
					else
						outputChatBox("Este jogador não está cumprindo uma sentença de prisão.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("release", jailRelease)
addCommandHandler("soltar", jailRelease)
