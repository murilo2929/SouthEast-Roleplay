--MAXIME / 2014.12.29
-- BAN
local mysql = exports.mysql
local GeoIP = "http://www.freegeoip.net/json/" -- A GeoIP API
local lastBan = nil
local lastBanTimer = nil
function banAPlayer(thePlayer, commandName, targetPlayer, hours, ...)
	if exports["integration"]:isPlayerTrialAdmin(thePlayer) then
		if not (targetPlayer) or not (hours) or not tonumber(hours) or tonumber(hours)<0 or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID] [Tempo em Horas, 0 = Infinito] [Razão]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			local targetPlayerSerial = getPlayerSerial(targetPlayer)
			local targetPlayerIP = getPlayerIP(targetPlayer)
			hours = tonumber(hours)

			if not isElement(targetPlayer) then
				outputChatBox("Jogador não encontrado.", thePlayer, 255, 0, 0)
			elseif (hours>168) then
				outputChatBox("Você não pode banir por mais de 7 dias (168 Horas).", thePlayer, 255, 194, 14)
			else
				local thePlayerPower = exports.global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.global:getPlayerAdminLevel(targetPlayer)
				reason = table.concat({...}, " ")

				if (targetPlayerPower <= thePlayerPower) then -- Check the admin isn't banning someone higher rank them him
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local playerName = getPlayerName(thePlayer)
					local accountID = getElementData(targetPlayer, "account:id")
					local username = getElementData(targetPlayer, "account:username") or "N/A"

					local seconds = ((hours*60)*60)
					local rhours = hours
					-- text value
					if (hours==0) then
						hours = "Permanente"
					elseif (hours==1) then
						hours = "1 Hora"
					else
						hours = hours .. " Horas"
					end

					if hours == "Permanente" then
						reason = reason .. " (" .. hours .. ")"
					else
						reason = reason .. " (" .. hours .. ")"
					end


					exports['admin-system']:addAdminHistory(targetPlayer, thePlayer, reason, 2 , rhours)
					local banId = nil
					banId = addToBan(accountID, targetPlayerSerial, targetPlayerIP, getElementData(thePlayer, "account:id"), reason, rhours)
					if banId and tonumber(banId) then
						banQ = dbQuery(mysql:getConn("core"), "SELECT * FROM bans WHERE id=? LIMIT 1", banId)
						ban = dbPoll(banQ, 10000)
						if ban and #ban == 1 then
							lastBan = ban[1]
						else
							dbFree(banQ)
						end
						if lastBanTimer and isTimer(lastBanTimer) then
							killTimer(lastBanTimer)
							lastBanTimer = nil
						end
						lastBanTimer = setTimer(function()
							lastBan = nil
						end, 1000*60*5,1) --5 minutes
					end

					local adminUsername = getElementData(thePlayer, "account:username")
					local adminUserID = getElementData(thePlayer, "account:id")
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					--makeForumThread(targetPlayerName or "N/A", username, hours, reason, adminUsername, banId )
					for key, value in ipairs(getElementsByType("player")) do
						if getPlayerSerial(value) == targetPlayerSerial then
							kickPlayer(value, thePlayer, reason)
						end
					end

					adminTitle = exports.global:getAdminTitle1(thePlayer)
					if (hiddenAdmin==1) then
						adminTitle = "Um Admin Oculto"
					end

					if string.lower(commandName) == "sban" then
						exports.global:sendMessageToAdmins("[SILENT-BAN] " .. adminTitle .. " baniu silenciosamente " .. targetPlayerName .. ". (" .. hours .. ")")
						exports.global:sendMessageToAdmins("[SILENT-BAN] Razão: " .. reason .. ".")
					elseif string.lower(commandName) == "forceapp" then
						for index, player in pairs( getElementsByType("player")) do
							if tonumber( getElementData( player, "punishment_notification_selector") ) ~= 1 or player == thePlayer or player == targetPlayer then
								outputChatBox("[FA] "..adminTitle .. " " .. playerName .. " forced app " .. targetPlayerName .. ".", player, 255,0,0)
								hours = "Permanente"
								reason = "Falha em atender ao padrão do servidor."
								outputChatBox("[FA]: Razão: " .. reason .. "." ,player, 255,0,0)
							end
						end
					else
						for index, player in pairs( getElementsByType("player")) do
							if tonumber( getElementData( player, "punishment_notification_selector") ) ~= 1 or player == thePlayer or player == targetPlayer then
								outputChatBox("AdmCmd: " .. adminTitle .. " baniu o jogador " .. targetPlayerName .. ". (" .. hours .. ")", player, 252, 115, 87)
								outputChatBox("AdmCmd: Motivo: " .. reason .. ".", player, 252, 115, 87)
							end
						end
					end
					exports.global:sendMessageToAdmins("/mostrarban para detalhes.")
				else
					outputChatBox(" Este jogador é um administrador de nível superior do que você.", thePlayer, 255, 0, 0)
					outputChatBox(playerName .. " tentou executar o comando ban em você.", targetPlayer, 255, 0 ,0)
				end
			end
		end
	end
