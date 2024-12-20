local punishments = {
	-- [number of points] = {hours} (0 = infinite)
	[2] = {1},
	[4] = {6},
	[6] = {12},
	[8] = {24},
	[10] = {48},
	[12] = {72},
	[14] = {96},
	[16] = {120},
	[18] = {144},
	[20] = {0}
}

function punishPlayer(thePlayer, commandName, target, points, repetitive, ...)
	if exports.integration:isPlayerTrialAdmin( thePlayer ) then
		-- Start the command usage check
		if not points or not target or not repetitive or not (...) then
			outputChatBox("SYNTAX: /"..commandName.." [Nome Parcial Jogador/ID] [Pontos] [Ofensa Repetida = 1, Não = 0] [Razão]", thePlayer, 255, 194, 14)
			return
		end

		if not tonumber(points) or tonumber(points) <= 0 or math.floor(tonumber(points)) ~= tonumber(points) then
			outputChatBox("Error: Os pontos devem ser um número inteiro positivo (ex: 2, 4).", thePlayer, 255, 0, 0)
			return
		end

		local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
		if not targetPlayer then
			return
		end

		if exports.integration:isPlayerTrialAdmin(targetPlayer) and not exports.integration:isPlayerHeadAdmin(thePlayer) then
			outputChatBox("AVISO: Você não pode emitir pontos para um administrador, a menos que seja um administrador principal.", thePlayer, 255, 0, 0)
			return
		end

		local repeated = tonumber(repetitive)
		if repeated == 1 or repeated == 0 then
			-- all good
		else
			outputChatBox("Error: A ofensa repetida deve ser '1' para sim e '0' para não. Esta ação duplica o tempo de banimento.", thePlayer, 255, 0, 0)
			return
		end

		if not ... then
			outputChatBox("Error: Você deve fornecer um motivo.", thePlayer, 255, 0, 0)
			return
		end
		-- End command usage check

		local reason = table.concat({...}," ")
		local currentPoints = tonumber(getElementData(targetPlayer, "punishment:points"))

		if currentPoints == 0 or getElementData(targetPlayer, "punishment:date") == nil then
			local result2 = sqlSetDate(getElementData(targetPlayer, "account:id"))
			if not result2 then
				outputChatBox("ERROR: #PUNISH02 - LY discord", thePlayer, 255, 0, 0)
			end
		elseif currentPoints > 0 then
			currentPoints = checkExpiration(targetPlayer)
		end

		exports.anticheat:changeProtectedElementDataEx(targetPlayer, "punishment:points", tonumber(points) + tonumber(currentPoints), true) -- update element data

		local result = sqlAddPoints(thePlayer, getElementData(targetPlayer, "account:id"), tonumber(points) + tonumber(currentPoints)) -- update sql as well!
		if not result then outputChatBox("Oops! Algo deu errado!", thePlayer, 255, 0, 0) end

		-- Tell the world
		local adminTitle = exports.global:getAdminTitle1(thePlayer)
		if commandName == "spunish" then
			exports.global:sendMessageToAdmins("[PUNISH-SILENCED]: "..adminTitle.." definiu "..points.." pontos para "..targetPlayerName..".")
			exports.global:sendMessageToAdmins("[PUNISH-SILENCED]: Razão: " .. reason)
			outputChatBox("[PUNISH-SILENCED]: "..adminTitle.." definiu "..points.." pontos para "..targetPlayerName..".", targetPlayer, 255, 0, 0)
			outputChatBox("[PUNISH-SILENCED]: Razão: " .. reason, targetPlayer, 255, 0, 0)
		else
			for index, player in pairs( exports.pool:getPoolElementsByType("player")) do
				if tonumber( getElementData( player, "punishment_notification_selector") ) ~= 1 or player == thePlayer or player == targetPlayer then
					outputChatBox("[PUNISH]: "..adminTitle.." definiu "..points.." pontos para "..targetPlayerName..".", player, 255, 0, 0)
					outputChatBox("[PUNISH]: Razão: " .. reason, player, 255, 0, 0)
				end
			end
		end

		exports.logs:dbLog(thePlayer, 4, targetPlayer, commandName.." definiu "..points.." pontos, Razão: "..reason)
		addAdminHistory(targetPlayer, thePlayer, reason, 8, points)
		executePunishment(thePlayer, targetPlayer, reason, repeated, nil, nil, nil, getElementData(targetPlayer, "account:username"))
	end
