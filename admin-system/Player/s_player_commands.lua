--[[
 * ***********************************************************************************************************************
 * Copyright (c) 2015 OwlGaming Community - All Rights Reserved
 * All rights reserved. This program and the accompanying materials are private property belongs to OwlGaming Community
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * ***********************************************************************************************************************
 ]]

local ACL_DETAILS = { username = "admintest", password = false }

mysql = exports.mysql
local getPlayerName_ = getPlayerName
getPlayerName = function( ... )
	s = getPlayerName_( ... )
	return s and s:gsub( "_", " " ) or s
end

MTAoutputChatBox = outputChatBox
function outputChatBox( text, visibleTo, r, g, b, colorCoded )
	if string.len(text) > 128 then -- MTA Chatbox size limit
		MTAoutputChatBox( string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded  )
		outputChatBox( string.sub(text, 128), visibleTo, r, g, b, colorCoded  )
	else
		MTAoutputChatBox( text, visibleTo, r, g, b, colorCoded  )
	end
end

--ban banPlayerSerial ( player bannedPlayer,  player responsiblePlayer = nil, string reason = nil, bool hide = false )
function banPlayerSerial(thePlayer, theAdmin, reason, hide)
	local serial = getPlayerSerial(thePlayer)
	local result = mysql:query("SELECT * FROM bannedSerials")
	if result then
		while true do
			local row = mysql:fetch_assoc(result)
			if not row then break end
			if row["serial"] == serial then
				exports.global:sendMessageToAdmins("BAN-SYSTEM: Player " .. getPlayerName(thePlayer):gsub("_", " ") .. " já está banido. Kikando o jogador")
				exports.gloval:sendMessageToAdmins("            Serial: " .. serial)
				kickPlayer(thePlayer, reason)
				return
			end
		end
	end
	local entry = mysql:query_free('INSERT INTO bannedSerials (serial) VALUES ("' .. mysql:escape_string(serial) .. '")' )
	if entry then
		if not hide then
			for key, value in ipairs(getElementsByType("player")) do
				if tonumber( getElementData( value, "punishment_notification_selector") ) ~= 1 or value == thePlayer or value == theAdmin then
					outputChatBox(exports.global:getPlayerAdminTitle(theAdmin) .. " " .. getPlayerName(theAdmin):gsub("_"," ") .. " jogador banido " .. getPlayerName(thePlayer):gsub("_"," "), value, 255, 0, 0)
					outputChatBox("Razão: " .. reason, value, 255, 0, 0)
				end
			end
		else
			outputChatBox("Você baniu  " .. getPlayerName(thePlayer):gsub("_"," ") .. " silenciosamente.", theAdmin, 0, 255, 0)
			exports.global:sendMessageToAdmins("ADM-WARN: " .. getPlayerName(theAdmin):gsub("_"," ") .. " jogador banido " .. getPlayerName(thePlayer):gsub("_"," ") .. " silenciosamente.")
			exports.global:sendMessageToAdmins("          Razão: " .. reason)
		end
		kickPlayer(thePlayer, theAdmin, reason)
		exports.global:updateBans()
		for key, value in ipairs(getElementsByType("player")) do
			if getPlayerSerial(value) == serial then
				kickPlayer(value, showingPlayer, reason)
			end
		end
	end
end



--/AUNCUFF
function adminUncuff(thePlayer, commandName, targetPlayer)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)

				if (logged==0) then
					outputChatBox("Jogador não esta logado.", thePlayer, 255, 0, 0)
				else
					local restrain = getElementData(targetPlayer, "restrain")

					if (restrain==0) then
						outputChatBox("Jogador não esta algemado.", thePlayer, 255, 0, 0)
					else
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						if hiddenAdmin == 0 then
							outputChatBox("Você foi desalgemado por " .. username .. ".", targetPlayer)
						else
							outputChatBox("Você foi desalgemado por um Admin Oculto.", targetPlayer)
						end
						outputChatBox("Você desalgemou " .. targetPlayerName .. ".", thePlayer)
						toggleControl(targetPlayer, "sprint", true)
						toggleControl(targetPlayer, "fire", true)
						toggleControl(targetPlayer, "jump", true)
						toggleControl(targetPlayer, "next_weapon", true)
						toggleControl(targetPlayer, "previous_weapon", true)
						toggleControl(targetPlayer, "accelerate", true)
						toggleControl(targetPlayer, "brake_reverse", true)
						toggleControl(targetPlayer, "aim_weapon", true)
						exports.anticheat:changeProtectedElementDataEx(targetPlayer, "restrain", 0, true)
						exports.anticheat:changeProtectedElementDataEx(targetPlayer, "restrainedBy", false, true)
						exports.anticheat:changeProtectedElementDataEx(targetPlayer, "restrainedObj", false, true)
						exports.global:removeAnimation(targetPlayer)
						mysql:query_free("UPDATE characters SET cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
						exports['item-system']:deleteAll(47, getElementData( targetPlayer, "dbid" ))
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNCUFF")
					end
				end
			end
		end
	end
end
addCommandHandler("auncuff", adminUncuff, false, false)
addCommandHandler("adesalgemar", adminUncuff, false, false)

--/AUNMASK
function adminUnmask(thePlayer, commandName, targetPlayer)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)

				if (logged==0) then
					outputChatBox("Jogador não esta logado.", thePlayer, 255, 0, 0)
				else
					local any = false
					local masks = exports['item-system']:getMasks()
					for key, value in pairs(masks) do
						if getElementData(targetPlayer, value[1]) then
							any = true
							exports.anticheat:changeProtectedElementDataEx(targetPlayer, value[1], false, true)
						end
					end

					if any then
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						if hiddenAdmin == 0 then
							outputChatBox("Sua mascara foi removida por um admin "..username, targetPlayer, 255, 0, 0)
						else
							outputChatBox("Sua mascara foi removida por um Admin Oculto", targetPlayer, 255, 0, 0)
						end
						outputChatBox("Você removeu a mascara de " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNMASK")
					else
						outputChatBox("Jogador não esta mascarado.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("aunmask", adminUnmask, false, false)
addCommandHandler("atirarmascara", adminUnmask, false, false)

function infoDisplay(thePlayer)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		outputChatBox("---[        Informaçõe        ]---", getRootElement(), 255, 194, 15)
		outputChatBox("---[ Server: LERP Port: 22003", getRootElement(), 255, 194, 15)
		outputChatBox("---[ Discord: https://discord.gg/bZATeG69uR", getRootElement(), 255, 194, 15)
		--outputChatBox("---[ UCP: www.owlgaming.net", getRootElement(), 255, 194, 15)
		--outputChatBox("---[ Forums: www.forums.owlgaming.net", getRootElement(), 255, 194, 15)
		--outputChatBox("---[ Mantis: bugs.owlgaming.net", getRootElement(), 255, 194, 15)
	end
end
addCommandHandler("info", infoDisplay)

function adminUnblindfold(thePlayer, commandName, targetPlayer)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)

				if (logged==0) then
					outputChatBox("Jogador não esta logado.", thePlayer, 255, 0, 0)
				else
					local blindfolded = getElementData(targetPlayer, "rblindfold")

					if (blindfolded==0) then
						outputChatBox("Jogador não esta vendado", thePlayer, 255, 0, 0)
					else
						exports.anticheat:changeProtectedElementDataEx(targetPlayer, "blindfold", false, false)
						fadeCamera(targetPlayer, true)
						outputChatBox("Você removeu a venda de " .. targetPlayerName .. ".", thePlayer)
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						if hiddenAdmin == 0 then
							outputChatBox("Você teve a venda retirada pelo admin " .. username .. ".", thePlayer)
						else
							outputChatBox("Você teve a venda retirada por um Admin Oculto.", thePlayer)
						end
						mysql:query_free("UPDATE characters SET blindfold = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNBLINDFOLD")
					end
				end
			end
		end
	end
end
addCommandHandler("aunblindfold", adminUnblindfold, false, false)
addCommandHandler("atirarvenda", adminUnblindfold, false, false)

-- /MUTE
function mutePlayer(thePlayer, commandName, targetPlayer)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged==0) then
					outputChatBox("Jogador não esta logado.", thePlayer, 255, 0, 0)
				else
					local muted = getElementData(targetPlayer, "muted") or 0
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					if muted == 0 then
						exports.anticheat:changeProtectedElementDataEx(targetPlayer, "muted", 1, false)
						outputChatBox(targetPlayerName .. " esta agora mutado do canal OOC.", thePlayer, 255, 0, 0)
						if hiddenAdmin == 0 then
							outputChatBox("Você foi mutado por '" .. getPlayerName(thePlayer) .. "'.", targetPlayer, 255, 0, 0)
						else
							outputChatBox("Você foi mutado por um Admin Oculto.", targetPlayer, 255, 0, 0)
						end
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "MUTE")
					else
						exports.anticheat:changeProtectedElementDataEx(targetPlayer, "muted", 0, false)
						outputChatBox(targetPlayerName .. " agora esta desmutado do OOC.", thePlayer, 0, 255, 0)

						if hiddenAdmin == 0 then
							outputChatBox("Você foi desmutado por '" .. getPlayerName(thePlayer) .. "'.", targetPlayer, 0, 255, 0)
						else
							outputChatBox("Você foi desmutado por um Admin Oculto.", targetPlayer, 0, 255, 0)
						end
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNMUTE")
					end
					mysql:query_free("UPDATE account_details SET muted=" .. mysql:escape_string(getElementData(targetPlayer, "muted")) .. " WHERE account_id = " .. mysql:escape_string(getElementData(targetPlayer, "account:id")) )
				end
			end
		end
	end
end
addCommandHandler("pmute", mutePlayer, false, false)
addCommandHandler("mutar", mutePlayer, false, false)

-- /DISARM
function disarmPlayer(thePlayer, commandName, targetPlayer)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged==0) then
					outputChatBox("Jogador não esta logado.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					for i = 115, 116 do
						while exports['item-system']:takeItem(targetPlayer, i) do
						end
					end
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					if (hiddenAdmin==0) then
						exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " desarmou " .. targetPlayerName..".")
						outputChatBox("Você foi desarmado por "..tostring(adminTitle) .. " " .. getPlayerName(thePlayer)..".", targetPlayer, 255, 0, 0)
					else
						exports.global:sendMessageToAdmins("AdmCmd: um Admin Oculto desarmou " .. targetPlayerName..".")
						outputChatBox("Você foi desarmado por um Admin Oculto.", targetPlayer, 255, 0, 0)
					end
					outputChatBox(targetPlayerName .. " esta agora desarmado.", thePlayer, 255, 0, 0)
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "DISARM")
				end
			end
		end
	end
end
addCommandHandler("disarm", disarmPlayer, false, false)
addCommandHandler("desarmar", disarmPlayer, false, false)

function forceApplication(thePlayer, commandName, targetPlayer, ...) -- Maxime
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)) then
		if not (targetPlayer) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador/ID] [Razão]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if not (targetPlayer) then

			else
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged==0) then
					outputChatBox("Jogador não esta logado.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local reason = table.concat({...}, " ")
					local id = getElementData(targetPlayer, "account:id")
					local username = getElementData(thePlayer, "account:username")
					mysql:query_free("UPDATE `account_details` SET `appstate`='0', `appreason`='" .. mysql:escape_string(reason) .. "', appdatetime = NOW() + INTERVAL 1 DAY, `monitored` = 'Forceapped for " .. mysql:escape_string(reason) .. "' WHERE `account_id`='" .. mysql:escape_string(id) .. "'")

					mysql:query_free("DELETE FROM `applications` WHERE `applicant`='" .. mysql:escape_string(id) .. "' AND `state`='0' ")
					mysql:query_free("DELETE FROM `force_apps` WHERE `forceapp_date` < NOW() - interval 30 day ")
					mysql:query_free("DELETE FROM `force_apps` WHERE `account`='" .. mysql:escape_string(id) .. "' ")
					mysql:query_free("INSERT INTO `force_apps` SET `account`='" .. mysql:escape_string(id) .. "' ")
					mysql:query_free("UPDATE `account_details` SET `appstate`='0' WHERE `account_id`='" .. id .. "' ")

					local adminTitle = exports.global:getAdminTitle1(thePlayer)

					for index, player in pairs( getElementsByType("player")) do
						if tonumber( getElementData( player, "punishment_notification_selector") ) ~= 1 or player == thePlayer or player == targetPlayer then
							outputChatBox("[FORCE APP] " .. tostring(adminTitle) .. " sent " .. targetPlayerName .. " de volta ao estágio de aplicação.", player, 255,0,0)
							outputChatBox("[FORCE APP] Razão: "..reason, player, 255,0,0)
						end
					end
					outputChatBox("[APLICAÇÂO] "..targetPlayerName .. " foi forçado a reescrever sua aplicação.", thePlayer, 255, 194, 14)
					addAdminHistory(targetPlayer, thePlayer, reason, 7, 0)
					redirectPlayer ( targetPlayer, "", 0 )
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "FORCEAPP " .. reason)
				end
			end
		end
	end
end
addCommandHandler("forceapp", forceApplication, false, false)
addCommandHandler("fa", forceApplication, false, false)
addCommandHandler("forcaraplicacao", forceApplication, false, false)

