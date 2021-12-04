--[[
* ***********************************************************************************************************************
* Copyright (c) 2015 OwlGaming Community - All Rights Reserved
* All rights reserved. This program and the accompanying materials are private property belongs to OwlGaming Community
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* ***********************************************************************************************************************
]]

local localPlayer = getLocalPlayer()
local root = getRootElement()
local vehList1 = { }
local vehTabPanel = false
local sx, sy = guiGetScreenSize()

local targetTab = { }
local targetList = { }
local colID = { }
local colPlate = { }
local colYear = { }
local colBrand = { }
local colModel = { }
local colVIN = { }
local colPlate = { }
local colLastUsed = { }
local colCarHP = { }
local colTinted = { }
local colOwner = { }
local colStolenAndChopped = { }
local colDeleted = { }
local colCreatedBy = { }
local colCreatedDate = { }
local colRegistered = { }


function createVehManagerWindow(data)
    if not canAccessVehicleManager( localPlayer ) then
        return
    end

    if gWin then
        closeVehManager()
    end

    showCursor(true)
    -- guiSetInputEnabled(true)
    -- vehList1 = vehList
    gWin = guiCreateWindow(sx / 2 - 400, sy / 2 - 300, 800, 600, "Gerente de Veículos", false)
    guiWindowSetSizable(gWin, false)
    -- guiSetProperty(gWin,"TitlebarEnabled","false")
    vehTabPanel = guiCreateTabPanel(0.0113, 0.1417, 0.9775, 0.8633, true, gWin)

    bDelVeh = guiCreateButton(0.0113, 0.035, 0.0938, 0.045, "DELETAR", true, gWin)
    guiSetFont(bDelVeh, "default-bold-small")
    bRestoreVeh = guiCreateButton(0.0113, 0.085, 0.0938, 0.045, "RESTAURAR", true, gWin)
    guiSetFont(bRestoreVeh, "default-bold-small")

    bToggleInt = guiCreateButton(0.1175, 0.035, 0.1, 0.045, "BIBLIOTECA", true, gWin)
    guiSetFont(bToggleInt, "default-bold-small")
    bGotoVeh = guiCreateButton(0.1175, 0.085, 0.1, 0.045, "IR ATÈ", true, gWin)
    guiSetFont(bGotoVeh, "default-bold-small")

    --bForceSell = guiCreateButton(0.23, 0.035, 0.1, 0.045, "FORCE-SELL", true, gWin)
    --guiSetFont(bForceSell, "default-bold-small")
    bRemoveVeh = guiCreateButton(0.23, 0.085, 0.1, 0.045, "REMOVER", true, gWin)
    guiSetFont(bRemoveVeh, "default-bold-small")

    bAdminNote = guiCreateButton(0.3425, 0.035, 0.1, 0.045, "CHECAR", true, gWin)
    guiSetFont(bAdminNote, "default-bold-small")
    bSearch = guiCreateButton(0.3425, 0.085, 0.1, 0.045, "PROCURAR", true, gWin)
    guiSetFont(bSearch, "default-bold-small")
    guiSetEnabled(bSearch, false)

    bClose = guiCreateButton(0.455, 0.035, 0.1, 0.09, "FECHAR", true, gWin)
    guiSetFont(bClose, "default-bold-small")

    targetTab[1] = guiCreateTab("Veículos Padrões", vehTabPanel)
    targetTab[2] = guiCreateTab("Veículos Unicos", vehTabPanel)
    --targetTab[3] = guiCreateTab("Deleted Interiors", vehTabPanel)
    --targetTab[3] = guiCreateTab("Search Results", vehTabPanel)

    targetList[1] = guiCreateGridList(0, 0, 1, 1, true, targetTab[1])
    targetList[2] = guiCreateGridList(0, 0, 1, 1, true, targetTab[2])
    --targetList[3] = guiCreateGridList(0, 0, 1, 1, true, targetTab[3])
    --targetList[3] = guiCreateGridList(0, 0, 1, 1, true, targetTab[4])

    for i = 1, 2 do
        colID[i] = guiGridListAddColumn(targetList[i], "ID", 0.07)
        colYear[i] = guiGridListAddColumn(targetList[i], "Ano", 0.05)
        colBrand[i] = guiGridListAddColumn(targetList[i], "Marca", 0.12)
        colModel[i] = guiGridListAddColumn(targetList[i], "Modelo", 0.17)
        colVIN[i] = guiGridListAddColumn(targetList[i], "VIN", 0.07)
        colPlate[i] = guiGridListAddColumn(targetList[i], "Placa", 0.1)
        colTinted[i] = guiGridListAddColumn(targetList[i], "Insulfilm", 0.05)
        colRegistered[i] = guiGridListAddColumn(targetList[i], "Registrado", 0.05)
        colLastUsed[i] = guiGridListAddColumn(targetList[i], "Ultima vez Usado", 0.1)
        colCarHP[i] = guiGridListAddColumn(targetList[i], "HP", 0.06)
        colOwner[i] = guiGridListAddColumn(targetList[i], "Dono", 0.10)
    end

    local allVehicles = getElementsByType("vehicle")
    local standardVehs = { }
    local uniqueVehs = { }
    for index, veh in ipairs(allVehicles) do
        if getElementData(veh, "dbid") > 0 then
            if getElementData(veh, "unique") then
                table.insert(uniqueVehs, veh)
            else
                table.insert(standardVehs, veh)
            end
        end
    end

    local disabledVehicles = { }
    local ckedVehicles = { }
    local inactiveVehicles = { }
    local deletedVehicles = { }

    local lTotal = guiCreateLabel(460, 25, 164, 17, "Veículos Padrões: " .. exports.global:formatMoney(#standardVehs), false, gWin)
    local lActive = guiCreateLabel(460, 42, 164, 17, "Veículos Unicos: " .. exports.global:formatMoney(#uniqueVehs), false, gWin)
    local lDisableInts = guiCreateLabel(628, 25, 159, 17, "Veículos Desativados: --", false, gWin)
    local lInactive = guiCreateLabel(628, 42, 159, 17, "Veículos Inativos: --", false, gWin)
    local lOwnedbyCKs = guiCreateLabel(460, 59, 164, 17, "Veículos de personagem Mortos (CK): --", false, gWin)
    local lDeletedInts = guiCreateLabel(628, 59, 159, 17, "Veículos Deletados: --", false, gWin)

    loadTab(standardVehs, 1)
    loadTab(uniqueVehs, 2)


    function getListFromActiveTab(vehTabPanel)
        if vehTabPanel then
            if guiGetSelectedTab(vehTabPanel) == targetTab[1] then
                return targetList[1], 1
            elseif guiGetSelectedTab(vehTabPanel) == targetTab[2] then
                return targetList[2], 2
            elseif guiGetSelectedTab(vehTabPanel) == targetTab[3] then
                return targetList[3], 3
            elseif guiGetSelectedTab(vehTabPanel) == targetTab[4] then
                return targetList[4], 4
            elseif guiGetSelectedTab(vehTabPanel) == targetTab[5] then
                return targetList[5], 5
            elseif guiGetSelectedTab(vehTabPanel) == targetTab[6] then
                return targetList[6], 6
            else
                return false, false
            end
        else
            return false, false
        end
    end

    addEventHandler("onClientGUIClick", bClose, function()
        if source == bClose then
            closeVehManager()
        end
    end )

    addEventHandler("onClientGUIClick", bSearch,
    function(button)
        if button == "left" then
            showCursor(true)
            guiSetInputEnabled(true)
            wInteriorSearch = guiCreateWindow(sx / 2 - 176, sy / 2 - 52, 352, 104, "Pesquisa de Veículo", false)
            guiWindowSetSizable(wInteriorSearch, false)
            local lText = guiCreateLabel(10, 22, 341, 16, "Insira qualquer informação relacionada sobre um veículo (ID, Nome, Dono, Modelo,...) :", false, wInteriorSearch)
            guiSetFont(lText, "default-small")
            local eSearch = guiCreateEdit(10, 38, 331, 31, "Procurar...", false, wInteriorSearch)
            addEventHandler("onClientGUIFocus", eSearch, function()
                guiSetText(eSearch, "")
            end , false)
            local bCancel = guiCreateButton(10, 73, 169, 22, "CANCELAR", false, wInteriorSearch)
            guiSetFont(bCancel, "default-bold-small")
            addEventHandler("onClientGUIClick", bCancel, function(button)
                if button == "left" and wInteriorSearch then
                    destroyElement(wInteriorSearch)
                    wInteriorSearch = nil
                    -- showCursor(false)
                    -- guiSetInputEnabled(false)
                end
            end , false)
            local bGo = guiCreateButton(179, 73, 162, 22, "GO", false, wInteriorSearch)
            guiSetFont(bGo, "default-bold-small")
            addEventHandler("onClientGUIClick", bGo, function(button)
                if button == "left" and wInteriorSearch then
                    triggerServerEvent("vehicleManager:Search", getLocalPlayer(), getLocalPlayer(), guiGetText(eSearch))
                    destroyElement(wInteriorSearch)
                    wInteriorSearch = nil
                    -- showCursor(false)
                    -- guiSetInputEnabled(false)
                end
            end , false)
        end
    end ,
    false)

    addEventHandler("onClientGUIClick", bDelVeh,
    function(button)
        if button == "left" then
            local row, col = -1, -1
            local activeList = getListFromActiveTab(vehTabPanel)
            if activeList then
                local row, col = guiGridListGetSelectedItem(activeList)
                if row ~= -1 and col ~= -1 then
                    local gridID = guiGridListGetItemText(activeList, row, 1)
                    if triggerServerEvent("vehicleManager:delVeh", getLocalPlayer(), getLocalPlayer(), gridID) then
                        -- closeVehManager()
                        -- triggerServerEvent("vehicleManager:openit", getLocalPlayer(), getLocalPlayer())
                    end
                else
                    guiSetText(gWin, "Você precisa selecionar um interior da lista abaixo primeiro.")
                end
            end
        end
    end ,
    false)

    addEventHandler("onClientGUIClick", bToggleInt,
    function(button)
        if button == "left" then
            triggerServerEvent("vehlib:sendLibraryToClient", localPlayer, localPlayer)
        end
    end ,
    false)

    addEventHandler("onClientGUIClick", bGotoVeh,
    function(button)
        if button == "left" then
            local row, col = -1, -1
            local activeList = getListFromActiveTab(vehTabPanel)
            if activeList then
                local row, col = guiGridListGetSelectedItem(activeList)
                if row ~= -1 and col ~= -1 then
                    local gridID = guiGridListGetItemText(activeList, row, 1)
                    if triggerServerEvent("vehicleManager:gotoVeh", getLocalPlayer(), getLocalPlayer(), gridID) then
                        -- closeVehManager()
                        -- triggerServerEvent("vehicleManager:openit", getLocalPlayer(), getLocalPlayer())
                    end
                else
                    guiSetText(gWin, "Você precisa selecionar um interior da lista abaixo primeiro.")
                end
            end
        end
    end ,
    false)

    addEventHandler("onClientGUIClick", bRestoreVeh,
    function(button)
        if button == "left" then
            local row, col = -1, -1
            local activeList = getListFromActiveTab(vehTabPanel)
            if activeList then
                local row, col = guiGridListGetSelectedItem(activeList)
                if row ~= -1 and col ~= -1 then
                    local gridID = guiGridListGetItemText(activeList, row, 1)
                    if triggerServerEvent("vehicleManager:restoreVeh", getLocalPlayer(), getLocalPlayer(), gridID) then
                        -- closeVehManager()
                        -- triggerServerEvent("vehicleManager:openit", getLocalPlayer(), getLocalPlayer())
                    end
                else
                    guiSetText(gWin, "Você precisa selecionar um interior da lista abaixo primeiro.")
                end
            end
        end
    end ,
    false)

    addEventHandler("onClientGUIClick", bRemoveVeh,
    function(button)
        if button == "left" then
            local row, col = -1, -1
            local activeList = getListFromActiveTab(vehTabPanel)
            if activeList then
                local row, col = guiGridListGetSelectedItem(activeList)
                if row ~= -1 and col ~= -1 then
                    local gridID = guiGridListGetItemText(activeList, row, 1)
                    if triggerServerEvent("vehicleManager:removeVeh", getLocalPlayer(), getLocalPlayer(), gridID) then
                        -- closeVehManager()
                        -- triggerServerEvent("vehicleManager:openit", getLocalPlayer(), getLocalPlayer())
                    end
                else
                    guiSetText(gWin, "Você precisa selecionar um interior da lista abaixo primeiro.")
                end
            end
        end
    end ,
    false)
    --[[
    addEventHandler("onClientGUIClick", bForceSell,
    function(button)
        if button == "left" then
            local row, col = -1, -1
            local activeList = getListFromActiveTab(vehTabPanel)
            if activeList then
                local row, col = guiGridListGetSelectedItem(activeList)
                if row ~= -1 and col ~= -1 then
                    local gridID = guiGridListGetItemText(activeList, row, 1)
                    if triggerServerEvent("vehicleManager:forceSellInt", getLocalPlayer(), getLocalPlayer(), gridID) then
                        -- closeVehManager()
                        -- triggerServerEvent("vehicleManager:openit", getLocalPlayer(), getLocalPlayer())
                    end
                else
                    guiSetText(gWin, "Você precisa selecionar um interior da lista abaixo primeiro.")
                end
            end
        end
    end ,
    false)
]]
    addEventHandler("onClientGUIClick", bAdminNote,
    function(button)
        if button == "left" then
            local row, col = -1, -1
            local activeList = getListFromActiveTab(vehTabPanel)
            if activeList then
                local row, col = guiGridListGetSelectedItem(activeList)
                if row ~= -1 and col ~= -1 then
                    local gridID = guiGridListGetItemText(activeList, row, 1)
                    if triggerServerEvent("vehicleManager:openAdminNote", getLocalPlayer(), getLocalPlayer(), gridID) then
                        -- guiGridListRemoveRow ( activeList, row )
                    end
                else
                    guiSetText(gWin, "Você precisa selecionar um veículo da lista abaixo primeiro.")
                end
            end
        end
    end ,
    false)

    function fetchSearchResults(interiorsResultList)
        if interiorsResultList then
            local i = 4
            guiGridListClear(targetList[i])
            local activeList, index = getListFromActiveTab(vehTabPanel)
            if index ~= i then
                guiSetSelectedTab(vehTabPanel, targetTab[i])
            end
            for _, record in ipairs(interiorsResultList) do
                local row = guiGridListAddRow(targetList[i])
                guiGridListSetItemText(targetList[i], row, colID[i], record.id or "--", false, true)
                guiGridListSetItemText(targetList[i], row, colYear[i], formatVehName(), false, false)
                guiGridListSetItemText(targetList[i], row, colVIN[i], record.show_vin == "1" and record.id or "Removed", false, true)
                guiGridListSetItemText(targetList[i], row, colPlate[i], record.show_plate == "1" and record.plate or "Removed", false, false)
                guiGridListSetItemText(targetList[i], row, colRegistered[i], record.registered == "1" and "Yes" or "No", false, false)
                --guiGridListSetItemText(targetList[i], row, colOwner[i], exports.cache:getCharacterNameFromID(getElementData(veh, "Owner")) or "Unknown", false, false)
                guiGridListSetItemText(targetList[i], row, colLastUsed[i], formatLastUsed(record.lastused_sec) , false, false)
                guiGridListSetItemText(targetList[i], row, colCarHP[i], math.round(tonumber(record.hp)) , false, false)
                guiGridListSetItemText(targetList[i], row, colTinted[i], record.tinted == "1" and "Yes" or "No", false, false)
            end
        end
    end
    addEvent("vehicleManager:FetchSearchResults", true)
    addEventHandler("vehicleManager:FetchSearchResults", localPlayer, fetchSearchResults)

    triggerEvent("hud:convertUI", localPlayer, gWin)
end
addEvent("createVehManagerWindow", true)
addEventHandler("createVehManagerWindow", localPlayer, createVehManagerWindow)
addCommandHandler("vehicles", createVehManagerWindow)
addCommandHandler("vehs", createVehManagerWindow)

function loadTab(vehs, i)
    for index, veh in ipairs(vehs) do
        local row = guiGridListAddRow(targetList[i])
        guiGridListSetItemText(targetList[i], row, colID[i], getElementData(veh, "dbid") or "--", false, true)
        guiGridListSetItemText(targetList[i], row, colYear[i], getElementData( veh, 'year' ) or '--', false, false)
        guiGridListSetItemText(targetList[i], row, colBrand[i], getElementData( veh, 'brand' ) or '--', false, false)
        guiGridListSetItemText(targetList[i], row, colModel[i], getElementData( veh, 'maximemodel' ) or '--', false, false)
        guiGridListSetItemText(targetList[i], row, colVIN[i], getElementData(veh, "show_vin") == 1 and getElementData(veh, "dbid") or "Removido", false, true)
        guiGridListSetItemText(targetList[i], row, colPlate[i], getElementData(veh, "show_plate") == 1 and getElementData(veh, "Plate") or "Removido", false, false)
        guiGridListSetItemText(targetList[i], row, colRegistered[i], getElementData(veh, "Registrado") == 1 and "Yes" or "No", false, false)
        --guiGridListSetItemText(targetList[i], row, colOwner[i], exports.cache:getCharacterNameFromID(getElementData(veh, "Owner")) or "Unknown", false, false)
        guiGridListSetItemText(targetList[i], row, colLastUsed[i], exports.datetime:formatTimeInterval(getElementData(veh, "lastused")) , false, false)
        guiGridListSetItemText(targetList[i], row, colCarHP[i], math.round(getElementHealth(veh)) , false, false)
        guiGridListSetItemText(targetList[i], row, colTinted[i], getElementData(veh, "Insulfilm") and "Sim" or "Não", false, false)
    end
end

function formatVehName()
    return ""
end


function formartDays(days)
    if not days then
        return "Unknown", false
    elseif tonumber(days) == 0 then
        return "Today", false
    elseif tonumber(days) >= 14 then
        return days .. " dias atrás (Inativo)", true
    else
        return days .. " dias atrás", false
    end
end

function intTypeName(intType)
    local intTypeName = "Unknown"
    if intType == "0" then
        intTypeName = "House"
    elseif intType == "1" then
        intTypeName = "Business"
    elseif intType == "2" then
        intTypeName = "Government"
    elseif intType == "3" then
        intTypeName = "Rentable"
    end
    return intTypeName
end

function cked(ckStatus)
    local cked = ""
    if ckStatus == "1" then
        cked = " - CKed"
    end
    return cked
end

function charName(name)
    local charName = ""
    if name then
        charName = name:gsub("_", " ")
    end
    return charName
end

function accountName(name)
    local accountName = ""
    if name then
        accountName = " (" .. name .. ")"
    end
    return accountName
end

function closeVehManager()
    if gWin then
        removeEventHandler("onClientGUIClick", root, singleClickedGate)
        destroyElement(gWin)
        gWin = nil
        if wInteriorSearch then
            destroyElement(wInteriorSearch)
            wInteriorSearch = nil
        end
        showCursor(false)
        guiSetInputEnabled(false)
        vehTabPanel = nil
    end
end

function singleClickedGate()
    if source == bClose then
        closeVehManager()
    end
end

local bAddNote = nil
local gAdminNote = nil
local newNoteLabel, newNoteMemo = nil
local notes = { }
local currentNote = nil

function formatCreator(creatorId)
	if creatorId then
		if creatorId == "0" then
			return "SYSTEM"
		else
			return accountNameBuilder(creatorId) or "N/A"
		end
	else
		return "N/A"
	end
end

function drawAdminNotes(tabAdminNote)
    if tabAdminNote and isElement(tabAdminNote) then
        cleanAllNotesGUI()
        guiSetText(bAddNote, "ADD NEW NOTE")
        gAdminNote = guiCreateGridList(0, 0, 1, 1, true, tabAdminNote)
        local note_colDate = guiGridListAddColumn(gAdminNote, "Data", 0.25)
        local note_colNote = guiGridListAddColumn(gAdminNote, "Conteudo", 0.5)
        local note_colCreator = guiGridListAddColumn(gAdminNote, "Criador", 0.1)
        local note_colNoteId = guiGridListAddColumn(gAdminNote, "Nota de Entrada", 0.1)
        for i, note in ipairs(notes) do
            local row = guiGridListAddRow(gAdminNote)
            guiGridListSetItemText(gAdminNote, row, note_colDate, note.date, false, true)
            guiGridListSetItemText(gAdminNote, row, note_colNote, note.note, false, false)
            guiGridListSetItemText(gAdminNote, row, note_colCreator, formatCreator(note.creatorname), false, false)
            guiGridListSetItemText(gAdminNote, row, note_colNoteId, note.id, false, false)
        end
        addEventHandler("onClientGUIDoubleClick", gAdminNote, function(button, state)
            if source == gAdminNote then
                local row, col = guiGridListGetSelectedItem(source)
                if row ~= -1 and col ~= -1 then
                    local noteId = guiGridListGetItemText(source, row, 4)
                    drawNewNote(tabAdminNote, #notes < 1, noteId, button == "left")
                end
            end
        end )
    end
end

function drawNewNote(tabAdminNote, isNotesEmpty, noteId, editExiting)
    if tabAdminNote and isElement(tabAdminNote) then
        cleanAllNotesGUI()
        guiSetText(bAddNote, "MOSTRAR NOTAS")
        local margin = 0.01
        local textH = 0.1
        local text = "Você pode criar uma nova entrada de nota abaixo:"
        if noteId then
            currentNote = getNoteFromId(noteId)
            if editExiting then
                text = "Editando nota #" .. noteId .. " por " .. currentNote.creatorname .. ". O criador desta nota será transferido para você após a conclusão:"
                currentNote.edit = true
            else
                text = "Vizualisando nota #" .. noteId .. " por " .. currentNote.creatorname .. ". Para editar, clique duas vezes com o botão ESQUERDO."
            end
        elseif isNotesEmpty then
            text = "Nenhuma nota encontrada neste veículo. " .. text
        end
        local curMemo = currentNote and currentNote.note or nil
        newNoteLabel = guiCreateLabel(margin, margin * 2, 1 - margin * 2, textH, text, true, tabAdminNote)
        newNoteMemo = guiCreateMemo(margin, margin * 2 + textH, 1 - margin * 2, 0.85, curMemo or "", true, tabAdminNote)
        if currentNote and not currentNote.edit then
            guiMemoSetReadOnly(newNoteMemo, true)
        end
    end
end

function getNoteFromId(id)
    for i, note in pairs(notes) do
        if tonumber(note.id) == tonumber(id) then
            return note
        end
    end
end

function cleanAllNotesGUI()
    if newNoteLabel and isElement(newNoteLabel) then destroyElement(newNoteLabel) newNoteLabel = nil destroyElement(newNoteMemo) newNoteMemo = nil end
    if gAdminNote and isElement(gAdminNote) then destroyElement(gAdminNote) gAdminNote = nil end
    currentNote = nil
end

function accountNameBuilder(id)
	accountName = false
	if id then
		local name = exports.cache:getUsernameFromId(id)
		if name then
			accountName = name
		end
	end
	return accountName
end

function createCheckVehWindow(result, adminTitle, history, notes1)
    closeCheckVehWindow()
    showCursor(true)
    guiSetInputEnabled(true)
    notes = notes1
    checkVehWindow = guiCreateWindow(sx / 2 - 300, sy / 2 - 233, 600, 466, "Vehicle Manager - Vehicle Admin Note - " .. adminTitle .. " " .. getElementData(getLocalPlayer(), "account:username"), false)
    guiWindowSetSizable(checkVehWindow, false)
    local lVehModelID = guiCreateLabel(12, 27, 365, 17, "Nome do Veículo/ID: ", false, checkVehWindow)
    local lOwner = guiCreateLabel(12, 44, 365, 17, "Dono: ", false, checkVehWindow)
    local lLastUsed = guiCreateLabel(12, 112, 365, 17, "Ultimo Uso: ", false, checkVehWindow)
    local lCarHP = guiCreateLabel(12, 78, 365, 17, "Motor: ", false, checkVehWindow)
    local lDriveType = guiCreateLabel(372, 95, 365, 17, "Tipo Direção: ", false, checkVehWindow)
    local lDeleted = guiCreateLabel(372, 27, 365, 17, "Deletado: ", false, checkVehWindow)
    local lMileageAndHP = guiCreateLabel(372, 61, 365, 17, "Quilometragem: ", false, checkVehWindow)
    local lPlate = guiCreateLabel(12, 61, 365, 17, "Placa: Registrada: ", false, checkVehWindow)
    local lStolenAndChopped = guiCreateLabel(372, 44, 365, 17, "Roubado: ", false, checkVehWindow)
    local lSuspensionHeight = guiCreateLabel(372, 78, 365, 17, "Altura da Suspensão: ", false, checkVehWindow)
    local lCreateDate = guiCreateLabel(372, 112, 365, 17, "Data Criação: ", false, checkVehWindow)
    local lCreateBy = guiCreateLabel(372, 129, 365, 17, "Criado Por: ", false, checkVehWindow)
    local lPosition = guiCreateLabel(12, 95, 365, 17, "Posição: ", false, checkVehWindow)
    local lToken = guiCreateLabel(372, 146, 365, 17, "Token Usado: ", false, checkVehWindow)
    local lAdminNote = guiCreateLabel(12, 133, 80, 17, "Nota Admin: ", false, checkVehWindow)
    guiSetFont(lAdminNote, "default-bold-small")
    local checkIntTabPanel = guiCreateTabPanel(12, 156, 576, 269, false, checkVehWindow)
    local tabAdminNote = guiCreateTab("Nota Admin", checkIntTabPanel)


    -- local mAdminNote = guiCreateMemo(0,0,1,1,"",true,tabAdminNote)

    local bCopyAdminInfo = guiCreateButton(110, 133, 220, 20, "Copiar o seu nome de administrador e data atual", false, checkVehWindow)

    local tabHistory = guiCreateTab("Historico", checkIntTabPanel)
    local gHistory = guiCreateGridList(0, 0, 1, 1, true, tabHistory)
    local colDate = guiGridListAddColumn(gHistory, "Data", 0.25)
    local colAction = guiGridListAddColumn(gHistory, "Ação", 0.5)
    local colActor = guiGridListAddColumn(gHistory, "Actor", 0.1)
    local colLogID = guiGridListAddColumn(gHistory, "Log", 0.1)

    -- fetching shit
    local ownerName = "<Proprietário desconhecido>"
    if result[1][10] or result[1][11] then
        ownerName =(result[1][10] or result[1][11]:gsub("_", " "))
    end

    local model = tonumber(result[1][1])
    local name = ""
    local isCustom, mod = exports.newmodels:isCustomModID(model)
    if isCustom then
        if mod then
            local base_id = tonumber(mod.base_id)
            if base_id then
                name = getVehicleNameFromModel(base_Id) or "?"
            end
        end
    else
        name = getVehicleNameFromModel(model) or "?"
    end
    
    guiSetText(lVehModelID, "Nome do Veículo/ID: " ..(name) .. " (ID #" ..(model) .. ")")
    guiSetText(lOwner, "Dono: " .. ownerName ..(result[1][14] == "1" and " - Apreendido" or ""))
    guiSetText(lLastUsed, "Ultimo Uso: " .. formartDays(result[1][24] or 0))
    guiSetText(lCarHP, "HP: " .. math.floor(tonumber(result[1][8]) / 10) .. "% (" .. math.floor(tonumber(result[1][8])) .. ")" .. "     " .. "Gasolina: " ..(result[1][6] .. "%" or "Desconhecido") .. "     " .. "Paintjob: " ..(result[1][7] == "0" and "Nenhum" or result[1][7]))
    guiSetText(lDriveType, "Tipo Direção: " ..(result[1][19] or "Padrão"))
    guiSetText(lDeleted, "Deletado: By " ..(accountNameBuilder(result[1][21]) or "Ninguem"))
    guiSetText(lMileageAndHP, "Quilometragem: " ..(math.floor(tonumber(result[1][17]) / 1000) or "0") .. " KM")
    guiSetText(lPlate, "Placa: " ..(result[1][9]) .. "	Registrado: " ..(result[1][26]) or "")
    guiSetText(lStolenAndChopped, "Roubado: " ..(result[1][23] == "1" and "Sim" or "Não") .. "           Sucateado: " ..(result[1][22] == "1" and "Sim" or "Não"))
    guiSetText(lSuspensionHeight, "Altura da Suspensão: " ..(result[1][18] or "Padrão"))
    guiSetText(lCreateDate, "Data Criação: " ..(result[1][25] or "Desconhecido"))
    guiSetText(lCreateBy, "Criado Por: " ..(accountNameBuilder(result[1][15]) or ""))
    guiSetText(lPosition, "Posição: " ..math.floor((result[1][3])).. ", " ..math.floor((result[1][4])) .. ", " ..math.floor((result[1][5])) .. " (Int " ..(result[1][13]) .. ", Dim " ..(result[1][12]) .. ")")
    guiSetText(lToken, "Token Usado: " .. (result[1][27] == "1" and "Sim" or "Não"))
    -- Fetching history
    if history then
        for _, h in ipairs(history) do
            local row = guiGridListAddRow(gHistory)
            guiGridListSetItemText(gHistory, row, colDate, h[1] or "N/A", false, true)
            guiGridListSetItemText(gHistory, row, colAction, h[2] or "N/A", false, false)
            guiGridListSetItemText(gHistory, row, colActor, accountNameBuilder(h[3]) or "N/A", false, false)
            guiGridListSetItemText(gHistory, row, colLogID, h[4] or "N/A", false, false)
        end
        -- guiGridListAutoSizeColumn ( gHistory, 1 )
        -- guiGridListAutoSizeColumn ( gHistory, 2 )
        -- guiGridListAutoSizeColumn ( gHistory, 3 )
        -- guiGridListAutoSizeColumn ( gHistory, 4 )
    end

    bAddNote = guiCreateButton(212, 430, 90, 28, "ADD NOVA NOTA", false, checkVehWindow)
    guiSetFont(bAddNote, "default-bold-small")
    addEventHandler("onClientGUIClick", bAddNote,
    function(button)
        if button == "left" then
            if guiGetText(bAddNote) == "ADD NOVA NOTA" then
                drawNewNote(tabAdminNote, #notes < 1)
            else
                drawAdminNotes(tabAdminNote)
            end
        end
    end ,
    false)
    if notes and #notes > 0 then
        drawAdminNotes(tabAdminNote, notes)
    else
        drawNewNote(tabAdminNote, #notes < 1)
    end

    -- local bGotoSafe = guiCreateButton(312,430,90,28,"GO TO SAFE",false,checkVehWindow)
    -- guiSetFont(bGotoSafe,"default-bold-small")
    -- guiSetEnabled(bGotoSafe, false)

    local bGotoVeh1, bRestoreVeh1, bDelVeh1 = nil
    if result[1][21] and tonumber(result[1][21])>0 then
        -- deleted
        bRestoreVeh1 = guiCreateButton(12, 430, 90, 28, "RESTAURAR VEH", false, checkVehWindow)
        guiSetFont(bRestoreVeh1, "default-bold-small")
        addEventHandler("onClientGUIClick", bRestoreVeh1,
        function(button)
            if button == "left" then
                if triggerServerEvent("vehicleManager:restoreVeh", getLocalPlayer(), getLocalPlayer(), result[1][1]) then
                    -- setTimer(function ()
                    triggerServerEvent("vehicleManager:checkveh", getLocalPlayer(), getLocalPlayer(), "checkveh", result[1][1])
                    -- end, 50, 1)
                end
            end
        end ,
        false)
        bRemoveVeh1 = guiCreateButton(112, 430, 90, 28, "REMOVER VEH", false, checkVehWindow)
        guiSetFont(bRemoveVeh1, "default-bold-small")
        addEventHandler("onClientGUIClick", bRemoveVeh1,
        function(button)
            if button == "left" then
                if triggerServerEvent("vehicleManager:removeVeh", getLocalPlayer(), getLocalPlayer(), result[1][1]) then
                    closeCheckVehWindow()
                end
            end
        end ,
        false)
        guiSetEnabled(bRemoveVeh1, exports.integration:isPlayerLeadAdmin(localPlayer))
        -- guiSetEnabled(bToggleInt1, false)
    else
        bGotoVeh1 = guiCreateButton(12, 430, 90, 28, "IR ATE VEH", false, checkVehWindow)
        guiSetFont(bGotoVeh1, "default-bold-small")
        addEventHandler("onClientGUIClick", bGotoVeh1,
        function(button)
            if button == "left" then
                triggerServerEvent("vehicleManager:gotoVeh", getLocalPlayer(), getLocalPlayer(), result[1][1])
            end
        end ,
        false)
        bDelVeh1 = guiCreateButton(112, 430, 90, 28, "DELETAR VEH", false, checkVehWindow)
        guiSetFont(bDelVeh1, "default-bold-small")
        addEventHandler("onClientGUIClick", bDelVeh1,
        function(button)
            if button == "left" then
                if triggerServerEvent("vehicleManager:delVeh", getLocalPlayer(), getLocalPlayer(), result[1][1]) then
                    triggerServerEvent("vehicleManager:checkveh", getLocalPlayer(), getLocalPlayer(), "checkveh", result[1][1])
                end
            end
        end ,
        false)
    end

    local bSave = guiCreateButton(412, 430, 90, 28, "SALVAR", false, checkVehWindow)
    guiSetFont(bSave, "default-bold-small")
    addEventHandler("onClientGUIClick", bSave,
    function(button)
        if button == "left" then
            local noteMemo = nil
            if newNoteMemo and isElement(newNoteMemo) then
                noteMemo = guiGetText(newNoteMemo) or nil
            end
            if noteMemo == "" or noteMemo == "\n" then
                noteMemo = nil
            end
            if noteMemo or(currentNote and currentNote.edit and currentNote.note ~= noteMemo) then
                triggerServerEvent("vehicleManager:saveAdminNote", localPlayer, result[1][1], noteMemo, currentNote and currentNote.id)
                exports.global:playSoundSuccess()
                closeCheckVehWindow()
            else
                outputChatBox("Nada para salvar.")
            end

        end
    end ,
    false)


    local bClose = guiCreateButton(509, 430, 79, 28, "FECHAR", false, checkVehWindow)
    guiSetFont(bClose, "default-bold-small")

    addEventHandler("onClientGUIClick", bClose,
    function(button)
        if button == "left" then
            closeCheckVehWindow()
        end
    end ,
    false)

    addEventHandler("onClientGUIClick", bCopyAdminInfo,
    function(button)
        if button == "left" then
            local time = getRealTime()
            local date = time.monthday
            local month = time.month + 1
            local year = time.year + 1900
            local adminUsername = getElementData(getLocalPlayer(), "account:username")
            local content = " (" .. adminTitle .. " " .. adminUsername .. " em " .. date .. "/" .. month .. "/" .. year .. ")"
            if setClipboard(content) then
                guiSetText(checkVehWindow, "Copiado: '" .. content .. "'")
            end
        end
    end ,
    false)

    triggerEvent("hud:convertUI", localPlayer, checkVehWindow)
end
addEvent("createCheckVehWindow", true)
addEventHandler("createCheckVehWindow", localPlayer, createCheckVehWindow)

function closeCheckVehWindow()
    if checkVehWindow and isElement(checkVehWindow) then
        destroyElement(checkVehWindow)
        checkVehWindow = nil
        showCursor(false)
        guiSetInputEnabled(false)
        bAddNote = nil
        gAdminNote = nil
        newNoteLabel = nil
        newNoteMemo = nil
        notes = { }
        currentNote = nil
    end
end
