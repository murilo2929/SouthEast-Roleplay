----------------------[PRISÂO]--------------------
function jailPlayer(thePlayer, commandName, who, minutes, ...)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		local minutes = tonumber(minutes) and math.ceil(tonumber(minutes))
		if not (who) or not (minutes) or not (...) or (minutes<1) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Player/ID] [Minutos(>=1) 999=Perm] [Razão]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, who)
			local reason = table.concat({...}, " ")

			if (targetPlayer) then
				local playerName = getPlayerName(thePlayer)
				local jailTimer = getElementData(targetPlayer, "jailtimer")
				local accountID = getElementData(targetPlayer, "account:id")

				if isTimer(jailTimer) then
					killTimer(jailTimer)
				end

				if (isPedInVehicle(targetPlayer)) then
					exports.anticheat:changeProtectedElementDataEx(targetPlayer, "realinvehicle", 0, false)
					removePedFromVehicle(targetPlayer)
				end
				detachElements(targetPlayer)

				if (minutes>=999) then
					mysql:query_free("UPDATE account_details SET adminjail='1', adminjail_time='" .. mysql:escape_string(minutes) .. "', adminjail_permanent='1', adminjail_by='" .. mysql:escape_string(playerName) .. "', adminjail_reason='" .. mysql:escape_string(reason) .. "' WHERE account_id='" .. mysql:escape_string(accountID) .. "'")
					--dbExec(exports.mysql:getConn("mta"), "UPDATE `account_details` SET `adminjail`= ? `adminjail_time`=? `adminjail_permanent`=? `adminjail_by`=? `adminjail_reason`=? WHERE `id`=?", 1, mysql:escape_string(minutes), 1, mysql:escape_string(playerName), mysql:escape_string(reason), mysql:escape_string(accountID))
					minutes = "indefinido."
					exports.anticheat:changeProtectedElementDataEx(targetPlayer, "jailtimer", true, false)
				else
					mysql:query_free("UPDATE account_details SET adminjail='1', adminjail_time='" .. mysql:escape_string(minutes) .. "', adminjail_permanent='0', adminjail_by='" .. mysql:escape_string(playerName) .. "', adminjail_reason='" .. mysql:escape_string(reason) .. "' WHERE account_id='" .. mysql:escape_string(tonumber(accountID)) .. "'")
					--dbExec(exports.mysql:getConn("mta"), "UPDATE `account_details` SET `adminjail`= ? `adminjail_time`=? `adminjail_permanent`=? `adminjail_by`=? `adminjail_reason`=? WHERE `id`=?", 1, mysql:escape_string(minutes), 0, mysql:escape_string(playerName), mysql:escape_string(reason), mysql:escape_string(accountID))
					local theTimer = setTimer(timerUnjailPlayer, 60000, 1, targetPlayer)
					setElementData(targetPlayer, "jailtimer", theTimer, false)
					exports.anticheat:changeProtectedElementDataEx(targetPlayer, "jailserved", 0, false)
					exports.anticheat:changeProtectedElementDataEx(targetPlayer, "jailtimer", theTimer, false)
				end
				exports.anticheat:changeProtectedElementDataEx(targetPlayer, "adminjailed", true, false)
				exports.anticheat:changeProtectedElementDataEx(targetPlayer, "jailreason", reason, false)
				exports.anticheat:changeProtectedElementDataEx(targetPlayer, "jailtime", minutes, false)
				exports.anticheat:changeProtectedElementDataEx(targetPlayer, "jailadmin", getPlayerName(thePlayer), false)

				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

				addAdminHistory(targetPlayer, thePlayer, reason, 0 , (tonumber(minutes) and ( minutes == 999 and 0 or minutes ) or 0))

				local adminTitle = exports.global:getAdminTitle1(thePlayer)
				if (hiddenAdmin==1) then
					adminTitle = "Admin OCULTO"
				end

				if commandName == "sjail" then
					if tonumber(minutes) then
						exports.global:sendMessageToAdmins("[ADMIN-JAIL-SILENCED]: " .. adminTitle .. " prendeu " .. targetPlayerName .. " por " .. minutes .. " minuto(s).")
						exports.global:sendMessageToAdmins("[ADMIN-JAIL-SILENCED]: Razão: " .. reason)
						exports.logs:dbLog(thePlayer, 4, targetPlayer,commandName.." por "..minutes.." mins, Razão: "..reason)
					else
						exports.global:sendMessageToAdmins("[ADMIN-JAIL-SILENCED]: " .. adminTitle .. " prendeu " .. targetPlayerName .. " "..minutes..".")
						exports.global:sendMessageToAdmins("[ADMIN-JAIL-SILENCED]: Razão: " .. reason)
						exports.logs:dbLog(thePlayer, 4, targetPlayer,commandName.." "..minutes..", Razão: "..reason)
					end
				else
					for index, player in pairs( getElementsByType("player")) do
						if tonumber( getElementData( player, "punishment_notification_selector") ) ~= 1 or player == thePlayer or player == targetPlayer then
							if tonumber(minutes) then
								outputChatBox("AdmCmd: " .. adminTitle .. " prendeu " .. targetPlayerName .. " na prisão administrativa por " .. minutes .. " minuto(s) pelo motivo: " .. reason..".", player, 252, 115, 87)
								--outputChatBox("AdmCmd: Motivo: " .. reason, player, 255, 0, 0)
							else
								outputChatBox("AdmCmd: " .. adminTitle .. " prendeu " .. targetPlayerName .. " na prisão administrativa por "..minutes.." pelo motivo: " ..reason.. ".", player, 252, 115, 87)
								--outputChatBox("AdmCmd: Motivo: " .. reason, player, 255, 0, 0)
							end
						end
					end
					exports.logs:dbLog(thePlayer, 4, targetPlayer,commandName.." por "..minutes.." mins, Razão: "..reason)
					exports.serp_logsDiscord:adminlogsMessage(playerName.. " deu /ajail em ".. targetPlayerName .." por "..minutes.." minuto(s), Razão: "..reason)
				end


				setElementDimension(targetPlayer, 65400+getElementData(targetPlayer, "playerid"))
				setElementInterior(targetPlayer, 6)
				setCameraInterior(targetPlayer, 6)
				setElementPosition(targetPlayer, 263.821807, 77.848365, 1001.0390625)
				setPedRotation(targetPlayer, 267.438446)

				toggleControl(targetPlayer,'next_weapon',false)
				toggleControl(targetPlayer,'previous_weapon',false)
				toggleControl(targetPlayer,'fire',false)
				toggleControl(targetPlayer,'aim_weapon',false)
				setPedWeaponSlot(targetPlayer,0)

			end
		end
	end
