--MAXIME
local wDonation,lSpendText,lActive,lAvailable, bClose,f7state, bRedeem, GUIEditor_TabPanel = nil
local lItems = {}
local bItems = { }
local screenWidth, screenHeight = guiGetScreenSize()
local obtained = {}
local available = {}
local credits = 0
local tab = {}
local grid = {}
local col = {}
local GUIEditor_Window = {}
local gui = {}
local ranking = {}
local history = {}
local purchased = {}
--local rankThisMonth = {}
local globalPurchaseHistory = {}

function openDonationGUI(obtained1, available1, credits1, history1, purchased1, globalPurchaseHistory1)
	showCursor(true)
	guiSetInputEnabled(true)
	obtained = obtained1
	available = available1
	credits = tonumber(credits1)
	--ranking = ranking1
	history = history1
	purchased = purchased1
	--rankThisMonth = rankThisMonth1
	globalPurchaseHistory = globalPurchaseHistory1
	if wDonation and isElement(wDonation) then
		--
	else
		triggerEvent( 'hud:blur', resourceRoot, 6, false, 0.5, nil )
		local w, h = 800,474
		local x, y = (screenWidth-w)/2, (screenHeight-h)/2
		wDonation = guiCreateWindow(x,y,w,h,"Recursos premium",false)
		guiWindowSetSizable(wDonation, false)

		GUIEditor_TabPanel = guiCreateTabPanel(0.0122,0.0401,0.9757,0.87,true,wDonation)
		tab.availableItems = guiCreateTab("Itens disponíveis",GUIEditor_TabPanel)
		tab.activatedPerks = guiCreateTab("Benefícios ativados",GUIEditor_TabPanel)
		tab.purchased = guiCreateTab("Histórico de compras",GUIEditor_TabPanel)
		tab.history = guiCreateTab("Minhas doações",GUIEditor_TabPanel)
		--tab.rankThisMonth = guiCreateTab("Donors of month",GUIEditor_TabPanel)
		--tab.rank = guiCreateTab("Donors of all times",GUIEditor_TabPanel)

		if exports.integration:isPlayerLeadAdmin(localPlayer) then
			tab.recent = guiCreateTab("Compras globais",GUIEditor_TabPanel)
		end

		grid.availableItems = guiCreateGridList(0,0,1,1,true,tab.availableItems)
		guiGridListSetSortingEnabled ( grid.availableItems, false )
		col.name = guiGridListAddColumn(grid.availableItems,"Nome do Perk",0.78)
		col.duration = guiGridListAddColumn(grid.availableItems,"Duração",0.1)
		col.price = guiGridListAddColumn(grid.availableItems,"Custo",0.07)
		--col.id = guiGridListAddColumn(grid.availableItems,"ID",0)

		grid.activatedPerks = guiCreateGridList(0,0,1,1,true,tab.activatedPerks)
		guiGridListSetSortingEnabled ( grid.activatedPerks, false )
		col.a_name = guiGridListAddColumn(grid.activatedPerks,"Nome do Perk",0.7)
		col.a_expire = guiGridListAddColumn(grid.activatedPerks,"Data de validade",0.2)
		--col.a_id = guiGridListAddColumn(grid.activatedPerks,"ID",0.1)

		grid.purchased = guiCreateGridList(0,0,1,1,true,tab.purchased)
		col.b_name = guiGridListAddColumn(grid.purchased,"Nome do Perk",0.6)
		col.b_GC = guiGridListAddColumn(grid.purchased,"Custo",0.1)
		col.b_purchaseDate = guiGridListAddColumn(grid.purchased,"Data da Compra",0.2)
		--[[
		grid.rankThisMonth = guiCreateGridList(0,0,1,1,true,tab.rankThisMonth)
		col.r_rank_month = guiGridListAddColumn(grid.rankThisMonth,"Rank",0.1)
		col.r_donor_month = guiGridListAddColumn(grid.rankThisMonth,"Donor",0.4)
		col.r_total_month = guiGridListAddColumn(grid.rankThisMonth,"Donated in total",0.4)

		grid.rank = guiCreateGridList(0,0,1,1,true,tab.rank)
		col.r_rank = guiGridListAddColumn(grid.rank,"Rank",0.1)
		col.r_donor = guiGridListAddColumn(grid.rank,"Donor",0.4)
		col.r_total = guiGridListAddColumn(grid.rank,"Donated in total",0.4)
		]]
		grid.history = guiCreateGridList(0,0,1,1,true,tab.history)
		--col.h_id = guiGridListAddColumn(grid.history,"ID",0.05)
		col.h_txn_id = guiGridListAddColumn(grid.history,"Transação ID",0.2)
		col.h_email = guiGridListAddColumn(grid.history,"Detalhes",0.45)
		col.h_amount = guiGridListAddColumn(grid.history,"Quantia",0.1)
		col.h_date = guiGridListAddColumn(grid.history,"Data",0.2)

		if exports.integration:isPlayerLeadAdmin(localPlayer) then
			grid.recent = guiCreateGridList(0,0,1,1,true,tab.recent)
			col.r_account = guiGridListAddColumn(grid.recent,"Conta",0.2)
			col.r_details = guiGridListAddColumn(grid.recent,"Detalhes",0.4)
			col.r_amount = guiGridListAddColumn(grid.recent,"Quantia",0.1)
			col.r_date = guiGridListAddColumn(grid.recent,"Data",0.2)
		end

		gui.donate = guiCreateButton(0.0135,0.9135,0.48715,0.0675,"Adquirir GCs!",true,wDonation)
		--guiCreateStaticImage(663, 25, 13, 13, "gamecoin.png", false, wDonation)
		guiSetFont(gui.donate, "default-bold-small")

		addEventHandler("onClientGUIClick", gui.donate, function()
			if source == gui.donate then
				showInfoPanel(1)
			end
		end)

		bClose = guiCreateButton(0.0135+0.48715,0.9135,0.48715,0.0675,"Fechar",true,wDonation)
		guiSetFont(bClose, "default-bold-small")
		addEventHandler("onClientGUIClick", bClose, function()
			if source == bClose then
				closeDonationGUI()
			end
		end)
		lSpendText = guiCreateLabel(0.82, 0.05, 0.3, 0.05, "GameCoins:     "..exports.global:formatMoney(credits), true, wDonation)
		guiCreateStaticImage(725, 25, 13, 13, "gamecoin.png", false, wDonation)
		guiSetFont(lSpendText, "default-bold-small")
	end
	updateAvailablePerks()
	updateObtainedPerks()
	updatePurchaseHistory()
	--updateRanking()
	--updateRankingMonth()
	updateMyHistory()
	updateRecents()
	guiSetText(lSpendText ,"GameCoins:     "..exports.global:formatMoney(credits))
end
addEvent("donation-system:GUI:open", true)
addEventHandler("donation-system:GUI:open", getRootElement(), openDonationGUI)