end
addCommandHandler("punish", punishPlayer)
addCommandHandler("spunish", punishPlayer)
addCommandHandler("punir", punishPlayer)

function offlinePunishPlayer(thePlayer, commandName, target, points, repetitive, ...)
	if exports.integration:isPlayerTrialAdmin( thePlayer ) then
		-- Start the command usage check
		if not points or not target or not repetitive or not (...) then
			outputChatBox("SYNTAX: /"..commandName.." [Usuario Exato] [Pontos] [Ofensa Repetida = 1, Não = 0] [Razão]", thePlayer, 255, 194, 14)
			return
		end

		if not tonumber(points) or tonumber(points) <= 0 or math.floor(tonumber(points)) ~= tonumber(points) then
			outputChatBox("Error: Os pontos devem ser um número inteiro positivo (ex: 2, 4).", thePlayer, 255, 0, 0)
			return
		end

		local repeated = tonumber(repetitive)
		if repeated == 1 or repeated == 0 then
			-- all good
		else
			outputChatBox("Error: A ofensa repetida deve ser '1' para sim e '0' para não. Esta ação duplica o tempo de banimento.", thePlayer, 255, 0, 0)
			return
		end

		if not ... then
			outputChatBox("Error: Você deve fornecer um motivo.", thePlayer, 255, 0, 0)
			return
		end
		-- End command usage check

		-- If player is still online
		local reason = table.concat({...}, " ")
		for _, player in ipairs(exports.pool:getPoolElementsByType("player")) do
			if tostring(target):lower() == tostring(getElementData(player, "account:username")):lower() then
				local commandNameTemp = "punish"
				if commandName:lower() == "sopunish" then
					commandNameTemp = "spunish"
				end
				punishPlayer(thePlayer, commandNameTemp, getPlayerName(player):gsub(" ", "_"), points, repetitive, reason)
				return true
			end
		end

		-- Otherwise actually offline
		local qh = dbQuery(exports.mysql:getConn('core'), "SELECT id, username, ip, punishdate, punishpoints FROM accounts WHERE `username`=? LIMIT 1", target)
		local result = dbPoll(qh, 10000)
		if result and #result > 0 then
			accID = result[1].id
			punishdate = result[1].punishdate
			punishpoints = result[1].punishpoints
			target = result[1].username
			ip = result[1].ip

			local qh2 = dbQuery(exports.mysql:getConn('mta'), "SELECT mtaserial FROM account_details WHERE `account_id`=? LIMIT 1", accID)
			local result2 = dbPoll(qh2, 1000)
			if result2 and #result2 > 0 then
				serial = result2[1].mtaserial
			end
		else
			outputChatBox("Error: Usuario não encontrado!", thePlayer, 255, 0, 0)
			return
		end

		local currentPoints = 0
		if punishdate == nil then
			local result2 = sqlSetDate(accID)
			if not result2 then
				outputChatBox("ERROR: #PUNISH02 - LY discord", thePlayer)
			end
		else
			currentPoints = checkExpiration(false, accID)
		end

		if not currentPoints then
			outputChatBox("ERROR: #PUNISH03 - LY discord", thePlayer, 255, 0, 0)
			return
		elseif currentPoints == 0 and punishdate ~= nil then -- If we didn't just do this above
			local result2 = sqlSetDate(accID)
			if not result2 then
				outputChatBox("ERROR: #PUNISH02 - LY discord", thePlayer, 255, 0, 0)
			end
		end

		local result = sqlAddPoints(thePlayer, accID, tonumber(points) + tonumber(currentPoints)) -- update sql as well!
		if not result then outputChatBox("Oops! Algo deu errado!", thePlayer, 255, 0, 0) end

		-- Tell the world
		local adminTitle = exports.global:getAdminTitle1(thePlayer)
		if commandName == "sopunish" then
			exports.global:sendMessageToAdmins("[OPUNISH-SILENCED]: "..adminTitle.." definiu "..points.." pontos para "..target..".")
			exports.global:sendMessageToAdmins("[OPUNISH-SILENCED]: Razão: " .. reason)
		else
			for index, player in pairs( exports.pool:getPoolElementsByType("player")) do
				if tonumber( getElementData( player, "punishment_notification_selector") ) ~= 1 or player == thePlayer then
					outputChatBox("[OPUNISH]: "..adminTitle.." definiu "..points.." pontos para "..target..".", player, 255, 0, 0)
					outputChatBox("[OPUNISH]: Razão: " .. reason, player, 255, 0, 0)
				end
			end
		end

		exports.logs:dbLog(thePlayer, 4, "ac"..accID, commandName.." definiu "..points.." pontos, Razão: "..reason)
		addAdminHistory(accID, thePlayer, reason, 8, points)
		executePunishment(thePlayer, accID, reason, repeated, tonumber(points) + tonumber(currentPoints), ip, serial, target)
	end