end
addCommandHandler("pban", banAPlayer, false, false)
--addCommandHandler("sban", banAPlayer, false, false)
addCommandHandler("banir", banAPlayer, false, false)

function makeForumThread(targetPlayerName, bannedUserName, hours, reason, adminUsername, banrecordId)
	local targetPlayerName = string.gsub(targetPlayerName,"_"," ")
	local adminUsername = string.gsub(adminUsername, "_", " ")
	local forumTitle = "("..bannedUserName..") "..targetPlayerName.." - "..hours
	local content = {
		{"Banned username:", bannedUserName},
		{"Character name:", targetPlayerName},
		{"Banned by:", adminUsername},
		{"Period:", hours},
		{"Razão:", reason}
	}

	triggerEvent("integration:createForumThread", resourceRoot, 61, forumTitle, content, banrecordId)
end

--OFFLINE BAN BY MAXIME
function offlineBanAPlayer(thePlayer, commandName, targetUsername, hours, ...)
	if exports.integration:isPlayerTrialAdmin(thePlayer) then
		if not (targetUsername) or not (hours) or not tonumber(hours) or (tonumber(hours)<0) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Usuario Jogador] [Tempo em Horas, 0 = Infinito] [Razão]", thePlayer, 255, 194, 14)
		else
			hours = tonumber(hours) or 0
			if (hours>168) then
				outputChatBox("Você não pode banir por mais de 7 dias (168 Horas).", thePlayer, 255, 194, 14)
				return false
			end
			local qh = dbQuery(mysql:getConn("core"), "SELECT * FROM `accounts` WHERE `username`=? LIMIT 1", targetUsername)
			local result = dbPoll(qh, 10000)
			if result and #result > 0 then
				local user = mysql:query_fetch_assoc("SELECT account_id as id, mtaserial FROM `account_details` WHERE `account_id`='".. mysql:escape_string( result[1].id ) .."' LIMIT 1")
				if user and user['id'] and tonumber(user['id']) then
					local banQ = dbQuery(mysql:getConn("core"), "SELECT * FROM bans WHERE account=? AND (until IS NULL OR until > NOW() ) LIMIT 1", result[1].id)
					local ban = dbPoll(banQ, 10000)
					if ban and #ban == 1 and ban[1]['id'] and tonumber(ban[1]['id']) then
						printBanInfo(thePlayer, ban[1])
						return false
					else
						dbFree(banQ)
					end

					local thePlayerPower = exports.global:getPlayerAdminLevel(thePlayer)
					local adminTitle = exports.global:getAdminTitle1(thePlayer)
					local adminUsername = getElementData(thePlayer, "account:username" )
					if (tonumber(result[1].admin) > thePlayerPower) then
						outputChatBox(" '"..targetUsername.."' é um administrador de nível superior que você.", thePlayer, 255, 0, 0)
						exports.global:sendMessageToAdmins("AdmWrn: "..adminTitle.." tentou executar o comando de ban no administrador superior '"..targetUsername.."'.")
						return false
					end

					local reason = table.concat({...}, " ")

					--check online players
					for i, player in pairs(getElementsByType("player")) do
						if getElementData(player, "account:id") == tonumber(result[1].id)  then
							local cmd = "pban"
							if string.lower(commandName) == "soban" then
								cmd = "sban"
							end
							banAPlayer(thePlayer, cmd, getElementData(player, "playerid"), hours, reason)
							return true
						end
					end


					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local playerName = getPlayerName(thePlayer)

					local seconds = ((hours*60)*60)
					local rhours = hours
					-- text value
					if (hours==0) then
						hours = "Permanente"
					elseif (hours==1) then
						hours = "1 Hora"
					else
						hours = hours .. " Horas"
					end
					reason = reason .. " (" .. hours .. ")"
					exports['admin-system']:addAdminHistory(user['id'], thePlayer, reason, 2, rhours)

					local targetSerial = nil
					if user['mtaserial'] ~= mysql_null() then
						targetSerial = user['mtaserial']
					end
					local banId = nil

					banId = addToBan(result[1].id, user['mtaserial'], result[1].ip, getElementData(thePlayer, "account:id"), reason, rhours)
					if banId and tonumber(banId) then
						banQ = dbQuery(mysql:getConn("core"), "SELECT * FROM bans WHERE id=? LIMIT 1", banId)
						ban = dbPoll(banQ, 10000)
						if ban and #ban == 1 then
							lastBan = ban[1]
						else
							dbFree(banQ)
						end
						if lastBanTimer and isTimer(lastBanTimer) then
							killTimer(lastBanTimer)
							lastBanTimer = nil
						end
						lastBanTimer = setTimer(function()
							lastBan = nil
						end, 1000*60*5,1) --5 minutes
					end

					local adminUsername = getElementData(thePlayer, "account:username")
					local adminUserID = getElementData(thePlayer, "account:id")
					adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					makeForumThread("N/A", targetUsername, hours, reason, adminUsername, banId )
					if targetSerial then
						for key, value in ipairs(getElementsByType("player")) do
							if getPlayerSerial(value) == targetSerial then
								kickPlayer(value, thePlayer, reason)
							end
						end
					end

					if (hiddenAdmin==1) then
						adminTitle = "Um Admin Oculto"
					end
					if string.lower(commandName) == "soban" then
						exports.global:sendMessageToAdmins("[OFFLINE-BAN]: " .. adminTitle .. " " .. adminUsername .. " baniu silenciosamente " .. targetUsername .. ". (" .. hours .. ")")
						exports.global:sendMessageToAdmins("[OFFLINE-BAN]: Razão: " .. reason .. ".")
					else
						for index, player in pairs(getElementsByType("player")) do
							if tonumber(getElementData(player, "punishment_notification_selector")) ~= 1 or player == thePlayer then
								outputChatBox("AdmCmd: " .. adminTitle .. " " .. adminUsername .. " baniu o jogador" .. targetUsername .. ". (" .. hours .. ")", player, 252, 115, 87)
								outputChatBox("AdmCmd: Razão: " .. reason .. ".", player, 252, 115, 87)
							end
						end
					end

					exports.global:sendMessageToAdmins("/mostrarban para detalhes.")
				end
			else
				outputChatBox("Usuario Jogador não encontrado!", thePlayer, 255, 194, 14)
				return false
			end
		end
	end
