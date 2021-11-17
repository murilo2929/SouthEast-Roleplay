--[[ //Chaos
~=~=~=~=~=~= ORGANIZED REPORTS FOR OWL INFO =~=~=~=~=~=~
Name: The name to show once the report is submitted and in the F2 menu
Staff to send to: The Usergroup ID on the forums that you are sending the report to
Abbreviation: Used in the report identifier for the staff
r, g, b: The color for the report

I used the strings as the values instead of the keys, this way its easier for us to organize.
{NAME, { Staff to send to }, Abbreviation, r, g, b} ]]

reportTypes = {
 	[1] = {"Problemas com outro jogador", {18, 17, 64, 15, 14, 16}, "PLY", 214, 6, 6, "Use este tipo se você estiver reportando um jogador devido a um problema ocorrido." },
	[2] = {"Problemas com interior", {18, 17, 64, 15, 14, 16}, "INT", 255, 126, 0, "Use este tipo se você estiver tendo problemas com um interior." },
	[3] = {"Problemas com itens", {18, 17, 64, 15, 14, 16}, "ITM", 255, 126, 0, "Use este tipo se precisar de ajuda com problema relacionado a item em seu inventario." },
	[4] = {"Duvida Geral", {30, 18, 17, 64, 15, 14, 16}, "SUP", 70, 200, 30, "Use este tipo se você tiver alguma dúvida." },
	[5] = {"Problemas Relacionados a Veículos", {30, 18, 17, 64, 15, 14, 16}, "VEH", 255, 126, 0, "Use este tipo se você tiver um problema com um veículo." },
	[6] = {"Solicitações de construção/importação de veículos", {39, 43}, "VCT", 176, 7, 237, "Use este tipo para entrar em contato com o VCT." },
	[7] = {"Duvidas sobre script", {32}, "ScrT", 148, 126, 12, "Use este tipo se você quiser entrar em contato com a Equipe de Scripting." },
    [8] = {"Arrombamento de Veículos", {14, 18, 17, 64, 15}, "VEH-BI", 255, 126, 0, "Use este tipo se você deseja relatar um furto de veículo que não atende aos padrões de roleplay."},
    [9] = {"Arrombamento de Interiores", {14, 18, 17, 64, 15}, "INT-BI", 255, 126, 0, "Use este tipo se você deseja relatar um furto de interior que não atende aos padrões de roleplay."},
	[10] = {"Problema com Mapa", {44, 28}, "MAP", 0, 150, 190, "Use este tipo se você tiver um problema com o seu mapeamento personalizado ou precisar da equipe de mapeamento." }
}

function getReportTypes( type )
	return type and reportTypes[type] or reportTypes
end

adminTeams = exports.integration:getAdminStaffNumbers()
auxiliaryTeams = exports.integration:getAuxiliaryStaffNumbers()
SUPPORTER = exports.integration:getSupporterNumber()

function getReportInfo(row, element)
	if not isElement(element) then
		element = nil
	end

	local staff = reportTypes[tonumber(row)][2]
	local players = getElementsByType("player")
	local vcount = 0
	local scount = 0


	for k,v in ipairs(staff) do
		if v == 39 or v == 43 then

			for key, player in ipairs(players) do
				if exports.integration:isPlayerVCTMember(player) or exports.integration:isPlayerVehicleConsultant(player) then
					vcount = vcount + 1
					save = player
				end
			end

			if vcount==0 then
				return false, "No momento não há membros VCT online. Contate-os aqui: Discord"
			elseif vcount==1 and save == element then -- Callback for checking if a aux staff logs out
				return false, "No momento não há membros VCT online. Contate-os aqui: Discord"
			end
		elseif v == 32 then

			for key, player in ipairs(players) do
				if exports.integration:isPlayerScripter(player) then
					scount = scount + 1
					save = player
				end
			end

			if scount==0 then
				return false, "No momento, não há membros da equipe de scripts online. Use o Centro de Suporte no discord"
			elseif scount==1 and save == element then -- Callback for checking if a aux staff logs out
				return false, "No momento, não há membros da equipe de scripts online. Use o Centro de Suporte no discord"
			end
		end
	end

	local name = reportTypes[row][1]
	local abrv = reportTypes[row][3]
	local red = reportTypes[row][4]
	local green = reportTypes[row][5]
	local blue = reportTypes[row][6]

	return staff, false, name, abrv, red, green, blue
end

function isSupporterReport(row)
	local staff = reportTypes[row][2]

	for k, v in ipairs(staff) do
		if v == SUPPORTER then
			return true
		end
	end
	return false
end

function isAdminReport(row)
	local staff = reportTypes[row][2]

	for k, v in ipairs(staff) do
		if string.find(adminTeams, v) then
			return true
		end
	end
	return false
end

function isAuxiliaryReport(row)
	local staff = reportTypes[row][2]

	for k, v in ipairs(staff) do
		if string.find(auxiliaryTeams, v) then
			return true
		end
	end
	return false
end

function showExternalReportBox(thePlayer)
	if not thePlayer then return false end
	return (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)) and (getElementData(thePlayer, "report_panel_mod") == "2" or getElementData(thePlayer, "report_panel_mod") == "3")
end

function showTopRightReportBox(thePlayer)
	if not thePlayer then return false end
	return (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)) and (getElementData(thePlayer, "report_panel_mod") == "1" or getElementData(thePlayer, "report_panel_mod") == "3")
end
