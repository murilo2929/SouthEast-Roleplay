main = {
    tab = {},
    progressbar = {},
    tabpanel = {},
    edit = {},
    button = {},
    window = {},
    label = {},
    memo = {}
}

local datatable = { } -- key: factionID
local factionstable = { } -- key: vehicleID
-- So you need an event that trigger from server with the tables from server. that function does only onething, that is to assign the client table to the table from server.
function updateClientCache(newTalbes)
	datatable = newTalbes[1]
	factionstable = newTalbes[2]
end
addEvent("insurance:updateClientCache", true)
addEventHandler("insurance:updateClientCache", root, updateClientCache)


function insuranceMainGUI(theTable) -- well it's not done -- ye just table.factionid and etc hey
	if isElement(main.window[1]) then destroyElement(main.window[1]) end
	if not theTable then return false end

	guiSetInputMode("no_binds_when_editing")

	local windowName = "[" ..theTable["name"].. "] Sistema de Seguro"
	main.window[1] = guiCreateWindow(391, 230, 640, 481, windowName, false)
	guiWindowSetSizable(main.window[1], false)
	guiSetAlpha(main.window[1], 1.00)

	main.tabpanel[1] = guiCreateTabPanel(0.01, 0.05, 0.97, 0.41, true, main.window[1])

	main.tab[1] = guiCreateTab("Notícias Internas", main.tabpanel[1])

	main.memo[1] = guiCreateMemo(5, 4, 611, 165, theTable["news"] or "Nenhum", false, main.tab[1])

	main.tab[2] = guiCreateTab("Inscrição", main.tabpanel[1])

	main.memo[2] = guiCreateMemo(5, 6, 611, 164, theTable["subscription"] or "Nenhum", false, main.tab[2])

	main.tab[3] = guiCreateTab("Configurações e estatísticas", main.tabpanel[1])

	main.label[1] = guiCreateLabel(0.02, 0.05, 0.14, 0.13, "Gen. Maxi", true, main.tab[3])
	main.label[2] = guiCreateLabel(0.02, 0.18, 0.14, 0.13, "Renda total", true, main.tab[3])
	main.label[3] = guiCreateLabel(0.02, 0.32, 0.14, 0.13, "Total de reivindicações", true, main.tab[3])
	main.label[4] = guiCreateLabel(0.02, 0.46, 0.14, 0.13, "Lucro", true, main.tab[3])
	main.edit[1] = guiCreateEdit(0.18, 0.02, 0.12, 0.18, "", true, main.tab[3])
	guiSetText(main.edit[1], theTable["gen_maxi"])
	main.label[5] = guiCreateLabel(0.18, 0.18, 0.14, 0.13, tostring(theTable["totalincome"]) or "0", true, main.tab[3])
	guiLabelSetColor(main.label[5], 41, 255, 0)
	main.label[6] = guiCreateLabel(0.18, 0.32, 0.14, 0.13, tostring(theTable["totalclaims"]) or "0", true, main.tab[3])
	guiLabelSetColor(main.label[6], 255, 0, 0)
	main.label[7] = guiCreateLabel(0.02, 0.60, 0.14, 0.13, "Total de clientes", true, main.tab[3])
	main.label[9] = guiCreateLabel(0.18, 0.60, 0.14, 0.13, "ERROR", true, main.tab[3])

	local tincome = 0
	local tclaims = 0
	local c = 0
	local fId = exports.factions:getCurrentFactionDuty(getLocalPlayer())
	if fId then
		for _,v in pairs(datatable) do
			if tonumber(fId) == tonumber(v["insurancefaction"]) then
				tincome = tonumber(v["cashout"]) + tincome
				tclaims = tonumber(v["claims"]) + tclaims
				c = c + 1
			end
		end
	end
	guiSetText(main.label[9], tostring(c))
	guiSetText(main.label[5], tostring(tincome))
	guiSetText(main.label[6], tostring(tclaims))

	local profits = tonumber(tincome) - tonumber(tclaims)
	main.label[8] = guiCreateLabel(0.18, 0.46, 0.14, 0.13, tostring(profits), true, main.tab[3])

	main.button[1] = guiCreateButton(0.01, 0.48, 0.12, 0.07, "Salvar Notícias", true, main.window[1])
	main.button[2] = guiCreateButton(0.14, 0.48, 0.12, 0.07, "Salvar Assinatura", true, main.window[1])
	main.button[3] = guiCreateButton(0.27, 0.48, 0.12, 0.07, "Salvar Configurações", true, main.window[1])
	main.label[10] = guiCreateLabel(0.01, 0.56, 0.98, 0.04, "/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////", true, main.window[1])
	main.button[4] = guiCreateButton(0.78, 0.87, 0.20, 0.11, "Desligar", true, main.window[1])
	main.button[5] = guiCreateButton(0.02, 0.60, 0.12, 0.11, "Citação - Simplicidade", true, main.window[1])
	main.button[6] = guiCreateButton(0.14, 0.60, 0.12, 0.11, "Citação - Complexidade", true, main.window[1])
	main.progressbar[1] = guiCreateProgressBar(0.02, 0.93, 0.72, 0.05, true, main.window[1])
	main.button[7] = guiCreateButton(0.02, 0.72, 0.12, 0.11, "Vender", true, main.window[1])
	main.button[8] = guiCreateButton(0.14, 0.72, 0.12, 0.11, "Gerenciar", true, main.window[1])
	main.button[9] = guiCreateButton(0.78, 0.75, 0.20, 0.11, "Concessões de acesso", true, main.window[1])

	local leader = exports.factions:hasMemberPermissionTo(getLocalPlayer(), theTable["factionID"], "add_member")

	if not leader then
		guiMemoSetReadOnly(main.memo[1], true)
		guiMemoSetReadOnly(main.memo[2], true)
		guiEditSetReadOnly(main.edit[1], true)
	end

	local count = 0

	addEventHandler("onClientGUIClick", main.button[4], function ()
			if isElement(main.window[1]) then destroyElement(main.window[1]) end
			guiSetInputMode("allow_binds")
		end, false)

	addEventHandler("onClientGUIClick", main.button[1], function () -- all those client click need a check  of source == the button. else you can click the window to trigger any of them
			if not leader then return false end
			local news = guiGetText(main.memo[1])
			local result = triggerServerEvent("insurance:sql", resourceRoot, "news", exports.factions:getCurrentFactionDuty(getLocalPlayer()), news)

			if result then
				outputChatBox("Suas notícias internas foram salvas.")
			else
				outputChatBox( "An error occured while saving. ERROR: #9238IS. Contact a scripter.", getLocalPlayer(), 255, 0, 0 )
			end
		end, false)

	addEventHandler("onClientGUIClick", main.button[2], function ()
			if not leader then return false end
			local subscription = guiGetText(main.memo[2])
			local result = triggerServerEvent("insurance:sql", resourceRoot, "subscription", exports.factions:getCurrentFactionDuty(getLocalPlayer()), subscription)

			if result then
				outputChatBox("Sua assinatura foi salva.")
			else
				outputChatBox( "An error occured while saving. ERROR: #9239IS. Contact a scripter.", getLocalPlayer(), 255, 0, 0 )
			end
		end, false)

	addEventHandler("onClientGUIClick", main.button[3], function ()
			if not leader then return false end
			local maxigen = guiGetText(main.edit[1])
			local result = triggerServerEvent("insurance:sql", resourceRoot, "gen_maxi", exports.factions:getCurrentFactionDuty(getLocalPlayer()), maxigen)

			if result then
				outputChatBox("O máximo do seu gerador foi salvo.")
			else
				outputChatBox( "An error occured while saving. ERROR: #9240IS. Contact a scripter.", getLocalPlayer(), 255, 0, 0 )
			end
		end, false)

	--All the timers below are meant to simulate some latency for the system itself. It is for passive roleplay.

	addEventHandler("onClientGUIClick", main.button[5], function ()
			setTimer( function ()
					count = count + 1
					if count ~= 10 then
						local i = guiProgressBarGetProgress( main.progressbar[1] )
						guiProgressBarSetProgress( main.progressbar[1], i + 10 )
					else
						count = 0
						guiProgressBarSetProgress( main.progressbar[1], 0 )
						quoteSimplicity(theTable["name"])
					end
				end, 100, 10)
		end, false)

	addEventHandler("onClientGUIClick", main.button[7], function ()
			setTimer( function ()
					count = count + 1
					if count ~= 10 then
						local i = guiProgressBarGetProgress( main.progressbar[1] )
						guiProgressBarSetProgress( main.progressbar[1], i + 10 )
					else
						count = 0
						guiProgressBarSetProgress( main.progressbar[1], 0 )
						insuranceSellGUI(theTable["name"])
					end
				end, 100, 10)
		end, false)

	addEventHandler("onClientGUIClick", main.button[8], function ()
			setTimer( function ()
					count = count + 1
					if count ~= 10 then
						local i = guiProgressBarGetProgress( main.progressbar[1] )
						guiProgressBarSetProgress( main.progressbar[1], i + 10 )
					else
						count = 0
						guiProgressBarSetProgress( main.progressbar[1], 0 )
						manageInsurance(theTable["name"])
					end
				end, 100, 10)
		end, false)

	addEventHandler("onClientGUIClick", main.button[6], function ()
			setTimer( function ()
					count = count + 1
					if count ~= 10 then
						local i = guiProgressBarGetProgress( main.progressbar[1] )
						guiProgressBarSetProgress( main.progressbar[1], i + 10 )
					else
						count = 0
						guiProgressBarSetProgress( main.progressbar[1], 0 )
						outputChatBox("Este botão não está disponível para você.")
					end
				end, 100, 10)
		end, false)
	addEventHandler("onClientGUIClick", main.button[9], function ()
			setTimer( function ()
					count = count + 1
					if count ~= 10 then
						local i = guiProgressBarGetProgress( main.progressbar[1] )
						guiProgressBarSetProgress( main.progressbar[1], i + 10 )
					else
						count = 0
						guiProgressBarSetProgress( main.progressbar[1], 0 )
						outputChatBox("Este botão não está disponível para você.")
					end
				end, 100, 10)
		end, false)
