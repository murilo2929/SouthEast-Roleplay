-- RANKS/WAGES

ranks = {}		-- Ranks Cache
rank_perms = {}	-- Permissions by Rank ID
factionRanks = {}
wages = {}
wRanks = nil
bRanksSave, bRanksClose = nil
ranks_gui = {checkbox = {}, label = {}, edit = {}}

function btEditRanks(button, state)
	if (source==gButtonEditRanks) and (button=="left") and (state=="up") then
		local factionType = tonumber(getElementData(theTeam, "type"))
		lRanks = { }
		tRanks = { }
		tRankWages = { }
		
		guiSetInputEnabled(true)
		-- Window
		local sX, sY = guiGetScreenSize()
		local wX, wY = 538, 354
		local sX, sY, wX, wY = (sX/2)-(wX/2),(sY/2)-(wY/2),wX,wY
		-- sX, sY, wX, wY = 503, 249, 538, 354
		wRanks = guiCreateWindow(sX, sY, wX, wY, "Rank Management System", false)
		guiWindowSetSizable(wRanks, false)
		guiSetAlpha(wRanks, 1.0)
		-- Labels
		ranksLabel1 = guiCreateLabel(9, 27, 172, 15, "Lista de Rank Facção", false, wRanks)
		guiSetFont(ranksLabel1, "default-bold-small")
		guiLabelSetColor(ranksLabel1, 57, 146, 204)
		guiLabelSetHorizontalAlign(ranksLabel1, "center", false)
		ranksLabel2 = guiCreateLabel(288, 27, 142, 15, "Lista de permissões de facção", false, wRanks)
		guiSetFont(ranksLabel2, "default-bold-small")
		guiLabelSetColor(ranksLabel2, 57, 146, 204)
		guiLabelSetHorizontalAlign(ranksLabel2, "center", false)
		ranksLabel3 = guiCreateLabel(193, 48, 335, 32, "Permissões é o que esta classificação tem acesso. Para alternar a permissão, basta marcar/desmarcar a caixa.", false, wRanks)
		guiLabelSetHorizontalAlign(ranksLabel3, "center", true)
		-- Gridlist
		ranksGridlist = guiCreateGridList(9, 76, 175, 211, false, wRanks)
		guiGridListAddColumn(ranksGridlist, "Lista de Rank Facção", 0.9)
		guiGridListSetSortingEnabled(ranksGridlist, false)
		-- Buttons
		btRanksClose = guiCreateButton(489, 28, 38, 15, "Fechar", false, wRanks)
		btRanksMvUp = guiCreateButton(9, 292, 85, 22, "Subir", false, wRanks)
		btRanksMvDn = guiCreateButton(99, 292, 85, 22, "Descer", false, wRanks)
		btRanksUpdOrd = guiCreateButton(9, 48, 175, 22, "Atualizar ordem de Rank", false, wRanks)
		btRanksAdd = guiCreateButton(9, 320, 55, 22, "Add", false, wRanks)
		btRanksRem = guiCreateButton(129, 320, 55, 22, "Remover", false, wRanks)
		btRanksRen = guiCreateButton(69, 320, 55, 22, "Renomear", false, wRanks)
		btRanksApply = guiCreateButton(284, 313, 158, 30, "Atualizar configurações de Rank", false, wRanks)
		guiSetFont(btRanksApply, "default-bold-small")
		-- Scrollpane
		ranksScrollPane = guiCreateScrollPane(192, 87, 337, 220, false, wRanks)

		triggerServerEvent("faction-system.getRankInfo", getLocalPlayer(), faction_tab) 

		addEventHandler("onClientGUIClick", btRanksClose, closeRanks, false)
		addEventHandler("onClientGUIClick", btRanksAdd, btAddRanks, false)
		addEventHandler("onClientGUIClick", btRanksRem, btRemoveRank, false)
		addEventHandler("onClientGUIClick", btRanksRen, btRenameRank, false)
		addEventHandler("onClientGUIClick", ranksGridlist, selectRankOffList, false)
		addEventHandler("onClientGUIClick", btRanksApply, applyPermissions, false)
		addEventHandler("onClientGUIClick", btRanksMvUp, updateRankOrder, false)
		addEventHandler("onClientGUIClick", btRanksMvDn, updateRankOrder, false)
		addEventHandler("onClientGUIClick", btRanksUpdOrd, updateRankOrder, false)

		triggerEvent("hud:convertUI", localPlayer, wRanks)
	end
