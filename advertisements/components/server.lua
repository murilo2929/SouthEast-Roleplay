local advertisementMessages = { "samp", "arıyorum", "aranır", "istiyom", "istiyorum", "SA-MP", "oyuncak", "boncuk", "silah", "peynir", "baharat", "deagle",  "colt", "mp", "ak", "roleplay", "ananı", "sikeyim", "sikerim", "orospu", "evladı", "Kye", "arena", "Arina", "rina", "vendetta", "vandetta", "shodown", "Vedic", "vedic","ventro","Ventro", "server", "sincityrp", "ls-rp", "sincity", "tri0n3", "mta", "mta-sa", "query", "Query", "inception", "p2win", "pay to win" }
local adverts = {}
local timers = {}
addEvent("adverts:receive", true)
addEventHandler("adverts:receive", root,
	function(player, message)
		if isTimer(timers[getElementData(player, "dbid")]) then
			outputChatBox("Você só pode postar um anúncio a cada 5 minutos.", player, 255, 255, 255, true)
		return
		end
		
		--if exports.global:hasMoney(player, 100) then
			timers[getElementData(player, "dbid")] = setTimer(function() end, 1000*60*5, 1)
			for k,v in ipairs(advertisementMessages) do
				local found = string.find(string.lower(message), "%s" .. tostring(v))
				local found2 = string.find(string.lower(message), tostring(v) .. "%s")
				if (found) or (found2) or (string.lower(message)==tostring(v)) then
					exports.global:sendMessageToAdmins("AdmWrn: " .. tostring(getPlayerName(player)) .. " Palavras perigosas encontradas durante a publicidade.")
					exports.global:sendMessageToAdmins("AdmWrn: Mensagem publicitária: " .. tostring(message))
					outputChatBox("[-]#ffffff Palavras incorretas foram encontradas ao anunciar, excluir e anunciar novamente..", player, 255, 0, 0, true)
					outputChatBox("[-]#ffffff Se você for postar um anúncio ilegal, use /deepweb.", player, 255, 0, 0, true)
					return
				end
			end
			local upperCount = 0
			for i=1, #message do
				local message = message:sub(i, i+1)
				if message == message:upper() then
					upperCount = upperCount + 1
				end
			end
		
			if (upperCount >= #message) then
				message = message:lower()
				message = tostring(message):gsub("^%l", string.upper)
			end
			local playerItems = exports["item-system"]:getItems(player)
			local phoneNumber = "-"
			for index, value in ipairs(playerItems) do
				if value[1] == 2 then
					phoneNumber = value[2]
				end
			end
			advertID = #adverts + 1;
			adverts[advertID] = player:getData("dbid");
			--exports.global:takeMoney(player, 100)
			outputChatBox("#ffffff Seu anúncio foi enviado com sucesso, será publicado em 10 segundos.", player, 0, 255, 0, true)	
			--exports.global:sendMessageToAdmins("AdmWrn: "..player.name.." anúncio:")
			exports.global:sendMessageToAdmins("AdmWrn: "..player.name.." fez um anúncio, Anúncio: "..message.."")

			local logMsg = "```"..player.name.." fez um anúncio (Legal), Anúncio: "..message.."```"
			exports.serp_discord_logs:msg("anuncio-logs", logMsg)
			
			Timer(
				function(adID, plr)
					if isElement(player) then
						if adverts[advertID] then
							for _, arrPlayer in ipairs(getElementsByType("player")) do
								if not getElementData(arrPlayer, "togNews") then
									outputChatBox("[LSN] "..message, arrPlayer, 0, 255, 0)
									outputChatBox("[LSN] Anúncio: "..phoneNumber.." // "..getPlayerName(player):gsub("_", " "), arrPlayer, 0, 255, 0)
								end
							end
						else
							--exports.global:giveMoney(player, 100)
						end
					end
				end,
			10000, 1, advertID, plr)
	
			
		--else
			--outputChatBox("#ffffff Você precisa de $ 100 para criar um anúncio.", player, 255, 0, 0, true)
		--end
	end
)

addCommandHandler("delanuncio",
	function(player, cmd, id)
		id = tonumber(id)
		if id and exports.integration:isPlayerTrialAdmin(player) or adverts[id] == player:getData("dbid") and adverts[id] and id and adverts[id] then
			adverts[(id)] = false
			outputChatBox("#ffffff Anúncio deletado com sucesso.", player, 0, 255, 0, true)
			exports.global:sendMessageToAdmins("AdmWrn: ["..player.name.."] cancelou o último anúncio, não irá ao ar.")
		end
	end
)
