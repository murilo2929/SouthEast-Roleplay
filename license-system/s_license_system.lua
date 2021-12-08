mysql = exports.mysql

function recoveryLicense(licensetext, cost, itemID, npcName)
	if not exports.global:takeMoney(client, cost) then
		exports.hud:sendBottomNotification(client, npcName, "Você precisa de $"..exports.global:formatMoney(cost).." para recuperar a "..licensetext..".")
		return false
	end

	if exports.global:giveItem(client, itemID, getPlayerName(client):gsub("_", " ")) then
		exports.hud:sendBottomNotification(client, npcName, "Você pagou $"..exports.global:formatMoney(cost).." para recuperar a  "..licensetext..".")
	end
end
addEvent("license:recover", true)
addEventHandler("license:recover", root, recoveryLicense)

function onLicenseServer()
	local gender = getElementData(source, "gender")
	if (gender == 0) then
		exports.global:sendLocalText(source, "Carla Cooper diz: Olá senhor, você quer obter uma licença?", 255, 255, 255, 10)
	else
		exports.global:sendLocalText(source, "Carla Cooper diz:  Olá senhora, você quer obter uma licença?", 255, 255, 255, 10)
	end
end
addEvent("onLicenseServer", true)
addEventHandler("onLicenseServer", getRootElement(), onLicenseServer)

function payFee(amount, reason)
	if exports.global:takeMoney(source, amount) then
		if not reason then
			reason = "a license"
		end
		exports.hud:sendBottomNotification(source, "Departamento de Veículos Motorizados", "Você pagou a taxa de $"..exports.global:formatMoney(amount).." por "..reason..".")
	end
end
addEvent("payFee", true)
addEventHandler("payFee", getRootElement(), payFee)

function showLicenses(thePlayer, commandName, targetPlayer)
	--outputChatBox("This command is deprecated. Please show actual license/certificate from your inventory.", thePlayer, 255, 194, 14)
	--return false

	local loggedin = getElementData(thePlayer, "loggedin")
	if (loggedin==1) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged==0) then
					outputChatBox("Jogador não esta logado.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)

					if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)>5) then -- Are they standing next to each other?
						outputChatBox("Você está muito longe para mostrar sua licença de arma para '".. targetPlayerName .."'.", thePlayer, 255, 0, 0)
					else
						outputChatBox("Você mostrou suas licenças de arma para " .. targetPlayerName .. ".", thePlayer, 255, 194, 14)
						outputChatBox(getPlayerName(thePlayer) .. " mostrou a você suas licenças de armas.", targetPlayer, 255, 194, 14)

						local gunlicense = getElementData(thePlayer, "license.gun")
						local gun2license = getElementData(thePlayer, "license.gun2")
						--[[local carlicense = getElementData(thePlayer, "license.car")
						local bikelicense = getElementData(thePlayer, "license.bike")
						local boatlicense = getElementData(thePlayer, "license.boat")
						local pilotlicense = getElementData(thePlayer, "license.pilot")
						local fishlicense = getElementData(thePlayer, "license.fish")]]

						local guns, guns2, cars, bikes, boats, pilots, fish

						if (gunlicense<=0) then
							guns = "Não"
						else
							guns = "Sim"
						end

						if (gun2license<=0) then
							guns2 = "Não"
						else
							guns2 = "Sim"
						end

						--[[if (carlicense<=0) then
							cars = "No"
						elseif (carlicense==3)then
							cars = "Theory test passed"
						else
							cars = "Yes"
						end

						if (bikelicense<=0) then
							bikes = "No"
						elseif (bikelicense==3)then
							bikes = "Theory test passed"
						else
							bikes = "Yes"
						end

						if (boatlicense<=0) then
							boats = "No"
						else
							boats = "Yes"
						end

						if (pilotlicense<=0) then
							pilots = "No"
						elseif (pilotlicense==1)then
							pilots = "ROT"
						elseif (pilotlicense==2)then
							pilots = "SER"
						elseif (pilotlicense==3)then
							pilots = "ROT+SER"
						elseif (pilotlicense==4)then
							pilots = "MER"
						elseif (pilotlicense==5)then
							pilots = "TER"
						elseif (pilotlicense==6)then
							pilots = "ROT+MER"
						elseif (pilotlicense==7)then
							pilots = "ROT+TER"
						else
							pilots = "No"
						end

						if (fishlicense<=0) then
							fishs = "No"
						else
							fishs = "Yes"
						end ]]

						--REQUIRES FUNCTION IN C_LICENSE_SYSTEM TO BE FIXED... triggerClientEvent ( "showLicenses", getRootElement(), showLicensesWindow)
						--triggerEvent("showLicenses", thePlayer, targetPlayer)

						--outputChatBox("----- " .. getPlayerName(thePlayer) .. " Licenças de Armas -----", targetPlayer, 255, 194, 14)
						outputChatBox("----- Licenças de Arma ((" .. getPlayerName(thePlayer) ..")) -----", targetPlayer, 255, 255, 255)
						outputChatBox("- Licença de Arma Tier 1: " .. guns, targetPlayer, 255, 255, 255)
						outputChatBox("- Licença de Arma Tier 2: " .. guns2, targetPlayer, 255, 255, 255)
					--[[	outputChatBox("        Driver License: " .. cars, targetPlayer, 255, 194, 14)
						outputChatBox("        Motorcycle License: " .. bikes, targetPlayer, 255, 194, 14)
						outputChatBox("        Boat License: " .. boats, targetPlayer, 255, 194, 14)
						outputChatBox("        Pilots License: " .. pilots, targetPlayer, 255, 194, 14)
						outputChatBox("        Fishing Permit: " .. fishs, targetPlayer, 255, 194, 14) ]]
					end
				end
			end
		end
	end

end
addCommandHandler("showlicenses", showLicenses, false, false)
addCommandHandler("mostrarlicencas", showLicenses, false, false)