end
addCommandHandler("oban", offlineBanAPlayer, false, false)
addCommandHandler("soban", offlineBanAPlayer, false, false)

function banPlayerSerial(thePlayer, commandName, serial, ...)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not serial or not string.len(serial) or not string.len(serial) == 32 or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Numero Serial] [Razão]", thePlayer, 255, 194, 14)
		else

			local reason = table.concat({...}, " ")
			serial = string.upper(serial)
			local id = addToBan(nil, serial, nil, getElementData(thePlayer,"account:id"), reason)
			if id and tonumber(id) then
				banQ = dbQuery(mysql:getConn("core"), "SELECT * FROM bans WHERE id=? LIMIT 1", id)
				ban = dbPoll(banQ, 10000)
				if ban and #ban > 0 and tonumber(ban[1]['id']) then
					lastBan = ban[1]
					if lastBanTimer and isTimer(lastBanTimer) then
						killTimer(lastBanTimer)
						lastBanTimer = nil
					end
					lastBanTimer = setTimer(function()
						lastBan = nil
					end, 1000*60*5,1) --5 minutes
					for key, value in ipairs(getElementsByType("player")) do
						if getPlayerSerial(value) == serial then
							kickPlayer(value, thePlayer, reason)
						end
					end
					exports.global:sendMessageToAdmins("[BAN] "..exports.global:getPlayerFullIdentity(thePlayer).." baniu serial numero '"..serial.."' permanentemente por '"..reason.."'. /mostrarban para detalhes.")
				else
					dbFree(banQ)
				end
			else

			end
		end
	end