function oforceApplication(thePlayer, commandName, username, ...) -- Chaos
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)) then
		if not (username) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Usuario Exato] [Razão]", thePlayer, 255, 194, 14)
		else
			local reason = table.concat({...}, " ")
			local id = tonumber(exports.cache:getIdFromUsername(username))
			if id then
				mysql:query_free("UPDATE `account_details` SET `appstate`='0', `appreason`='" .. mysql:escape_string(reason) .. "', appdatetime = NOW() + INTERVAL 1 DAY, `monitored` = 'Forceapped for " .. mysql:escape_string(reason) .. "' WHERE `account_id`='" .. mysql:escape_string(id) .. "'")

				mysql:query_free("DELETE FROM `applications` WHERE `applicant`='" .. mysql:escape_string(id) .. "' AND `state`='0' ")
				mysql:query_free("DELETE FROM `force_apps` WHERE `forceapp_date` < NOW() - interval 30 day ")
				mysql:query_free("DELETE FROM `force_apps` WHERE `account`='" .. mysql:escape_string(id) .. "' ")
				mysql:query_free("INSERT INTO `force_apps` SET `account`='" .. mysql:escape_string(id) .. "' ")
				mysql:query_free("UPDATE `account_details` SET `appstate`='0' WHERE `account_id`='" .. id .. "' ")

				local adminTitle = exports.global:getAdminTitle1(thePlayer)

				for index, player in pairs( getElementsByType("player")) do
					if tonumber( getElementData( player, "punishment_notification_selector") ) ~= 1 or player == thePlayer then
						outputChatBox("[FORCE APP] " .. tostring(adminTitle) .. " offline sent " .. username .. " de volta ao estágio de aplicação.", player, 255,0,0)
						outputChatBox("[FORCE APP] Razão: "..reason, player, 255,0,0)
					end
				end

				outputChatBox("[APPLICATION] "..username .. " foi forçado a reescrever sua aplicação.", thePlayer, 255, 194, 14)
				addAdminHistory(id, thePlayer, reason, 7, 0)
				exports.logs:dbLog(thePlayer, 4, thePlayer, "OFFLINE FORCEAPP " .. username .. " - " .. reason)
			else
				outputChatBox("Nenhum usuario com esse nome encontrado.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("oforceapp", oforceApplication, false, false)
addCommandHandler("ofa", oforceApplication, false, false)

function unforceApplication(thePlayer, commandName, targetPlayer) --Maxime
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Usuario]", thePlayer, 255, 194, 14)
		else
			local userid = exports.cache:getIdFromUsername(targetPlayer)
			if userid then
				local username = targetPlayer

				local staffName = exports.global:getPlayerFullIdentity(thePlayer, 1)
				mysql:query_free("UPDATE `account_details` SET `appstate`='3', `appreason`=NULL, appdatetime = NULL, `monitored` = 'Has been unforceapp-ed by " .. mysql:escape_string(staffName) .. "' WHERE `account_id`='" .. mysql:escape_string(userid) .. "'")

				mysql:query_free("DELETE FROM `applications` WHERE `applicant`='" .. mysql:escape_string(userid) .. "' AND `state`='0' ")
				mysql:query_free("DELETE FROM `force_apps` WHERE `forceapp_date` < NOW() - interval 30 day ")
				mysql:query_free("DELETE FROM `force_apps` WHERE `account`='" .. mysql:escape_string(userid) .. "' ")

				exports.global:sendMessageToStaff("[APPLICATION] Player '" .. username .. "' has been unforceapp-ed by " .. tostring(staffName)..".")
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNFORCEAPP ")
			end
		end
	end
end
addCommandHandler("unforceapp", unforceApplication, false, false)
addCommandHandler("unfa", unforceApplication, false, false)

-- /FRECONNECT
function forceReconnect(thePlayer, commandName, targetPlayer)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				local adminName = getPlayerName(thePlayer)
				if (hiddenAdmin==0) then
					exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. adminName .. " reconectou " .. targetPlayerName )
				else
					adminTitle = ""
					adminName = "um Admin Oculto"
					exports.global:sendMessageToAdmins("AdmCmd: um Admin Oculto reconectou " .. targetPlayerName )
				end
				outputChatBox("Player '" .. targetPlayerName .. "' foi forçado a se reconectar.", thePlayer, 255, 0, 0)

				local timer = setTimer(kickPlayer, 1000, 1, targetPlayer, getRootElement(), "Você foi forçado a se reconectar por "..tostring(adminTitle) .. " " .. adminName ..".")
				addEventHandler("onPlayerQuit", targetPlayer, function( ) killTimer( timer ) end)

				redirectPlayer ( targetPlayer, "", 0 )

				exports.logs:dbLog(thePlayer, 4, targetPlayer, "FRECONNECT")
			end
		end
	end
end
addCommandHandler("freconnect", forceReconnect, false, false)
addCommandHandler("frec", forceReconnect, false, false)