end
addEvent("insurance:mainGUI", true)
addEventHandler("insurance:mainGUI", resourceRoot, insuranceMainGUI)

simplicity = {
    edit = {},
    button = {},
    window = {},
    label = {},
    memo = {}
}
function quoteSimplicity(companyname)
	if isElement(simplicity.window[1]) then return false end
	if not companyname then
		companyname = "ERROR"
	end

	guiSetInputMode("no_binds_when_editing")

	simplicity.window[1] = guiCreateWindow(509, 314, 409, 320, "<Citação - Simplicidade> ["..companyname.."] Sistema de Seguro", false)
	guiWindowSetSizable(simplicity.window[1], false)
	guiSetAlpha(simplicity.window[1], 1.00)

	simplicity.label[1] = guiCreateLabel(0.02, 0.09, 0.19, 0.06, "Veículo VIN", true, simplicity.window[1])
	simplicity.edit[1] = guiCreateEdit(0.22, 0.08, 0.20, 0.07, "", true, simplicity.window[1])
	simplicity.button[1] = guiCreateButton(0.45, 0.07, 0.13, 0.08, "Enviar", true, simplicity.window[1])
	simplicity.label[2] = guiCreateLabel(0.00, 0.16, 0.99, 0.05, "///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////", true, simplicity.window[1])
	simplicity.label[3] = guiCreateLabel(0.02, 0.26, 0.27, 0.73, "Dono do Veículo\n\nAno\n\nMarca\n\nModelo\n\nValor de Substituição\n\nPlaca\n\nCusto Estimado", true, simplicity.window[1])
	simplicity.memo[1] = guiCreateMemo(0.29, 0.24, 0.30, 0.73, "dono\n\nano\n\nmarca\n\nmodelo\n\nvalor\n\nplaca\n\ncustoestimado", true, simplicity.window[1])
	simplicity.button[2] = guiCreateButton(0.79, 0.07, 0.19, 0.08, "Fechar", true, simplicity.window[1])
	simplicity.label[4] = guiCreateLabel(0.68, 0.25, 0.31, 0.18, "Cobrar\n Ex: 1.20 para adicionar 20%\n 0.80 para remover 20%", true, simplicity.window[1])
	simplicity.edit[2] = guiCreateEdit(0.83, 0.46, 0.15, 0.10, "", true, simplicity.window[1])
	simplicity.button[3] = guiCreateButton(0.69, 0.62, 0.27, 0.10, "Calcular", true, simplicity.window[1])
	simplicity.label[5] = guiCreateLabel(0.60, 0.74, 0.38, 0.22, "0$", true, simplicity.window[1])
	guiSetFont(simplicity.label[5], "sa-header")
	guiLabelSetColor(simplicity.label[5], 54, 255, 0)
	guiLabelSetHorizontalAlign(simplicity.label[5], "right", true)

	addEventHandler("onClientGUIClick", simplicity.button[2], function ()
			if isElement(simplicity.window[1]) then destroyElement(simplicity.window[1]) end
			guiSetInputMode("allow_binds")
		end, false)

	addEventHandler("onClientGUIClick", simplicity.button[1], function ()
			local vinInput = guiGetText(simplicity.edit[1])

			if not tonumber(vinInput) then return false end
			if tonumber(vinInput) < 0 then return false end

			triggerServerEvent("insurance:calculate", localPlayer, tonumber(vinInput), exports.factions:getCurrentFactionDuty(getLocalPlayer()), "faction")
		end, false)

	addEventHandler("onClientGUIClick", simplicity.button[3], function ()
			local vinInput = guiGetText(simplicity.edit[1])
			if not tonumber(vinInput) then return false end
			if tonumber(vinInput) < 0 then return false end

			local charge = guiGetText(simplicity.edit[2])
			if not tonumber(charge) then return false end

			triggerServerEvent("insurance:calculate", localPlayer, tonumber(vinInput), exports.factions:getCurrentFactionDuty(getLocalPlayer()), tonumber(charge))
		end, false)

	addEvent("insurance:clientrecieve", true)
	addEventHandler("insurance:clientrecieve", localPlayer, function (owner, year, brand, model, plate, price, estimatedpremium, premium)
			local formatText = owner.."\n\n"..year.."\n\n"..brand.."\n\n"..model.."\n\n"..price.."\n\n"..plate.."\n\n"..estimatedpremium
			guiSetText(simplicity.memo[1], formatText)
			if premium then
				guiSetText(simplicity.label[5], premium.."$")
			else
				guiSetText(simplicity.label[5], estimatedpremium.."$")
			end
		end)