end
addCommandHandler("banserial", banPlayerSerial, false, false)
addCommandHandler("serialban", banPlayerSerial, false, false)
addCommandHandler("banirserial", banPlayerSerial, false, false)

function banPlayerIP(thePlayer, commandName, ip, ...)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not ip or not string.len(ip) or string.len(ip) > 15 or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Endereço de IP] [Razão]", thePlayer, 255, 194, 14)
			--outputChatBox("You can use * for IP range ban. For example: 192.168.*.*", thePlayer, 255, 194, 14)
		else
			local reason = table.concat({...}, " ")
			local id = addToBan(nil, nil, ip, getElementData(thePlayer,"account:id"), reason)
			if id and tonumber(id) then
				banQ = dbQuery(mysql:getConn("core"), "SELECT * FROM bans WHERE id=? LIMIT 1", id)
				ban = dbPoll(banQ, 10000)
				if ban and #ban == 1 and tonumber(ban[1]['id']) then
					lastBan = ban[1]
					if lastBanTimer and isTimer(lastBanTimer) then
						killTimer(lastBanTimer)
						lastBanTimer = nil
					end
					lastBanTimer = setTimer(function()
						lastBan = nil
					end, 1000*60*5,1) --5 minutes
					for key, value in ipairs(getElementsByType("player")) do
						if getPlayerIP(value) == ip then
							kickPlayer(value, thePlayer, reason)
						end
					end
					exports.global:sendMessageToAdmins("[BAN] "..exports.global:getPlayerFullIdentity(thePlayer).." baniu o endereço IP '"..ip.."' permanentemente por '"..reason.."'. /mostrarban para detalhes.")
				else
					dbFree(banQ)
				end
			end
		end
	end
end
addCommandHandler("ipban", banPlayerIP, false, false)
addCommandHandler("banip", banPlayerIP, false, false)
addCommandHandler("banirip", banPlayerIP, false, false)

function banPlayerAccount(thePlayer, commandName, account, ...)
	if not exports.integration:isPlayerTrialAdmin(thePlayer) then
		return
	end

	if not account or not (...) then
		return outputChatBox("SYNTAX: /" .. commandName .. " [Username] [Razão]", thePlayer, 255, 194, 14)
	end

	local accountid = exports.cache:getIdFromUsername(account)
	if not accountid then
		outputChatBox("Conta '"..account.."' não existe.", thePlayer, 255, 0, 0)
		return false
	end

	local reason = table.concat({...}, " ")
	addToBan(accountid, nil, nil, getElementData(thePlayer,"account:id"), reason)

	local banQ = dbQuery(mysql:getConn("core"), "SELECT * FROM bans WHERE account=? ORDER BY id DESC LIMIT 1", accountid)
	local ban = dbPoll(banQ, 10000)
	if ban and #ban == 1 and tonumber(ban[1]['id']) then
		lastBan = ban[1]
		if lastBanTimer and isTimer(lastBanTimer) then
			killTimer(lastBanTimer)
			lastBanTimer = nil
		end
		lastBanTimer = setTimer(function() lastBan = nil end, 1000*60*5,1) --5 minutes

		for _, value in ipairs(getElementsByType("player")) do
			if getElementData(value, "account:id") == tonumber(accountid) then
				kickPlayer(value, thePlayer, reason)
			end
		end

		exports.global:sendMessageToAdmins("[BAN] "..exports.global:getPlayerFullIdentity(thePlayer).." baniu a conta '"..(account).."' permanentemente por '"..reason.."'. /mostrarban para detalhes.")
	else
		dbFree(banQ)
	end
end
addCommandHandler("banaccount", banPlayerAccount, false, false)
addCommandHandler("accountban", banPlayerAccount, false, false)
addCommandHandler("banirconta", banPlayerAccount, false, false)