-- /MAKEGUN
function givePlayerGun(thePlayer, commandName, targetPlayer, ...)
	local theSerial = getPlayerSerial( thePlayer )
	if exports["integration"]:isPlayerScripter(thePlayer) or theSerial == ("70B012B0992244C3220D8AA708D1A3F2") then
		local args = {...}
		if not (targetPlayer) or (#args < 1) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador/ID] [Nome Arma/ID]", thePlayer, 255, 194, 14)
			outputChatBox("     Da ao jogador uma arma.", thePlayer, 150, 150, 150)
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador/ID] [Nome Arma/ID] [Quantidade]", thePlayer, 255, 194, 14)
			outputChatBox("     Da ao jogador uma quantidade de armas.", thePlayer, 150, 150, 150)
			outputChatBox("(Digite /gunlist ou pressione F4 para abrir o criador de armas)", thePlayer, 0, 255, 0)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local weaponID = tonumber(args[1])
				local weaponName = args[1]
				local quantity = tonumber(args[2])
				if weaponID == nil then
					local cWeaponName = weaponName:lower()
					if cWeaponName == "colt45" then
						weaponID = 22
					elseif cWeaponName == "rocketlauncher" then
						weaponID = 35
					elseif cWeaponName == "combatshotgun" then
						weaponID = 27
					elseif cWeaponName == "fireextinguisher" then
						weaponID = 42
					else
						if getWeaponIDFromName(cWeaponName) == false then
							outputChatBox("[MAKEGUN] Nome da Arma Invalido/ID. Digite /gunlist para uma visão geral de todas as armas disponíveis.", thePlayer, 255, 0, 0)
							return
						else
							weaponID = getWeaponIDFromName(cWeaponName)
						end
					end
				end

				if weaponID == 40 or weaponID == 38 or weaponID == 35 or weaponID == 36 or weaponID == 37 and not exports["integration"]:isPlayerScripter(thePlayer) then
					outputChatBox("[MAKEGUN] O nome/ID da arma fornecido não pode ser gerado.", thePlayer, 255, 0, 0)
					return
				end

				if not exports.weapon:getAmmoPerClip(weaponID) then
						outputChatBox("[MAKEGUN] Nome da Arma Invalido/ID. Digite /gunlist para uma visão geral de todas as armas disponíveis.", thePlayer, 255, 0, 0)
						return
				end

				local logged = getElementData(targetPlayer, "loggedin")
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

				if (logged==0) then
					outputChatBox("[MAKEGUN] Jogador não esta logado.", thePlayer, 255, 0, 0)
				elseif (logged==1) then

					local adminDBID = tonumber(getElementData(thePlayer, "account:character:id"))
					local playerDBID = tonumber(getElementData(targetPlayer, "account:character:id"))

					if quantity == nil then
						quantity = 1
					end

					local maxAmountOfWeapons = tonumber(get( getResourceName( getThisResource( ) ).. '.maxAmountOfWeapons' ))
					if quantity > maxAmountOfWeapons then
						quantity = maxAmountOfWeapons
						outputChatBox("[MAKEGUN] Você não pode dar mais do que "..maxAmountOfWeapons.." armas de cada vez. Tentando spawnar "..maxAmountOfWeapons.."...", thePlayer, 150, 150, 150)
					end

					local count = 0
					local fails = 0
					local allSerials = ""
					local give, error = ""
					for variable = 1, quantity, 1 do
						local mySerial = exports.global:createWeaponSerial( 1, adminDBID, playerDBID)
						--outputChatBox(mySerial)
						give, error = exports.global:giveItem(targetPlayer, 115, weaponID..":"..mySerial..":"..getWeaponNameFromID(weaponID)..":0")
						if give then
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVEWEAPON "..getWeaponNameFromID(weaponID).." "..tostring(mySerial))
							if count == 0 then
								allSerials = mySerial
							else
								allSerials = allSerials.."', '"..mySerial
							end
							count = count + 1
						else
							fails = fails + 1
						end
					end
					if count > 0 then
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						if (hiddenAdmin==0) then
							--Inform Spawner
							outputChatBox("[MAKEGUN] Você deu (x"..count..") ".. getWeaponNameFromID(weaponID).." para "..targetPlayerName..".", thePlayer, 0, 255, 0)
							--Inform Player
							outputChatBox("Voce recebeu (x"..count..") ".. getWeaponNameFromID(weaponID).." de "..adminTitle.." "..getPlayerName(thePlayer)..".", targetPlayer, 0, 255, 0)
							--Send adm warning
							if not exports.integration:isPlayerScripter(thePlayer) then
								exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " deu " .. targetPlayerName .. " (x"..count..") " .. getWeaponNameFromID(weaponID) .. " com serial '"..allSerials.."'")
							end
						else -- If hidden admin
							outputChatBox("[MAKEGUN] Você deu (x"..count..") ".. getWeaponNameFromID(weaponID).." para "..targetPlayerName.." com o serial '"..allSerials, thePlayer, 0, 255, 0)

							outputChatBox("Voce recebeu (x"..count..") ".. getWeaponNameFromID(weaponID).." de um Admin Oculto.", targetPlayer, 0, 255, 0)
						end
					end
					if fails > 0 then
						outputChatBox("[MAKEGUN] "..fails.." armas não puderam ser criadas. Jogadoras ".. error ..".", thePlayer, 255, 0, 0)
						outputChatBox("[ERROR] "..fails.." as armas não puderam ser recebidas do Admin. Seu ".. error ..".", targetPlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("makegun", givePlayerGun, false, false)
addCommandHandler("acriararma", givePlayerGun, false, false)
addEvent("onMakeGun", true)
addEventHandler("onMakeGun", getRootElement(), givePlayerGun)

-- /makeammo
function givePlayerGunAmmo( thePlayer, commandName, targetPlayer, weap_id, rounds )
	local theSerial = getPlayerSerial( thePlayer )
	if exports["integration"]:isPlayerScripter( thePlayer ) or theSerial == ("70B012B0992244C3220D8AA708D1A3F2")  then
		if not targetPlayer or not weap_id or not tonumber(weap_id) or not getWeaponNameFromID( tonumber(weap_id) ) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador/id] [ID Arma] [balas -opcional]", thePlayer, 255, 194, 14)
			outputChatBox("Info: https://wiki.multitheftauto.com/wiki/Weapons", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick( thePlayer, targetPlayer )
			if targetPlayer then
				if getElementData(targetPlayer, 'loggedin') ~= 1 then
					outputChatBox("Jogador não esta logado.", thePlayer, 255, 0, 0)
					return
				end

				weap_id = tonumber(weap_id)
				rounds = tonumber(rounds) or nil
				if exports.weapon:isWeapAmmoless( weap_id ) then
					outputChatBox( getWeaponNameFromID(weap_id).." não precisa de munição." , thePlayer, 255, 0, 0 )
					return
				end

				local given, ammo, why = exports.weapon:givePlayerAmmo( thePlayer, targetPlayer, weap_id, nil, rounds )
				if given then
					outputChatBox( "Você deu a "..targetPlayerName.." um pacote de "..ammo.cartridge.." ("..ammo.rounds.." balas, serial: '"..why.."').", thePlayer, 0, 255, 0 )
					outputChatBox( exports.global:getPlayerFullIdentity(thePlayer) .." deu a você um pacote de "..ammo.cartridge.." ("..ammo.rounds.." balas, serial: '"..why.."').", targetPlayer, 0, 255, 0)
					if getElementData(thePlayer, 'hiddenadmin') ~= 1 then
						if not exports.integration:isPlayerScripter(thePlayer) then
							exports.global:sendMessageToAdmins( exports.global:getPlayerFullIdentity(thePlayer) .." deu a "..targetPlayerName.." um pacote de "..ammo.cartridge.." ("..ammo.rounds.." balas, serial: '"..why.."')." )
						end
					end
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVEITEM "..ammo.cartridge.." ("..ammo.rounds.." balas, serial: '"..why.."').")
				else
					outputChatBox( why.." ("..getWeaponNameFromID(weap_id)..")" , thePlayer, 255, 0, 0 )
				end
			end
		end
	end
end
addCommandHandler("makeammo", givePlayerGunAmmo, false, false)
addCommandHandler("acriarmunicao", givePlayerGunAmmo, false, false)

-- /daritem
function givePlayerItem(thePlayer, commandName, targetPlayer, itemID, ...)
	if exports.integration:isPlayerScripter(thePlayer) then
		itemID = tonumber(itemID)
		if not (itemID) or not (...) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID] [ID Item] [Valor Item]", thePlayer, 255, 194, 14)
		else
			if (itemID == 169 or itemID == 150) and getElementData(thePlayer, "account:id") ~= 1 then
				outputChatBox("ID do Item Invalido.", thePlayer, 255, 0, 0)
				return false
			end

			if ( itemID == 74 or itemID == 150 or itemID == 75 or itemID == 78 or itemID == 2 or itemID == 216) and not exports.integration:isPlayerLeadAdmin( thePlayer) then -- Banned Items
				exports.hud:sendBottomNotification(thePlayer, "Itens Banidos", "Apenas Admin Senior+ pode spawnar este tipo de itens.")
				return false
			end
			local itemValue = table.concat({...}, " ")
			itemValue = tonumber(itemValue) or itemValue

			-- skins
			if itemID == 16 then
				if not tonumber(itemValue) then
					outputChatBox("O ID da pele deve ser inteiro. Para roupas personalizadas, use Dupont NPC em vez.", thePlayer, 255, 0, 0)
					return false
				elseif itemValue == 300 and not exports.integration:isPlayerLeadAdmin(thePlayer) then
					outputChatBox("Você não tem permissões suficientes para gerar pele de cachorro.", thePlayer, 255, 0, 0)
					return false
				end
			end

			if itemID == 114 and exports.npc:getDisabledUpgrades()[tonumber(itemValue)] then
				outputChatBox("Este item está temporariamente desativado.", thePlayer, 255, 0, 0)
				return false
			end
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			local preventSpawn = exports["item-system"]:getItemPreventSpawn(itemID, itemValue)
			if preventSpawn then
				exports.hud:sendBottomNotification(thePlayer, "Item Não Spawnavel", "Este item não pode ser gerado. Pode ser temporariamente restrito ou apenas obtido IC.")
				return false
			end

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")

				if ( itemID == 84 ) and not exports.integration:isPlayerAdmin( thePlayer ) then
				elseif itemID == 114 and not exports.integration:isPlayerTrialAdmin( thePlayer ) then
				elseif (itemID == 262 or itemID ==263) and not exports.integration:isPlayerLeadAdmin(thePlayer) then
				elseif (itemID == 115 or itemID == 116 or itemID == 68 or itemID == 134 --[[or itemID == 137)]]) then
					outputChatBox("Desculpa, você não pode usar isso com /daritem.", thePlayer, 255, 0, 0)
				elseif (logged==0) then
					outputChatBox("Jogador não esta logado.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local name = call( getResourceFromName( "item-system" ), "getItemName", itemID, itemValue )

					if itemID > 0 and name and name ~= "?" then
						local success, reason = exports.global:giveItem(targetPlayer, itemID, itemValue)
						if success then
							outputChatBox("Player " .. targetPlayerName .. " recebeu um(a) " .. name .. " com valor " .. itemValue .. ".", thePlayer, 0, 255, 0)
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVEITEM "..name.." "..tostring(itemValue))
							triggerClientEvent(targetPlayer, "item:updateclient", targetPlayer)
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
							if (hiddenAdmin==0) then
								outputChatBox(tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " deu a você um(a) " .. name .. " com valor " .. itemValue .. ".", targetPlayer, 0, 255, 0)
							else
								outputChatBox("um Admin Oculto deu a você um(a) " .. name .. " com valor " .. itemValue .. ".", targetPlayer, 0, 255, 0)
							end
						else
							outputChatBox("Não pode dar a " .. targetPlayerName .. " um(a) " .. name .. ": " .. tostring(reason), thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("ID do Item Invalido.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("giveitem", givePlayerItem, false, false)
addCommandHandler("daritem", givePlayerItem, false, false)

-- /GIVEPEDITEM
function givePedItem(thePlayer, commandName, ped, itemID, ...)
	if (exports.integration:isPlayerHeadAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer)) then
		if not (itemID) or not (...) or not (ped) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Ped dbid] [ID Item] [Valor Item]", thePlayer, 255, 194, 14)
		else
			if ped then
				--local logged = getElementData(targetPlayer, "loggedin")
				local element = exports.pool:getElement("ped", tonumber(ped))
				local pedname = getElementData(element, "rpp.npc.name")
				itemID = tonumber(itemID)
				local itemValue = table.concat({...}, " ")
				itemValue = tonumber(itemValue) or itemValue

				if ( itemID == 74 or itemID == 150 or itemID == 75 or itemID == 78 or itemID == 2 or itemID == 216) and not exports.integration:isPlayerLeadAdmin( thePlayer) then -- Banned Items
					exports.hud:sendBottomNotification(thePlayer, "Itens Banidos", "Apenas Admin Senior+ pode spawnar este tipo de item.")
					return false
				elseif ( itemID == 84 ) and not exports.global:isPlayerAdmin( thePlayer ) then
				elseif itemID == 114 and not exports.global:isPlayerTrialAdmin( thePlayer ) then
				--elseif (itemID == 115 or itemID == 116) then
				--	outputChatBox("Not possible to use this item with /daritem, sorry.", thePlayer, 255, 0, 0)
				else
					local name = call( getResourceFromName( "item-system" ), "getItemName", itemID, itemValue )

					if itemID > 0 and name and name ~= "?" then
						local success, reason = exports.global:giveItem(element, itemID, itemValue)
						if success then
							outputChatBox("Ped "..tostring(pedname) or "".." (".. tostring(ped) ..") agora tem um(a)" .. name .. " com valor " .. itemValue .. ".", thePlayer, 0, 255, 0)
							exports.logs:dbLog(thePlayer, 4, ped, "GIVEITEM "..name.." "..tostring(itemValue))
							if element then
								exports['item-system']:npcUseItem(element, itemID)
							else
								outputChatBox("Failed to get ped element from dbid.", thePlayer, 255, 255, 255)
							end
						else
							outputChatBox("Não pode dar ao ped " .. tostring(ped) .. " um(a) " .. name .. ": " .. tostring(reason), thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("ID do Item Invalido.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("givepeditem", givePedItem, false, false)
addCommandHandler("daritemped", givePedItem, false, false)

local allowedFactions = {
	[147] = { ['80'] = true, ['89'] = true, ['95'] = true }, -- Dinoco
	[212] = { ['89'] = true, ['95'] = true }, -- Sparta Inc.
	[159] = { ['80'] = true, ['89'] = true, ['95'] = true }, -- Western Solutions LLC
}
	
function makeGenericItemCargo(thePlayer, admin, genericType, price, quantity, name, model, scale, texURL, texName)
	local itemID = (tonumber(genericType) == 1 and 80) or (tonumber(genericType) == 2 and 89) or (tonumber(genericType) == 3 and 95) or false
	
	-- faction checks
	local factionID, isLeader = false, false
	if not admin then
		factionID = exports.factions:getCurrentFactionDuty(thePlayer) or 0
		if (not allowedFactions[factionID]) or (not allowedFactions[factionID][tostring(itemID)]) then
			outputChatBox("Você precisa estar em modo trabalho de facção que possui o privilégio de spawnar item genérico.", thePlayer, 255, 0, 0)
			return false
		end
		isLeader = exports.factions:hasMemberPermissionTo(thePlayer, factionID, "add_member")
		if (not isLeader) then
			outputChatBox("Apenas líderes de facção podem gerar itens genéricos.", thePlayer, 255, 0, 0)
			return false
		end
	end
	-- end checks
	
	if getElementData(thePlayer, "loggedin") == 1 then
		local fPrice = exports.global:formatMoney(price)
		if not exports.global:takeMoney((factionID and exports.factions:getFactionFromID(factionID)) or thePlayer, price) then
			outputChatBox("Você" .. (factionID and "r facção" or "") .. " não pode pagar $" .. fPrice .. " por um(a) '" .. name .. "'.", thePlayer, 255, 0, 0)
			return false
		end

		local playerName = exports.global:getPlayerName(thePlayer)
		
		if not admin then
			exports.bank:addBankTransactionLog((factionID and -factionID) or getElementData(thePlayer, "account:character:id"), 0, price, 15, "Pedido de (" .. playerName .. ")")
		end
		
		local metadata = { ['item_name'] = name, ['model'] = model, ['scale'] = scale or 1 }

		if texURL and texName then
			metadata['url'] = texURL
			metadata['texture'] = texName
		end

		for k, v in pairs(metadata) do --fix for unwanted linebreaks
			if type(v) == "string" then
				metadata[k] = v:gsub("\n", "")
			end
		end

		for i = 1, tonumber(quantity) do
			local success, reason = (genericType == 1 and exports.global:giveItem(thePlayer, itemID, "1", metadata)) or exports.global:giveItem(thePlayer, itemID, name .. ":" .. model)
			if not success then
				outputChatBox("Falha ao criar alguns itens genéricos. O processo foi interrompido no item ".. tostring(i) .. "/" .. quantity .. ".", thePlayer, 255, 0, 0)
				outputChatBox("Razão: " .. reason, thePlayer, 255, 0, 0)
				break
			end
		end

		outputChatBox("[MAKEGENERIC] Você criou " .. quantity .. "x " .. name .. " por $" .. exports.global:formatMoney(price) .. ".", thePlayer, 100, 255, 100)
		exports.global:sendWrnToStaffOnDuty(playerName.." criou (".. quantity ..") '"..name.."' para eles mesmos por $"..fPrice..".", (admin and "ADMIN" or exports.factions:getFactionName(factionID)))
		exports.logs:dbLog(thePlayer, 4, thePlayer, (admin and "ADMIN" or exports.factions:getFactionName(factionID)) .. " makegeneric " .. name .. " (x" .. quantity .. ") for " .. fPrice)
		triggerClientEvent(thePlayer, "item:updateclient", thePlayer)

		return true
	end
end
addEvent("createCargoGeneric", true)
addEventHandler("createCargoGeneric", getResourceRootElement(), makeGenericItemCargo)

-- /TAKEITEM
function takePlayerItem(thePlayer, commandName, targetPlayer, itemID, ...)
    if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer)) then
        if not (itemID) or not (...) or not (targetPlayer) then
            outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID] [ID Item] [Valor Item]", thePlayer, 255, 194, 14)
        else
            local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
            if targetPlayer then
                local logged = getElementData(targetPlayer, "loggedin")
                local itemValue = table.concat({...}, " ")
                itemID = tonumber(itemID)
                itemValue = tonumber(itemValue) or itemValue
                local displayItemName = exports['item-system']:getItemName(itemID)
               
 
                if (logged==0) then
                    outputChatBox("Jogador não esta logado.", thePlayer, 255, 0, 0)
                elseif (logged==1) then
                    if exports.global:hasItem(targetPlayer, itemID, itemValue) then
                        if (commandName == "delplayeritem") or (commandName == "removeritem") then
                            outputChatBox("Você deletou o item " .. displayItemName .. " com o valor de (" .. itemValue .. ") do inventario de " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
                            exports.global:takeItem(targetPlayer, itemID, itemValue)
                            exports.logs:dbLog(thePlayer, 4, targetPlayer, "DELPLAYERITEM "..tostring(itemID).." "..tostring(itemValue))
                            triggerClientEvent(targetPlayer, "item:updateclient", targetPlayer)
                        elseif (commandName == "takeitem") or (commandName == "tiraritem") then
                            outputChatBox("Você retirou o item " .. displayItemName .. " com o valor de (" .. itemValue .. ") do inventario de " .. targetPlayerName .. " e transferiu para o seu inventario.", thePlayer, 0, 255, 0)
                            exports.global:takeItem(targetPlayer, itemID, itemValue)
                            exports.global:giveItem(thePlayer, itemID, itemValue)
                            exports.logs:dbLog(thePlayer, 4, targetPlayer, "TAKEITEM "..tostring(itemID).." "..tostring(itemValue))
                            triggerClientEvent(targetPlayer, "item:updateclient", targetPlayer)
                        end
                    else
                        outputChatBox("Jogador não possui este item.", thePlayer, 255, 0, 0)
                    end
                end
            end
        end
    end
end
addEvent("admin-system:takeItem", true)
addEventHandler("admin-system:takeItem", getRootElement(), takePlayerItem)
addCommandHandler("takeitem", takePlayerItem, false, false)
addCommandHandler("delplayeritem", takePlayerItem, false, false)
addCommandHandler("removeritem", takePlayerItem, false, false)
addCommandHandler("tiraritem", takePlayerItem, false, false)


-- /SETHP
function setPlayerHealth(thePlayer, commandName, targetPlayer, health)
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer)) then
		if not tonumber(health) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID] [Vida]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				if tonumber( health ) < getElementHealth( targetPlayer ) and getElementData( thePlayer, "admin_level" ) < getElementData( targetPlayer, "admin_level" ) then
					outputChatBox("Nah.", thePlayer, 255, 0, 0)
				elseif not setElementHealth(targetPlayer, tonumber(health)) then
					outputChatBox("Valor de Vida Invalido.", thePlayer, 255, 0, 0)
				else
					--mysql:query_free("UPDATE characters SET health=0 WHERE id="..getElementData(targetPlayer, 'dbid'))
					outputChatBox("Player " .. targetPlayerName .. " recebeu " .. health .. " de Vida.", thePlayer, 0, 255, 0)
					triggerEvent("onPlayerHeal", targetPlayer, true)
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETHP "..health)
				end
			end
		end
	end
end
addCommandHandler("sethp", setPlayerHealth, false, false)

function adminHeal(thePlayer, commandName, targetPlayer)
	if (exports.global:isStaffOnDuty(thePlayer)) then
		local health = 100
		local targetPlayerName = getPlayerName(thePlayer):gsub("_", " ")
		if not (targetPlayer) then
			targetPlayer = thePlayer
		else
			targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
		end

		if targetPlayer then
			setElementHealth(targetPlayer, tonumber(health))
			outputChatBox("Player " .. targetPlayerName .. " recebeu " .. health .. " de Vida.", thePlayer, 0, 255, 0)
			triggerEvent("onPlayerHeal", targetPlayer, true)
			exports.logs:dbLog(thePlayer, 4, targetPlayer, "AHEAL "..health)
		end
	end
end
addCommandHandler("aheal", adminHeal, false, false)
addCommandHandler("acurar", adminHeal, false, false)

--[[ /SETARMOR
function setPlayerArmour(thePlayer, commandName, targetPlayer, armor)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (armor) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID] [Armor]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged==0) then
					outputChatBox("Jogador não esta logado.", thePlayer, 255, 0, 0)
				elseif (tostring(type(tonumber(armor))) == "number") then
					local setArmor = setPedArmor(targetPlayer, tonumber(armor))
					outputChatBox("Player " .. targetPlayerName .. " recebeu " .. armor .. " Armor.", thePlayer, 0, 255, 0)
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETARMOR "..tostring(armor))
				else
					outputChatBox("Invalid armor value.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("setarmor", setPlayerArmour, false, false)
]]--