end
addCommandHandler("ajail", jailPlayer, false, false)
--addCommandHandler("sjail", jailPlayer, false, false)

--OFFLINE JAIL BY MAXIME--------------------
function offlineJailPlayer(thePlayer, commandName, who, minutes, ...)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		local minutes = tonumber(minutes) and math.ceil(tonumber(minutes))
		if not (who) or not (minutes) or not (...) or (minutes<1) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Usuario Exato] [Minutos(>=1) 999=Perm] [Razão]", thePlayer, 255, 194, 14)
		else
			-- If player is still online
			local reason = table.concat({...}, " ")
			local onlinePlayers = getElementsByType("player")
			for _, player in ipairs(onlinePlayers) do
				if who:lower() == getElementData(player, "account:username"):lower() then
					local commandNameTemp = "jail"
					if commandName:lower() == "sojail" then
						commandNameTemp = "sjail"
					end
					jailPlayer(thePlayer, commandNameTemp, getPlayerName(player):gsub(" ", "_"), minutes, reason)
					return true
				end
			end
			-- if player is acutally offline.
			local row = mysql:query_fetch_assoc("SELECT `id`, `username`, `mtaserial`, `admin` FROM `accounts` WHERE `username`='".. mysql:escape_string( who ) .."' LIMIT 1")
			--local row = dbQuery(exports.mysql:getConn("core"), "SELECT `id`,`username`, `mtaserial`, `admin` FROM `accounts` WHERE `username`=? LIMIT 1",  mysql:escape_string( who ))
			local accountID = false
			local accountUsername = false
			if row and row.id ~= mysql_null() then
				accountID = row["id"]
				accountUsername = row["username"]
			else
				outputChatBox("Usuario não encontrado!", thePlayer, 255, 0, 0)
				return false
			end

			local playerName = getPlayerName(thePlayer)

			if (minutes>=999) then
				mysql:query_free("UPDATE account_details SET adminjail='1', adminjail_time='" .. mysql:escape_string(minutes) .. "', adminjail_permanent='1', adminjail_by='" .. mysql:escape_string(playerName) .. "', adminjail_reason='" .. mysql:escape_string(reason) .. "' WHERE account_id='" .. mysql:escape_string(accountID) .. "'")
				--dbExec(exports.mysql:getConn("mta"), "UPDATE `account_details` SET `adminjail`= ? `adminjail_time`=? `adminjail_permanent`=? `adminjail_by`=? `adminjail_reason`=? WHERE `id`=?", 1, mysql:escape_string(minutes), 1, mysql:escape_string(playerName), mysql:escape_string(reason), mysql:escape_string(accountID))
				minutes = 9999999
				minutesString = "indefinido."
			else
				mysql:query_free("UPDATE account_details SET adminjail='1', adminjail_time='" .. mysql:escape_string(minutes) .. "', adminjail_permanent='0', adminjail_by='" .. mysql:escape_string(playerName) .. "', adminjail_reason='" .. mysql:escape_string(reason) .. "' WHERE account_id='" .. mysql:escape_string(tonumber(accountID)) .. "'")
				--dbExec(exports.mysql:getConn("mta"), "UPDATE `account_details` SET `adminjail`= ? `adminjail_time`=? `adminjail_permanent`=? `adminjail_by`=? `adminjail_reason`=? WHERE `id`=?", 1, mysql:escape_string(minutes), 0, mysql:escape_string(playerName), mysql:escape_string(reason), mysql:escape_string(accountID))
				minutesString = minutes .. " minuto(s)."
			end

			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			addAdminHistory(accountID, thePlayer, reason, 0 , (tonumber(minutes) and ( minutes == 999 and 0 or minutes ) or 0))

			local adminTitle = exports.global:getAdminTitle1(thePlayer)
			if (hiddenAdmin==1) then
				adminTitle = "Hidden admin"
			end

			if commandName == "sojail" then
				exports.global:sendMessageToAdmins("[ADMIN-JAIL-SILENCED]: " .. adminTitle .. " prendeu " .. accountUsername .. " por " .. minutesString)
				exports.global:sendMessageToAdmins("[ADMIN-JAIL-SILENCED]: Razão: " .. reason)
			else
				outputChatBox("[ADMIN-JAIL]: " .. adminTitle .. " prendeu " .. accountUsername .. " por " .. minutesString, root, 255, 0, 0)
				outputChatBox("[ADMIN-JAIL]: Razão: " .. reason, root, 255, 0, 0)
			end
			exports.logs:dbLog(thePlayer, 4, thePlayer,commandName.." "..accountUsername.." por "..minutes.." mins, Razão: "..reason)
			exports.serp_logsDiscord:adminlogsMessage(playerName.. " deu /ojail em "..accountUsername.." por "..minutes.." minuto(s), Razão: "..reason)
			exports.announcement:makePlayerNotification(accountID, "Você recebeu uma sentença de prisão por "..exports.global:getPlayerFullIdentity(thePlayer, 1, true)..".", "Razão: "..reason)
		end
	end