function updateAvailablePerks()
	guiGridListClear(grid.availableItems)
	local purchasable = 0
	local gcTransferFee = false
	for perkID, perkArr in ipairs(available) do
		if (perkArr[1] ~= nil) and (perkArr[2] ~= 0) then
			local row = guiGridListAddRow(grid.availableItems)

			guiGridListSetItemText(grid.availableItems, row, col.name, perkArr[1], false, false)

			guiGridListSetItemText(grid.availableItems, row, col.duration, ( perkArr[3] > 1 and (perkArr[3] .." dias") or "Permanente") , false, false)

			if perkArr[4] == 13 then--GCs Transfer
				guiGridListSetItemText(grid.availableItems, row, col.price, "Taxa "..perkArr[2].."%", false, false)
				gcTransferFee = tonumber(perkArr[2]) or 0
			elseif perkArr[4] == 14 then--max ints
				local nextIntCap = tonumber( getElementData(localPlayer, "maxinteriors") )+1
				if credits >= perkArr[2]*(nextIntCap-10)*2 then
					guiGridListSetItemText(grid.availableItems, row, col.price, perkArr[2]*(nextIntCap-10)*2 .." GC" , false, false)
				else
					guiGridListSetItemText(grid.availableItems, row, col.price, perkArr[2]*(nextIntCap-10)*2 .." GC (insuficiente)", false, false)
				end
			elseif perkArr[4] == 15 then--max veh
				local currentMaxVehicles = tonumber( getElementData(localPlayer, "maxvehicles") )+1
				if credits >= perkArr[2]*(currentMaxVehicles-5)*2 then
					guiGridListSetItemText(grid.availableItems, row, col.price, perkArr[2]*(currentMaxVehicles-5)*2 .." GC" , false, false)
				else
					guiGridListSetItemText(grid.availableItems, row, col.price, perkArr[2]*(currentMaxVehicles-5)*2 .." GC (insuficiente)", false, false)
				end
			else
				if credits >= perkArr[2] then
					guiGridListSetItemText(grid.availableItems, row, col.price, perkArr[2] .." GC" , false, false)
				else
					guiGridListSetItemText(grid.availableItems, row, col.price, perkArr[2] .." GC (insuficiente)", false, false)
				end
			end
			--guiGridListSetItemText(grid.availableItems, row, col.id, perkArr[4] , false, true)
			guiGridListSetItemData ( grid.availableItems , row, 1, perkArr[4] )
		end
	end

	addEventHandler( "onClientGUIDoubleClick", grid.availableItems,
		function( button )
			if button == "left" then
				local row, col = -1, -1
				local row, col = guiGridListGetSelectedItem(grid.availableItems)
				if row ~= -1 and col ~= -1 then
					local cName = guiGridListGetItemText( grid.availableItems , row, 1 )
					local cDur = guiGridListGetItemText( grid.availableItems , row, 2 )
					local cCost = string.match(guiGridListGetItemText( grid.availableItems , row, 3 ),"%d+")
					local cID = guiGridListGetItemData( grid.availableItems , row, 1 )
					cID = tonumber(cID)
					if cID == 13 and gcTransferFee then
						showGcTransfer(cID, gcTransferFee)
					elseif tonumber(cID) == 18 or tonumber(cID) == 19 then
						showPhonePicker(cID)
					elseif cID == 20 or cID == 21 or cID == 22 or cID == 23 or cID == 28 or cID == 33 or cID == 35 or cID == 36 or cID == 37 or cID == 38 then
						showInfoPanel(cID, cCost)
					elseif cID == 16 then
						showUsernameChange(cID)
					elseif cID == 17 then
						showKeypadDoorLock(cID)
					elseif cID == 29 then
						showCustomChatIconMenu(cID, cCost)
					elseif cID == 30 or cID == 31 then
						triggerServerEvent("bank:applyForNewATMCard", localPlayer)
					elseif cID == 34 then
						showLearnLanguageMenu(cID, cCost)
					else
						showConfirmSpend(cName, cDur, cCost, cID)
					end
					playSuccess()
				end
			end
		end,
	false)
end

function updateObtainedPerks()
	guiGridListClear(grid.activatedPerks)
	for perkID, perkTable in ipairs(obtained) do
		local perkArr = perkTable[1]
		local expirationDate = perkTable[2] or "Nunca"
		if (perkArr[1] ~= nil) then
			local row = guiGridListAddRow(grid.activatedPerks)
			guiGridListSetItemText(grid.activatedPerks, row, col.a_name, perkArr[1] , false, false)
			guiGridListSetItemText(grid.activatedPerks, row, col.a_expire, expirationDate , false, false)
			guiGridListSetItemData(grid.activatedPerks, row, 1, perkArr[4] )
		end
	end

	addEventHandler( "onClientGUIDoubleClick", grid.activatedPerks,
		function( button )
			if button == "left" then
				local row, col = -1, -1
				local row, col = guiGridListGetSelectedItem(grid.activatedPerks)
				if row ~= -1 and col ~= -1 then
					local aName = guiGridListGetItemText( grid.activatedPerks , row, 1 )
					local aExpireDate = guiGridListGetItemText( grid.activatedPerks , row, 2 )
					local aID = guiGridListGetItemData( grid.activatedPerks , row, 1 )
					if aID == "29" then
						showCustomChatIconMenu(aID, "0 GC", true)
					else
						showConfirmRemovePerk(aName, aExpireDate, aID)
					end
					playSuccess()
				end
			end
		end,
	false)
end

function updateRanking()
	--ranking = sortTable(ranking)
	guiGridListClear(grid.rank)
	local maxRow = #ranking
	for i = 1, maxRow do
		local row = guiGridListAddRow(grid.rank)
		guiGridListSetItemText(grid.rank, row, col.r_rank, i , false, true)
		guiGridListSetItemText(grid.rank, row, col.r_donor, ranking[i][1] , false, false)
		guiGridListSetItemText(grid.rank, row, col.r_total, "$"..ranking[i][2] , false, true)
	end
end

function updateRankingMonth()
	guiGridListClear(grid.rankThisMonth)
	local maxRow = #rankThisMonth
	for i = 1, maxRow do
		local row = guiGridListAddRow(grid.rankThisMonth)
		guiGridListSetItemText(grid.rankThisMonth, row, col.r_rank_month, i , false, true)
		guiGridListSetItemText(grid.rankThisMonth, row, col.r_donor_month, rankThisMonth[i][1] , false, false)
		guiGridListSetItemText(grid.rankThisMonth, row, col.r_total_month, "$"..rankThisMonth[i][2] , false, true)
	end
end

function updateMyHistory()
	guiGridListClear(grid.history)
	for i = 1, #history do
		local row = guiGridListAddRow(grid.history)
		--guiGridListSetItemText(grid.history, row, col.h_id, history[i]["order_id"] , false, true)
		guiGridListSetItemText(grid.history, row, col.h_txn_id, history[i].id , false, false)
		guiGridListSetItemText(grid.history, row, col.h_email, history[i].details, false, false)
		guiGridListSetItemText(grid.history, row, col.h_amount, history[i].amount , false, true)
		guiGridListSetItemText(grid.history, row, col.h_date, history[i].date , false, false)
	end
end

function updatePurchaseHistory()
	guiGridListClear(grid.purchased)
	for i = 1, #purchased do
		local row = guiGridListAddRow(grid.purchased)
		guiGridListSetItemText(grid.purchased, row, col.b_name, purchased[i][1] , false, false)
		guiGridListSetItemText(grid.purchased, row, col.b_GC, ((tonumber(purchased[i][2]) > 0) and ("+"..purchased[i][2]) or (purchased[i][2])).." GC(s)", false, true)
		guiGridListSetItemText(grid.purchased, row, col.b_purchaseDate, purchased[i][3] , false, false)
	end

	addEventHandler( "onClientGUIDoubleClick", grid.purchased,
		function( button )
			if button == "left" then
				local row, col = -1, -1
				local row, col = guiGridListGetSelectedItem(grid.purchased)
				if row ~= -1 and col ~= -1 then
					local b_name = guiGridListGetItemText( grid.purchased , row, 1 )
					local b_GC = guiGridListGetItemText( grid.purchased , row, 2 )
					local b_purchaseDate = guiGridListGetItemText( grid.purchased , row, 3 )
					if setClipboard(b_name.." - "..b_GC.." - "..b_purchaseDate) then
						playSuccess()
						outputChatBox("Copied.")
					end
				end
			end
		end,
	false)
end

function updateRecents()

	if exports.integration:isPlayerLeadAdmin(localPlayer) then
		guiGridListClear(grid.recent)
		for i = 1, #globalPurchaseHistory do
			local row = guiGridListAddRow(grid.recent)
			guiGridListSetItemText(grid.recent, row, col.r_account, (globalPurchaseHistory[i][4] or "Desconhecido") , false, false)
			guiGridListSetItemText(grid.recent, row, col.r_details, (globalPurchaseHistory[i][1] or "Desconhecido") , false, false)
			guiGridListSetItemText(grid.recent, row, col.r_amount, ( tonumber(globalPurchaseHistory[i][2]) > 0 and ("+"..globalPurchaseHistory[i][2]) or (globalPurchaseHistory[i][2])).." GC(s)" , false, true)
			guiGridListSetItemText(grid.recent, row, col.r_date, globalPurchaseHistory[i][3] , false, false)
		end
	end