-- /SETARMOR
--Armor only for law enforcement members, unless admin is lead+. - Chuevo, 19/05/13
function setPlayerArmour(thePlayer, theCommand, targetPlayer, armor)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) or not (armor) then
			outputChatBox("SYNTAX: /" .. theCommand .. " [Nome Parcial Jogador / ID] [Tipo]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==1) then
					local currentArmor = tonumber(getPedArmor(thePlayer))
					if (tostring(type(tonumber(armor))) == "number") and tonumber(armor) < currentArmor then
						local targetPlayerFaction = getElementData(targetPlayer, "faction")
						if (targetPlayerFaction[1]) or (targetPlayerFaction[15]) or (targetPlayerFaction[59]) then
							local setArmor = setPedArmor(targetPlayer, tonumber(armor))
							outputChatBox("Player " .. targetPlayerName .. " recebeu " .. armor .. " de Colete.", thePlayer, 0, 255, 0)
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETARMOR " ..tostring(armor))
						elseif (not targetPlayerFaction[1]) or (not targetPlayerFaction[15]) or (not targetPlayerFaction[59]) then
							if (exports.integration:isPlayerAdmin(thePlayer)) then
								local setArmor = setPedArmor(targetPlayer, tonumber(armor))
								outputChatBox("Player " .. targetPlayerName .. " recebeu " .. armor .. " de Colete.", thePlayer, 0, 255, 0)
								exports.logs:dbLog(thePlayer, 4, tagetPlayer, "SETARMOR " ..tostring(armor))
							else
								outputChatBox("Este jogador não faz parte de uma facção da lei. Contate um administrador Lead+ para definir o colete.", thePlayer, 255, 0, 0)
							end
						end
					else
						outputChatBox("Este comando não é mais usado. Por Favor use /items com IDs 162, 219, 220 or 221.", thePlayer)
					end
				else
					outputChatBox("Jogador não esta logado.", thePlayer, 255, 0, 0)
				end
			end
		end

	end
end
addCommandHandler("setarmor", setPlayerArmour, false, false)


-- /SETSKIN
function setPlayerSkinCmd(thePlayer, commandName, targetPlayer, skinID, clothingID)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (skinID) or not (targetPlayer) then -- Clothing ID is a optional argument
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID] [Skin ID] (Roupa ID)", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged==0) then
					outputChatBox("Jogador não esta logado.", thePlayer, 255, 0, 0)
				elseif tostring(type(tonumber(skinID))) == "number" and tonumber(skinID) ~= 0 then
					if tonumber(skinID) == 300 and not exports.integration:isPlayerLeadAdmin(thePlayer) then return false end -- only senior+ can setskin dogs

					local fat = getPedStat(targetPlayer, 21)
					local muscle = getPedStat(targetPlayer, 23)

					setPedStat(targetPlayer, 21, 0)
					setPedStat(targetPlayer, 23, 0)
					local oldSkin = getElementModel(targetPlayer)
					--local skin = setElementModel(targetPlayer, tonumber(skinID))
					local data_name = exports.newmodels:getDataNameFromType("ped") -- gets the correct data name
					local skin = setElementData(targetPlayer, data_name, tonumber(skinID)) or setElementModel( targetPlayer, tonumber(skinID))-- sets the skin ID 



					setPedStat(targetPlayer, 21, fat)
					setPedStat(targetPlayer, 23, muscle)
					if not (skin) and tonumber(oldSkin) ~= tonumber(skin) then
						outputChatBox("ID Skin Invalida.", thePlayer, 255, 0, 0)
					else
						if not tonumber(clothingID) then
							outputChatBox("Player " .. targetPlayerName .. " recebeu skin " .. skinID .. ".", thePlayer, 0, 255, 0)
							setElementData(targetPlayer, 'clothing:id', nil, true)
							mysql:query_free("UPDATE characters SET skin = " .. mysql:escape_string(skinID) .. ", clothingid = NULL WHERE id=" .. mysql:escape_string(getElementData( targetPlayer, "dbid" ) .. "") )
							clothingID = ""
						else
							outputChatBox("Player " .. targetPlayerName .. " recebeu skin " .. skinID .. " e roupa " .. clothingID  .. ".", thePlayer, 0, 255, 0)
							setElementData(targetPlayer, 'clothing:id', tonumber(clothingID), true)
							mysql:query_free("UPDATE characters SET skin = " .. mysql:escape_string(skinID) .. ", clothingid = " .. mysql:escape_string(clothingID) .. " WHERE id=" .. mysql:escape_string(getElementData( targetPlayer, "dbid" ) .. "") )
						end

						exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETSKIN "..tostring(skinID).." CLOTHING "..tostring(clothingID))
					end
				else
					outputChatBox("ID Skin Invalida.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("setskin", setPlayerSkinCmd, false, false)

-- /CHANGENAME
function asetPlayerName(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isStaffOnDuty(thePlayer)) then
		if not (...) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID] [Novo Nome Jogador]", thePlayer, 255, 194, 14)
		else
			local newName = table.concat({...}, "_")
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local hoursPlayed = getElementData( targetPlayer, "hoursplayed" )
				if hoursPlayed > 5 and not exports.integration:isPlayerAdmin(thePlayer) then
					outputChatBox( "Apenas administrador regular ou superior pode alterar o nome do personagem com mais de 5 horas.", thePlayer, 255, 0, 0)
					return false
				end
				if newName == targetPlayerName then
					outputChatBox( "O nome do jogador já é esse.", thePlayer, 255, 0, 0)
				else
					local dbid = getElementData(targetPlayer, "dbid")
					local result = mysql:query("SELECT charactername FROM characters WHERE charactername='" .. mysql:escape_string(newName) .. "' AND id != " .. mysql:escape_string(dbid))

					if (mysql:num_rows(result)>0) then
						outputChatBox("Este nome já esta em uso.", thePlayer, 255, 0, 0)
					else
						exports.anticheat:changeProtectedElementDataEx(targetPlayer, "legitnamechange", 1, false)
						local name = setPlayerName(targetPlayer, tostring(newName))

						if (name) then
							exports['cache']:clearCharacterName( dbid )
							mysql:query_free("UPDATE characters SET charactername='" .. mysql:escape_string(newName) .. "' WHERE id = " .. mysql:escape_string(dbid))
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

							local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
							local processedNewName = string.gsub(tostring(newName), "_", " ")
							if (hiddenAdmin==0) then
								exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " mudou o nome de " .. targetPlayerName .. " para " .. newName .. ".")
								outputChatBox("O nome do seu personagem foi alterado de '"..targetPlayerName .. "' para '" .. tostring(newName) .. "' por "..adminTitle.." "..getPlayerName(thePlayer)..".", targetPlayer, 0, 255, 0)
							else
								outputChatBox("O nome do seu personagem foi alterado de '"..targetPlayerName .. "' para " .. processedNewName .. "' por um Admin Oculto.", targetPlayer, 0, 255, 0)
							end
							outputChatBox("Você mudou o nome de " .. targetPlayerName .. " para '" .. processedNewName .. "'.", thePlayer, 0, 255, 0)

							exports.anticheat:changeProtectedElementDataEx(targetPlayer, "legitnamechange", 0, false)

							exports.logs:dbLog(thePlayer, 4, targetPlayer, "CHANGENAME "..targetPlayerName.." -> "..tostring(newName))
							--triggerClientEvent(targetPlayer, "updateName", targetPlayer, getElementData(targetPlayer, "dbid"))
						else
							outputChatBox("Erro ao mudar nome.", thePlayer, 255, 0, 0)
						end
						exports.anticheat:changeProtectedElementDataEx(targetPlayer, "legitnamechange", 0, false)
					end
					mysql:free_result(result)
				end
			end
		end
	end
end
addCommandHandler("changename", asetPlayerName, false, false)
addCommandHandler("mudarnome", asetPlayerName, false, false)

-- /HIDEADMIN
function hideAdmin(thePlayer, commandName)
	if exports.integration:isPlayerHeadAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer) then
		local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

		if (hiddenAdmin==0) then
			exports.anticheat:changeProtectedElementDataEx(thePlayer, "hiddenadmin", 1, true)
			outputChatBox("Admin Oculto - ON", thePlayer, 255, 194, 14)
		elseif (hiddenAdmin==1) then
			exports.anticheat:changeProtectedElementDataEx(thePlayer, "hiddenadmin", 0, true)
			outputChatBox("Admin Oculto - OFF", thePlayer, 255, 194, 14)
		end
		exports.global:updateNametagColor(thePlayer)
		mysql:query_free("UPDATE account_details SET hiddenadmin=" .. mysql:escape_string(getElementData(thePlayer, "hiddenadmin")) .. " WHERE account_id = " .. mysql:escape_string(getElementData(thePlayer, "account:id")) )
	end
end
addCommandHandler("hideadmin", hideAdmin, false, false)
addCommandHandler("adminoculto", hideAdmin, false, false)

-- /SLAP
function slapPlayer(thePlayer, commandName, targetPlayer)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local thePlayerPower = exports.global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.global:getPlayerAdminLevel(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged==0) then
					outputChatBox("Jogador não esta logado.", thePlayer, 255, 0, 0)
				elseif (targetPlayerPower > thePlayerPower) then -- Check the admin isn't slapping someone higher rank them him
					outputChatBox("Você não pode dar um tapa neste jogador, pois ele é um administrador superior do que você.", thePlayer, 255, 0, 0)
				else
					local x, y, z = getElementPosition(targetPlayer)

					if (isPedInVehicle(targetPlayer)) then
						exports.anticheat:changeProtectedElementDataEx(targetPlayer, "realinvehicle", 0, false)
						removePedFromVehicle(targetPlayer)
					end
					detachElements(targetPlayer)

					setElementPosition(targetPlayer, x, y, z+15)
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

					if (hiddenAdmin==0) then
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " slapped " .. targetPlayerName .. ".")
					end
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "SLAP")
				end
			end
		end
	end
end
addCommandHandler("slap", slapPlayer, false, false)

-- HEADS Hidden OOC
function hiddenOOC(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")

	if (exports.integration:isPlayerHeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Mensagem]", thePlayer, 255, 194, 14)
		else
			local players = exports.pool:getPoolElementsByType("player")
			local message = table.concat({...}, " ")

			for index, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")

				if (logged==1) and getElementData(arrayPlayer, "globalooc") == 1 then
					outputChatBox("(( Admin Oculto: " .. message .. " ))", arrayPlayer, 255, 255, 255)
				end
			end
		end
	end
end
addCommandHandler("ho", hiddenOOC, false, false)
addCommandHandler("ocultoooc", hiddenOOC, false, false)

-- HEADS Hidden Whisper
function hiddenWhisper(thePlayer, command, who, ...)
	if (exports.integration:isPlayerHeadAdmin(thePlayer)) then
		if not (who) or not (...) then
			outputChatBox("SYNTAX: /" .. command .. " [Nome Parcial Jogador / ID] [Mensagem]", thePlayer, 255, 194, 14)
		else
			message = table.concat({...}, " ")
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, who)

			if (targetPlayer) then
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged==1) then
					local playerName = getPlayerName(thePlayer)
					outputChatBox("PM deu Admin Oculto: " .. message, targetPlayer, 255, 194, 14)
					outputChatBox("PM oculto enviado para " .. targetPlayerName .. ": " .. message, thePlayer, 255, 194, 14)
				elseif (logged==0) then
					outputChatBox("Jogador não esta logado ainda.", thePlayer, 255, 194, 14)
				end
			end
		end
	end
end
addCommandHandler("hw", hiddenWhisper, false, false)

-- Kick
function kickAPlayer(thePlayer, commandName, targetPlayer, ...)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador] [Razão]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local thePlayerPower = exports.global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.global:getPlayerAdminLevel(targetPlayer)
				reason = table.concat({...}, " ")

				if (targetPlayerPower <= thePlayerPower) then
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local playerName = getPlayerName(thePlayer)

					addAdminHistory(targetPlayer, thePlayer, reason, 1 , 0)
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "PKICK "..reason)
					if (hiddenAdmin==0) then
						if commandName ~= "skick" or commandName ~= "kickar" then
							local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
							exports.global:sendMessageToAdmins("AdmCmd: " .. adminTitle .. " " .. playerName .. " kickou o jogador " .. targetPlayerName .. " por: ".. reason .. ".")
							outputChatBox("AdmCmd: " .. adminTitle .. " " .. playerName .. " kickou o jogador " .. targetPlayerName .. " por: ".. reason .. ".", thePlayer, 252, 115, 87)
							--exports.global:sendMessageToAdmins("AdmCmd: Motivo: " .. reason .. ".")

						end
						kickPlayer(targetPlayer, thePlayer, reason)
					else
						if commandName ~= "skick" or commandName ~= "kickar" then
							exports.global:sendMessageToAdmins("AdmCmd: "..targetPlayerName.." foi kickado do servidor por:".. reason .."." )
								outputChatBox("AdmCmd: "..targetPlayerName.." foi kickado do servidor por:".. reason ..".", thePlayer, 252, 115, 87)
							--exports.global:sendMessageToAdmins("AdmCmd: Razão: " .. reason .. ".")
						end
						kickPlayer(targetPlayer, getRootElement(), reason)
					end

				else
					outputChatBox(" Este jogador é um administrador de nível superior do que você.", thePlayer, 255, 0, 0)
					outputChatBox(playerName .. " tentou executar o comando de kick em você.", targetPlayer, 255, 0 ,0)
				end
			end
		end
	end
end
addCommandHandler("pkick", kickAPlayer, false, false)
addCommandHandler("skick", kickAPlayer, false, false)
addCommandHandler("kickar", kickAPlayer, false, false)

--MAXIME
function setMoney(thePlayer, commandName, target, money, ...)
	if exports["integration"]:isPlayerScripter(thePlayer) then
		if not (target) or not money or not tonumber(money) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador] [Dinheiro] [Razão]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)

			if targetPlayer then
				money = tonumber(money) or 0
				if money and money > 500000 then
					outputChatBox("Por razões de segurança, você não tem permissão para definir mais de $ 500.000 de uma vez para um jogador.", thePlayer, 255, 0, 0)
					return false
				end

				if not exports.global:setMoney(targetPlayer, money) then
					outputChatBox("Não foi possível definir esse valor.", thePlayer, 255, 0, 0)
					return false
				end

				exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETMONEY "..money)


				local amount = exports.global:formatMoney(money)
				reason = table.concat({...}, " ")
				outputChatBox(targetPlayerName .. " recebeu " .. amount .. " $.", thePlayer)
				outputChatBox("Admin " .. username .. " setou seu dinheiro para " .. amount .. " $.", targetPlayer)
				outputChatBox("Razão: " .. reason .. ".", targetPlayer)
				local targetUsername = string.gsub(getElementData(targetPlayer, "account:username"), "_", " ")
				targetUsername = mysql:escape_string(targetUsername)
				local targetCharacterName = mysql:escape_string(targetPlayerName)


				if tonumber(money) >= 5000 then
					local content = {
						{"Admin:", username},
						{"Definiu dinheiro para o usuário:", targetUsername},
						{"Nome Personagem:", targetCharacterName},
						{"Quantia:", "$"..amount},
						{"Razão:", reason}
					}
					triggerEvent("integration:createForumThread", resourceRoot, 62, "/"..commandName.." $"..amount.." para ("..targetUsername..") "..targetCharacterName, content)
				end
				--exports.global:sendMessageToAdmins("[SETMONEY] Admin " .. username .. " definiu dinheiro de ("..targetUsername..") "..targetCharacterName.." para $" .. amount.." ("..reason..")." )
			end
		end
	end
end
addCommandHandler("setmoney", setMoney, false, false)

