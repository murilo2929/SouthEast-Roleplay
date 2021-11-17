addEvent("pd:ped:start", true)
function pdPedStart(pedName)
	exports['global']:sendLocalText(client, "Joe McDonald diz: Olá, como posso ajudá-lo?", 255, 255, 255, 10)
end
addEventHandler("pd:ped:start", getRootElement(), pdPedStart)

addEvent("pd:ped:help", true)
function pdPedHelp(pedName)
	exports['global']:sendLocalText(client,"Joe McDonald diz: Tudo bem, notificarei todas as unidades disponíveis agora, por favor, aguarde pacientemente.", 255, 255, 255, 10)
	for key, value in ipairs( exports.factions:getPlayersInFaction(1) ) do
	outputChatBox("[RADIO] Aqui é a central, temos um civil no saguão relatando um crime. ((" .. getPlayerName(client):gsub("_"," ") .. "))", value, 0, 183, 239)
	end
end
addEventHandler("pd:ped:help", getRootElement(), pdPedHelp)

addEvent("pd:ped:appointment", true)
function pdPedAppointment(pedName)
	exports['global']:sendLocalText(client, "Joe McDonald diz: Vou notificar todos os oficiais disponíveis agora, por favor, sente-se.", 255, 255, 255, 10)
	for key, value in ipairs( exports.factions:getPlayersInFaction(1) ) do
		outputChatBox("[RADIO] Aqui é central, temos um civil no saguão pedindo para falar com um oficial. ((" .. getPlayerName(client):gsub("_"," ") .. "))", value, 0, 183, 239)
	end
end
addEventHandler("pd:ped:appointment", getRootElement(), pdPedAppointment)