end

function closeDonationGUI()
	closeConfirmSpend()
	if wDonation and isElement(wDonation) then
		destroyElement(wDonation)
		wDonation,lSpendText,lActive,lAvailable,bClose,bRedeem  = nil
		lItems = {}
		bItems = { }
		triggerEvent( 'hud:blur', resourceRoot, 'off' )
	end
	hideKeyValidator()
	hidePhonePicker()
	guiSetInputEnabled(false)
	showCursor(false)
end

--

function showInfoPanel(state, cost)
	closeInfoPanel()
	if wDonation and isElement(wDonation) then
		guiSetEnabled(wDonation, false)
	end
	playSuccess()
	local length = 110
	local content = ""
	local confirmBtnText = "Ok"
	local links = {
		[1] = "https://discord.gg/bZATeG69uR",
		[20] = "",
		[21] = "",
	}
	if state == 1 then -- Donation intro
		length = 120
		content = "Hey, "..getElementData(localPlayer, "account:username").."! Nossa comunidade precisa de sua ajuda! Compre GCs agora para apoiar o trabalho comunitário deste projeto!\n\nAo ajudar nosso servidor, você será presenteado com uma quantidade de GameCoins. Esta é outra moeda além do dinheiro no jogo e é usada para desbloquear recursos especiais.\n\nCada Real que recebemos é investido diretamente no trabalho de desenvolvimento para a comunidade e no pagamento de despesas relacionadas à manutenção dos servidores do Live Yours!\n\nPor favor visite '"..links[state].."' para doar."
		confirmBtnText = "Copiar Link"
	elseif state == 20 then-- Assest transfer
		length = 65
		content = "Você tem atualmente "..exports.global:formatMoney(credits).." GC para que você seja capaz de  "..math.floor(credits/cost).." transferir.\n\nVocê pode obter mais GC comprando-os em nosso discord.\n\nIsso custa "..cost.." GC para cada vez que transfere alguns ou todos os bens (dinheiro, interiores, veículos, ...) de um personagem para um personagem alternativo seu.\n\nPor favor visite '"..links[state].."' para processar a transferência."
		confirmBtnText = "Copiar Link"
	elseif state == 21 then-- Custom int
		length = 155
		content = "Você pode gastar "..cost.." Game Coins para obter um interior personalizado para sua propriedade.\n\nDepois de inserir o mapa, ele será validado, processado e estará pronto para uso no jogo instantaneamente.\n\n- Você pode fazer upload apenas de arquivos .map.\n- O tamanho do arquivo deve ser menor que 100 KB.\n- O arquivo de mapa deve conter menos de 250 objetos.\n- O arquivo do mapa deve conter pelo menos 1 cilindro (marcador para a saída do interior).\n- Todos os objetos devem ser colocados dentro dos limites do mundo nos eixos X, Y, Z entre -3000 e 3000\n\nPara enviar seu mapa nos contate no discord. '"..links[state].."'."

		confirmBtnText = "Copiar Link"
	elseif state == 22 then-- Instant driver's licenses & fishing permit
		length = 0
		content = "Você pode gastar "..cost.." Game Coins para obter uma carteira de motorista instantânea de qualquer tipo (automotivo, motocicleta, barco) ou uma licença de pesca do Departamento de Veículos Motorizados (DMV) em qualquer momento e sem fazer nenhum exame.\n\nPor favor visite DMV para ativar este benefício."
		confirmBtnText = "Activate"
	elseif state == 23 then-- Personalized vehicle licence plates
		length = 0
		content = "Você pode gastar "..cost.." Game Coins para dar a si mesmo opções para escolher uma mensagem personalizada apropriada que equilibre o direito de expressão pessoal e os padrões da comunidade na placa do seu veículo.\n\nPor favor visite DMV para ativar este benefício."
		confirmBtnText = "Activate"
	elseif state == 24 then-- 	Unregistered vehicle
		length = 0
		content = "Você pode gastar "..cost.." Game Coins para remover o registro do seu veículo. Deixe o seu veículo escondido da gestão e fiscalização do Governo.\n\nPor favor visite DMV para ativar este benefício."
		confirmBtnText = "Activate"
	elseif state == 25 then-- 	No-plate vehicle
		length = 0
		content = "Você pode gastar "..cost.." Game Coin para remover a placa do seu veículo, prepare-o para alguns negócios sujos.\n\nPor favor visite DMV para ativar este benefício."
		confirmBtnText = "Activate"
	elseif state == 26 then-- 	No-VIN vehicle
		length = 0
		content = "Você pode gastar "..cost.." Game Coin para remover VIN de seu veículo, prepare-o para alguns negócios sujos.\n\nPor favor visite DMV para ativar este benefício."
		confirmBtnText = "Activate"
	elseif state == 28 then -- radio
		length = 230
		content = "Você pode comprar e possuir um número ilimitado de estações ("..cost.." GCs cada) para transmitir seu próprio som, voz ou canal de música no jogo.\n\nAssim que o privilégio for comprado, você poderá configurar sua estação, renovar ou comprar mais estações, renomear ou alterar o URL de streaming de sua estação a qualquer momento no Gerenciador de estação de rádio no menu F10.\n\nPara adquirir estações, por favor visite o menu F10 -> Gerenciador de estação de rádio -> Estação Doador -> Criar nova estação."
	elseif state == 33 then-- Cellphone Private Number
		length = 0
		content = "Você pode gastar "..cost.." Moedas de jogo para fazer com que seu identificador de chamadas seja oculto na tela do celular de outro jogador.\n\nPegue o seu telefone, vá para Configurações -> Chamadas para ativar este benefício."
		confirmBtnText = "OK"
	elseif state == 35 then--
		length = 250
		content = "Os seriais são usados pelo servidor MTA e pelos administradores do servidor para identificar com segurança um PC que o jogador está usando. Eles estão vinculados à configuração de software e hardware. As séries têm 32 caracteres e contêm letras e números.\n\nSeriais são a forma mais precisa de identificar jogadores que o MTA possui. Por padrão, você tem permissão para se conectar ao servidor Live yours MTA de qualquer PC. No entanto, permitir apenas conexões de determinado (s) PC (s) criando uma lista branca de publicações em série pode melhorar muito a segurança da sua conta. O hacker não conseguirá acessar sua conta de um PC estranho, mesmo quando sua senha estiver completamente exposta.\n\nIt's always recommended to have at least one serial of your favorite PC added to the serial whitelist.\n\nPor padrão, ele permite que apenas 2 números de série sejam adicionados por motivos de segurança. Se você quiser ter mais números de série em sua lista de permissões, vai custar "..cost.." GC(s) por cada número adicional.\n\nPara ativar fale com um administrador."
		confirmBtnText = "OK"
	elseif state == 36 then--
		length = 120
		content = "Um interior fica inativo quando ninguem entrou nele por 14 dias ou quando seu personagem não entrou no jogo por 30 dias.\n\nUm interior inativo é um desperdício de recursos e, até agora, a propriedade do interior será retirada de você para dar a outros jogadores a oportunidade de comprá-lo e usá-lo de maneira mais eficiente.\n\nPara evitar que isso aconteça, você pode usar seu (s) GC (s) para protegê-lo do scanner interno inativo. Isso custa "..cost.." GCs por semana, você também pode estender a duração dentro e depois de ativar o benefício.\n\nFale com um administrador para ativar."
		confirmBtnText = "OK"
	elseif state == 37 then--
		length = 30
		content = "Offline Private Message is a premium feature that allows you to send a private massage to any player no matter if they're online or offline.\n\nIt costs "..cost.." GC(s) per message (free-of-charge for staff members).\n\nTo send offline private message click OK or type /opm"
		confirmBtnText = "OK"
	elseif state == 38 then--
		length = 120
		content = "Um veículo fica inativo quando seu personagem não está logado no jogo por 30 dias ou quando ninguem ligou seu motor por 14 dias enquanto estacionava ao ar livre.\n\nUm veículo inativo é um desperdício de recursos e, até agora, o veículo será removido ou sua propriedade deve ser retirada de você para dar a outros jogadores a oportunidade de comprá-lo e usá-lo com mais eficiência.\n\nPara evitar que isso aconteça, você pode gastar seu (s) GC (s) para protegê-lo do scanner inativo do veículo. \n\nIsso custa "..cost.." GCs por semana.\n\nFale com um administrador para ativar."
		confirmBtnText = "OK"
	end
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 350, 190+length
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	wPhone = guiCreateStaticImage(left, top, windowWidth, windowHeight, ":resources/window_body.png", false)

	gui["lblText1"] = guiCreateLabel(20, 25, windowWidth-40, 100+length, content, false, wPhone)
	guiLabelSetHorizontalAlign(gui["lblText1"], "left", true)

	gui["confirm"] = guiCreateButton(20, 140+length, 150, 30, confirmBtnText, false, wPhone)
	addEventHandler( "onClientGUIClick", gui["confirm"], function()
		if source == gui["confirm"] then
			if state == 1 or state == 20 or state == 21 then
				setClipboard(links[state])
			elseif state == 37 then
				executeCommandHandler("opm")
			end
			playSoundCreate()
			closeInfoPanel()
		end
	end)

	if state == 22 or state == 23 or state == 24 or state == 25 or state == 26 or state == 28 then
		guiSetEnabled(gui["confirm"], false)
	end

	gui["btnCancel"] = guiCreateButton(180, 140+length, 150, 30, "Cancelar", false, wPhone)
	addEventHandler( "onClientGUIClick", gui["btnCancel"], function()
		if source == gui["btnCancel"] then
			closeInfoPanel()
		end
	end)