--MAXIME
function giveMoney(thePlayer, commandName, target, money, ...)
	if exports["integration"]:isPlayerScripter(thePlayer) then
		if not (target) or not money or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador] [Dinheiro] [Razão]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)

			if targetPlayer then
				money = tonumber(money) or 0
				if money and money > 500000 then
					outputChatBox("Por razões de segurança, você só pode dar a um jogador menos de $ 500.000 de uma vez.", thePlayer, 255, 0, 0)
					return false
				end

				if not exports.global:giveMoney(targetPlayer, money) then
					outputChatBox("Não foi possível dar ao jogador aquela quantia.", thePlayer, 255, 0, 0)
					return false
				end

				exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVEMONEY " ..money)


				local amount = exports.global:formatMoney(money)
				reason = table.concat({...}, " ")
				outputChatBox("Você deu " .. targetPlayerName .. " $" .. amount .. ".", thePlayer)
				outputChatBox("Admin " .. username .. " deu a você: $" .. amount .. ".", targetPlayer)
				outputChatBox("Razão: " .. reason .. ".", targetPlayer)

				local targetUsername = string.gsub(getElementData(targetPlayer, "account:username"), "_", " ")
				targetUsername = mysql:escape_string(targetUsername)
				local targetCharacterName = mysql:escape_string(targetPlayerName)


				if tonumber(money) >= 1 then
					local content = {
						{"Admin:", username},
						{"Spawnado para o usuario:", targetUsername},
						{"Nome Personagem:", targetCharacterName},
						{"Quantia:", "$"..amount},
						{"Razão:", reason}
					}

					--triggerEvent("integration:createForumThread", resourceRoot, 62, "/"..commandName.." $"..amount.." para ("..targetUsername..") "..targetCharacterName, content)
				end
				--exports.global:sendMessageToAdmins("[GIVEMONEY] Admin " .. username .. " deu a ("..targetUsername..") "..targetCharacterName.." $" .. amount .. " ("..reason..").")
			end
		end
	end
end
addCommandHandler("givemoney", giveMoney, false, false)

--MAXIME
function takeMoney(thePlayer, commandName, target, money, ...)
	if exports["integration"]:isPlayerScripter(thePlayer) then
		if not (target) or not money or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador] [Dinheiro] [Razão]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)

			if targetPlayer then
				money = tonumber(money) or 0
				local amount = exports.global:formatMoney(money)
				if not exports.global:takeMoney(targetPlayer, money) then
					outputChatBox("Não foi possível tirar $"..amount.." do jogador.", thePlayer, 255, 0, 0)
					return false
				end

				exports.logs:dbLog(thePlayer, 4, targetPlayer, "TAKEMONEY " ..money)

				outputChatBox("Você tirou do inventario de " .. targetPlayerName .. " $" .. amount .. ".", thePlayer)
				outputChatBox("Admin " .. username .. " tirou de você: $" .. amount .. ".", targetPlayer)

				local targetUsername = string.gsub(getElementData(targetPlayer, "account:username"), "_", " ")
				targetUsername = mysql:escape_string(targetUsername)
				local targetCharacterName = mysql:escape_string(targetPlayerName)
				reason = table.concat({...}, " ")
				if tonumber(money) >= 5000 then
					local content = {
						{"Admin:", username},
						{"Retirou do usuario:", targetUsername},
						{"Nome Personagem:", targetCharacterName},
						{"Quantia:", "$"..amount},
						{"Razão:", reason}
					}

					triggerEvent("integration:createForumThread", resourceRoot, 62, "/"..commandName.." $"..amount.." de ("..targetUsername..") "..targetCharacterName, content)
				end
				exports.global:sendMessageToAdmins("[TAKEMONEY] Admin " .. username .. " retirou de ("..targetUsername..") "..targetCharacterName.." $" .. amount .. ". ("..reason..")")
			end
		end
	end
end
addCommandHandler("takemoney", takeMoney, false, false)

-----------------------------------[FREEZE]----------------------------------
function freezePlayer(thePlayer, commandName, target)
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			if targetPlayer then
				local textStr = "admin"
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				local veh = getPedOccupiedVehicle( targetPlayer )
				if (veh) then
					setElementFrozen(veh, true)
					toggleAllControls(targetPlayer, false, true, false)
					outputChatBox(" Você foi congelado por um ".. textStr ..". Tome cuidado ao seguir as instruções.", targetPlayer)
					outputChatBox(" Você congelou " ..targetPlayerName.. ".", thePlayer)
				else
					detachElements(targetPlayer)
					toggleAllControls(targetPlayer, false, true, false)
					setElementFrozen(targetPlayer, true)
					setPedWeaponSlot(targetPlayer, 0)
					exports.anticheat:changeProtectedElementDataEx(targetPlayer, "freeze", 1, false)
					outputChatBox(" Você foi congelado por um ".. textStr ..". Tome cuidado ao seguir as instruções.", targetPlayer)
					outputChatBox(" Você congelou " ..targetPlayerName.. ".", thePlayer)
				end

				local username = getPlayerName(thePlayer)
				exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. username .. " congelou " .. targetPlayerName .. ".")
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "FREEZE")
			end
		end
	end
end
addCommandHandler("freeze", freezePlayer, false, false)
addCommandHandler("congelar", freezePlayer, false, false)
addEvent("remoteFreezePlayer", true )
addEventHandler("remoteFreezePlayer", getRootElement(), freezePlayer)

-----------------------------------[UNFREEZE]----------------------------------
function unfreezePlayer(thePlayer, commandName, target)
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " /descongelar [Nome Parcial Jogador]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			if targetPlayer then
				local textStr = "admin"
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)

				local veh = getPedOccupiedVehicle( targetPlayer )
				if (veh) then
					setElementFrozen(veh, false)
					toggleAllControls(targetPlayer, true, true, true)
					if (isElement(targetPlayer)) then
						outputChatBox(" Você foi descongelado por um ".. textStr ..". Obrigado pela sua cooperação.", targetPlayer)
					end

					if (isElement(thePlayer)) then
						outputChatBox(" Você descongelou " ..targetPlayerName.. ".", thePlayer)
					end
				else
					toggleAllControls(targetPlayer, true, true, true)
					setElementFrozen(targetPlayer, false)
					-- Disable weapon scrolling if restrained
					if getElementData(targetPlayer, "restrain") == 1 then
						setPedWeaponSlot(targetPlayer, 0)
						toggleControl(targetPlayer, "next_weapon", false)
						toggleControl(targetPlayer, "previous_weapon", false)
					end
					exports.anticheat:changeProtectedElementDataEx(targetPlayer, "freeze", false, false)
					outputChatBox(" Você foi descongelado por um ".. textStr ..". Obrigado pela sua cooperação.", targetPlayer)
					outputChatBox(" Você descongelou " ..targetPlayerName.. ".", thePlayer)
				end

				local username = getPlayerName(thePlayer)
				exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. username .. " descongelou " .. targetPlayerName .. ".")
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNFREEZE")
			end
		end
	end
end
addCommandHandler("unfreeze", unfreezePlayer, false, false)
addCommandHandler("descongelar", unfreezePlayer, false, false)

function adminDuty(thePlayer, commandName)
	if exports.integration:isPlayerTrialAdmin(thePlayer) then
		local adminduty = getElementData(thePlayer, "duty_admin")
		local username = getPlayerName(thePlayer)

		if adminduty == 0 then
			triggerClientEvent(thePlayer, "accounts:settings:updateAccountSettings", thePlayer, "duty_admin", 1)
			exports.global:sendMessageToAdmins("AdmDuty: " .. username .. " entrou em modo trabalho.")
		else
			triggerClientEvent(thePlayer, "accounts:settings:updateAccountSettings", thePlayer, "duty_admin", 0)
			exports.global:sendMessageToAdmins("AdmDuty: " .. username .. " saiu do modo trabalho.")
			if getElementData(thePlayer, "supervising") == true then
				setElementData(thePlayer, "supervising", false)
				setElementData(thePlayer, "supervisorBchat", false)
				setElementAlpha(thePlayer, 255)
			end
		end
	end
end
addCommandHandler("adminduty", adminDuty, false, false)
addCommandHandler("aduty", adminDuty, false, false)
addCommandHandler("atrabalho", adminDuty, false, false)
addEvent("admin-system:adminduty", true)
addEventHandler("admin-system:adminduty", getRootElement(), adminDuty)


function gmDuty(thePlayer, commandName)
	if exports.integration:isPlayerSupporter(thePlayer) then

		local gmDuty = getElementData(thePlayer, "duty_supporter") or false
		local username = getPlayerName(thePlayer)


		if gmDuty == 0 then
			triggerClientEvent(thePlayer, "accounts:settings:updateAccountSettings", thePlayer, "duty_supporter", 1)
			exports.global:sendMessageToAdmins("SDuty: " .. username .. " entrou em modo trabalho.")
		elseif gmDuty == 1 then
			triggerClientEvent(thePlayer, "accounts:settings:updateAccountSettings", thePlayer, "duty_supporter", 0)
			exports.global:sendMessageToAdmins("SDuty: " .. username .. " saiu do modo trabalho.")
		end
	end
end
addCommandHandler("sduty", gmDuty, false, false)
addCommandHandler("gduty", gmDuty, false, false)
addEvent("admin-system:gmduty", true)
addEventHandler("admin-system:gmduty", getRootElement(), gmDuty)

-- GET PLAYER ID
function getPlayerID(thePlayer, commandName, target)
	if not (target) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador]", thePlayer, 255, 194, 14)
	else
		local username = getPlayerName(thePlayer)
		local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)

		if targetPlayer then
			local logged = getElementData(targetPlayer, "loggedin")
			if (logged==1) then
				local id = getElementData(targetPlayer, "playerid")
				outputChatBox("** " .. targetPlayerName .. "'s possui o ID " .. id .. ".", thePlayer, 255, 194, 14)
			else
				outputChatBox("Jogador não esta logado.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("getid", getPlayerID, false, false)
addCommandHandler("id", getPlayerID, false, false)

--[[ EJECT
function ejectPlayer(thePlayer, commandName, target)
	if not target then
		if isPedInVehicle(thePlayer) then
			outputChatBox("You have thrown yourself out of your vehicle.", thePlayer, 0, 255, 0)
			removePedFromVehicle(thePlayer)
			exports.anticheat:changeProtectedElementDataEx(targetPlayer, "realinvehicle", 0, false)
			local x, y, z = getElementPosition(thePlayer)
			setElementPosition(thePlayer, x, y, z+3)
		else
			outputChatBox("Você não esta em um veículo.", thePlayer, 255, 0, 0)
		end
	else
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle or exports.integration:isPlayerTrialAdmin(thePlayer) then
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			local targetVehicle = getPedOccupiedVehicle(targetPlayer)
			if targetVehicle and (targetVehicle == theVehicle or exports.integration:isPlayerTrialAdmin(thePlayer)) then
				outputChatBox("This player is not in your vehicle.", thePlayer, 255, 0, 0)
			else
				outputChatBox("You have thrown " .. targetPlayerName .. " out of your vehicle.", thePlayer, 0, 255, 0)
				removePedFromVehicle(targetPlayer)
				exports.anticheat:changeProtectedElementDataEx(targetPlayer, "realinvehicle", 0, false)
				local x, y, z = getElementPosition(targetPlayer)
				setElementPosition(targetPlayer, x, y, z+2)
			end
		else
			outputChatBox("Você não esta em um veículo", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("eject", ejectPlayer, false, false) ]]--

--Temporary eject (Chuevo, 09/04/13)
function ejectPlayer(thePlayer, commandName, target)
	if not (target) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador]", thePlayer, 255, 194, 14)
	else
		if not (isPedInVehicle(thePlayer)) then
			outputChatBox("Você não esta em um veículo.", thePlayer, 255, 0, 0)
		else
			local vehicle = getPedOccupiedVehicle(thePlayer)
			local seat = getPedOccupiedVehicleSeat(thePlayer)

			if (seat~=0) then
				outputChatBox("Você precias ser o motorista para ejetar.", thePlayer, 255, 0, 0)
			else
				local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)

				if not (targetPlayer) then
				elseif (targetPlayer==thePlayer) then
					outputChatBox("Você não pode se auto ejetar.", thePlayer, 255, 0, 0)
				else
					local targetvehicle = getPedOccupiedVehicle(targetPlayer)

					if targetvehicle~=vehicle and not exports.integration:isPlayerTrialAdmin(thePlayer) then
						outputChatBox("Este jogador não esta em seu veículo.", thePlayer, 255, 0, 0)
					else
						outputChatBox("Você ejetou " .. targetPlayerName .. " de seu veículo.", thePlayer, 0, 255, 0)
						removePedFromVehicle(targetPlayer)
						exports.anticheat:changeProtectedElementDataEx(targetPlayer, "realinvehicle", 0, false)
						triggerEvent("removeTintName", targetPlayer)
					end
				end
			end
		end
	end
end
addCommandHandler("eject", ejectPlayer, false, false)
addCommandHandler("ejetar", ejectPlayer, false, false)

