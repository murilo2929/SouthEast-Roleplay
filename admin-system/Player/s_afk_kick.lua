local pending = {}

function checkAFK()
	if (getPlayerIdleTime(client) or 0) >  600000 then
		if exports.integration:isPlayerScripter(client) then return end
		if exports.integration:isPlayerTrialAdmin(client) then
			if getElementData(client, "duty_admin") == 1 then
				triggerClientEvent(client, "accounts:settings:updateAccountSettings", client, "duty_admin", 0)
				exports.global:sendMessageToAdmins("AdmDuty: " .. getPlayerName(client):gsub("_", " ") .. " saiu de serviço (AFK).")
				exports.global:updateNametagColor(client)
			end
		else
			--triggerClientEvent(client, "accounts:logout", client, "You have been put to the character selection for being AFK.")
		end
		setElementData(client, "afk", true)
	end
end
addEvent("admin:armAFK", true)
addEventHandler("admin:armAFK", resourceRoot, checkAFK)

function disarmAFK()
	removeElementData(client, "afk")
end
addEvent("admin:disarmAFK", true)
addEventHandler("admin:disarmAFK", resourceRoot, disarmAFK)