-- /desbanir
function unbanPlayer(thePlayer, commandName, id)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not id or not tonumber(id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Ban ID]", thePlayer, 255, 194, 14)
			outputChatBox("/mostrarban [USUARIO ou SERIAL ou IP] para ver o ID do ban.", thePlayer, 255, 194, 14)
		else
			if tonumber(getElementData(thePlayer, "cmd:unban")) ~= tonumber(id) then
				banQ = dbQuery(mysql:getConn("core"), "SELECT * FROM bans WHERE id=? LIMIT 1", id)
				ban = dbPoll(banQ, 10000)
				if ban and #ban == 1 and ban[1]['id'] and tonumber(ban[1]['id']) then
					printBanInfo(thePlayer,ban[1])
					outputChatBox("Você está prestes a remover este registro de banimento. Por favor digite /desbanir "..ban[1]['id'].." mais uma vez para prosseguir.", thePlayer, 255, 194, 14)
					setElementData(thePlayer, "cmd:unban", ban[1]['id'])
				else
					dbFree(banQ)
				end
			else
				banQ = dbQuery(mysql:getConn("core"), "SELECT * FROM bans WHERE id=? LIMIT 1", id)
				ban = dbPoll(banQ, 10000)
				if ban and #ban == 1 and ban[1]['id'] and tonumber(ban[1]['id']) then
					lastBan = ban[1]
					if lastBanTimer and isTimer(lastBanTimer) then
						killTimer(lastBanTimer)
						lastBanTimer = nil
					end
					lastBanTimer = setTimer(function()
						lastBan = nil
					end, 1000*60*5,1) --5 minutes
					if dbExec(mysql:getConn("core"), "DELETE FROM bans WHERE id=?", id) then
						for _, banElement in ipairs(getBans()) do
							if getBanSerial(banElement) == ban[1]['mta_serial'] or getBanIP(banElement) == ban[1]['ip'] then
								removeBan(banElement)
								break
							end
						end
						if ban[1]['account'] ~=mysql_null() then
							exports['admin-system']:addAdminHistory(ban[1]['account'], thePlayer, "UNBAN", 2 , 0)
						end
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						exports.global:sendMessageToAdmins("[UNBAN] "..exports.global:getPlayerFullIdentity(thePlayer).." removeu o registro de proibição #"..ban[1]['id']..". /mostrarban para detalhes.")
					end
				else
					dbFree(banQ)
					outputChatBox("Ops, desculpe a proibição deve ter sido suspensa.", thePlayer, 255, 194, 14)
				end
			end
		end
	end
end
addCommandHandler("unban", unbanPlayer, false, false)
addCommandHandler("desbanir", unbanPlayer, false, false)

function checkForSerialOrIpBan(playerNick, playerIP, playerUsername, playerSerial, playerVersionNumber, playerVersionString)
	--serial + IP ban.
	local resultQ = dbQuery(mysql:getConn("core"), "SELECT * FROM bans WHERE (mta_serial=? OR ip=?) AND (until IS NULL OR until > NOW() ) LIMIT 1", playerSerial, playerIP)
	local result = dbPoll(resultQ, 10000)
	if result and #result > 0 then
		lastBan = result[1]
		if lastBanTimer and isTimer(lastBanTimer) then
			killTimer(lastBanTimer)
			lastBanTimer = nil
		end
		lastBanTimer = setTimer(function()
			lastBan = nil
		end, 1000*60*5,1) --5 minutes
		local banText = "Você esta banido. Faça um appeal em nosso discord"
		local bannedSerial = false
		local bannedIp = false
		if result[1]['mta_serial'] == playerSerial then
		 	banText = "Seu serial esta banido. Faça um appeal em nosso discord"
		 	bannedSerial = playerSerial
		end
		if result[1]['ip'] == playerIP then
			bannedIp = playerIP
			banText = "Seu IP esta banido. Faça um appeal em nosso discord"
		end
		cancelEvent(true, banText)
		exports.global:sendMessageToAdmins("[BAN] Conexão rejeitada de"..(bannedSerial and (" serial: '"..tostring(bannedSerial).."'") or "" ).." "..(bannedIp and (" IP: '"..tostring(bannedIp).."'") or "")..". /mostrarban para detalhes.")
		return true
	else
		dbFree(resultQ)
	end
	--IP range ban
	resultQ = dbQuery(mysql:getConn("core"), "SELECT * FROM bans WHERE ip LIKE '%*%' ")
	local result = dbPoll(resultQ, 10000)
	if result and #result > 0 then
		for ban in pairs(result) do
			if string.find( playerIP, "^" .. ban.ip .. "$" ) then
				lastBan = ban
				if lastBanTimer and isTimer(lastBanTimer) then
					killTimer(lastBanTimer)
					lastBanTimer = nil
				end
				lastBanTimer = setTimer(function()
					lastBan = nil
				end, 1000*60*5,1) --5 minutes
				cancelEvent(true, "Seu IP esta banido. Faça um appeal em nosso discord")
				exports.global:sendMessageToAdmins("[RANGE-BAN] Conexão rejeitada do IP: '"..playerIP.."' IP '"..ban.ip.."' esta banido. /mostrarban para detalhes.")
				return true
			end
		end
	else
		dbFree(resultQ)
	end
	return false