-- WARNINGS
function warnPlayer(thePlayer, commandName, targetPlayer, ...)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador] [Razão]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local thePlayerPower = exports.global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.global:getPlayerAdminLevel(targetPlayer)
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				local targetPlayerAdminTitle = exports.global:getPlayerAdminTitle(targetPlayer)
				local thePlayerUsername = getElementData(thePlayer, "account:username")
				local targetPlayerUsername = getElementData(targetPlayer, "account:username")
				if (targetPlayerPower > thePlayerPower) then
					exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " ("..thePlayerUsername..") tentou executar comando /aviso em um rank superior "..targetPlayerAdminTitle.." "..targetPlayerName.." ("..targetPlayerUsername..").")
					return false
				end

				local accountID = getElementData(targetPlayer, "account:id")
				if not accountID then
					return
				end

				local fetchData = mysql:query_fetch_assoc("SELECT `warns` FROM `account_details` WHERE `account_id`='"..mysql:escape_string(accountID).."'")

				local adminUsername = getElementData(thePlayer, "account:username")
				local playerName = getPlayerName(thePlayer)

				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				if hiddenAdmin == 1 then
					adminTitle = "Oculto"
					adminUsername = "Admin"
				end

				local warns = fetchData["warns"] or 0
				reason = table.concat({...}, " ")
				warns = warns + 1

				mysql:query_free("UPDATE account_details SET warns=" .. mysql:escape_string(warns) .. ", monitored = 'Was warned for " .. tostring(reason):gsub("'","''").."' WHERE account_id = " .. mysql:escape_string(accountID) )
				outputChatBox("Você deu " .. targetPlayerName .. " um aviso. (" .. warns .. "/3).", thePlayer, 255, 0, 0)
				outputChatBox("Você recebeu um aviso de " .. adminTitle.." "..adminUsername .. ".", targetPlayer, 255, 0, 0)
				outputChatBox("Razão: " .. reason, targetPlayer, 255, 0, 0)

				exports.anticheat:changeProtectedElementDataEx(targetPlayer, "warns", warns, false)
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "WARN "..warns .. ": " .. reason)


				addAdminHistory(targetPlayer, thePlayer, reason, 4 , 0)

				exports.global:sendMessageToAdmins("[WARN]: " .. adminTitle .. " " .. adminUsername .. " deu um aviso a " .. targetPlayerName .. ". (" .. warns .. "/3)")
				exports.global:sendMessageToAdmins("[WARN]: Razão: " .. reason)

				if (warns>=3) then
					addAdminHistory(targetPlayer, thePlayer, warns .. ' Admin Warnings', 5 , 0)
					exports.bans:addToBan(accountID, getPlayerSerial(targetPlayer), getPlayerIP(targetPlayer), 0, "3 Admin Warnings")
					kickPlayer(targetPlayer, getRootElement(), "Banido automaticamente devido à regra de avisos 3/3.")
					for index, player in pairs(getElementsByType("player")) do
						if tonumber( getElementData( player, "punishment_notification_selector") ) ~= 1 or player == thePlayer or player == targetPlayer then
							outputChatBox("[BAN]: " .. targetPlayerName .. " foi banido automaticamente devido à regra de avisos 3/3.", player, 255, 0, 0)
						end
					end
				else
					local countedWarns = 0
					local result = mysql:query_fetch_assoc("SELECT SUM(`warns`) AS warns FROM `account_details` WHERE `ip`='" .. mysql:escape_string( getPlayerIP(targetPlayer) ) .. "' OR mtaserial='" .. mysql:escape_string( getPlayerSerial(targetPlayer) ) .."'")
					if result then
						countedWarns = tonumber( result.warns )
						if (countedWarns >= 3) then
							addAdminHistory(targetPlayer, thePlayer, warns .. ' Avisos de administrador em várias contas.', 5 , 0)
							--banPlayerSerial(targetPlayer, thePlayer, "Received " .. warns .. " admin warnings over multiple accounts.", false)
							--banPlayer(targetPlayer, false, false, true, thePlayer, "Received " .. warns .. " admin warnings over multiple accounts.")
							--mysql:query_free("UPDATE accounts SET banned='1', banned_reason='3 Admin Warnings', banned_by='Warn System' WHERE id='" .. mysql:escape_string(accountID) .. "'")
							exports.bans:addToBan(accountID, getPlayerSerial(targetPlayer), getPlayerIP(targetPlayer), 0, "3 Admin Warnings")
						end
					end
				end
			end
		end
	end
end
--addCommandHandler("warn", warnPlayer, false, false)

-- RESET CHARACTER
function resetCharacter(thePlayer, commandName, ...)
    if exports.integration:isPlayerAdmin(thePlayer) then
        if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [nome personagem exato]", thePlayer, 255, 0, 0)
        else
            local character = table.concat({...}, "_")
            if getPlayerFromName(character) then
				kickPlayer(getPlayerFromName(character), "Character Reset")
            end
            local result = mysql:query_fetch_assoc("SELECT id, account FROM characters WHERE charactername='" .. mysql:escape_string(character) .. "'")
            local charid = tonumber(result["id"])
            local account = tonumber(result["account"])
            if charid then
                -- delete all in-game vehicles
                for key, value in pairs( getElementsByType( "vehicle" ) ) do
                    if isElement( value ) then
                        if getElementData( value, "owner" ) == charid then
                            call( getResourceFromName( "item-system" ), "deleteAll", 3, getElementData( value, "dbid" ) )
                            destroyElement( value )
                        end
                    end
                end

				local admAccID = getElementData( thePlayer, "account:id" )

                mysql:query_free("UPDATE `vehicles` SET `deleted`='"..mysql:escape_string(admAccID).."' WHERE owner = " .. mysql:escape_string(charid) )

                -- un-rent all interiors
                local old = getElementData( thePlayer, "dbid" )
                exports.anticheat:changeProtectedElementDataEx( thePlayer, "dbid", charid, false )
                local result = mysql:query("SELECT id FROM interiors WHERE owner = " .. mysql:escape_string(charid) .. " AND type != 2" )
                if result then
                    local continue = true
                    while continue do
                        local row = mysql:fetch_assoc(result)
                        if not row then break end
                        local id = tonumber(row["id"])
                        call( getResourceFromName( "interior_system" ), "publicSellProperty", thePlayer, id, false, false )
                    end
                end

                exports.anticheat:changeProtectedElementDataEx( thePlayer, "dbid", old, false )
                -- get rid of all items, give him default items back
                mysql:query_free("DELETE FROM items WHERE type = 1 AND owner = " .. mysql:escape_string(charid) )
                -- get the skin
                local skin = 264
                local skinr = mysql:query_fetch_assoc("SELECT skin FROM characters WHERE id = " .. mysql:escape_string(charid) )
                if skinr then
                    skin = tonumber(skinr["skin"]) or 264
                end
                mysql:query_free("INSERT INTO items (type, owner, itemID, itemValue) VALUES (1, " .. mysql:escape_string(charid) .. ", 16, " .. mysql:escape_string(skin) .. ")" )
                mysql:query_free("INSERT INTO items (type, owner, itemID, itemValue) VALUES (1, " .. mysql:escape_string(charid) .. ", 17, 1)" )
                mysql:query_free("INSERT INTO items (type, owner, itemID, itemValue) VALUES (1, " .. mysql:escape_string(charid) .. ", 18, 1)" )
                -- delete wiretransfers
                mysql:query_free("DELETE FROM wiretransfers WHERE `from` = " .. mysql:escape_string(charid) .. " OR `to` = " .. mysql:escape_string(charid) )
                -- set spawn at unity, strip off money etc
                if mysql:query_free("UPDATE characters SET `money`='500', `bankmoney`='1000' WHERE id = " .. mysql:escape_string(charid) ) then
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

					local adminTitle = exports.global:getAdminTitle1(thePlayer)
					if (hiddenAdmin==1) then
						adminTitle = "um Admin Oculto"
					end

					exports.global:sendMessageToAdmins("[RESET-CHARACTER]: " .. tostring(adminTitle) .. " resetou " .. character .. ".")
					exports.logs:dbLog(thePlayer, 4, "ch"..tostring(charid), "RESETCHARACTER")
				else
					outputChatBox("Error ao resetar o " .. character .. ".", thePlayer)
				end

            else
                outputChatBox("Não foi possivel achar " .. character, thePlayer, 255, 0, 0)
            end
        end
	end
end
addCommandHandler("resetcharacter", resetCharacter)
addCommandHandler("resetarpersonagem", resetCharacter)

-- MAXIME
local characters = {}
function resetAccount(thePlayer, commandName, accountName)
	if not exports.integration:isPlayerAdmin(thePlayer) then
		return false
	end
	if not accountName then
		outputChatBox("SYNTAX: /" .. commandName .. " [nome usuario exato] - Resetar um personagem ou todos os personagens de uma conta.", thePlayer, 255, 194, 14)
		return false
	end
	characters[thePlayer] = {}

	local cmSQL = mysql:query( "SELECT `charactername`, `money`, `bankmoney`, `hoursplayed` FROM `characters` WHERE `account`='"..mysql:escape_string(exports.cache:getIdFromUsername(accountName)).."' ORDER BY `lastlogin` DESC ")

	local count = 0
	while true do
		local row = mysql:fetch_assoc(cmSQL) or false
		if not row then
			break
		end
		table.insert(characters[thePlayer], { (row["charactername"]), tonumber(row["money"]),tonumber(row["bankmoney"]),tonumber(row["hoursplayed"])} )
		count = count + 1
	end
	mysql:free_result(cmSQL)

	if count > 0 then
		outputChatBox("Resetando "..count.." personagens dentro da conta '" .. accountName .. "':", thePlayer, 255, 194, 14)
		outputChatBox("   0. All", thePlayer , 255, 194, 14)
		for i = 1, #characters[thePlayer] do
			outputChatBox("   "..i..". "..tostring(characters[thePlayer][i][1]):gsub("_", " ").." - Dinheiro em mãos: $"..exports.global:formatMoney(characters[thePlayer][i][2]).." - Dinheiro do banco: $"..exports.global:formatMoney(characters[thePlayer][i][3]), thePlayer , 255, 194, 14)
		end
		setElementData(thePlayer, "admin-system:canAccessRS", true)
		outputChatBox("/rs [Numero] para resetar.", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("resetaccount", resetAccount)
addCommandHandler("resetarconta", resetAccount)

function resetAccountCmd(thePlayer, command, index)
	if getElementData(thePlayer, "admin-system:canAccessRS") and tonumber(index) and (tonumber(index)>= 0)  then
		--setElementData(thePlayer, "admin-system:canAccessRS", false)
		index = math.floor(tonumber(index))

		if index > 0 then
			if not characters[thePlayer][index] then
				outputChatBox("Index Invalido.", thePlayer, 255, 0, 0)
				return false
			end
			resetCharacter(thePlayer, "resetcharacter" , characters[thePlayer][index][1])
		elseif index == 0 then
			local timerDelay = 0
			for i = 1, #characters[thePlayer] do
				timerDelay = timerDelay + 1000
				setTimer(function()
					resetCharacter(thePlayer, "resetcharacter" , characters[thePlayer][i][1])
				end,timerDelay, 1)
			end
		end
	end
end
addCommandHandler("rs", resetAccountCmd)

function resetCharacterPosition(thePlayer, commandName, ...)
	if exports.integration:isPlayerTrialAdmin(thePlayer) then
		local spawnPoints ={
			igs = {1949.7724609375, -1793.298828125, 13.546875},
			unity = { 1792.423828125, -1861.041015625, 13.578001022339},
			cityhall = { 1481.7568359375, -1739.0322265625, 13.546875},
			bank = { 594.1728515625, -1239.8916015625, 17.976270675659},
		}
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [nome personagem exato]", thePlayer, 255, 0, 0)
		else
			local character = table.concat({...}, "_")
			if getPlayerFromName(character) then
				kickPlayer(getPlayerFromName(character), "Character Position Reset")
			end

			local result = mysql:query_fetch_assoc("SELECT id, account FROM characters WHERE charactername='" .. mysql:escape_string(character) .. "'")
			local charid = false
			local account = false
			if result then
				charid = tonumber(result["id"])
				account = tonumber(result["account"])
			end
			if charid then

				mysql:query_free("UPDATE characters SET x = 1949.7724609375, y = -1793.298828125, z = 13.546875 WHERE id = " .. mysql:escape_string(charid) )
				outputChatBox("Você resetou a posição de " .. character .. ".", thePlayer, 0, 255, 0)
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				if hiddenAdmin == 0 then
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " resetou a posição de spawn de " .. character .. ".")
				else
					exports.global:sendMessageToAdmins("AdmCmd: um Admin Oculto resetou a posição de " .. character .. ".")
				end
				exports.logs:dbLog(thePlayer, 4, "ch"..tostring(charid), "RESETPOS")
			else
				outputChatBox("Não foi possivel achar " .. character, thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("resetpos", resetCharacterPosition)
addCommandHandler("resetarposicao", resetCharacterPosition)


function vehicleLimit(admin, command, player, limit)
	if exports.integration:isPlayerLeadAdmin(admin) then
		if (not player and not limit) then
			outputChatBox("SYNTAX: /" .. command .. " [Player] [Limite]", admin, 255, 194, 14)
		else
			local tplayer, targetPlayerName = exports.global:findPlayerByPartialNick(admin, player)
			if (tplayer) then
				local query = mysql:query_fetch_assoc("SELECT maxvehicles FROM characters WHERE id = " .. mysql:escape_string(getElementData(tplayer, "dbid")))
				if (query) then
					local oldvl = query["maxvehicles"]
					local newl = tonumber(limit)
					if (newl) then
						if (newl>0) then
							mysql:query_free("UPDATE characters SET maxvehicles = " .. mysql:escape_string(newl) .. " WHERE id = " .. mysql:escape_string(getElementData(tplayer, "dbid")))

							exports.anticheat:changeProtectedElementDataEx(tplayer, "maxvehicles", newl, false)

							outputChatBox("Você setou para" .. targetPlayerName:gsub("_", " ") .. " um limite de veículo de " .. newl .. ".", admin, 255, 194, 14)
							outputChatBox("Admin " .. getPlayerName(admin):gsub("_"," ") .. " definiu o limite de veículos seus para " .. newl .. ".", tplayer, 255, 194, 14)

							exports.logs:dbLog(thePlayer, 4, tplayer, "SETVEHLIMIT "..oldvl.." "..newl)
						else
							outputChatBox("Você não pode definir um nível abaixo de 0", admin, 255, 194, 14)
						end
					end
				end
			else
				outputChatBox("Algo deu errado ao escolher o jogador.", admin)
			end
		end
	end
end
addCommandHandler("setvehlimit", vehicleLimit)
addCommandHandler("setarlimiteveiculo", vehicleLimit)


function intLimit(admin, command, player, limit)
	if exports.integration:isPlayerLeadAdmin(admin) then
		if (not player and not limit) then
			outputChatBox("SYNTAX: /" .. command .. " [Player] [Limite]", admin, 255, 194, 14)
		else
			local tplayer, targetPlayerName = exports.global:findPlayerByPartialNick(admin, player)
			if (tplayer) then
				local query = mysql:query_fetch_assoc("SELECT `maxinteriors` FROM `characters` WHERE `id` = " .. mysql:escape_string(getElementData(tplayer, "dbid")))
				if (query) then
					local oldvl = query["maxinteriors"]
					local newl = tonumber(limit)
					if (newl) then
						if (newl>0) then
							mysql:query_free("UPDATE `characters` SET `maxinteriors` = " .. mysql:escape_string(newl) .. " WHERE `id` = " .. mysql:escape_string(getElementData(tplayer, "dbid")))

							exports.anticheat:changeProtectedElementDataEx(tplayer, "maxinteriors", newl, false)

							outputChatBox("Você setou para " .. targetPlayerName:gsub("_", " ") .. " um limite de interior para " .. newl .. ".", admin, 255, 194, 14)
							outputChatBox("Admin " .. getPlayerName(admin):gsub("_"," ") .. " definiu seu limite de interior para " .. newl .. ".", tplayer, 255, 194, 14)

							exports.logs:dbLog(thePlayer, 4, tplayer, "SETINTLIMIT "..oldvl.." "..newl)
						else
							outputChatBox("Você não pode definir um nível abaixo de 0", admin, 255, 194, 14)
						end
					end
				end
			else
				outputChatBox("Algo deu errado ao escolher o jogador.", admin)
			end
		end
	end
end
addCommandHandler("setintlimit", intLimit)
addCommandHandler("setarlimiteinterior", intLimit)

-- /NUDGE by Bean
function nudgePlayer(thePlayer, commandName, targetPlayer)
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if not targetPlayer then
				return false
			end
			local logged = getElementData(targetPlayer, "loggedin")
			if (logged==0) then
			   outputChatBox("Jogador não esta logado.", thePlayer, 255, 0, 0)
			else
				triggerClientEvent ( "playNudgeSound", targetPlayer)
				outputChatBox("Você cutucou " .. targetPlayerName .. ".", thePlayer)
				outputChatBox("Você foi cutucado por " .. getPlayerName(thePlayer) .. ".", targetPlayer)
			end
		end
	end
end
addCommandHandler("nudge", nudgePlayer, false, false)

-- /EARTHQUAKE BY ANTHONY
function earthquake(thePlayer, commandName, shakeIntensity)
	if exports.integration:isPlayerLeadAdmin(thePlayer) then
		if not tonumber(shakeIntensity) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Screen Shake Intensity]", thePlayer, 255, 194, 14)
			return
		end
		local players = exports.pool:getPoolElementsByType("player")
		for index, arrayPlayer in ipairs(players) do
			triggerClientEvent("doEarthquake", arrayPlayer, shakeIntensity)
		end
	end