end
addCommandHandler("opunish", offlinePunishPlayer)
addCommandHandler("sopunish", offlinePunishPlayer)

function sqlAddPoints(player, accountID, newpoints)
	if tonumber(accountID) and tonumber(newpoints) and player then
		if dbExec( exports.mysql:getConn('core'), "UPDATE `accounts` SET `punishpoints`=? WHERE `id`=?", newpoints, accountID ) then
			return true
		end
	else
		outputChatBox("ERROR: #PUNISH01 - Contate um Administrador!", player)
		return false
	end
end

function sqlSetDate(accountID)
	if accountID then
		if dbExec( exports.mysql:getConn('core'), "UPDATE `accounts` SET `punishdate`=NOW() WHERE `id`=?", accountID ) then
			return true
		end
	else
		return false
	end
end

function makeForumThread(targetPlayerName, bannedUserName, hours, reason, adminUsername, banrecordId)
	local targetPlayerName = string.gsub(targetPlayerName,"_"," ")
	local adminUsername = string.gsub(adminUsername, "_", " ")
	local forumTitle = "("..bannedUserName..") "..targetPlayerName.." - "..hours
	local content = {
		{"Usuario Banido:", bannedUserName},
		{"Nome Personagem:", targetPlayerName},
		{"Banido Por:", adminUsername},
		{"Periodo:", hours},
		{"Razão:", reason}
	}

	triggerEvent("integration:createForumThread", resourceRoot, 61, forumTitle, content, banrecordId)
end