end

function saveRanks(button, state)
	if (source==bRanksSave) and (button=="left") and (state=="up") then
		local found = false
		local isNumber = true
		for key, value in ipairs(tRanks) do
			if (string.find(guiGetText(tRanks[key]), ";")) or (string.find(guiGetText(tRanks[key]), "'")) then
				found = true
			end
		end
		
		local factionType = tonumber(getElementData(theTeam, "type"))
		if (factionType==2) or (factionType==3) or (factionType==4) or (factionType==5) or (factionType==6) or (factionType==7) then -- Added Mechanic type \ Adams
			for key, value in ipairs(tRankWages) do
				if not (tostring(type(tonumber(guiGetText(tRankWages[key])))) == "number") then
					isNumber = false
				end
			end
		end
		
		if (found) then
			outputChatBox("Seus ranks contêm caracteres inválidos, certifique-se de que não contenha caracteres como '@.;", 255, 0, 0)
		elseif not (isNumber) then
			outputChatBox("Seus salários não são números, certifique-se de inserir um número e nenhum símbolo.", 255, 0, 0)
		else
			local sendRanks = { }
			local sendWages = { }
			
			for key, value in ipairs(tRanks) do
				sendRanks[key] = guiGetText(tRanks[key])
			end
			
			if (factionType==2) or (factionType==3) or (factionType==4) or (factionType==5) or (factionType==6) or (factionType==7) then -- Added Mechanic type \ Adams
				for key, value in ipairs(tRankWages) do
					sendWages[key] = guiGetText(tRankWages[key])
				end
			end
			
			hideFactionMenu()
			if (factionType==2) or (factionType==3) or (factionType==4) or (factionType==5) or (factionType==6) or (factionType==7) then -- Added Mechanic type \ Adams
				triggerServerEvent("cguiUpdateRanks", getLocalPlayer(), sendRanks, sendWages)
			else
				triggerServerEvent("cguiUpdateRanks", getLocalPlayer(), sendRanks)
			end
		end
	end
end

function closeRanks(button, state)
	if (source==btRanksClose) and (button=="left") and (state=="up") then
		if (wRanks) then
			destroyElement(wRanks)
			ranks_gui.checkbox = {}
			guiSetInputEnabled(false)
		end
	end
end


-- Add Rank GUI

