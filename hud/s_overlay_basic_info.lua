function showStats(thePlayer, commandName, targetPlayerName)
	if getElementData(thePlayer, "loggedin") ~= 1 then
		outputChatBox("Você não está logado.", thePlayer, 255, 0, 0)
		return
	end

	local showPlayer = thePlayer
	if exports.integration:isPlayerTrialAdmin(thePlayer) and targetPlayerName then
		targetPlayer = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerName)
		if targetPlayer then
			if getElementData(targetPlayer, "loggedin") == 1 then
				thePlayer = targetPlayer
			else
				outputChatBox("Jogador não esta logado.", showPlayer, 255, 0, 0)
				return
			end
		else
			return
		end
	end
	
	local isOverlayDisabled = getElementData(showPlayer, "hud:isOverlayDisabled")
	--LICNESES
	local carlicense = getElementData(thePlayer, "license.car")
	local bikelicense = getElementData(thePlayer, "license.bike")
	local boatlicense = getElementData(thePlayer, "license.boat")
	--local pilotlicense = getElementData(thePlayer, "license.pilot")
	local fishlicense = getElementData(thePlayer, "license.fish")
	local gunlicense = getElementData(thePlayer, "license.gun")
	local gun2license = getElementData(thePlayer, "license.gun2")
	if (carlicense==1) then
		carlicense = "Sim"
	elseif (carlicense==3) then
		carlicense = "Teste teórico aprovado"
	else
		carlicense = "Não"
	end
	if (bikelicense==1) then
		bikelicense = "Sim"
	elseif (bikelicense==3) then
		bikelicense = "Teste teórico aprovado"
	else
		bikelicense = "Não"
	end
	if (boatlicense==1) then
		boatlicense = "Sim"
	else
		boatlicense = "Não"
	end
	
	local pilotLicenses = exports.mdc:getPlayerPilotLicenses(thePlayer) or {}
	local pilotlicense = ""
	local maxShow = 5
	local numAdded = 0
	local numOverflow = 0
	local typeratings = 0
	for k,v in ipairs(pilotLicenses) do
		local licenseID = v[1]
		local licenseValue = v[2]
		local licenseName = v[3]
		if licenseID == 7 then --if typerating
			if licenseValue then
				typeratings = typeratings + 1
			end
		else
			if numAdded >= maxShow then
				numOverflow = numOverflow + 1
			else
				if numAdded == 0 then
					pilotlicense = pilotlicense..tostring(licenseName)
				else
					pilotlicense = pilotlicense..", "..tostring(licenseName)
				end
				numAdded = numAdded + 1
			end
		end
	end
	if(numAdded == 0) then
		pilotlicense = "Não"
	else
		if numOverflow > 0 then
			pilotlicense = pilotlicense.." (+"..tostring(numOverflow+typeratings)..")"
		else
			if typeratings > 0 then
				pilotlicense = pilotlicense.." (+"..tostring(typeratings)..")"
			else
				pilotlicense = pilotlicense.."."
			end
		end
	end
	
	if (fishlicense==1) then
		fishlicense = "Sim"
	else
		fishlicense = "Não"
	end
	if (gunlicense==1) then
		gunlicense = "Sim"
	else
		gunlicense = "Não"
	end
	if (gun2license==1) then
		gun2license = "Sim"
	else
		gun2license = "Não"
	end
	--VEHICLES
	local dbid = tonumber(getElementData(thePlayer, "dbid"))
	local carids = ""
	local numcars = 0
	local printCar = ""
	for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
		local owner = tonumber(getElementData(value, "owner"))

		if (owner) and (owner==dbid) then
			local id = getElementData(value, "dbid")
			carids = carids .. id .. ", "
			numcars = numcars + 1
			exports.anticheat:changeProtectedElementDataEx(value, "owner_last_login", exports.datetime:now(), true)
		end
	end
	printCar = numcars .. "/" .. getElementData(thePlayer, "maxvehicles")

	-- PROPERTIES
	local properties = ""
	local numproperties = 0
	for key, value in ipairs(getElementsByType("interior")) do
		local stt = getElementData(value, "status")
		if stt.owner and stt.owner == dbid and getElementData(value, "name") then
			local id = getElementData(value, "dbid")
			properties = properties .. id .. ", "
			numproperties = numproperties + 1
			--Update owner last login / MAXIME 2015.01.07
			exports.anticheat:changeProtectedElementDataEx(value, "owner_last_login", exports.datetime:now(), true)
		end
	end

	if (properties=="") then properties = "Nenhuma.  " end
	if (carids=="") then carids = "Nenhum.  " end
	--FETCH ABOVE
	local hoursplayed = getElementData(thePlayer, "hoursplayed")
	local info = {}
	if isOverlayDisabled then
		outputChatBox(getPlayerName(thePlayer):gsub("_", " "), showPlayer , 255, 194, 14)
		outputChatBox(" Carteira de Motorista: " .. carlicense, showPlayer)
		outputChatBox(" Carteira de Motocicleta: " .. bikelicense, showPlayer)
		outputChatBox(" Licença de Barco: " .. boatlicense, showPlayer)
		outputChatBox(" Licença de Pilotos: " .. pilotlicense, showPlayer)
		outputChatBox(" Licença de armas de fogo Tier 1: " .. gunlicense , showPlayer)
		outputChatBox(" Licença de armas de fogo Tier 2: " .. gun2license , showPlayer)
		outputChatBox(" Licença de Pesca: " .. fishlicense, showPlayer)
		outputChatBox(" Veículos (" .. printCar .. "): " .. string.sub(carids, 1, string.len(carids)-2) , showPlayer)
		outputChatBox(" Propiedades (" .. numproperties .. "/"..(getElementData(thePlayer, "maxinteriors") or 10).."): " .. string.sub(properties, 1, string.len(properties)-2) , showPlayer)
		outputChatBox(" Tempo gasto neste personagem: " .. hoursplayed .. " horas." , showPlayer)
		outputChatBox(" Idiomas: " , showPlayer)
	else
		info = {
			{getPlayerName(thePlayer):gsub("_", " ")},
			{""},
			{" Data de Nascimento: "..exports.global:getPlayerDoB(thePlayer)},
			{" Carteira de Motorista: " .. carlicense},
			{" Carteira de Motocicleta: " .. bikelicense},
			{" Licença de Barco: " .. boatlicense},
			{" Licença de Pilotos: " .. pilotlicense},
			{" Licença de arma Tier 1: " .. gunlicense},
			{" Licença de arma Tier 2: " .. gun2license},
			{" Licença de Pesca: " .. fishlicense},
			{" Veículos (" .. printCar .. "): " .. string.sub(carids, 1, string.len(carids)-2)},
			{" Propriedades (" .. numproperties .. "/"..(getElementData(thePlayer, "maxinteriors") or 10).."): " .. string.sub(properties, 1, string.len(properties)-2)},
			{" Tempo gasto neste personagem: " .. hoursplayed .. " horas."},
			{" Idiomas: "},
		}
	end
	--LANGUAGES
	for i = 1, 3 do
		local lang = getElementData(thePlayer, "languages.lang" .. i)
		if lang and lang ~= 0 then
			local skill = getElementData(thePlayer, "languages.lang" .. i .. "skill")
			local langname = exports['language-system']:getLanguageName( lang )
			if langname then
				if isOverlayDisabled then
					outputChatBox("   - "..langname.." (" .. skill .. "%)", showPlayer)
				else
					table.insert(info, {"   - "..langname.." (" .. skill .. "%)"})
				end
			end
		end
	end
	--CAREER
	local job = getElementData(thePlayer, "job") or 0
	if job == 0 then
		if isOverlayDisabled then
			outputChatBox(" Emprego: Desempregado", showPlayer)
		else
			table.insert(info, {" Emprego: Desempregado"})
		end
	else
		local jobName = exports["job-system"]:getJobTitleFromID(job)
		local joblevel = getElementData(thePlayer, "jobLevel") or 1
		local jobProgress = getElementData(thePlayer, "jobProgress") or 0
		if isOverlayDisabled then
			outputChatBox(" Emprego: "..jobName, showPlayer)
			outputChatBox("   - Level: "..joblevel, showPlayer)
			outputChatBox("   - Progresso: "..jobProgress, showPlayer)
		else
			table.insert(info, {" Emprego: "..jobName})
			table.insert(info, {"   - Level: "..joblevel})
			table.insert(info, {"   - Progresso: "..jobProgress})
		end
	end
	--CARRIED
	local carried = " Peso Transportado: "..("%.2f/%.2f" ):format( exports["item-system"]:getCarriedWeight( thePlayer ), exports["item-system"]:getMaxWeight( thePlayer ) ).." kg(s)"
	if isOverlayDisabled then
		outputChatBox( carried, showPlayer)
	else
		table.insert(info, {carried})
	end
	--FINANCE
	local currentGC = getElementData(thePlayer, "credits") or 0
	local bankmoney = getElementData(thePlayer, "bankmoney") or 0
	local money = getElementData(thePlayer, "money") or 0
	if isOverlayDisabled then
		outputChatBox( " Finança: ", showPlayer)
		outputChatBox( "   - GCs: "..exports.global:formatMoney(currentGC), showPlayer)
		outputChatBox( "   - Dinheiro: $"..exports.global:formatMoney(money), showPlayer)
		outputChatBox( "   - Dinheiro no Banco: $"..exports.global:formatMoney(bankmoney), showPlayer)
	else
		table.insert(info, {" Finança: "})
		table.insert(info, {"   - GCs: "..exports.global:formatMoney(currentGC)})
		table.insert(info, {"   - Dinheiro: $"..exports.global:formatMoney(money)})
		table.insert(info, {"   - Dinheiro no Banco: $"..exports.global:formatMoney(bankmoney)})
	end
	
	if not isOverlayDisabled then
		triggerClientEvent(showPlayer, "hudOverlay:drawOverlayTopRight", showPlayer, info ) 
	end
end
addCommandHandler("stats", showStats, false, false)
addEvent("showStats", true)
addEventHandler("showStats", root, showStats)
