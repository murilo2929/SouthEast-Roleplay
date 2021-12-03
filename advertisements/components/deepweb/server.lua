local advertisementMessages = { "samp", "arıyorum", "aranır", "istiyom", "arıyorum", "lazım", "istiyorum", "SA-MP", "roleplay", "ananı", "sikeyim", "sikerim", "orospu", "evladı", "inception", "arena", "Arina", "rina", "vendetta", "vandetta", "shodown", "Vedic", "vedic","ventro","Ventro", "server", "sincityrp", "ls-rp", "sincity", "tri0n3", "mta", "mta-sa", "query", "Query", "inception", "p2win", "pay to win" }
local adverts = {}
local timers = {}
addEvent("deepweb:receive", true)
addEventHandler("deepweb:receive", root,
	function(player, message)
		if isTimer(timers[getElementData(player, "dbid")]) then
			outputChatBox("Você só pode postar uma vez a cada 30 minutos", player, 255, 255, 255)
		return
		end
		
		--if exports.global:hasMoney(player, 300) or player:getData("vipver") > 0 then
			timers[getElementData(player, "dbid")] = setTimer(function() end, 1000*60*30, 1)
			for k,v in ipairs(advertisementMessages) do
				local found = string.find(string.lower(message), "%s" .. tostring(v))
				local found2 = string.find(string.lower(message), tostring(v) .. "%s")
				if (found) or (found2) or (string.lower(message)==tostring(v)) then
					exports.global:sendMessageToAdmins("AdmWrn: " .. tostring(getPlayerName(player)) .. " Palavras perigosas encontradas durante a postagem.")
					exports.global:sendMessageToAdmins("AdmWrn: Mensagem: " .. tostring(message))
					outputChatBox("Palavras perigosas foram encontradas em seu anúncio.", player, 255, 255, 255)
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
			--if player:getData("vipver") == 0 then
				--exports.global:takeMoney(player, 300)
			--end
			outputChatBox("Você compartilhou com sucesso, será verificado e compartilhado em 15 segundos.", player, 255, 255, 255)	
			exports.global:sendMessageToAdmins("AdmWrn: "..player.name.." publicou um anúncio, Anúnciou: "..message)
			
			Timer(
				function(adID, plr)
					if isElement(player) then
						if adverts[advertID] then
							for _, arrPlayer in ipairs(getElementsByType("player")) do
								local theTeam = getPlayerTeam(arrPlayer)
								local factionType = getElementData(theTeam, "type")
								
								--if factionType == 0 or factionType == 1 or factionType == 5 then
									if not getElementData(arrPlayer, "togNews") then
										outputChatBox("[Deep Web] "..message, arrPlayer, 120, 65, 111)
										outputChatBox("[Deep Web] Contate-me agora: "..phoneNumber.." // Desconhecido", arrPlayer, 120, 65, 111, true)
										--outputChatBox("[Deep Web] Contate-me agora: "..phoneNumber.." // "..getPlayerName(player):gsub("_", " "), arrPlayer, 120, 65, 111, true)
									end
								--end
							end
						else
							exports.global:giveMoney(player, 300)
						end
					end
				end,
			15000, 1, advertID, plr)
	
			
		--else
			--outputChatBox("Você precisa de $300 para anúnciar.", player, 255, 255, 255)
		--end
	end
)

addCommandHandler("delanunciodw",
	function(player, cmd, id)
		id = tonumber(id)
		if id and exports.integration:isPlayerTrialAdmin(player) or adverts[id] == player:getData("dbid") and adverts[id] and id and adverts[id] then
			adverts[(id)] = false
			outputChatBox("Anúncio deletado com sucesso.", player, 255, 255, 255)
			exports.global:sendMessageToAdmins("AdmWrn: ["..player.name.."] cancelou o ultimo anúncio, ele não será publicada.")
		end
	end
)
