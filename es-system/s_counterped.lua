addEvent("lses:ped:start", true)
function lsesPedStart(pedName)
	exports['global']:sendLocalText(client, pedName.." diz: Olá, como posso ajudá-lo hoje?", 255, 255, 255, 10)
end
addEventHandler("lses:ped:start", getRootElement(), lsesPedStart)

addEvent("lses:ped:help", true)
function lsesPedHelp(pedName)
	exports['global']:sendLocalText(client, pedName.." diz: Mesmo?! Um momento!", 255, 255, 255, 10)
	exports['global']:sendLocalText(client, pedName.." [RADIO]: Alguém precisa de ajuda na recepção do hospital!", 255, 255, 255, 10)
	for key, value in ipairs( exports.factions:getPlayersInFaction(164) ) do
		outputChatBox("[RADIO] Este é a central, temos um incidente, sobre.", value, 0, 183, 239)
		outputChatBox("[RADIO] Situação: Alguém precisa de ajuda!.  ((" .. getPlayerName(client):gsub("_"," ") .. "))", value, 0, 183, 239)
		outputChatBox("[RADIO] Local: Hospital Geral All Saints, na recepção, over.", value, 0, 183, 239)
	end
end
addEventHandler("lses:ped:help", getRootElement(), lsesPedHelp)

addEvent("lses:ped:appointment", true)
function lsesPedAppointment(pedName)
	exports['global']:sendLocalText(client, pedName.." diz: Vou avisar quem puder, por favor, sente-se enquanto espera.", 255, 255, 255, 10)
	for key, value in ipairs( exports.factions:getPlayersInFaction(164) ) do
		outputChatBox("[RADIO] Recepção aqui, temos alguém para uma consulta, over. ((" .. getPlayerName(client):gsub("_"," ") .. "))", value, 0, 183, 239)
		outputChatBox("[RADIO] Local: All Saints General, na recepção, over.", value, 0, 183, 239)
	end
end
addEventHandler("lses:ped:appointment", getRootElement(), lsesPedAppointment)

function pedOutputChat(ped, chat, text, theClient, language)
	if not ped then return end
	if not client then client = theClient end
	if not client then return end
	if not tonumber(language) then language = 1 end
	if chat == "me" then
		local name = getElementData(ped, "name") or exports.global:getPlayerName(ped)
		local message = tostring(text)
		exports.global:sendLocalText(client, " *"..string.gsub(name, "_", " ")..( message:sub(1, 1) == "'" and "" or " ")..message, 255, 51, 102)
	elseif chat == "hospitalpa" then
		local name = getElementData(ped, "name") or exports.global:getPlayerName(ped)
		local message = tostring(text)
		exports['chat-system']:radio(ped, -5, message, chat)
	else
		exports['chat-system']:localIC(ped, tostring(text), language)
	end
end
addEvent("lses:ped:outputchat", true)
addEventHandler("lses:ped:outputchat", getResourceRootElement(), pedOutputChat)