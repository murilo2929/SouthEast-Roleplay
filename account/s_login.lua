local mysql = exports.mysql
--local salt = "wedorp"

function clientReady()
	local thePlayer = source
	local resources = getResources()
	local missingResources = false
	for key, value in ipairs(resources) do
		local resourceName = getResourceName(value)
		if resourceName == "global" or resourceName == "mysql" or resourceNmae == "pool" then
			if getResourceState(value) == "loaded" or getResourceState(value) == "stopping" or getResourceState(value) == "failed to load" then
				missingResources = true
				outputChatBox("O servidor está sem recurso dependente '"..getResourceName(value).."'.", thePlayer, 255, 0, 0)
				outputChatBox("Por favor tente novamente em breve.", thePlayer, 255, 0, 0)
				outputChatBox("       - Staff Southeast", thePlayer, 255, 0, 0)
				break
			end
		end
	end
	if missingResources then return end
	local willPlayerBeBanned = false
	local bannedIPs = exports.global:fetchIPs()
	local playerIP = getPlayerIP(thePlayer)
	for key, value in ipairs(bannedIPs) do
		if playerIP == value then
			outputChatBox("Seu IP está na lista negra do servidor.", thePlayer, 255, 0, 0)
			setTimer(outputChatBox, 1000, 1, "Você será expulso do servidor em 10 segundos.", thePlayer, 255, 0, 0)
			setTimer(kickPlayer, 10000, 1, thePlayer, "Você está na lista negra deste servidor.")
			willPlayerBeBanned = true
			break
		end
	end
	if not willPlayerBeBanned then
		local bannedSerials = exports.global:fetchSerials()
		local playerSerial = getPlayerSerial(thePlayer)
		for key, value in ipairs(bannedSerials) do
			if playerSerial == value then
				outputChatBox("Seu serial está na lista negra do servidor.", thePlayer, 255, 0, 0)
				setTimer(outputChatBox, 1000, 1, "Você será expulso do servidor em 10 segundos.", thePlayer, 255, 0, 0)
				setTimer(kickPlayer, 10000, 1, thePlayer, "Você está na lista negra deste servidor.")
				willPlayerBeBanned = true
				break
			end
		end
	end
	if not willPlayerBeBanned then
		triggerClientEvent(thePlayer, "beginLogin", thePlayer)
	else
		triggerClientEvent(thePlayer, "beginLogin", thePlayer, "Banned.")
	end
end
addEvent("onJoin", true)
addEventHandler("onJoin", getRootElement(), clientReady)

addEventHandler("accounts:login:request", getRootElement(),
	function ()
		local seamless = getElementData(client, "account:seamless:validated")
		if seamless == true then

			-- outputChatBox("-- Migrated your session after a system restart", client, 0, 200, 0)
			setElementData(client, "account:seamless:validated", false, false, true)
			triggerClientEvent(client, "accounts:options", client)
			triggerClientEvent(client, "item:updateclient", client)
			return
		end
		triggerClientEvent(client, "accounts:login:request", client)
	end
);

function quitPlayer(quitReason, reason)
	local accountID = tonumber(getElementData(source, "account:id"))
	if accountID then
		local affected = { "ac"..tostring(accountID) }
		local dbID = getElementData(source,"dbid")
		if dbID then
			table.insert(affected, "ch"..tostring(dbID))
		end
		exports.logs:dbLog("ac"..tostring(accountID), 27, affected, "Disconnected (".. (quitReason or "Unknown reason") ..") (Name: "..getPlayerName(source)..")" )
	end
end
addEventHandler("onPlayerQuit",getRootElement(), quitPlayer)