--MAXIME
function startStep3(newApp)
	if source and isElement(source) and getElementType(source) == "player" then
		client = source
	end
	
	if newApp or not getElementData(client, "apps:notified")  then
		local applicantName = getElementData(client, "account:username")
		local count = 0
		local staffNames = ""
		local players = getElementsByType("player")
		for i, player in pairs(players) do
			if exports.global:isStaffOnDuty(player) then
				if getElementData(player, "loggedin") == 1 then
					local staffName = getElementData(player, "account:username")
					local msg = "[APLICAÇÂO] Player '"..applicantName.."' enviou uma aplicação e está aguardando para entrar no jogo, pressione F7 para revisar."
					if getElementData(player, "report_panel_mod") == "2" or getElementData(player, "report_panel_mod") == "3" then
						exports['report']:showToAdminPanel(msg, player, 255,0,0)
					else
						if getElementData(player, "wrn:style") == 1 then
							triggerClientEvent(player, "sendWrnMessage", player, msg)
						else
							outputChatBox(msg, player, 255, 0, 0)
						end
					end
					
					count = count + 1
					if staffNames == "" then
						staffNames = staffName
					else
						staffNames = staffNames..", "..staffName
					end
				end
			end
		end
		triggerEvent("apps:requestApps", getResourceRootElement())
		if count > 0 then
			triggerClientEvent(client, "apps:startStep3", client, "Olá "..applicantName.."!\n\n"..count.." dos membros da nossa equipe ("..staffNames..") foram alertados sobre sua aplicação.\nUm deles tratará de sua aplicação em breve, aguarde!")
		else
			triggerClientEvent(client, "apps:startStep3", client, "Não há membros da equipe online no momento.\nNo entanto, sua aplicação foi enviada com sucesso e você pode sair.\nVocê poderá entrar no jogo assim que um membro da equipe lidar com sua aplicação.\nLamentamos profundamente pelo atraso que isso pode ter causado.")
		end
		setElementData(client, "apps:notified", true) 
	else
		triggerClientEvent(client, "apps:startStep3", client)
	end
end
addEvent("apps:startStep3", true)
addEventHandler("apps:startStep3", root, startStep3)

function retakeApplicationPart2()
	if source and isElement(source) and getElementType(source) == "player" then
		client = source
	end
	triggerEvent("apps:finishStep1", client)
end
addEvent("apps:retakeApplicationPart2", true)
addEventHandler("apps:retakeApplicationPart2", root, retakeApplicationPart2)