end
addCommandHandler("ojail", offlineJailPlayer, false, false)
--addCommandHandler("sojail", offlineJailPlayer, false, false)

function timerUnjailPlayer(jailedPlayer)
	if(isElement(jailedPlayer)) then
		local timeServed = getElementData(jailedPlayer, "jailserved")
		local timeLeft = getElementData(jailedPlayer, "jailtime")
		local accountID = getElementData(jailedPlayer, "account:id")
		if (timeServed) then
			exports.anticheat:changeProtectedElementDataEx(jailedPlayer, "jailserved", timeServed+1, false)
			local timeLeft = timeLeft - 1
			exports.anticheat:changeProtectedElementDataEx(jailedPlayer, "jailtime", timeLeft, false)

			if (timeLeft<=0) and not (getElementData(jailedPlayer, "pd.jailtime")) then
				local query = mysql:query_free("UPDATE account_details SET adminjail_time='0', adminjail='0' WHERE account_id='" .. mysql:escape_string(accountID) .. "'")
				--local query = dbExec(exports.mysql:getConn("mta"), "UPDATE `account_details` SET `adminjail_time`=? `adminjail`= ? WHERE `id`=?", 0, 0, mysql:escape_string(accountID))
				exports.anticheat:changeProtectedElementDataEx(jailedPlayer, "jailtimer", false, false)
				exports.anticheat:changeProtectedElementDataEx(jailedPlayer, "adminjailed", false, false)
				exports.anticheat:changeProtectedElementDataEx(jailedPlayer, "jailreason", false, false)
				exports.anticheat:changeProtectedElementDataEx(jailedPlayer, "jailtime", false, false)
				exports.anticheat:changeProtectedElementDataEx(jailedPlayer, "jailadmin", false, false)
				if not getElementData(jailedPlayer, "jailed") then
					setElementPosition(jailedPlayer, 1520.2783203125, -1700.9189453125, 13.546875)
					setPedRotation(jailedPlayer, 303)
					setElementDimension(jailedPlayer, 0)
					setElementInterior(jailedPlayer, 0)
					setCameraInterior(jailedPlayer, 0)
				else
					exports["prison-system"]:checkForRelease(jailedPlayer)
				end
				toggleControl(jailedPlayer,'next_weapon',true)
				toggleControl(jailedPlayer,'previous_weapon',true)
				toggleControl(jailedPlayer,'fire',true)
				toggleControl(jailedPlayer,'aim_weapon',true)
				outputChatBox("Sua hora foi cumprida, comporte-se da próxima vez!", jailedPlayer, 0, 255, 0)

				local gender = getElementData(jailedPlayer, "gender")
				local genderm = "seu"
				if (gender == 1) then
					genderm = "seu"
				end
				exports.global:sendMessageToAdmins("[PRISÂO]: " .. getPlayerName(jailedPlayer):gsub("_", " ") .. " serviu " .. genderm .. " tempo de prisão.")
				--triggerClientEvent(jailedPlayer, "updateAdminJailCounter", jailedPlayer, nil)
			else
				local query = mysql:query_free("UPDATE account_details SET adminjail_time='" .. mysql:escape_string(timeLeft) .. "' WHERE account_id='" .. mysql:escape_string(accountID) .. "'")
				--local query = dbExec(exports.mysql:getConn("mta"), "UPDATE `account_details` SET `adminjail_time`=? WHERE `id`=?", mysql:escape_string(timeLeft), mysql:escape_string(accountID))
				local theTimer = setTimer(timerUnjailPlayer, 60000, 1, jailedPlayer)
				setElementData(jailedPlayer, "jailtimer", theTimer, false)
				local jailCounter = {}
				jailCounter.minutesleft = timeLeft
				jailCounter.reason = getElementData(jailedPlayer, "jailreason")
				jailCounter.admin = getElementData(jailedPlayer, "jailadmin")
				--triggerClientEvent(jailedPlayer, "updateAdminJailCounter", jailedPlayer, jailCounter)
			end
		end
	end