end



sell = {
    edit = {},
    button = {},
    window = {},
    label = {},
    memo = {}
}

function insuranceSellGUI(companyname)
	if isElement(sell.window[1]) then return false end
	if not companyname then
		companyname = "ERROR"
	end

	guiSetInputMode("no_binds_when_editing")

	sell.window[1] = guiCreateWindow(494, 293, 352, 326, "<Vender> ["..companyname.."] Sistema de Seguro", false)
	guiWindowSetSizable(sell.window[1], false)
	guiSetAlpha(sell.window[1], 1.00)

	sell.label[1] = guiCreateLabel(0.05, 0.09, 0.08, 0.06, "VIN", true, sell.window[1])

	sell.edit[2] = guiCreateEdit(0.15, 0.08, 0.26, 0.10, "", true, sell.window[1])

	sell.button[2] = guiCreateButton(0.42, 0.07, 0.18, 0.10, "Enviar", true, sell.window[1])
	sell.button[5] = guiCreateButton(0.80, 0.07, 0.18, 0.10, "Fechar", true, sell.window[1])

	sell.label[2] = guiCreateLabel(-0.01, 0.18, 1.03, 0.06, "////////////////////////////////////////////////////////////////////////////////////", true, sell.window[1])
	sell.label[3] = guiCreateLabel(0.03, 0.27, 0.21, 0.06, "Dono:", true, sell.window[1])
	sell.label[4] = guiCreateLabel(0.03, 0.35, 0.21, 0.06, "Veículo:", true, sell.window[1])
	sell.edit[3] = guiCreateEdit(0.24, 0.25, 0.72, 0.09, "", true, sell.window[1])
	guiEditSetReadOnly(sell.edit[3], true)
	sell.edit[4] = guiCreateEdit(0.24, 0.34, 0.72, 0.09, "", true, sell.window[1])
	guiEditSetReadOnly(sell.edit[4], true)
	sell.memo[1] = guiCreateMemo(0.03, 0.57, 0.51, 0.40, "", true, sell.window[1])
	guiMemoSetReadOnly(sell.memo[1], true)
	sell.button[3] = guiCreateButton(0.03, 0.45, 0.22, 0.10, "Proteção Basica", true, sell.window[1])
	sell.edit[5] = guiCreateEdit(0.62, 0.64, 0.29, 0.14, "", true, sell.window[1])
	sell.button[4] = guiCreateButton(0.62, 0.83, 0.30, 0.13, "Vender", true, sell.window[1])
	sell.label[5] = guiCreateLabel(227, 187, 105, 21, "Taxa por dia de pagamento", false, sell.window[1])

	addEventHandler("onClientGUIClick", sell.button[5], function ()
			if isElement(sell.window[1]) then destroyElement(sell.window[1]) end
			guiSetInputMode("allow_binds")
		end, false)

	addEventHandler("onClientGUIClick", sell.button[2], function ()
			local vinInput = guiGetText(sell.edit[2])

			if not tonumber(vinInput) then return false end
			if tonumber(vinInput) < 0 then return false end

			triggerServerEvent("insurance:sellinfo", localPlayer, tonumber(vinInput))
		end, false)

	addEvent("insurance:clientrecieve:sell", true)
	addEventHandler("insurance:clientrecieve:sell", localPlayer, function (owner, year, brand, model)
			local formatText = year.." "..brand.." "..model

			guiSetText(sell.edit[4], formatText)
			guiSetText(sell.edit[3], owner)
		end)

	addEventHandler("onClientGUIClick", sell.button[3], function ()
		guiSetText(sell.memo[1], [[PROTEÇÂO BASICA

			Sem franquias.
			Apenas pequenos acidentes de carro. As reclamações são redirecionadas para garagens Pay'n'Spray.
			Pagamos integralmente, desde que sejam elegíveis para garagens Pay n Spray.
			]])
		end, false)

	addEventHandler("onClientGUIClick", sell.button[4], function ()
		local protection = guiGetText(sell.memo[1])
		if string.len(protection) < 10 then
			return false
		end
		if string.find(protection, "BASIC") ~= nil then
			protection = "Basico"
		end

		local owner = guiGetText(sell.edit[3])
		if string.len(owner) < 5 then
			return false
		end

		local premium = guiGetText(sell.edit[5])
		if not tonumber(premium) then
			return false
		end
		premium = tonumber(premium)
		premium = math.ceil(premium)
		if premium < 1 or premium > 50000 then
			return false
		end


		outputChatBox("SEGURO DE AUTOMÓVEL - "..companyname)
		outputChatBox("---CLIENTE: "..owner)
		outputChatBox("---VEÍCULO: "..guiGetText(sell.edit[4]))
		outputChatBox("---PACOTE DE PROTEÇÃO: "..protection)
		outputChatBox("--- ---PREMIUM: "..tostring(premium).."$")

		local ownerElement = getPlayerFromName( string.gsub(owner, " ", "_") ) -- ohhwel, a lot better to use pass the plain name to server than the whole element data. Well cuz an integer is so small :D
		if isElement(ownerElement) then
			outputChatBox("(Cliente avisado... aguardando resposta...)")
			triggerServerEvent("insurance:sell", getLocalPlayer() , ownerElement, premium, guiGetText(sell.edit[2]), protection) -- oh ty, salesman clicked this?
		else
			outputChatBox("O proprietário do veículo não está online. Tente mais tarde.", 255, 0, 0)
		end
	end, false)