end

function closeInfoPanel()
	if wPhone and isElement(wPhone) then
		destroyElement(wPhone)
		wPhone = nil
	end
	if wDonation and isElement(wDonation) then
		guiSetEnabled(wDonation, true)
	end
end

local wPhone = nil
local eNumber, lNumber, bNumber
local specialPhone = false
function showPhonePicker(perkID)
	if perkID == 19 then
		specialPhone = true
	else
		specialPhone = false
	end
	hidePhonePicker()
	guiSetInputEnabled(true)
	if wDonation and isElement(wDonation) then
		guiSetEnabled(wDonation, false)
	end
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 350, 190
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	wPhone = guiCreateStaticImage(left, top, windowWidth, windowHeight, ":resources/window_body.png", false)
	--guiWindowSetSizable(wPhone, false)

	guiCreateLabel(20, 25, windowWidth-40, 16, "Escolha um número de telefone de sua escolha:", false, wPhone)
	eNumber = guiCreateEdit(20, 45, windowWidth-40, 30, "", false, wPhone)
	guiSetProperty(eNumber,"ValidationString","[0-9]{0,9}")
	addEventHandler("onClientGUIChanged", eNumber, checkNumber)
	lNumber = guiCreateLabel(20, 45+30 , windowWidth-40, 16, "", false, wPhone)
	guiLabelSetColor(lNumber, 255, 0, 0)

	gui["lblText2"] = guiCreateLabel(20, 45+15*2, windowWidth-40, 70, "Ao clicar no botão Comprar, você concorda que o reembolso não é possível. Obrigado por seu apoio!", false, wPhone)
	guiLabelSetHorizontalAlign(gui["lblText2"], "left", true)
	guiLabelSetVerticalAlign(gui["lblText2"], "center", true)

	bNumber = guiCreateButton(20, 140, 150, 30, "Purchase", false, wPhone)
	guiSetEnabled(bNumber, false)
	addEventHandler("onClientGUIClick", bNumber,
		function()
			triggerServerEvent("donation-system:GUI:activate", getLocalPlayer(), perkID, guiGetText(eNumber))
			playSoundCreate()
		end, false
	)
	local cancel = guiCreateButton(180, 140, 150, 30, "Cancelar", false, wPhone)
	addEventHandler("onClientGUIClick", cancel, hidePhonePicker, false)
end

function checkNumber()
	local valid, reason = checkValidNumber(tonumber(guiGetText(eNumber)), specialPhone)
	if valid then
		guiSetText(lNumber, "Número Valido")
		guiLabelSetColor(lNumber, 0, 255, 0)

		guiSetEnabled(bNumber, true)
	else
		guiSetText(lNumber, reason)
		guiLabelSetColor(lNumber, 255, 0, 0)
		guiSetEnabled(bNumber, false)
	end
end

function hidePhonePicker()
	if wPhone then
		destroyElement(wPhone)
		wPhone = nil
	end

	if wDonation then
		guiSetEnabled(wDonation, true)
	end
	guiSetInputEnabled(false)
end
addEvent("donation-system:phone:close", true)
addEventHandler("donation-system:phone:close", getRootElement(), closeDonationGUI)

function hideKeyValidator()
	if wValidate then
		destroyElement(wValidate)
		wValidate = nil
	end

	if wDonation then
		guiSetEnabled(wDonation, true)
	end
	guiSetInputEnabled(false)
end

local guiUsername = {}
function showUsernameChange(perkID)
	hideUsernameChange()
	guiSetInputEnabled(true)
	if wDonation and isElement(wDonation) then
		guiSetEnabled(wDonation, false)
	end
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 350, 190
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	guiUsername.main = guiCreateStaticImage(left, top, windowWidth, windowHeight, ":resources/window_body.png", false)
	--guiWindowSetSizable(wPhone, false)

	guiCreateLabel(20, 25, windowWidth-40, 16, "Renomear meu nome de usuário para:", false, guiUsername.main)
	guiUsername.username = guiCreateEdit(20, 45, windowWidth-40, 30, "", false, guiUsername.main)
	guiEditSetMaxLength(guiUsername.username, 25)

	addEventHandler("onClientGUIChanged", guiUsername.username, checkUsername)
	--guiUsername.noti = guiCreateLabel(20, 45+30 , windowWidth-40, 16, "This changes your forums name also.", false, guiUsername.main)
	--guiLabelSetColor(guiUsername.noti, 255, 255, 255)

	guiUsername["lblText2"] = guiCreateLabel(20, 45+15*2, windowWidth-40, 70, "Ao clicar no botão Comprar, você concorda que o reembolso não é possível. Obrigado por seu apoio!", false, guiUsername.main)
	guiLabelSetHorizontalAlign(guiUsername["lblText2"], "left", true)
	guiLabelSetVerticalAlign(guiUsername["lblText2"], "center", true)

	guiUsername.purchase = guiCreateButton(20, 140, 150, 30, "Purchase", false, guiUsername.main)
	guiSetEnabled(guiUsername.purchase, false)
	addEventHandler("onClientGUIClick", guiUsername.purchase,
		function()
			triggerServerEvent("donation-system:GUI:activate", getLocalPlayer(), perkID, guiGetText(guiUsername.username))
			playSoundCreate()
		end, false
	)
	guiUsername.cancel = guiCreateButton(180, 140, 150, 30, "Cancelar", false, guiUsername.main)
	addEventHandler("onClientGUIClick", guiUsername.cancel, hideUsernameChange, false)
end

