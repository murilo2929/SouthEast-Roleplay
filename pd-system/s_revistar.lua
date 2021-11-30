--
function ustArama(thePlayer, cmdName, targetPlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if getElementData(thePlayer, "ustArama") then
			outputChatBox("#f0f0f0Você não pode revistar mais de uma pessoa ao mesmo tempo.!", thePlayer, 255, 0, 0, true)
			return false
		end

		if not (targetPlayer) then
			outputChatBox("#f0f0f0Comando: /" .. cmdName .. " [Nome da Pessoa / ID]", thePlayer, 255, 194, 14, true)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer == thePlayer then
				outputChatBox("#f0f0f0Você não pode se revistar.", thePlayer, 255, 0, 0, true)
				return
			end
			
			if targetPlayer then
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
			
				local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
				
				if (distance<=5) then
					outputChatBox("#f0f0f0Um pedido de revista foi enviado para o jogador: " .. targetPlayerName, thePlayer, 0, 255, 0, true)
					triggerClientEvent(targetPlayer, "pd:ustAramaOnayGUI", thePlayer, thePlayer, targetPlayer)
				else
					outputChatBox("#f0f0f0Você está longe do jogador.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addCommandHandler("revistar", ustArama)

function aramaKabul(thePlayer, targetPlayer)
	if thePlayer and targetPlayer then
		local para = exports.global:getMoney(targetPlayer)
		local pistol, deagle, uzi, tec9, mp5, shotgun, ak47, m4, sniper = false
		
		local silahlar = getPedWeapons(targetPlayer)
		local deagle, uzi, tec9, mp5, shotgun, ak47, m4, sniper = false
		for i, v in ipairs(silahlar) do
			if v == 28 then
				uzi = true
			elseif v == 24 then
				deagle = true
			elseif v == 32 then
				tec9 = true
			elseif v == 29 then
				mp5 = true
			elseif v == 25 then
				shotgun = true
			elseif v == 30 then
				ak47 = true
			elseif v == 31 then
				m4 = true
			elseif v == 34 then
				sniper = true
			end
		end
		
		local marijuana = exports["item-system"]:countItems(targetPlayer, 38)
		local kokain = exports["item-system"]:countItems(targetPlayer, 34)
		local mantar = false
		local eroin = exports["item-system"]:countItems(targetPlayer, 37)
		local ekstazi = exports["item-system"]:countItems(targetPlayer, 36)
		local meth = exports["item-system"]:countItems(targetPlayer, 39)
		
		local telefon = exports["item-system"]:hasItem(targetPlayer, 2)
		local telsiz = exports["item-system"]:hasItem(targetPlayer, 6)
	
		outputChatBox("#f0f0f0Dinheiro: $" .. exports.global:formatMoney(para), thePlayer, 0, 0, 255, true)
		outputChatBox("#f0f0f0Telefone: " .. (telefon and "[#00ff00Possui#f0f0f0]" or "[#ff0000Não possui#f0f0f0]") .. " - Rádio: " .. (telsiz and "[#00ff00Possui#f0f0f0]" or "[#ff0000Não possui#f0f0f0]"), thePlayer, 0, 0, 255, true)
		outputChatBox("#f0f0f0Pistola: " .. (pistol and "[#00ff00Possui#f0f0f0]" or "[#ff0000Não possui#f0f0f0]") .. " - Deagle: " .. (deagle and "[#00ff00Possui#f0f0f0]" or "[#ff0000Não possui#f0f0f0]") .. " UZI: " .. (uzi and "[#00ff00Possui#f0f0f0]" or "[#ff0000Não possui#f0f0f0]"), thePlayer, 0, 0, 255, true)
		outputChatBox("#f0f0f0TEC9: " .. (tec9 and "[#00ff00Possui#f0f0f0]" or "[#ff0000Não possui#f0f0f0]") .. " - MP5: " .. (mp5 and "[#00ff00Possui#f0f0f0]" or "[#ff0000Não possui#f0f0f0]") .. " Shotgun: " .. (shotgun and "[#00ff00Possui#f0f0f0]" or "[#ff0000Não possui#f0f0f0]"), thePlayer, 0, 0, 255, true)
		outputChatBox("#f0f0f0AK47: " .. (ak47 and "[#00ff00Possui#f0f0f0]" or "[#ff0000Não possui#f0f0f0]") .. " - M4: " .. (m4 and "[#00ff00Possui#f0f0f0]" or "[#ff0000Não possui#f0f0f0]") .. " Sniper: " .. (sniper and "[#00ff00Possui#f0f0f0]" or "[#ff0000Não possui#f0f0f0]"), thePlayer, 0, 0, 255, true)
		outputChatBox("#f0f0f0Marijuana: " .. "[" .. marijuana .. "]" .. " - Cocaína: " ..  "[" .. kokain .. "]" ..  " Cogumelos:[0]", thePlayer, 0, 0, 255, true)
		outputChatBox("#f0f0f0Heroina: [" .. eroin .. "] - Êxtase: [" .. ekstazi .. "] - Metamorfina: [" .. meth .. "]", thePlayer, 0, 0, 255, true)
	end
end
addEvent("pd:aramaKabul", true)
addEventHandler("pd:aramaKabul", getRootElement(), aramaKabul)

function aramaRed(thePlayer, targetPlayer)
	if thePlayer and targetPlayer then
		outputChatBox(" #f0f0f0Você negou com sucesso um pedido de revista.", targetPlayer, 0, 255, 0, true)
		outputChatBox(" #f0f0f0Sua solicitação de revista foi negada.", thePlayer, 255, 0, 0, true)
	end
end
addEvent("pd:aramaRed", true)
addEventHandler("pd:aramaRed", getRootElement(), aramaRed)

function getPedWeapons(ped)
	local playerWeapons = {}
	if ped and isElement(ped) and getElementType(ped) == "ped" or getElementType(ped) == "player" then
		for i=2,9 do
			local wep = getPedWeapon(ped,i)
			if wep and wep ~= 0 then
				table.insert(playerWeapons,wep)
			end
		end
	else
		return false
	end
	return playerWeapons
end