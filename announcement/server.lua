--[[
	server.lua
	Allows server administrators to create banner annoucements
]]

mysql = exports.mysql
integration = exports.integration
pool = exports.pool

-- Admin announcement
addCommandHandler("ann",
	function(player, commandName, ...)
		local isLoggedIn = getElementData(player, "loggedin") == 1

		if isLoggedIn and (integration:isPlayerTrialAdmin(player) or integration:isPlayerSupporter(player)) then
			if not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Menssagem]", player, 255, 194, 14)
				return
			end

			local message = table.concat({ ... }, " ")
			local players = exports.pool:getPoolElementsByType("player")
			local username = getPlayerName(player)

			for _, arrayPlayer in ipairs(players) do
				if integration:isPlayerTrialAdmin(player) then
					triggerClientEvent(arrayPlayer, "announcement:post", arrayPlayer, "Anúncio do administrador: " .. message, 255, 194, 14, 1)
				elseif integration:isPlayerSupporter(player) then
					triggerClientEvent(arrayPlayer, "announcement:post", arrayPlayer, "Anúncio do SUPPORTER: " .. message, 255, 100, 150, 1)
				end
			end
			outputConsole("Adm/SUPCmd: " .. message)
			exports.global:sendMessageToAdmins("Adm/SUPCmd: " .. username .. " fez um anúncio")
			exports.logs:dbLog(player, 4, player, "ANN " .. message)
		end
	end,
	false,
	false
)