local guiGC = {}
local fee = nil
function showGcTransfer(perkID, fee1)
	fee = fee1
	hideGcTransfer()
	guiSetInputEnabled(true)
	if wDonation and isElement(wDonation) then
		guiSetEnabled(wDonation, false)
	end
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 350, 190+15*4
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	guiGC.main = guiCreateStaticImage(left, top, windowWidth, windowHeight, ":resources/window_body.png", false)
	--guiWindowSetSizable(wPhone, false)

	guiCreateLabel(20, 25, windowWidth-40, 16, "Insira o nome da conta para a qual deseja transferir os GCs:", false, guiGC.main)
	guiGC.username = guiCreateEdit(20, 45, windowWidth-40, 30, "", false, guiGC.main)

	guiGC.noti = guiCreateLabel(20, 45+30 , windowWidth-40, 16, "Por favor, insira o nome da conta.", false, guiGC.main)
	guiLabelSetColor(guiGC.noti, 255, 255, 255)
	guiSetFont(guiGC.noti, "default-small")

	guiCreateLabel(20, 45+15*3, windowWidth-40, 70, "Quantidade de GCs para transferir:", false, guiGC.main)
	guiGC.amount = guiCreateEdit(20, 45+15*3+20, windowWidth/2-40, 30, "", false, guiGC.main)

	guiGC.math = guiCreateLabel(windowWidth/2, 45+15*3+20 , windowWidth-40, 16, "Taxa ("..fee.."%): -- GCs", false, guiGC.main)
	guiSetFont(guiGC.math, "default-small")
	guiGC.total = guiCreateLabel(windowWidth/2, 45+15*4+20 , windowWidth-40, 16, "Total: -- GCs", false, guiGC.main)
	guiSetFont(guiGC.total, "default-small")

	guiGC["lblText2"] = guiCreateLabel(20, 45+15*6, windowWidth-40, 70, "Ao clicar no botão Transferir, você concorda que um reembolso não é possível. Obrigado por seu apoio!", false, guiGC.main)
	guiLabelSetHorizontalAlign(guiGC["lblText2"], "left", true)
	guiLabelSetVerticalAlign(guiGC["lblText2"], "center", true)

	guiGC.purchase = guiCreateButton(20, 140+15*4, 150, 30, "Transferir", false, guiGC.main)
	guiSetEnabled(guiGC.purchase, false)
	addEventHandler("onClientGUIClick", guiGC.purchase,
		function()
			if dataToSend then
				triggerServerEvent("donation-system:GUI:activate", getLocalPlayer(), perkID, dataToSend)
				playSoundCreate()
			end
			hideGcTransfer()
		end, false
	)

	addEventHandler("onClientRender", root, checkUsernameExistanceAndAmmount)

	guiGC.cancel = guiCreateButton(180, 140+15*4, 150, 30, "Cancelar", false, guiGC.main)
	addEventHandler("onClientGUIClick", guiGC.cancel, function()
		removeEventHandler("onClientRender", root, checkUsernameExistanceAndAmmount)
		hideGcTransfer()
	end, false)
end

function hideGcTransfer()
	removeEventHandler("onClientRender", root, checkUsernameExistanceAndAmmount)
	if guiGC.main and isElement(guiGC.main) then
		destroyElement(guiGC.main)
	end
	guiGC = {}
	if wDonation then
		guiSetEnabled(wDonation, true)
	end
	guiSetInputEnabled(false)
end

function checkUsernameExistanceAndAmmount()
	local isEverythingAlright = true
	dataToSend = {}
	local valid, reason, found = exports.cache:checkUsernameExistance(guiGetText(guiGC.username))
	if valid then
		dataToSend.target = found
		guiSetText(guiGC.noti, reason)
		guiLabelSetColor(guiGC.noti, 0, 255, 0)
	else
		guiSetText(guiGC.noti, reason)
		guiLabelSetColor(guiGC.noti, 255, 0, 0)
		isEverythingAlright = false
	end

	local amount = tonumber(guiGetText(guiGC.amount))
	if amount and amount > 0 then
		amount = math.floor(amount)
		dataToSend.amount = amount
		local fee1 = math.ceil(amount/100*math.ceil(fee))
		guiSetText(guiGC.math, "Taxa ("..fee.."%): "..fee1.." GCs")
		local total = amount+fee1
		dataToSend.total = total
		guiSetText(guiGC.total, "Total: "..total.." GCs")
		if credits >= total then
			guiLabelSetColor(guiGC.math, 0, 255, 0)
			guiLabelSetColor(guiGC.total, 0, 255, 0)
		else
			guiLabelSetColor(guiGC.math, 255, 0, 0)
			guiLabelSetColor(guiGC.total, 255, 0, 0)
			isEverythingAlright = false
		end
	else
		isEverythingAlright = false
	end

	if isEverythingAlright then
		guiSetEnabled(guiGC.purchase, true)
	else
		guiSetEnabled(guiGC.purchase, false)
	end
end



function hideUsernameChange()
	for i, gui in pairs(guiUsername) do
		if gui and isElement(gui) then
			destroyElement(gui)
		end
	end
	guiUsername = {}
	if wDonation then
		guiSetEnabled(wDonation, true)
	end
	guiSetInputEnabled(false)
end
addEvent("donation-system:username:close", true)
addEventHandler("donation-system:username:close", getRootElement(), hideUsernameChange)

function checkUsername()
	local valid, reason = checkValidUsername(guiGetText(guiUsername.username))
	if valid then
		guiSetText(guiUsername.noti, reason)
		guiLabelSetColor(guiUsername.noti, 0, 255, 0)
		guiSetEnabled(guiUsername.purchase, true)
	else
		guiSetText(guiUsername.noti, reason)
		guiLabelSetColor(guiUsername.noti, 255, 0, 0)
		guiSetEnabled(guiUsername.purchase, false)
	end
end