end
addEvent("admin:timerUnjailPlayer", false)
addEventHandler("admin:timerUnjailPlayer", getRootElement(), timerUnjailPlayer)

function unjailPlayer(thePlayer, commandName, who)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (who) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Player/ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, who)
			local playerName = getPlayerName(thePlayer)

			if (targetPlayer) then
				local jailed = getElementData(targetPlayer, "jailtimer", nil)
				local username = getPlayerName(thePlayer)
				local accountID = getElementData(targetPlayer, "account:id")

				if not (jailed) then
					outputChatBox(targetPlayerName .. " não esta preso.", thePlayer, 255, 0, 0)
				else
					local query = mysql:query_free("UPDATE account_details SET adminjail_time='0', adminjail='0' WHERE account_id='" .. mysql:escape_string(accountID) .. "'")

					if isTimer(jailed) then
						killTimer(jailed)
					end
					exports.anticheat:changeProtectedElementDataEx(targetPlayer, "jailtimer", false, false)
					exports.anticheat:changeProtectedElementDataEx(targetPlayer, "adminjailed", false, false)
					exports.anticheat:changeProtectedElementDataEx(targetPlayer, "jailreason", false, false)
					exports.anticheat:changeProtectedElementDataEx(targetPlayer, "jailtime", false, false)
					exports.anticheat:changeProtectedElementDataEx(targetPlayer, "jailadmin", false, false)
					setElementPosition(targetPlayer, 1520.2783203125, -1700.9189453125, 13.546875)
					setPedRotation(targetPlayer, 303)
					setElementDimension(targetPlayer, 0)
					setCameraInterior(targetPlayer, 0)
					setElementInterior(targetPlayer, 0)
					toggleControl(targetPlayer,'next_weapon',true)
					toggleControl(targetPlayer,'previous_weapon',true)
					toggleControl(targetPlayer,'fire',true)
					toggleControl(targetPlayer,'aim_weapon',true)
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

					local adminTitle = exports.global:getAdminTitle1(thePlayer)
					if (hiddenAdmin==1) then
						adminTitle = "Admin OCULTO"
					end

					outputChatBox("Você foi solto por "..adminTitle..", comporte-se da próxima vez!", targetPlayer, 0, 255, 0)
					exports.global:sendMessageToAdmins("AdmCmd: " .. targetPlayerName .. " foi solto por "..adminTitle..".")
					exports.serp_logsDiscord:adminlogsMessage(playerName.. " deu /unjail em ".. targetPlayerName)
					exports.logs:dbLog(thePlayer, 4, targetPlayerName,commandName)
				end
			end
		end
	end