end
addEventHandler("onPlayerConnect", getRootElement(), checkForSerialOrIpBan)

local function isLocalIP(ip)
	return ip == '127.0.0.1' or string.sub(ip, 1, 8) == '192.168.'
end

function proxyCheck()
	--IP Proxy Check
	local thePlayer = source
	local ip = getPlayerIP(thePlayer)

	if not ip then
		outputDebugString("[BANS] Não foi possível obter o IP do jogador, deixando-o entrar..")
		return false
	end

	callRemote(GeoIP .. ip, function(data)
		if type(data) ~= "table" then -- Error
			--outputDebugString("[BANS] Issue retriveing proxy information: "..data)
			return false
		end

		local country_code = data.country_code
		local longitude = data.longitude
		local latitude = data.latitude
		local count = 0
		for _ in pairs(data) do count = count + 1 end

		-- Conditions

		if (count == 0) then -- Failed to retrieve information. Let them in.
			outputDebugString("[BANS] Não foi possível obter nenhuma informação..")
			return false
		elseif isLocalIP( ip ) then
			outputDebugString( "[BANS] IP Local Detectado: "..ip )
			return false
		elseif count == 1 then -- Only returned the IP address meaning either their IP is spoofed or internal.
			outputDebugString("[BANS] Falsificado: ".. ip)
			outputChatBox("Há um problema com o seu endereço IP. Entre em contato conosco pelo discord", thePlayer, 255, 0, 0)
			kickPlayer(thePlayer, "There is a issue with your IP address.")
			return true
		elseif (not country_code) or (country_code == "A1") or (not longitude) or (not latitude) or (longitude == 0 and latitude == 0) then
			outputChatBox("Seu endereço IP não é genuíno. Conecte-se sem usar um serviço de proxy.", thePlayer, 255, 0, 0)
			exports.global:sendMessageToAdmins("[BANS] Conexão rejeitada de IP: '"..ip.."' uma vez que foi automaticamente detectado como não genuíno.")
			kickPlayer(thePlayer, "Seu endereço IP não é genuíno.")
			return true
		end
	end )
	return false
end
addEventHandler("onPlayerJoin", getRootElement(), proxyCheck)

function checkAccountBan(userid)
	local resultQ = dbQuery(mysql:getConn("core"), "SELECT * FROM bans WHERE account=? AND (until IS NULL OR until > NOW() ) LIMIT 1", userid)
	local result = dbPoll(resultQ, 10000)
	if result and #result > 0 then
		lastBan = result
		if lastBanTimer and isTimer(lastBanTimer) then
			killTimer(lastBanTimer)
			lastBanTimer = nil
		end
		lastBanTimer = setTimer(function()
			lastBan = nil
		end, 1000*60*5,1) --5 minutes
		exports.global:sendMessageToAdmins("[BAN] Conexão rejeitada da conta "..exports.cache:getUsernameFromId(userid).." por que a conta esta banida. /mostrarban para detalhes.")
		return true
	else
		dbFree(resultQ)
	end
	return false
end