end
addCommandHandler("earthquake", earthquake, false, false)

--/SETAGE
function asetPlayerAge(thePlayer, commandName)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		outputChatBox("Por Favor use /setdob.", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("setage", asetPlayerAge)

    --/SETHEIGHT
    function asetPlayerHeight(thePlayer, commandName, targetPlayer, height)
       if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
          if not (height) or not (targetPlayer) then
             outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID] [Altura (150 - 200)]", thePlayer, 255, 194, 14)
          else
             local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
             local dbid = getElementData(targetPlayer, "dbid")
             local heightint = tonumber(height)
             if (heightint>200) or (heightint<150) then
                outputChatBox("Você não pode definir a altura para isso.", thePlayer, 255, 0, 0)
             else
                mysql:query_free("UPDATE characters SET height='" .. mysql:escape_string(height) .. "' WHERE id = " .. mysql:escape_string(dbid))
				exports.anticheat:changeProtectedElementDataEx(targetPlayer, "height", height, true)
                outputChatBox("Você mudou a altura de " .. targetPlayerName .. " para " .. height .. " cm.", thePlayer, 0, 255, 0)
                outputChatBox("Sua altura foi definida para " .. height .. " cm.", targetPlayer, 0, 255, 0)
				exports.logs:dbLog(thePlayer, 4, targetPlayer, commandName.." "..height)
             end
          end
       end
    end
    addCommandHandler("setheight", asetPlayerHeight)
    addCommandHandler("setaraltura", asetPlayerHeight)

    --/SETRACE
    function asetPlayerRace(thePlayer, commandName, targetPlayer, race)
       if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
          if not (race) or not (targetPlayer) then
             outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID] [0= Negro, 1= Branco, 2= Asiatico]", thePlayer, 255, 194, 14)
          else
             local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
             local dbid = getElementData(targetPlayer, "dbid")
             race = tonumber(race)
             if (race>2) or (race<0) then
                outputChatBox("Error: Escolha 0 para negro, 1 para branco ou 2 para asiatico.", thePlayer, 255, 0, 0)
             else
             	dbExec( exports.mysql:getConn('mta'), "UPDATE characters SET skincolor=? WHERE id=? ", race, dbid )
				if (race==0) then
				    outputChatBox("Você mudou a etnia de " .. targetPlayerName .. " para negro.", thePlayer, 0, 255, 0)
				    outputChatBox("Sua etnia foi alterada para negra.", targetPlayer, 0, 255, 0)
				elseif (race==1) then
					outputChatBox("Você mudou a etnia de " .. targetPlayerName .. " para branco.", thePlayer, 0, 255, 0)
				    outputChatBox("Sua etnia foi alterada para branca.", targetPlayer, 0, 255, 0)
				elseif (race==2) then
					outputChatBox("Você mudou a etnia de " .. targetPlayerName .. " para asiatico.", thePlayer, 0, 255, 0)
				    outputChatBox("Sua etnia foi alterada para asiatico.", targetPlayer, 0, 255, 0)
				end
				exports.logs:dbLog(thePlayer, 4, targetPlayer, commandName.." "..race)
				exports.anticheat:setEld(targetPlayer, "race", race, 'all')
             end
          end
       end
    end
    addCommandHandler("setrace", asetPlayerRace)
    addCommandHandler("setaretnia", asetPlayerRace)

    --/SETGENDER
    function asetPlayerGender(thePlayer, commandName, targetPlayer, gender)
       if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
          if not (gender) or not (targetPlayer) then
             outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID] [0= Homem, 1= Mulher]", thePlayer, 255, 194, 14)
          else
             local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
             local dbid = getElementData(targetPlayer, "dbid")
             gender = tonumber(gender)
             if (gender>1) or (gender<0) then
                outputChatBox("Error: Escolha 0 para masculino ou 1 para feminino.", thePlayer, 255, 0, 0)
             else
             dbExec( exports.mysql:getConn('mta'), "UPDATE characters SET gender=? WHERE id=? ", gender, dbid )
			 exports.anticheat:setEld(targetPlayer, "gender", gender, 'all')
				if (gender==0) then
				    outputChatBox("Você mudou o genero de " .. targetPlayerName .. " para Hoem.", thePlayer, 0, 255, 0)
				    outputChatBox("Seu genero foi definido para Masculino.", targetPlayer, 0, 255, 0)
				elseif (gender==1) then
					outputChatBox("Você mudou o genero de " .. targetPlayerName .. " para mulher.", thePlayer, 0, 255, 0)
				    outputChatBox("Seu genero foi definido para Feminino.", targetPlayer, 0, 255, 0)
				end
				exports.logs:dbLog(thePlayer, 4, targetPlayer, commandName.." "..gender)
             end
          end
       end
    end
    addCommandHandler("setgender", asetPlayerGender)
    addCommandHandler("setargenero", asetPlayerGender)

 --/SET DATE OF BITH
function aSetDateOfBirth(thePlayer, commandName, targetPlayer, dob, mob, year)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) or not dob or not mob or not year then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID] [Dia] [Mes] [Ano]", thePlayer, 255, 194, 14)
		else
			local targetPlayerName
			targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if getElementData(targetPlayer, "loggedin") ~= 1 then
				outputChatBox("Jogador não esta logado.", thePlayer, 255, 0, 0)
				return false
			end

			if not tonumber(dob) or not tonumber(mob) or not tonumber(year) then
				outputChatBox("Data e mês de nascimento devem ser numéricos.", thePlayer, 255, 194, 14)
				return false
			else
				dob = tonumber(dob)
				mob = tonumber(mob)
				year = tonumber(year)
			end

			local dbid = getElementData(targetPlayer, "dbid")
			local date = string.format("%04d-%02d-%02d", year, mob, dob)
			if mysql:query_free("UPDATE `characters` SET `day`='" .. mysql:escape_string(dob) .. "', `month`='" .. mysql:escape_string(mob) .. "', date_of_birth = '" .. mysql:escape_string(date) .. "' WHERE id = '" .. mysql:escape_string(dbid).."' " ) then
				exports.anticheat:changeProtectedElementDataEx(targetPlayer, "day", dob, true)
				exports.anticheat:changeProtectedElementDataEx(targetPlayer, "month", mob, true)
				exports.anticheat:changeProtectedElementDataEx(targetPlayer, "year", year, true)

				-- recalculate age
				local currentTime = getRealTime()
				local currentYear, currentMonth, currentDay = currentTime.year + 1900, currentTime.month + 1, currentTime.monthday
				local age = currentYear - year
				if currentMonth < mob or (currentMonth == mob and currentDay < dob) then
					age = age - 1
				end
				exports.anticheat:changeProtectedElementDataEx(targetPlayer, "age", age, true)

				outputChatBox("Você mudou a data de nascimento de " .. targetPlayerName .. " para " .. exports.global:getPlayerDoB(targetPlayer) .. " (" .. age .. " anoss).", thePlayer, 0, 255, 0)
				outputChatBox("Sua data de nascimento foi definida para " .. exports.global:getPlayerDoB(targetPlayer) .. ".", targetPlayer, 0, 255, 0)
				exports.logs:dbLog(thePlayer, 4, targetPlayer, commandName.." "..dob.."/"..mob)
			else
				outputChatBox("Error ao definir DoB, DB error.", thePlayer, 0, 255, 0)
			end
		end
	end
end
addCommandHandler("setdob", aSetDateOfBirth)
addCommandHandler("setdateofbirth", aSetDateOfBirth)
addCommandHandler("setardatanascimento", aSetDateOfBirth)

function unRecovery(thePlayer, commandName, targetPlayer)
	local theTeam = getPlayerTeam(thePlayer)
	local factionType = getElementData(theTeam, "type")
	if exports.integration:isPlayerTrialAdmin(thePlayer) or exports.factions:isInFactionType(thePlayer, 4) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local dbid = getElementData(targetPlayer, "dbid")
				setElementFrozen(targetPlayer, false)
				mysql:query_free("UPDATE characters SET recovery='0' WHERE id = " .. dbid) -- Allow them to move, and revert back to recovery type set to 0.
				mysql:query_free("UPDATE characters SET recoverytime=NULL WHERE id = " .. dbid)
				setElementData(targetPlayer, "recovery", false)
				exports.global:sendMessageToAdmins("AdmWrn: " .. getPlayerName(targetPlayer):gsub("_"," ") .. " foi removido da recuperação por " .. getPlayerName(thePlayer):gsub("_"," ") .. ".")
				outputChatBox("Você não está mais em recuperação!", targetPlayer, 0, 255, 0) -- Let them know about it!
				outputChatBox("Você removeu "..targetPlayerName.." da recuperação!", thePlayer, 0, 255, 0)
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNRECOVERY")
			else
				outputChatBox("Jogador não encontrado.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("unrecovery", unRecovery)
addCommandHandler("tirarrecuperacao", unRecovery)

function checkSkin ( thePlayer, commandName)
	outputChatBox ( "Sua ID da Skin é: " .. getPedSkin ( thePlayer ), thePlayer)
end
addCommandHandler ( "checkskin", checkSkin )
addCommandHandler ( "verskin", checkSkin )

--GIVE PLAYER ABILITY TO FLY TEMPORARILY BY MAXIME
function giveSuperman(thePlayer, commandName, targetPlayer)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not targetPlayer then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID] - Give player temporary ability to fly + freecam.", thePlayer, 255, 194, 14)
			outputChatBox("Execute the cmd again to revoke the abilities. Abilities will be automatically gone after player relogs.", thePlayer, 200, 150, 0)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if not targetPlayer then
				outputChatBox("Jogador não encontrado.",thePlayer, 255,0,0)
				return false
			end
			local logged = getElementData(targetPlayer, "loggedin")
            if (logged==0) then
				outputChatBox("Jogador não esta logado.", thePlayer, 255, 0, 0)
				return false
			end
			local dbid = getElementData(targetPlayer, "dbid")
			local canFly = getElementData(targetPlayer, "canFly")

			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)

			if not canFly then
				if setElementData(targetPlayer, "canFly", true) then
					outputChatBox("Você deu "..targetPlayerName.." temporary ability to fly.", thePlayer, 0, 255, 0)
					if (hiddenAdmin==0) then
						outputChatBox(adminTitle.." "..getPlayerName(thePlayer):gsub("_", " ").." has given you temporary ability to fly.", targetPlayer, 0, 255, 0)
						outputChatBox("TIP: /superman or jump twice to fly.", targetPlayer, 255, 255, 0)
						outputChatBox("TIP: /freecam to enable freecam, /dropme to disable it.", targetPlayer, 255, 255, 0)
						exports.global:sendMessageToAdmins("[ADMWARN] "..adminTitle.." "..getPlayerName(thePlayer):gsub("_", " ").." has given " .. getPlayerName(targetPlayer):gsub("_"," ") .. " temporary ability to fly.")
					else
						outputChatBox("um Admin Oculto has given you temporary ability to fly.", targetPlayer, 0, 255, 0)
						outputChatBox("TIP: /superman or jump twice to fly.", targetPlayer, 255, 255, 0)
						outputChatBox("TIP: /freecam to enable freecam, /dropme to disable it.", targetPlayer, 255, 255, 0)
						exports.global:sendMessageToAdmins("[ADMWARN] um Admin Oculto has given " .. getPlayerName(targetPlayer):gsub("_"," ") .. " temporary ability to fly.")
					end
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVESUPERMAN")
				end
			else
				if setElementData(targetPlayer, "canFly", false) then
					outputChatBox("You have revoked do inventario de "..targetPlayerName.." temporary ability to fly.", thePlayer, 255, 0, 0)
					if (hiddenAdmin==0) then
						outputChatBox(adminTitle.." "..getPlayerName(thePlayer):gsub("_", " ").." has revoked from you temporary ability to fly.", targetPlayer, 255, 0, 0)
						exports.global:sendMessageToAdmins("AdmWrn: "..adminTitle.." "..getPlayerName(thePlayer):gsub("_", " ").." has revoked do inventario de " .. getPlayerName(targetPlayer):gsub("_"," ") .. " temporary ability to fly.")
					else
						outputChatBox("um Admin Oculto have revoked from you temporary ability to fly.", targetPlayer, 255, 0, 0)
						exports.global:sendMessageToAdmins("AdmWrn: um Admin Oculto has revoked do inventario de " .. getPlayerName(targetPlayer):gsub("_"," ") .. " temporary ability to fly.")
					end
				end
			end
		end
	end
end
addCommandHandler ( "givesuperman", giveSuperman )