end
addCommandHandler("unjail", unjailPlayer, false, false)
addCommandHandler("adminsoltar", unjailPlayer, false, false)


function jailedPlayers(thePlayer, commandName)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		outputChatBox("----- Preso -----", thePlayer, 255, 194, 15)
		local players = exports.pool:getPoolElementsByType("player")
		local count = 0
		for key, value in ipairs(players) do
			if getElementData(value, "adminjailed") then
				if tonumber(getElementData(value, "jailtime")) then
					outputChatBox("[PRISÂO] " .. getPlayerName(value) .. ", preso por " .. tostring(getElementData(value, "jailadmin")) .. ", serviu " .. tostring(getElementData(value, "jailserved")) .. " minutos, " .. tostring(getElementData(value,"jailtime")) .. " minutos restantes", thePlayer, 255, 194, 15)
					outputChatBox("[PRISÂO] Razão: " .. tostring(getElementData(value, "jailreason")), thePlayer, 255, 194, 15)
				else
					outputChatBox("[PRISÂO] " .. getPlayerName(value) .. ", preso por " .. tostring(getElementData(value, "jailadmin")) .. ", permanente,", thePlayer, 255, 194, 15)
					outputChatBox("[PRISÂO] Razão: " .. tostring(getElementData(value, "jailreason")), thePlayer, 255, 194, 15)
				end
				count = count + 1
			elseif getElementData(value, "jailed") then
				outputChatBox("[PRESO] ".. getPlayerName(value).. " || Cela:"..getElementData(value, "jail:cell").." || Prisioneiro ID:".. tostring(getElementData(value, "jail:id")) .." || Use /prender para mais infos.", thePlayer, 0, 102, 255)
				count = count + 1
			end
		end

		if count == 0 then
			outputChatBox("Não há ninguém preso.", thePlayer, 255, 194, 15)
		end
	end
end
addCommandHandler("jailed", jailedPlayers, false, false)
addCommandHandler("presos", jailedPlayers, false, false)