function showBanDetails(thePlayer, commandName, clue)
	if exports.integration:isPlayerTrialAdmin(thePlayer) then
		if clue then
			clue = exports.global:toSQL(clue)
			local username = exports.cache:getIdFromUsername(clue) or "0"

			dbQuery(function(qh, thePlayer, clue, username)
				local result = dbPoll(qh, 0)
				if result and #result > 0 then
					for _, ban in pairs(result) do
						if ban and ban.id then
							printBanInfo(thePlayer, ban)
						else
							outputChatBox("Desculpe, a proibição que você está procurando deve ter sido suspensa.", thePlayer, 255, 194, 14)
						end
					end
				elseif #result == 0 then
					outputChatBox("Não há registros de banimento com serial ou IP ou nome de conta que corresponda à palavra-chave '"..clue.."'.", thePlayer, 255, 194, 14)
				end
			end, {thePlayer, clue, username}, mysql:getConn("core"), "SELECT * FROM bans WHERE id=? OR mta_serial=? OR ip=? OR account=? ORDER BY date DESC", clue, clue, clue, username)
		elseif lastBan then
			printBanInfo(thePlayer, lastBan)
		else
			outputChatBox("SYNTAX: /" .. commandName .. " [SERIAL ou IP ou USUARIO]", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("showban", showBanDetails, false, false)
addCommandHandler("findban", showBanDetails, false, false)
addCommandHandler("mostrarban", showBanDetails, false, false)

function printBanInfo(thePlayer, result)
	outputChatBox("===========BAN RECORD #"..result['id'].."============", thePlayer, 255, 194, 14)

	local bannedAccount = exports.cache:getUsernameFromId(result['account'])
	outputChatBox("Conta: "..(bannedAccount and bannedAccount or "N/A"), thePlayer, 255, 194, 14)

	local bannedSerial = nil
	if result['mta_serial'] then
		bannedSerial = result['mta_serial']
	end
	outputChatBox("Serial: "..(bannedSerial and bannedSerial or "N/A"), thePlayer, 255, 194, 14)

	local bannedIp = nil
	if result['ip'] then
		bannedIp = result['ip']
	end
	outputChatBox("IP: "..(bannedIp and bannedIp or "N/A"), thePlayer, 255, 194, 14)

	local banningAdmin = exports.cache:getUsernameFromId(result['admin'])
	outputChatBox("Banido pelo administrador: "..(banningAdmin and banningAdmin or "N/A"), thePlayer, 255, 194, 14)

	local bannedDate = nil
	if result['date'] then
		bannedDate = result['date']
	end
	outputChatBox("Banned Date: "..(bannedDate and bannedDate or "N/A"), thePlayer, 255, 194, 14)
	local bannedUntil = 'Permanente'
	if result['until'] then
		bannedUntil = result['until']
	end
	outputChatBox("Banido até: "..bannedUntil, thePlayer, 255, 194, 14)
	local bannedReason = nil
	if result['reason'] then
		bannedReason = result['reason']
	end
	outputChatBox("Razão: "..(bannedReason and bannedReason or "N/A"), thePlayer, 255, 194, 14)
	--[[local banThread = nil
	if result['threadid'] then
		banThread = "http://forums.owlgaming.net/index.php?showtopic="..result['threadid']
	end
	outputChatBox("Ban thread: "..(banThread and banThread or "N/A"), thePlayer, 255, 194, 14)]]
end

function addToBan(account, serial, ip, admin, reason, hours)
	local tail = ''
	if serial then
		tail = tail..", mta_serial='"..serial.."'"
	end
	if ip then
		tail = tail..", ip='"..ip.."'"
	end
	if admin and tonumber(admin) then
		tail = tail..", admin='"..admin.."'"
	end
	if reason then
		tail = tail..", reason='"..exports.global:toSQL(reason).."'"
	else
		tail = tail..", reason='"..exports.global:toSQL("N/A").."'"
	end
	if account and tonumber(account) then
		tail = tail..", account='"..account.."'"
	end
	if hours and tonumber(hours) and tonumber(hours) >0 then
		tail = tail..", until=NOW() + INTERVAL "..hours.." HOUR "
	end
	return dbExec(mysql:getConn("core"), "INSERT INTO bans SET date=NOW() "..tail)
end

function cleanUp()
	dbExec(mysql:getConn("core"), "DELETE FROM bans WHERE until IS NOT NULL AND until < NOW() ")
end
addEventHandler("onResourceStart", resourceRoot, cleanUp)
