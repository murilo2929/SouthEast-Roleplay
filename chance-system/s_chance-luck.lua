function tryLuck(thePlayer, commandName , pa1, pa2)
	local p1, p2, p3 = nil
	p1 = tonumber(pa1)
	p2 = tonumber(pa2)
	if pa1 == nil and pa2 == nil and pa3 == nil then
		exports.global:sendLocalText(thePlayer, "((OOC Sorte)) "..getPlayerName(thePlayer):gsub("_", " ").." tenta a sorte de 1 a 100 e obtém "..math.random(100)..".", 255, 51, 102, 30, {}, true)
	elseif pa1 ~= nil and p1 ~= nil and pa2 == nil then
		exports.global:sendLocalText(thePlayer, "((OOC Sorte)) "..getPlayerName(thePlayer):gsub("_", " ").." tenta a sorte de 1 a "..p1.." e obtém "..math.random(p1)..".", 255, 51, 102, 30, {}, true)
	else
		outputChatBox("SYNTAX: /" .. commandName.."                  - Digite um número aleatório de 1 a 100", thePlayer, 255, 194, 14)
		outputChatBox("SYNTAX: /" .. commandName.." [max]         - Digite um número aleatório de 1 a [max]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("luck", tryLuck)
addCommandHandler("sorte", tryLuck)

function tryChance(thePlayer, commandName , pa1, pa2)
	local p1, p2, p3 = nil
	p1 = tonumber(pa1)
	p2 = tonumber(pa2)
	if pa1 ~= nil then 
		if pa2 == nil and p1 ~= nil then
			if p1 <= 100 and p1 >=0 then
				if math.random(100) >= p1 then
					exports.global:sendLocalText(thePlayer, "((OOC Chance em "..p1.."%)) "..getPlayerName(thePlayer):gsub("_", " ").."'s tentou mais falhou.", 255, 51, 102, 30, {}, true)
				else
					exports.global:sendLocalText(thePlayer, "((OOC Chance em "..p1.."%)) "..getPlayerName(thePlayer):gsub("_", " ").."'s teve sua tentativa foi bem sucedida.", 255, 51, 102, 30, {}, true)
				end
			else
				outputChatBox("Probability must range from 0 to 100%.", thePlayer, 255, 0, 0, true)
			end
		else
			outputChatBox("SYNTAX: /" .. commandName.." [0-100%]                 - Chance de que você terá sucesso na probabilidade de [0-100%]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("SYNTAX: /" .. commandName.." [0-100%]                 - Chance de que você terá sucesso na probabilidade de [0-100%]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("chance", tryChance)

function oocCoin(thePlayer)
	if  math.random( 1, 2 ) == 2 then
		exports.global:sendLocalText(thePlayer, " ((OOC Moeda)) " .. getPlayerName(thePlayer):gsub("_", " ") .. " joga uma moeda, caindo na coroa.", 255, 51, 102)
	else
		exports.global:sendLocalText(thePlayer, " ((OOC Moeda)) " .. getPlayerName(thePlayer):gsub("_", " ") .. " joga uma moeda, caindo na cara.", 255, 51, 102)
	end
end
addCommandHandler("flipcoin", oocCoin)
addCommandHandler("virarmoeda", oocCoin)