-- TEMP GIVE A PLAYER THE ABILITY TO MOVE OBJECTS IN DIM 0
function giveTempMove(p, c, t)
	if exports.integration:isPlayerTrialAdmin(p, true) then
		if not t then
			outputChatBox("SYNTAX: /" .. c .. " [Nome Parcial Jogador / ID] - Dê acesso para movimentar itens no mundo.",p, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(p, t)
			if targetPlayer then
				local adminTitle = exports.global:getPlayerAdminTitle(p)

				if getElementData(targetPlayer, "admin:tempmove") then
					setElementData(targetPlayer, "admin:tempmove", false)
					outputChatBox(adminTitle.." "..getPlayerName(p):gsub("_", " ").." revogou a capacidade temporária de /moveritem na dimensão 0.", targetPlayer, 0, 255, 0)

					exports.global:sendMessageToAdmins("[Mover Item] " .. exports.global:getPlayerFullIdentity(p) .. " revogou o movimento do item temporário do inventario de " .. exports.global:getPlayerFullIdentity(targetPlayer) .. ".")
				else
					setElementData(targetPlayer, "admin:tempmove", true)
					outputChatBox(adminTitle.." "..getPlayerName(p):gsub("_", " ").." deu a você a capacidade temporária de usasr /moveritem na dimensão 0.", targetPlayer, 0, 255, 0)

					exports.global:sendMessageToAdmins("[Mover Item] " .. exports.global:getPlayerFullIdentity(p) .. " emitiu movimento de item temporário para " .. exports.global:getPlayerFullIdentity(targetPlayer) .. ".")
					exports.logs:dbLog(p, 4, targetPlayer, "GIVEMOVEITEM")
				end
			else
				outputChatBox("Jogador com esse nome não existe.", p, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("givemoveitem", giveTempMove)
addCommandHandler("darmoveritem", giveTempMove)

--/SETINTERIOR, /SETINT
function setPlayerInterior(thePlayer, commandName, targetPlayer, interiorID)
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer)) then
		local interiorID = tonumber(interiorID)
		if (not targetPlayer) or (not interiorID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID] [Interior ID]", thePlayer, 255, 194, 14, false)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged == 0) then
					outputChatBox("Jogador não esta logado.", thePlayer, 255, 0, 0, false)
				else
					if (interiorID >= 0 and interiorID <= 255) then
						local username = getPlayerName(thePlayer)
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						setElementInterior(targetPlayer, interiorID)
						outputChatBox((hiddenAdmin == 0 and adminTitle .. " " .. username or "Admin Oculto") .. " mudou seu interior para " .. tostring(interiorID) .. ".", targetPlayer)
						outputChatBox("Você definiu " .. targetPlayerName .. (string.find(targetPlayerName, "s", -1) and "'" or "'s") .. " interior para " .. tostring(interiorID) .. ".", thePlayer)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "PLAYER-SETINTERIOR " .. tostring(interiorID))
						
						local theVehice = getPedOccupiedVehicle(targetPlayer)
						if theVehicle then
							setElementInterior(theVehicle, interiorID)
							for seat, player in pairs(getVehicleOccupants(theVehicle)) do
								if player ~= targetPlayer then
									setElementInterior(player, interiorID)
								end
							end
						end
					else
						outputChatBox("Interior invalido ID (0-255).", thePlayer, 255, 0, 0, false)
					end
				end
			end
		end
	end
end
addCommandHandler("setint", setPlayerInterior, false, false)
addCommandHandler("setinterior", setPlayerInterior, false, false)

--/SETDIMENSION, /SETDIM
function setPlayerDimension(thePlayer, commandName, targetPlayer, dimensionID)
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer)) then
		local dimensionID = tonumber(dimensionID)
		if (not targetPlayer) or (not dimensionID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID] [Dimension ID]", thePlayer, 255, 194, 14, false)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged == 0) then
					outputChatBox("Jogador não esta logado.", thePlayer, 255, 0, 0, false)
				else
					if (dimensionID >= 0 and dimensionID <= 65535) then
						local username = getPlayerName(thePlayer)
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						setElementDimension(targetPlayer, dimensionID)
						outputChatBox((hiddenAdmin == 0 and adminTitle .. " " .. username or "Admin Oculto") .. " mudou seu ID de dimensão para " .. tostring(dimensionID) .. ".", targetPlayer)
						outputChatBox("Você definiu " .. targetPlayerName .. (string.find(targetPlayerName, "s", -1) and "'" or "'s") .. " ID dimensão para " .. tostring(dimensionID) .. ".", thePlayer)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "PLAYER-SETDIMENSION " .. tostring(dimensionID))
						
						local theVehice = getPedOccupiedVehicle(targetPlayer)
						if theVehicle then
							setElementDimension(theVehicle, dimensionID)
							for seat, player in pairs(getVehicleOccupants(theVehicle)) do
								if player ~= targetPlayer then
									setElementDimension(player, dimensionID)
								end
							end
						end
					else
						outputChatBox("ID Invalido (0-65535).", thePlayer, 255, 0, 0, false)
					end
				end
			end
		end
	end
end
addCommandHandler("setdim", setPlayerDimension, false, false)
addCommandHandler("setdimension", setPlayerDimension, false, false)

addCommandHandler("charid",
	function (thePlayer, commandName, input)
		if exports.integration:isPlayerTrialAdmin(thePlayer) then
			if not input then
				outputChatBox("SYNTAX: /"..commandName.." [input] - A entrada pode ser um nome personagem exato (com sublinhado) ou um ID de caractere. ", thePlayer)
			else
				if tonumber(input) then
					local name = exports.mysql:query_fetch_assoc("SELECT `charactername` FROM characters WHERE `id`='"..exports.mysql:escape_string(tonumber(input)).."'")
					if name then
						for k, v in pairs(name) do outputChatBox("#"..input.." retorna nome personagem: "..v, thePlayer) end
					end
				else
					local id = exports.mysql:query_fetch_assoc("SELECT `id` FROM characters WHERE `charactername`='"..exports.mysql:escape_string(input).."'")
					if id then
						for k, v in pairs(id) do outputChatBox("Nome Personagem "..input.." retorna id: #"..v, thePlayer) end
					end
				end
			end
		end
	end
)

function getTwoFactorKey(thePlayer, cmd, fname) -- Maxime / 2015.3.7
	if exports.integration:isPlayerLeadAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer) then
		if not (fname) then
			outputChatBox("SYNTAX: /" .. cmd .. " [Forums Username] - Reveal Recovery Key for Two-Factor Authentication.", thePlayer, 255, 194, 14)
			return false
		end
		local qh = dbQuery( exports.mysql:getConn('mta'), "SELECT userid, username, dbtech_twofactor_recovery FROM user WHERE username=? ", fname )
		local res, nums, id = dbPoll( qh, 10000 )
		if res and nums > 0 then
			local f = res[1]
			if f and f.userid and tonumber(f.userid) then
				outputChatBox("Two-Factor Authentication Recovery Key for Forums Account '"..f.username.."' is '"..f.dbtech_twofactor_recovery.."'.", thePlayer, 255, 0, 0)
				exports.logs:dbLog(thePlayer, 4, thePlayer, cmd..' '..f.username)
			else
				outputChatBox("Forums Account '"..fname.."' not found.", thePlayer, 255, 0, 0)
			end
		else
			dbFree( qh )
			outputChatBox("Forums Account '"..fname.."' not found.", thePlayer, 255, 0, 0)
		end
	end
end
--addCommandHandler("getforumstwofactorkey", getTwoFactorKey)

function charityGC(thePlayer, cmd, amount)
	if not amount or not tonumber(amount) or tonumber(amount) <= 0 then
		outputChatBox("SYNTAX: /" .. cmd .. " [Amount to Charity]", thePlayer, 255, 194, 14)
	else
		amount = tonumber(amount)
		id = getElementData(thePlayer,"account:id")

		local qh = dbQuery(function(qh, thePlayer, amount, id)
				result = dbPoll(qh, 0)
				if result and #result > 0 then
					currentGC = tonumber(result[1].credits)
					if currentGC < amount then
						outputChatBox("You don't have that many GCs!", thePlayer, 255, 0, 0)
						return
					end
			
					if dbExec(exports.mysql:getConn("core"), "UPDATE `accounts` SET `credits`=`credits`-? WHERE `id`=? ", amount, id) then
						setElementData(thePlayer, "credits", currentGC-amount, true)
						exports.global:sendMessageToAdmins("AdmWrn: "..getElementData(thePlayer, "account:username").." charitied "..amount.." GCs.")
						outputChatBox("You have charitied "..amount.." GCs.", thePlayer, 0, 255, 0)
						exports.donators:addPurchaseHistory(thePlayer, "Charity GCs", -amount)
					else
						outputChatBox("ERROR: TAKEGC #001", thePlayer, 255, 0, 0)
					end
				end
			end, {thePlayer, amount, id}, exports.mysql:getConn("core"), "SELECT `credits` FROM `accounts` WHERE `id`=?  LIMIT 1", id)
	end
end
addCommandHandler("charitygc", charityGC)

function kickBugged(thePlayer, commandName)
	if exports.integration:isPlayerAdmin(thePlayer) then
		local players = exports.pool:getPoolElementsByType("player")
		kickcount = 0
		for k, arrayPlayer in ipairs(players) do
			local playerping = getPlayerPing(arrayPlayer)
			if (playerping == 00) or (playerping>1000) then
				kickPlayer(arrayPlayer, getRootElement(), "Problema com o seu ping detectado. Por favor, reconecte.")
				kickcount = kickcount + 1
			end
		end
		exports.global:sendMessageToAdmins("AdmWrn: " .. getElementData(thePlayer, "account:username") .. " kickou "..kickcount.." pessoas por terem um problema de ping." )
	end
end
addCommandHandler("pingcheck", kickBugged)
addCommandHandler("ping", kickBugged)

addCommandHandler( 'extendmaxchar', function( player, cmd, target )
	if exports.integration:isPlayerTrialAdmin( player, true ) and getElementData( player, 'loggedin' ) == 1 then
		local limit = 200
		if not target then
			outputChatBox( "SYNTAX: /" .. cmd .. " [Partial Player Name or ID]", player, 255, 194, 14 )
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick( player, target )
			if targetPlayer then
				if getElementData( targetPlayer, 'loggedin' ) == 1 then
					local id = getElementData( targetPlayer, 'account:id' )
					dbQuery( function( qh, player, cmd, targetPlayer, targetPlayerName, id )
						local res = dbPoll(qh, 0)
						if res and #res==1 then
							local to = math.max( res[1].cur, res[1].cap ) + 1
							if to <= limit then
								dbExec( exports.mysql:getConn('mta'), "UPDATE account_details SET max_characters=? WHERE account_id=? ", to, id )
								exports.logs:dbLog( player, 4, targetPlayer, cmd.." to "..to )
								outputChatBox( "You have successfully extended "..exports.global:getPlayerFullIdentity( targetPlayer ).."'s character cap to "..res[1].cur.."/"..to..".", player, 0, 255, 0 )
								outputChatBox( exports.global:getPlayerFullIdentity( player ).." has extended your character cap to "..res[1].cur.."/"..to..".", targetPlayer, 0, 255, 0 )
							else
								outputChatBox( exports.global:getPlayerFullIdentity( targetPlayer ).." has already reached the limit of "..limit.." characters cap and can not be extended anymore.", player, 255, 0, 0 )
							end
						else
							outputChatBox( "Errors occurred while checking characters quota.", player, 255, 0, 0 )
						end
					end, { player, cmd, targetPlayer, targetPlayerName, id }, exports.mysql:getConn('mta'), "SELECT COUNT(id) AS cur, (SELECT max_characters FROM account_details WHERE account_details.account_id=?) AS cap FROM characters WHERE account=?", id, id )
				else
					outputChatBox( "Jogador não esta logado.", player, 255, 0, 0 )
				end
			end
		end
	end
end, false )

function clearWhois(thePlayer, command)
	if exports.integration:isPlayerHeadAdmin(thePlayer) or exports.integration:isPlayerLeadAdmin(thePlayer) then
		dbExec(exports.mysql:getConn("mta"), "UPDATE account_details SET mtaserial=NULL WHERE mtaserial=?", getPlayerSerial(thePlayer))
		dbExec(exports.mysql:getConn("core"), "UPDATE accounts SET ip=NULL WHERE ip=?", getPlayerIP(thePlayer))

		exports.logs:dbLog(thePlayer, 4, thePlayer, command)

		outputChatBox("Seu IP e serial foram liberados, boi furtivo.", thePlayer, 0, 255, 0)
	end
end
addCommandHandler("clearwhois", clearWhois)

local charset = {}  do -- [0-9a-zA-Z]
    for c = 48, 57  do table.insert(charset, string.char(c)) end
    for c = 65, 90  do table.insert(charset, string.char(c)) end
    for c = 97, 122 do table.insert(charset, string.char(c)) end
end

local function randomString(length)
    if not length or length <= 0 then return '' end
    math.randomseed(os.clock()^5)
    return randomString(length - 1) .. charset[math.random(1, #charset)]
end

function developMode(thePlayer, commandName)
	if exports.integration:isPlayerLeadScripter(thePlayer) or exports.integration:isPlayerHeadAdmin(thePlayer) then
		local isPlayerGuest = isGuestAccount(getPlayerAccount(thePlayer))
		if isPlayerGuest then
			local aclAccount = getAccount(ACL_DETAILS.username)
			if aclAccount then 
				local attempt = logIn(thePlayer, aclAccount, ACL_DETAILS.password)
				if not attempt then 
					outputChatBox("Failed to log you into ACL (Another user is also in /devmode).", thePlayer, 255, 0, 0)
				end
			else 
				ACL_DETAILS.password = randomString(15)
				addAccount(ACL_DETAILS.username, ACL_DETAILS.password)
				aclAccount = getAccount(ACL_DETAILS.username)
				aclGroupAddObject(aclGetGroup("Scripter"), "user." .. ACL_DETAILS.username)
				logIn(thePlayer, aclAccount, ACL_DETAILS.password)
			end
			triggerClientEvent(thePlayer, "admin-system:devmode", thePlayer, true)
		else
			logOut(thePlayer)
			triggerClientEvent(thePlayer, "admin-system:devmode", thePlayer)
		end
	end
end
addCommandHandler("devmode", developMode)