end
-- see if it works. well it's used to work.

confirm = {
    button = {},
    window = {},
    edit = {},
    label = {}
}
-- This GUI is prompted to the customer so he can confirm that he wants to subscribe to the insurance plan. / Well kinda good work to manage to get it work lol, :D
function confirmInsurance(premium, carinfo, salesman, carid, protection)
	if isElement(confirm.window[1]) then return false end
	confirm.window[1] = guiCreateWindow(552, 357, 193, 136, "Confirmação de Seguro", false)
	guiWindowSetSizable(confirm.window[1], false)
	guiSetAlpha(confirm.window[1], 1.00)

	confirm.button[1] = guiCreateButton(0.09, 0.71, 0.35, 0.21, "SIM", true, confirm.window[1])
	confirm.button[2] = guiCreateButton(0.54, 0.71, 0.35, 0.21, "NÃO", true, confirm.window[1])
	confirm.label[1] = guiCreateLabel(0.05, 0.17, 0.30, 0.14, "Premium:", true, confirm.window[1])
	confirm.label[2] = guiCreateLabel(0.35, 0.17, 0.30, 0.14, premium.."$", true, confirm.window[1])
	confirm.edit[1] = guiCreateEdit(0.05, 0.31, 0.90, 0.18, carinfo, true, confirm.window[1])
	guiEditSetReadOnly(confirm.edit[1], true)
	confirm.label[3] = guiCreateLabel(0.05, 0.54, 0.92, 0.18, "Você confirma esse pagamento?", true, confirm.window[1])

	addEventHandler("onClientGUIClick", confirm.button[2], function ()
			outputChatBox("Você recusou o plano de seguro.")
			triggerServerEvent("insurance:outputchatbox", resourceRoot, salesman, "O cliente recusou o plano de seguro.")
			if isElement(confirm.window[1]) then destroyElement(confirm.window[1]) end
		end, false)

	addEventHandler("onClientGUIClick", confirm.button[1], function ()
			if isElement(confirm.window[1]) then destroyElement(confirm.window[1]) end
--this doesn't sound right :D the output chatbox thing. let me think
			triggerServerEvent("insurance:finalpurchase", root, salesman, getLocalPlayer(), carid, protection, premium, exports.factions:getCurrentFactionDuty(salesman) )
		end, false)