function executePunishment(admin, targetPlayer, reason, repeated, pointsum, ip, serial, username)
	if isElement(targetPlayer) then
		pointsum = getElementData(targetPlayer, "punishment:points")
		ip = getPlayerIP(targetPlayer)
		serial = getPlayerSerial(targetPlayer)
	end
	local hours = countBanHours(pointsum)
	if hours then
		if repeated == 1 then
			hours = hours*2
			addAdminHistory(targetPlayer, admin, "(REPETIDAS OFENSAR) Pontos de Punição Acumulados", 5, hours)
		else
			addAdminHistory(targetPlayer, admin, "Pontos de Punição Acumulados", 5, hours)
		end

		-- Check if already banned?
		if exports.bans:checkAccountBan((isElement(targetPlayer) and getElementData(targetPlayer, "account:id") or targetPlayer)) then
			outputChatBox("Este jogador já foi banido. Pontos foram adicionados, mas a proibição não foi ajustada. Use manualmente /unban e /oban.", admin)
		else
			local banID = exports.bans:addToBan(isElement(targetPlayer) and getElementData(targetPlayer, "account:id") or targetPlayer, serial, ip, getElementData(admin, "account:id"), reason, hours)

			if hours == 0 then
				makeForumThread((isElement(targetPlayer) and getPlayerName(targetPlayer) or "N/A"), username, (hours == 0 and "Permanente" or hours.." horas"), reason, getElementData(admin, "account:username"), banID)
			end

			if isElement(targetPlayer) then
				for index, player in pairs(exports.pool:getPoolElementsByType("player")) do
					if tonumber( getElementData( player, "punishment_notification_selector") ) ~= 1 or player == thePlayer or player == targetPlayer then
						outputChatBox("[PUNISH-BAN]: " .. exports.global:getPlayerFullIdentity(targetPlayer) .. " foi banido "..(hours == 0 and "Permanentemente" or "por "..hours.." horas")..".", player, 255, 0, 0)
					end
				end
				kickPlayer(targetPlayer, admin, "Banido por '"..reason.."' (".. (hours == 0 and "Permanente" or hours.." horas") .. ")")
			else
				for index, player in pairs(exports.pool:getPoolElementsByType("player")) do
					if tonumber( getElementData( player, "punishment_notification_selector") ) ~= 1 or player == thePlayer then
						outputChatBox("[OPUNISH-BAN]: " .. username .. " foi banido "..(hours == 0 and "Permanentemente" or "por "..hours.." horas")..".", player, 255, 0, 0)
					end
				end
			end
		end
	end
end

function countBanHours(points)
	if not tonumber(points) then return false end
	local p = tonumber(points)

	if punishments[p] then return punishments[p][1] end

	if p > 20 then
		return punishments[20][1] -- unlimited
	elseif p < 2 then
		return false -- dont ban
	elseif p > 2 and p < 20 then
		p = p - 1
		return punishments[p][1]
	else
		return false -- shouldn happen though
	end
end


function checkExpiration(thePlayer, accountID)
	if thePlayer and not accountID then
		accountID = getElementData(thePlayer, "account:id")
	end

	--local qh = dbQuery(exports.mysql:getConn('mta'), "SELECT id, punishpoints, punishdate, TIMESTAMPDIFF(DAY,punishdate,NOW()) AS date FROM accounts WHERE `id`=? AND TIMESTAMPDIFF(DAY,punishdate,NOW()) > 45 LIMIT 1", accountID)
	local qh = dbQuery(exports.mysql:getConn('core'), "SELECT id, punishpoints, punishdate, TIMESTAMPDIFF(DAY,punishdate,NOW()) AS date FROM accounts WHERE `id`=? LIMIT 1", accountID)
	local sqlHandler = dbPoll(qh, 10000)

	if sqlHandler and #sqlHandler > 0 and sqlHandler[1]['id'] then
		local date = tonumber(sqlHandler[1]['date']) or 0
		local toBeRemoved = math.floor(date / 45)
		if toBeRemoved >= 1 then
			local currentPoints = tonumber(sqlHandler[1].punishpoints)
			local newPointTotal = currentPoints - toBeRemoved
			if newPointTotal <= 0 then newPointTotal = 0 end
			dbExec( exports.mysql:getConn('core'), "UPDATE `accounts` SET `punishpoints`=?, `punishdate`=DATE_ADD(punishdate, INTERVAL ? DAY) WHERE `id`=?", newPointTotal, tonumber(45*toBeRemoved), accountID )
			if thePlayer then
				exports.anticheat:changeProtectedElementDataEx(thePlayer, "punishment:points", tonumber(newPointTotal), true)
			end

			return newPointTotal
		else
			return tonumber(sqlHandler[1].punishpoints)
		end
	elseif sqlHandler then
		return 0
	else
		dbFree(qh)
		return false
	end
end
addEvent("points:checkexpiration", true)
addEventHandler("points:checkexpiration", root, checkExpiration)