local keypadDoor = {}
local comboItemIndex = {}
function showKeypadDoorLock(perkID)
	local offSet = 15*6
	hideKeypadDoorLock()
	guiSetInputEnabled(true)
	if wDonation and isElement(wDonation) then
		guiSetEnabled(wDonation, false)
	end
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 350, 190+offSet
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	keypadDoor.main = guiCreateStaticImage(left, top, windowWidth, windowHeight, ":resources/window_body.png", false)
	--guiWindowSetSizable(wPhone, false)

	keypadDoor.purchase = guiCreateButton(20, 140+offSet, 150, 30, "Comprar", false, keypadDoor.main)
	guiSetEnabled(keypadDoor.purchase, false)

	local ints = getInteriorsOwnedByPlayer()
	if #ints <= 0 then
		guiSetEnabled(keypadDoor.purchase, false)
		local t1 = guiCreateLabel(20, 25, windowWidth-40, 16*4, "Você deve possuir pelo menos um interior para comprar este item.", false, keypadDoor.main)
		guiLabelSetHorizontalAlign(t1, "left", true)
		--guiLabelSetVerticalAlign(t1, "center", true)
	else
		guiSetEnabled(keypadDoor.purchase, true)
		guiCreateLabel(20, 25, windowWidth-40, 16, "Fechaduras das portas do teclado, para o interior:", false, keypadDoor.main)

		keypadDoor.charname = guiCreateComboBox(20, 45, windowWidth-40, 30, ints[1][2].." ((ID #"..ints[1][1].."))", false, keypadDoor.main)
		comboItemIndex[0] = {ints[1][1], ints[1][2]}
		for i = 1, #ints do
			guiComboBoxAddItem(keypadDoor.charname, ints[i][2].." ((ID #"..ints[i][1].."))")
			comboItemIndex[i-1] = {ints[i][1], ints[i][2]}
		end
		exports.global:guiComboBoxAdjustHeight(keypadDoor.charname, #ints+1)

		keypadDoor.noti = guiCreateLabel(20, 45+30 , windowWidth-40, 16, "", false, keypadDoor.main)
		guiLabelSetColor(keypadDoor.noti, 255, 0, 0)

		keypadDoor["lblText2"] = guiCreateLabel(20, 45+15*2, windowWidth-40, 70+offSet, "Este privilégio vem com um par de 2 fechaduras de teclado digital sem chave.\n\nEsse sistema de segurança sofisticado é muito mais seguro do que uma fechadura com chave tradicional porque não pode ser arrombado ou batido.\n\nAo clicar no botão Comprar, você concorda que o reembolso não é possível. Obrigado por seu apoio!", false, keypadDoor.main)
		guiLabelSetHorizontalAlign(keypadDoor["lblText2"], "left", true)
		guiLabelSetVerticalAlign(keypadDoor["lblText2"], "center", true)

		addEventHandler("onClientGUIClick", keypadDoor.purchase,
			function()
				local selectedIndex = guiComboBoxGetSelected ( keypadDoor.charname )
				if selectedIndex == -1 then
					selectedIndex = 0
				end

				local selectedInt = comboItemIndex[selectedIndex]
				if selectedInt and selectedInt[1] and selectedInt[2] then
					guiSetText(keypadDoor.noti, "")
					playSoundCreate()
					triggerServerEvent("donation-system:GUI:activate", getLocalPlayer(), perkID, selectedInt)
					hideKeypadDoorLock()
				else
					exports.global:PlaySoundError()
					guiSetText(keypadDoor.noti, "Este interior está defeituoso.")
				end
			end, false
		)
	end

	keypadDoor.cancel = guiCreateButton(180, 140+offSet, 150, 30, "Cancelar", false, keypadDoor.main)
	addEventHandler("onClientGUIClick", keypadDoor.cancel, hideKeypadDoorLock, false)
end

function hideKeypadDoorLock()
	for i, gui in pairs(keypadDoor) do
		if gui and isElement(gui) then
			destroyElement(gui)
		end
	end
	keypadDoor = {}
	if wDonation then
		guiSetEnabled(wDonation, true)
	end
	guiSetInputEnabled(false)
end
addEvent("donation-system:charname:close", true)
addEventHandler("donation-system:charname:close", getRootElement(), hideKeypadDoorLock)

function getInteriorsOwnedByPlayer()
	ints = {}
	for key, interior in ipairs(getElementsByType("interior")) do
		if isElement(interior) then
			local status = getElementData(interior, "status")
			if status.owner == getElementData(localPlayer, "dbid") then
				local id = getElementData(interior, "dbid")
				local name = getElementData(interior, "name")
				table.insert(ints, {id, name})
			end
		end
	end
	return ints
end


--[[
function checkCharname()
	local valid, reason = exports.account:checkValidCharacterName(guiGetText(keypadDoor.charname))
	if valid then
		guiSetText(keypadDoor.noti, reason)
		guiLabelSetColor(keypadDoor.noti, 0, 255, 0)
		guiSetEnabled(keypadDoor.purchase, true)
	else
		guiSetText(keypadDoor.noti, reason)
		guiLabelSetColor(keypadDoor.noti, 255, 0, 0)
		guiSetEnabled(keypadDoor.purchase, false)
	end
end
]]

function checkCodeLength()
	if tonumber(string.len(guiGetText(source))) == 40 then
		guiSetText(lValid, "Este código parece válido.")
		guiLabelSetColor(lValid, 0, 255, 0)
		guiSetEnabled(bValidate, true)
	else
		guiSetText(lValid, "Este código não é valido.")
		guiLabelSetColor(lValid, 255, 0, 0)
		guiSetEnabled(bValidate, false)
	end
end

function showConfirmSpend(perkName, perkDur, perkCost, perkID)
	closeConfirmSpend()
	--guiSetInputEnabled(true)
	if wDonation and isElement(wDonation) then
		guiSetEnabled(wDonation, false)
	end

	local length = 1
	local shiftDown = 0
	local previewHeight = 150
	local btmText = "Ao clicar no botão Comprar, você concorda que o reembolso não é possível. Obrigado por seu apoio!"
	if perkID == 24 or perkID == 25 or perkID == 26 then
		length = 5
		shiftDown = previewHeight+10
		btmText = "Se você possui mais de uma tela, sempre pode alternar entre telas diferentes na guia 'Benefícios ativados'.\n\n"..btmText
	elseif perkID == 28 then
		length = 8
		previewHeight = 0
		shiftDown = previewHeight+10
		btmText = "Você pode possuir um número ilimitado de estações.\n\nAssim que o perk for comprado, você poderá acessar o Radio Station Manager no menu F10, que permite configurar sua estação, renovar ou comprar mais estações, renomear ou alterar o URL de streaming da estação a qualquer momento que desejar.\n\n"..btmText
	end

	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 350, 190+15*length+shiftDown
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2



	wPhone = guiCreateStaticImage(left, top, windowWidth, windowHeight, ":resources/window_body.png", false)
	--guiWindowSetSizable(wPhone, false)

	gui["lblText1"] = guiCreateLabel(20, 25, windowWidth-40, 16, "Você está prestes a comprar o seguinte benefício:", false, wPhone)
	gui["lblVehicleName"] = guiCreateLabel(20, 45+5, windowWidth-40, 13, "Perk: "..perkName, false, wPhone)
	guiSetFont(gui["lblVehicleName"], "default-bold-small")
	gui["lblDurr"] = guiCreateLabel(20, 45+15+5, windowWidth-40, 13, "Duração: "..perkDur, false, wPhone)
	guiSetFont(gui["lblDurr"], "default-bold-small")
	gui["lblVehicleCost"] = guiCreateLabel(20, 45+15*2+5, windowWidth-40, 13, "Custo: "..exports.global:formatMoney(perkCost), false, wPhone)
	guiSetFont(gui["lblVehicleCost"], "default-bold-small")


	if perkID == 24 or perkID == 25 or perkID == 26 then
		guiCreateStaticImage(20, 45+15*4, windowWidth-40, previewHeight, ":resources/selectionScreenID"..perkID..".jpg", false, wPhone)
	end

	gui["lblText2"] = guiCreateLabel(20, 45+15*3+shiftDown, windowWidth-40, 55+15*(length), btmText, false, wPhone)
	guiLabelSetHorizontalAlign(gui["lblText2"], "left", true)
	guiLabelSetVerticalAlign(gui["lblText2"], "center", true)

	gui["spend"] = guiCreateButton(20, 140+15*(length)+shiftDown, 150, 30, "Comprar", false, wPhone)
	addEventHandler( "onClientGUIClick", gui["spend"], function()
		if source == gui["spend"] then
			if wPhone and isElement(wPhone) then
				guiSetEnabled(wPhone, false)
			end
			triggerServerEvent("donation-system:GUI:activate", localPlayer, perkID)
			playSoundCreate()
		end
	end)

	gui["btnCancel"] = guiCreateButton(180, 140+15*(length)+shiftDown, 150, 30, "Cancelar", false, wPhone)
	addEventHandler( "onClientGUIClick", gui["btnCancel"], function()
		if source == gui["btnCancel"] then
			closeConfirmSpend()
		end
	end)

end

function closeConfirmSpend()
	if wPhone then
		destroyElement(wPhone)
		wPhone = nil
	end

	if wDonation and isElement(wDonation) then
		guiSetEnabled(wDonation, true)
	end
end

function showConfirmRemovePerk(aName, aExpireDate, aID)
	if tonumber(aID) == 24 or tonumber(aID) == 25 or tonumber(aID) == 26 then
		closeConfirmRemovePerk()
		--guiSetInputEnabled(true)
		if wDonation and isElement(wDonation) then
			guiSetEnabled(wDonation, false)
		end
		local screenWidth, screenHeight = guiGetScreenSize()
		local windowWidth, windowHeight = 350, 190+150
		local left = screenWidth/2 - windowWidth/2
		local top = screenHeight/2 - windowHeight/2
		wPhone = guiCreateStaticImage(left, top, windowWidth, windowHeight, ":resources/window_body.png", false)
		--guiWindowSetSizable(wPhone, false)

		gui["lblText1"] = guiCreateLabel(20, 25, windowWidth-40, 16, "Configurações exclusivas da tela de seleção de personagens:", false, wPhone)
		guiSetFont(gui["lblText1"], "default-bold-small")
		gui["lblVehicleName"] = guiCreateLabel(20, 45+5, windowWidth-40, 13, aName, false, wPhone)
		--guiSetFont(gui["lblVehicleName"], "default-bold-small")
		gui["lblVehicleCost"] = guiCreateLabel(20, 45+15+5, windowWidth-40, 13, "Data de validade: "..aExpireDate, false, wPhone)
		--guiSetFont(gui["lblVehicleCost"], "default-bold-small")

		guiCreateStaticImage(20, 45+15*3+5, windowWidth-40, 150, ":resources/selectionScreenID"..aID..".jpg", false, wPhone)

		local hasThisPerk, thisPerkValue = hasPlayerPerk(localPlayer, aID)
		if hasThisPerk and tonumber(thisPerkValue) == 1 then
			gui["use"] = guiCreateButton(20, 45+15*4+150, windowWidth-40, 30, "Parar de usar esta tela", false, wPhone)
			addEventHandler( "onClientGUIClick", gui["use"], function()
				if source == gui["use"] then
					if wPhone and isElement(wPhone) then
						guiSetEnabled(wPhone, false)
					end
					triggerServerEvent("donators:updatePerkValue", localPlayer, localPlayer, aID, 0)
					playSoundCreate()
					closeConfirmRemovePerk()
				end
			end)
		else
			gui["use"] = guiCreateButton(20, 45+15*4+150, windowWidth-40, 30, "Usar esta tela", false, wPhone)
			addEventHandler( "onClientGUIClick", gui["use"], function()
				if source == gui["use"] then
					if wPhone and isElement(wPhone) then
						guiSetEnabled(wPhone, false)
					end
					triggerServerEvent("donators:updatePerkValue", localPlayer, localPlayer, aID, 1)
					playSoundCreate()
					closeConfirmRemovePerk()
				end
			end)
		end


		gui["spend"] = guiCreateButton(20, 140+150, 150, 30, "Remover", false, wPhone)
		addEventHandler( "onClientGUIClick", gui["spend"], function()
			if source == gui["spend"] then
				if wPhone and isElement(wPhone) then
					guiSetEnabled(wPhone, false)
				end
				triggerServerEvent("donation-system:GUI:remove", localPlayer, aID)
				playSoundCreate()
			end
		end)

		gui["btnCancel"] = guiCreateButton(180, 140+150, 150, 30, "Cancelar", false, wPhone)
		addEventHandler( "onClientGUIClick", gui["btnCancel"], function()
			if source == gui["btnCancel"] then
				closeConfirmRemovePerk()
			end
		end)
	else
		closeConfirmRemovePerk()
		--guiSetInputEnabled(true)
		if wDonation and isElement(wDonation) then
			guiSetEnabled(wDonation, false)
		end
		local screenWidth, screenHeight = guiGetScreenSize()
		local windowWidth, windowHeight = 350, 190
		local left = screenWidth/2 - windowWidth/2
		local top = screenHeight/2 - windowHeight/2
		wPhone = guiCreateStaticImage(left, top, windowWidth, windowHeight, ":resources/window_body.png", false)
		--guiWindowSetSizable(wPhone, false)

		gui["lblText1"] = guiCreateLabel(20, 25, windowWidth-40, 16, "Você está prestes a remover o seguinte benefício:", false, wPhone)
		gui["lblVehicleName"] = guiCreateLabel(20, 45+5, windowWidth-40, 13, aName, false, wPhone)
		guiSetFont(gui["lblVehicleName"], "default-bold-small")
		gui["lblVehicleCost"] = guiCreateLabel(20, 45+15+5, windowWidth-40, 13, "Data de validade: "..aExpireDate, false, wPhone)
		guiSetFont(gui["lblVehicleCost"], "default-bold-small")
		gui["lblText2"] = guiCreateLabel(20, 45+15*2, windowWidth-40, 70, "Essa ação não pode ser desfeita!", false, wPhone)
		guiLabelSetHorizontalAlign(gui["lblText2"], "left", true)
		guiLabelSetVerticalAlign(gui["lblText2"], "center", true)

		gui["spend"] = guiCreateButton(20, 140, 150, 30, "Remover", false, wPhone)
		addEventHandler( "onClientGUIClick", gui["spend"], function()
			if source == gui["spend"] then
				if wPhone and isElement(wPhone) then
					guiSetEnabled(wPhone, false)
				end
				triggerServerEvent("donation-system:GUI:remove", localPlayer, aID)
				playSoundCreate()
			end
		end)

		gui["btnCancel"] = guiCreateButton(180, 140, 150, 30, "Cancelar", false, wPhone)
		addEventHandler( "onClientGUIClick", gui["btnCancel"], function()
			if source == gui["btnCancel"] then
				closeConfirmRemovePerk()
			end
		end)
	end
end

function closeConfirmRemovePerk()
	if wPhone then
		destroyElement(wPhone)
		wPhone = nil
	end
	if wDonation and isElement(wDonation) then
		guiSetEnabled(wDonation, true)
	end
end

local chatIcon = {}
local countryFlags = {
	[1] = "Default",
	[2] = "Albania",
	[3] = "Brazil",
	[4] = "Bulgaria",
	[5] = "Canada",
	[6] = "Denmark",
	[7] = "United_Kingdom",
	[8] = "Estonia",
	[9] = "Finland",
	[10] = "France",
	[11] = "India",
	[12] = "Ireland",
	[13] = "Lithuania",
	[14] = "Morocco",
	[15] = "Montenegro",
	[16] = "Netherlands",
	[17] = "Norway",
	[18] = "Portugal",
	[19] = "Russia",
	[20] = "Scotland",
	[21] = "Serbia",
	[22] = "Spain",
	[23] = "Sweden",
	[24] = "Turkey",
	[25] = "United_States",
	[26] = "Wales",
	[27] = "Slovenia",
	[28] = "Lebanon",
	[29] = "Palestine",
	[30] = "Australia",
	[31] = "Romania",
	[32] = "Israel",
	[33] = "Lybia",
	[34] = "Hercegovina",
	[35] = "Khalistan",
	[36] = "Iraq",
	[37] = "Ukraine",
	[38] = "Puerto_Rico",
	[39] = "Latvia",
	[40] = "Mexico",
	[41] = "Poland",
	[42] = "Belgium",
	[43] = "Wallonia_(Belgian_Province)",
	[44] = "Flanders_(Belgian_Province)",
	[45] = "Jamaica",
	[46] = "Japan",
	[47] = "Slovakia",
	[48] = "Switzerland",
	[49] = "United_Arab_Emirates",
	[50] = "Egypt",
	[51] = "Croatia",
	[52] = "Kazakhstan",
	[53] = "Greece",
	[54] = "Republic_Of_Congo",
	[55] = "North_Korea",
	[56] = "Pakistan",
	[57] = "Saudi_Arabia"
}

function getFlagURL(index)
	if countryFlags[index] then
		return ":donators/typing_icons/"..countryFlags[index]..".png"
	else
		return false
	end
end

local selectedIcon = 1

function switchIcon(movingForward, currentIcon, label, image)
	local nextIcon = movingForward and (currentIcon+1) or (currentIcon-1)
	if label and image and isElement(label) and isElement(image) and countryFlags[nextIcon] then
		guiSetText(label, "("..nextIcon.."/"..(#countryFlags)..") "..(string.gsub(countryFlags[nextIcon], "_", " ")))

		local nextImg = nil
		if nextIcon == 1 then
			nextImg = ":chat-system/chat.png"
		else
			nextImg = "typing_icons/"..countryFlags[nextIcon]..".png"
		end
		guiStaticImageLoadImage(image, nextImg)
		playSoundFrontEnd(1)
		return nextIcon
	else
		playError()
	end
end

function showCustomChatIconMenu(pID, pCost, removing)
	closeCustomChatIconMenu()
	if wDonation and isElement(wDonation) then
		guiSetEnabled(wDonation, false)
	end
	playSuccess()
	selectedIcon = 1
	local length = 110

	local content = "Você pode gastar "..pCost.." sobre como obter uma bandeira de país personalizada para substituir o logotipo padrão do OwlGaming por seu próprio ícone de digitação acima da cabeça de seu personagem. \n\nDepois de comprar e ativar o benefício, você poderá mudar para bandeiras de outros países a qualquer momento na guia 'Benefícios ativados'."

	if removing then
		content = "O ícone de digitação da bandeira do país personalizado é um privilégio especial, que permite substituir o logotipo padrão do LY por seu próprio ícone acima da cabeça do personagem.\n\nEscolha um sinalizador para mudar, é grátis, pois você já comprou este benefício."
	end

	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 400, 280
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2

	local imageScale = 1
	local imageSizeW, imageSizeH = 126*imageScale, 77*imageScale
	local imgPosX = (windowWidth-imageSizeW)/2

	chatIcon.wMain = guiCreateStaticImage(left, top, windowWidth, windowHeight, ":resources/window_body.png", false)

	chatIcon["lblText1"] = guiCreateLabel(20, 25, windowWidth-40, 100, content, false, chatIcon.wMain)
	guiLabelSetHorizontalAlign(chatIcon["lblText1"], "left", true)


	chatIcon["lFlag"] = guiCreateLabel(20, 125+imageSizeH, windowWidth-40, 15, "(1/"..#countryFlags..") Default", false, chatIcon.wMain)
	guiLabelSetHorizontalAlign(chatIcon["lFlag"], "center", true)
	chatIcon["iFlag"] = guiCreateStaticImage(imgPosX, 125, imageSizeW, imageSizeH, ":chat-system/chat.png", false, chatIcon.wMain)

	btnSize = 20
	chatIcon.bPrevious = guiCreateButton(imgPosX-btnSize*2, 125+imageSizeH/2-btnSize/2, btnSize, btnSize, "<", false, chatIcon.wMain)
	chatIcon.bNext = guiCreateButton(imgPosX+btnSize+imageSizeW, 125+imageSizeH/2-btnSize/2, btnSize, btnSize, ">", false, chatIcon.wMain)

	addEventHandler( "onClientGUIClick", chatIcon.bNext, function()
		if source == chatIcon.bNext then
			local selectedIconTmp = switchIcon(true, selectedIcon, chatIcon["lFlag"], chatIcon["iFlag"])
			if selectedIconTmp and tonumber(selectedIconTmp) then
				selectedIcon = selectedIconTmp
			end
		end
	end)

	addEventHandler( "onClientGUIClick", chatIcon.bPrevious, function()
		if source == chatIcon.bPrevious then
			local selectedIconTmp = switchIcon(false, selectedIcon, chatIcon["lFlag"], chatIcon["iFlag"])
			if selectedIconTmp and tonumber(selectedIconTmp) then
				selectedIcon = selectedIconTmp
			end
		end
	end)

	local btnW = (windowWidth-40)/2
	chatIcon["confirm"] = guiCreateButton(20, 120+length, btnW, 30, (removing and "Mudar" or "Comprar"), false, chatIcon.wMain)
	addEventHandler( "onClientGUIClick", chatIcon["confirm"], function()
		if source == chatIcon["confirm"] then
			playSoundCreate()
			closeCustomChatIconMenu()
			if removing then
				triggerServerEvent("donators:updatePerkValue" , localPlayer, localPlayer, pID, selectedIcon)
			else
				triggerServerEvent("donation-system:GUI:activate", localPlayer, pID, selectedIcon)
			end
		end
	end)

	chatIcon["btnCancel"] = guiCreateButton(20+btnW, 120+length, btnW, 30, "Cancelar", false, chatIcon.wMain)
	addEventHandler( "onClientGUIClick", chatIcon["btnCancel"], function()
		if source == chatIcon["btnCancel"] then
			closeCustomChatIconMenu()
		end
	end)
end


function showLearnLanguageMenu(pID, pCost)
	closeCustomChatIconMenu()
	if wDonation and isElement(wDonation) then
		guiSetEnabled(wDonation, false)
	end
	playSuccess()
	local length = 110

	local content = "Você pode gastar "..pCost.." GC(s) em fazer seu personagem atual ("..tostring(getPlayerName(localPlayer)):gsub("_", " ")..") aprender totalmente um idioma selecionado instantaneamente. Selecione o idioma na lista abaixo."

	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 400, 280
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2

	local imageScale = 1
	local imageSizeW, imageSizeH = 126*imageScale, 77*imageScale
	local imgPosX = (windowWidth-imageSizeW)/2

	chatIcon.wMain = guiCreateStaticImage(left, top, windowWidth, windowHeight, ":resources/window_body.png", false)

	chatIcon["lblText1"] = guiCreateLabel(20, 25, windowWidth-40, 100, content, false, chatIcon.wMain)
	guiLabelSetHorizontalAlign(chatIcon["lblText1"], "left", true)

	local btnW = (windowWidth-40)/2
	chatIcon["confirm"] = guiCreateButton(20, 120+length, btnW, 30, "Comprar ("..tostring(pCost).." GCs)", false, chatIcon.wMain)
	addEventHandler( "onClientGUIClick", chatIcon["confirm"], function()
		if source == chatIcon["confirm"] then
			playSoundCreate()
			local item = guiComboBoxGetSelected(chatIcon["select"])
			local text = guiComboBoxGetItemText(chatIcon["select"], item)
			local selectedLang
			local languages = chatIcon["languages"]
			for k,v in ipairs(languages) do
				if text == v then
					selectedLang = k
					break
				end
			end
			if selectedLang then
				selectedLang = tonumber(selectedLang)
				if selectedLang > 0 then
					triggerServerEvent("donation-system:GUI:activate", localPlayer, pID, selectedLang)
				end
				closeLearnLanguageMenu()
			else
				closeLearnLanguageMenu()
			end
		end
	end)

	chatIcon["btnCancel"] = guiCreateButton(20+btnW, 120+length, btnW, 30, "Cancelar", false, chatIcon.wMain)
	addEventHandler( "onClientGUIClick", chatIcon["btnCancel"], function()
		if source == chatIcon["btnCancel"] then
			closeLearnLanguageMenu()
		end
	end)

	local languages = exports["language-system"]:getLanguageList()
	chatIcon["languages"] = languages
	--table.sort(languages)

	chatIcon["select"] = guiCreateComboBox(20, 150, windowWidth-40, 100, "Selecionar Idioma", false, chatIcon.wMain)

	for k,v in ipairs (languages) do
		guiComboBoxAddItem(chatIcon["select"], tostring(v))
	end

end
function closeLearnLanguageMenu()
	if chatIcon.wMain then
		destroyElement(chatIcon.wMain)
		chatIcon.wMain = nil
	end

	if wDonation and isElement(wDonation) then
		guiSetEnabled(wDonation, true)
	end
end

function closeCustomChatIconMenu()
	if chatIcon.wMain then
		destroyElement(chatIcon.wMain)
		chatIcon.wMain = nil
	end

	if wDonation and isElement(wDonation) then
		guiSetEnabled(wDonation, true)
	end
end
















function getResponseFromServer(code, msg)
	if code == 1 then
		closeConfirmSpend()
	elseif code == 2 then
		closeConfirmRemovePerk()
	elseif code == 3 then

	end
	if wDonation and isElement(wDonation) then
		guiSetText(wDonation, "OwlGaming Store - "..msg)
	end
end
addEvent("donation-system:getResponseFromServer", true)
addEventHandler("donation-system:getResponseFromServer", root, getResponseFromServer)

function playError()
	playSoundFrontEnd(4)
end

function playSuccess()
	playSoundFrontEnd(13)
end

function playSoundCreate()
	playSoundFrontEnd(6)
end

function isVisible()
	return wDonation and isElement(wDonation)
end