end
addEvent("insurance:confirmgui", true)
addEventHandler("insurance:confirmgui",root, confirmInsurance)


manage = {
    gridlist = {},
    progressbar = {},
    button = {},
    window = {},
    column = {}
}
function manageInsurance(companyname)
	if isElement(manage.window[1]) then return false end
	manage.window[1] = guiCreateWindow(442, 295, 491, 317, "<Gerenciar> ["..companyname.."] Sistema de Seguro", false)
	guiWindowSetSizable(manage.window[1], false)
	guiSetAlpha(manage.window[1], 1.00)

	manage.gridlist[1] = guiCreateGridList(0.02, 0.07, 0.96, 0.46, true, manage.window[1])
	manage.column[1] = guiGridListAddColumn(manage.gridlist[1], "Apólice ID", 0.1)
	manage.column[2] = guiGridListAddColumn(manage.gridlist[1], "Cliente", 0.1)
	manage.column[3] = guiGridListAddColumn(manage.gridlist[1], "Veículo", 0.1)
	manage.column[4] = guiGridListAddColumn(manage.gridlist[1], "Proteção", 0.1)
	manage.column[5] = guiGridListAddColumn(manage.gridlist[1], "Premium", 0.1)
	manage.column[6] = guiGridListAddColumn(manage.gridlist[1], "Franquia", 0.1)
	manage.column[7] = guiGridListAddColumn(manage.gridlist[1], "Segurado de", 0.1)
	manage.column[8] = guiGridListAddColumn(manage.gridlist[1], "Reivindicações", 0.1)
	manage.column[9] = guiGridListAddColumn(manage.gridlist[1], "Saque", 0.1)
	manage.button[1] = guiCreateButton(0.79, 0.84, 0.19, 0.13, "Fechar", true, manage.window[1])
	manage.button[2] = guiCreateButton(0.02, 0.55, 0.16, 0.11, "Editar", true, manage.window[1])
	manage.button[3] = guiCreateButton(0.19, 0.55, 0.16, 0.11, "Cancelar", true, manage.window[1])
	manage.progressbar[1] = guiCreateProgressBar(0.02, 0.90, 0.74, 0.07, true, manage.window[1])
	guiGridListSetSortingEnabled(manage.gridlist[1], true)

	addEventHandler("onClientGUIClick", manage.button[1], function ()
			if isElement(manage.window[1]) then destroyElement(manage.window[1]) end
		end, false)

	addEventHandler("onClientGUIClick", manage.button[2], function ()
			outputChatBox("Este botão ainda não foi liberado. Por enquanto, cancele a apólice de alguém e crie uma nova para editá-la.")
		end, false)

	addEventHandler("onClientGUIClick", manage.button[3], function ()
			local rindex, cindex = guiGridListGetSelectedItem(manage.gridlist[1])
			local id = guiGridListGetItemText(manage.gridlist[1], rindex, manage.column[3]) -- this works too
			outputChatBox(id) -- yeha i idididididididid! try it
			if rindex ~= -1 then
				triggerServerEvent("insurance:cancel", localPlayer, id)
			else
				outputChatBox("Você deve selecionar uma apólice da lista.")
			end
		end, false)
	
	local playerFaction = exports.factions:getCurrentFactionDuty(getLocalPlayer())
	if playerFaction then
		for k,v in pairs(datatable) do
			if tonumber(v["insurancefaction"]) == playerFaction then
				local row = guiGridListAddRow(manage.gridlist[1])
				guiGridListSetItemText( manage.gridlist[1], row, manage.column[1], v["policyid"], false, true)
				guiGridListSetItemText( manage.gridlist[1], row, manage.column[2], v["customername"], false, false)
				guiGridListSetItemText( manage.gridlist[1], row, manage.column[3], v["vehicleid"], false, true)
				guiGridListSetItemText( manage.gridlist[1], row, manage.column[4], v["protection"], false, false)
				guiGridListSetItemText( manage.gridlist[1], row, manage.column[5], v["premium"], false, true)
				guiGridListSetItemText( manage.gridlist[1], row, manage.column[6], v["deductible"], false, true)
				guiGridListSetItemText( manage.gridlist[1], row, manage.column[7], v["date"], false, false)
				guiGridListSetItemText( manage.gridlist[1], row, manage.column[8], v["claims"], false, true)
				guiGridListSetItemText( manage.gridlist[1], row, manage.column[9], v["cashout"], false, true)
			end
		end
	end
end