function btAddRanks()
	-- Window
	local sX, sY = guiGetScreenSize()
	local wX, wY = 347, 129
	local sX, sY, wX, wY = (sX/2)-(wX/2),(sY/2)-(wY/2),wX,wY
	-- sX, sY, wX, wY = 628, 335, 347, 129
	wAddRank = guiCreateWindow(sX, sY, wX, wY, "Adicionar Rank Facção...", false)
	guiWindowSetSizable(wAddRank, false)
	guiSetAlpha(wAddRank, 1.00)
	-- Labels
	lAddRank1 = guiCreateLabel(9, 74, 223, 15, "Nome Rank", false, wAddRank)
	guiLabelSetHorizontalAlign(lAddRank1, "center", false)
	lAddRank2 = guiCreateLabel(9, 26, 224, 15, "Herdar permissões de...", false, wAddRank)
	guiLabelSetHorizontalAlign(lAddRank2, "center", false)
	lAddRank3 = guiCreateLabel(239, 20, 15, 99, "|  |  |  |  |  |  |", false, wAddRank)
	guiLabelSetHorizontalAlign(lAddRank3, "left", true)
	lAddRank4 = guiCreateLabel(239, 23, 15, 99, "|  |  |  |  |  |  |", false, wAddRank)
	guiLabelSetHorizontalAlign(lAddRank4, "left", true)
	-- Edit
	eAddrank = guiCreateEdit(9, 94, 225, 23, "", false, wAddRank)
	guiEditSetMaxLength(eAddrank, 32)
	-- Combobox
	combAddRank = guiCreateComboBox(45, 44, 154, 23, "", false, wAddRank)
	-- Buttons
	bAddRankCreate = guiCreateButton(250, 35, 85, 28, "Criar", false, wAddRank)
	guiSetFont(bAddRankCreate, "default-bold-small")
	guiSetProperty(bAddRankCreate, "NormalTextColour", "FFAAAAAA")
	bAddRankClose = guiCreateButton(250, 78, 85, 28, "Fechar", false, wAddRank)
	guiSetProperty(bAddRankClose, "NormalTextColour", "FFAAAAAA")

	guiComboBoxClear(combAddRank)
	for i,rank in ipairs(ranks) do
		guiComboBoxAddItem(combAddRank, rank[2])
	end
	guiComboBoxSetSelected(combAddRank, #ranks-1)
	local x,y = guiGetSize(combAddRank, false)
	guiSetSize(combAddRank, x, 25+(#ranks*20), false)

	addEventHandler("onClientGUIClick", bAddRankCreate, addRank, false)
	addEventHandler("onClientGUIClick", bAddRankClose, closeAddFactionRankPanel, false)

	triggerEvent("hud:convertUI", localPlayer, wAddRank)
end


-- Add Faction Rank -->>
function addRank()
	local rank = guiGetText(eAddrank)
	if (rank == "") then
		outputChatBox("Insira um nome para o rank.", 255, 100, 100)
		return
	end
	local perms = guiComboBoxGetItemText( combAddRank, guiComboBoxGetSelected(combAddRank) )
	
	for i,rankID in ipairs(ranks) do
		if (rankID[2] == perms) then
			perms = rankID[1]
			break
		end
	end
	triggerServerEvent("faction-system.addFactionRank", resourceRoot, rank, perms, faction_tab)
end

function closeAddFactionRankPanel()
	if (wAddRank) then
		destroyElement(wAddRank)
	end	
end
addEvent("faction-system.closeAddFactionRankPanel", true)
addEventHandler("faction-system.closeAddFactionRankPanel", root, closeAddFactionRankPanel)
-- Rename Rank GUI

function btRenameRank()
	-- Window
	local sX, sY = guiGetScreenSize()
	local wX, wY = 245, 113
	local sX, sY, wX, wY = (sX/2)-(wX/2),(sY/2)-(wY/2),wX,wY
	local row = guiGridListGetSelectedItem(ranksGridlist)
	local currentRank = guiGridListGetItemText(ranksGridlist, row, 1)
	-- sX, sY, wX, wY = 625, 320, 245, 113
	wRenameRank = guiCreateWindow(sX, sY, wX, wY, "Renomear Nome Rank", false)
	guiWindowSetSizable(wRenameRank, false)
	-- Label
	lRenameRank1 = guiCreateLabel(-18, 28, 277, 15, "Mudar o nome de '"..currentRank.."' para:", false, wRenameRank)
	guiLabelSetHorizontalAlign(lRenameRank1, "center", false)
	-- Editbox
	editRenameRank = guiCreateEdit(16, 48, 216, 21, "", false, wRenameRank)
	guiEditSetMaxLength(editRenameRank, 32)
	-- Button
	btRenameRankChange = guiCreateButton(53, 77, 63, 26, "Mudar", false, wRenameRank)
	guiSetProperty(btRenameRankChange, "NormalTextColour", "FFAAAAAA")
	btRenameRankCancel = guiCreateButton(125, 77, 63, 26, "Cancelar", false, wRenameRank)
	guiSetProperty(btRenameRankCancel, "NormalTextColour", "FFAAAAAA")

	addEventHandler("onClientGUIClick", btRenameRankChange, renameRank, false)
	addEventHandler("onClientGUIClick", btRenameRankCancel, function() destroyElement( wRenameRank ) end, false)

	triggerEvent("hud:convertUI", localPlayer, wRenameRank)
end

-- Remove Rank GUI
function btRemoveRank()
	-- Window
	local sX, sY = guiGetScreenSize()
	local wX, wY = 285, 138
	local sX, sY, wX, wY = (sX/2)-(wX/2),(sY/2)-(wY/2),wX,wY
	-- sX, sY, wX, wY = 660, 366, 285, 138
	wRemoveRank = guiCreateWindow(660, 366, 285, 138, "Exclusão de rank facção", false)
	guiWindowSetSizable(wRemoveRank, false)
	-- Labels
	local row = guiGridListGetSelectedItem(ranksGridlist)
	local rankName = guiGridListGetItemText(ranksGridlist, row, 1)
	lRemoveRank1 = guiCreateLabel(26, 24, 225, 30, "Tem certeza de que deseja excluir o rank \n'"..rankName.."' ?", false, wRemoveRank)
	guiSetFont(lRemoveRank1, "default-bold-small")
	guiLabelSetHorizontalAlign(lRemoveRank1, "center", false)
	local def_rank = guiGridListGetItemText(ranksGridlist, guiGridListGetRowCount(ranksGridlist)-1, 1)
	lRemoveRank2 = guiCreateLabel(10, 58, 257, 31, "Todos os membros com esta classificação receberão o rank \n'"..def_rank.."'.", false, wRemoveRank)
	guiLabelSetHorizontalAlign(lRemoveRank2, "center", false)
	-- Buttons
	btRemoveRankDel = guiCreateButton(68, 96, 67, 29, "Deletar", false, wRemoveRank)
	guiSetProperty(btRemoveRankDel, "NormalTextColour", "FFAAAAAA")
	btRemoveRankCancel = guiCreateButton(141, 96, 67, 29, "Cancelar", false, wRemoveRank)
	guiSetProperty(btRemoveRankCancel, "NormalTextColour", "FFAAAAAA")

	addEventHandler("onClientGUIClick", btRemoveRankDel, removeRank, false)
	addEventHandler("onClientGUIClick", btRemoveRankCancel, function() destroyElement(wRemoveRank) end, false)
	triggerEvent("hud:convertUI", localPlayer, wRemoveRank)
end	


function setRankInfo(rankTbl, rankperms, perms, wageTable)
	ranks = rankTbl
	rank_perms = rankperms
	wages = wageTable
	wasOrderChanged = nil
	
	guiGridListClear(ranksGridlist)
	for i,rank in ipairs(rankTbl) do
		local row = guiGridListAddRow(ranksGridlist)
		guiGridListSetItemText(ranksGridlist, row, 1, rank[2], false, false)
	end
	
	for i=1,#ranks_gui.checkbox do
		if isElement(ranks_gui.checkbox[i]) then
			destroyElement(ranks_gui.checkbox[i])
		end	
	end
	ranks_gui.checkbox = {}
	
	if not isElement(ranksLabel5) then
		ranksLabel5 = guiCreateLabel(0, 0, 337, 15, "Selecione um rank para personalizar suas permissões", false, ranksScrollPane)
		guiLabelSetHorizontalAlign(ranksLabel5, "center", true)
		guiSetFont(ranksLabel5, "default-bold-small")
		guiLabelSetColor(ranksLabel5, 57, 146, 204)
	end	
	
	for i,perm in ipairs(perms) do
		ranks_gui.checkbox[i] = guiCreateCheckBox(0, (i*25)-5, 337, 20, perm, false, false, ranksScrollPane)
		guiSetEnabled(ranks_gui.checkbox[i], false)
		if #perms == i  then
			ranks_gui.label[1] = guiCreateLabel(0, (i*25+25), 39, 15, "Salário:", false, ranksScrollPane)
        	ranks_gui.edit[1] = guiCreateEdit(39, (i*25+25), 89, 24, "", false, ranksScrollPane)   
        	guiSetEnabled(ranks_gui.edit[1], false)
        end	
	end
	
	guiSetEnabled(btRanksUpdOrd, false)
end
addEvent("faction-system.setRankInfo", true)
addEventHandler("faction-system.setRankInfo", root, setRankInfo)

-- View Rank Permissions
------------------------->>

function selectRankOffList()
	local row = guiGridListGetSelectedItem(ranksGridlist)
	if (not row or row == -1) then return end
	
	local rankID = ranks[row+1][1]
	local isDefault = tonumber(factionRanks[rankID]["isDefault"])
	local isLeader = tonumber(factionRanks[rankID]["isLeader"])
	local perms = rank_perms[rankID]
	guiSetEnabled(btRanksMvDn, true)
	guiSetEnabled(btRanksMvUp, true)

	-- Enable perm checkboxes for ranks that are not defined as 'default' or 'leader'
	if isDefault == 0 and isLeader == 0 then
		guiSetEnabled(btRanksRem, true)
		for i,box in ipairs(ranks_gui.checkbox) do
			guiSetEnabled(box, true)
			guiCheckBoxSetSelected(box, false)
		end	
	else
		guiSetEnabled(btRanksRem, false)	
		for i,box in ipairs(ranks_gui.checkbox) do
			guiSetEnabled(box, false)
			guiCheckBoxSetSelected(box, false)
		end	
	end	
		-- Select based on permissions
	for _,i in pairs(perms) do
		if (ranks_gui.checkbox[i]) then
			guiCheckBoxSetSelected(ranks_gui.checkbox[i], true)
		end
	end
		-- Disable Move Up/Down Buttons
	if (row == 0) then
		guiSetEnabled(btRanksMvUp, false)
	end
	if (row == guiGridListGetRowCount(ranksGridlist)-1) then
		guiSetEnabled(btRanksMvDn, false)
	end
	
	guiSetText(ranks_gui.edit[1], wages[rankID] or "")
	guiSetEnabled(ranks_gui.edit[1], true)

	guiSetText(ranksLabel5, "Editando permissões de '"..ranks[row+1][2].."'")
end

-- Update Rank Permissions
--------------------------->>

function applyPermissions()
	local row = guiGridListGetSelectedItem(ranksGridlist)
	if (not row or row == -1) then 
		outputChatBox("Selecione um rank primeiro.", 255, 100, 100)
	return end
	local rankID = ranks[row+1][1]

	local permissions = {}
	for i,box in ipairs(ranks_gui.checkbox) do
		if (guiCheckBoxGetSelected(box)) then
			table.insert(permissions, i)
		end
	end
	local wage = guiGetText(ranks_gui.edit[1])
	factionRanks[rankID]["permissions"] = table.concat(permissions, ",")
	triggerServerEvent("faction-system.updateRankPermissions", resourceRoot, rankID, permissions, wage, faction_tab)
	hideFactionMenu()
end

-- Update Rank Order
--------------------->>

function updateRankOrder()
		-- Move Up or Down
	if (source == btRanksMvUp or source == btRanksMvDn) then
		local row = guiGridListGetSelectedItem(ranksGridlist)
		if (not row or row == -1) then 
			outputChatBox("Selecione um rank primeiro.", 255, 125, 0)
		return end
	
		local rankTbl = ranks[row+1]
		table.remove(ranks, row+1)
		if (source == btRanksMvUp) then
			table.insert(ranks, row, rankTbl)
		else
			table.insert(ranks, row+2, rankTbl)
		end
		
		guiGridListClear(ranksGridlist)
		for i,rank in ipairs(ranks) do
			local row = guiGridListAddRow(ranksGridlist)
			guiGridListSetItemText(ranksGridlist, row, 1, rank[2], false, false)
		end
		guiSetEnabled(btRanksUpdOrd, true)
	elseif (source == btRanksUpdOrd) then
		local rankIDs = {}
		for i,rank in ipairs(ranks) do
			table.insert(rankIDs, rank[1]) 
		end
		triggerServerEvent("faction-system.updateRankOrder", resourceRoot, rankIDs, faction_tab)
	end
end

-- Change Rank Name -->>
function renameRank()
	local rankName = guiGetText(editRenameRank)
	if (rankName == "") then
		outputChatBox("Digite um nome para o rank.", 255, 100, 100)
		return
	end
	
	local row = guiGridListGetSelectedItem(ranksGridlist)
	if (not row or row == -1) then return end
	local rankID = ranks[row+1][1]
	
	triggerServerEvent("faction-system.setFactionRankName", resourceRoot, rankID, rankName, faction_tab)
	destroyElement(wRenameRank)
end

-- Remove Rank -->>
function removeRank()
	local row = guiGridListGetSelectedItem(ranksGridlist)
	if (not row or row == -1) then return end
	local rankID = ranks[row+1][1]
	
	triggerServerEvent("faction-system.removeFactionRank", resourceRoot, rankID, faction_tab)
	destroyElement(wRemoveRank)
end

function cacheRanks(FactionRanks)
	if not factionRanks then return end
	factionRanks = FactionRanks
end
addEvent("faction-system.cacheRanks", true)
addEventHandler("faction-system.cacheRanks", root, cacheRanks)