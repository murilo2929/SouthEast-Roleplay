addEvent("cityhall:makeIdCard", true)
addEventHandler("cityhall:makeIdCard", root,
	function ()
		local characterName = getPlayerName(client)
		local gender = getElementData(client, "gender")
		local month = getElementData(client, "month")
		local day = getElementData(client, "day")
		local year = getElementData(client, "year")
		local fingerprint = getElementData(client, "fingerprint")
		if characterName and gender and month and day and year and fingerprint and exports.global:takeMoney(client, 5) then
			exports.global:giveItem( client, 152, characterName..";" .. (gender==0 and "Masculino" or "Feminino")..";"..exports.global:numberToMonth(month or 1).." "..exports.global:formatDate(day or 1)..", "..year..";"..fingerprint)
			outputChatBox("Um novo cartão de identificação foi criado e adicionado em seu inventario por $5.", client)
		else
			outputChatBox("Você precisa de $5 para obter um cartão de identificação novo.", client)
		end
	end
)
