--[[
* ***********************************************************************************************************************
* Copyright (c) 2015 OwlGaming Community - All Rights Reserved
* All rights reserved. This program and the accompanying materials are private property belongs to OwlGaming Community
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* ***********************************************************************************************************************
]]

local gui = {
    tab = {},
    staticimage = {},
    tabpanel = {},
    edit = {},
    window = {},
    label = {},
    memo = {},
    button = {},
    gridlist = {},
}

local gui2 = {
	window = {},
	label = {},
	button = {},
}

local gui3 = {
    tab = {},
    staticimage = {},
    edit = {},
    window = {},
    tabpanel = {},
    gridlist = {},
    label = {},
    button = {},
    memo = {}
}

local gui4 = {
    button = {},
    window = {},
    memo = {}
}

local lockGui = false
local tabToSwitch = nil

local function togWindow( win, state )
	if win and isElement( win ) then
		guiSetEnabled( win, state )
	end
end

local function showWindow( win, state )
	if win and isElement( win ) then
		guiSetVisible( win , state )
	end
end

local function getReqFromId( id, reqs )
	for _, req in pairs( reqs ) do
		if tonumber(req.id) == tonumber(id) then
			return req
		end
	end
end

local tabPopulated = {}

function openMapManager()
	if not lockGui then
		if gui.window[1] and isElement( gui.window[1] ) then
			showWindow( gui.window[1], not guiGetVisible( gui.window[1] ) )
			guiSetInputEnabled( guiGetVisible( gui.window[1] ) )
			showCursor( guiGetVisible( gui.window[1] ) )
			showWindow( gui2.window[2], guiGetVisible( gui.window[1] ) )
			showWindow( gui3.window[2], guiGetVisible( gui.window[1] ) )
			showWindow( gui4.window[1], guiGetVisible( gui.window[1] ) )
			if guiGetVisible( gui.window[1] ) then
				triggerEvent( 'hud:blur', resourceRoot, 6, false, 0.5, nil )
			else
				triggerEvent( 'hud:blur', resourceRoot, 'off' )
			end
		elseif getElementData( localPlayer, 'loggedin' ) == 1 then
			triggerEvent( 'hud:blur', resourceRoot, 6, false, 0.5, nil )
			showCursor( true )
			guiSetInputEnabled( true )
		    gui.window[1] = guiCreateWindow(651, 276, 800, 600, "Map Manager", false)
		    guiWindowSetSizable(gui.window[1], false)
		    exports.global:centerWindow( gui.window[1] )

		    gui.tabpanel[1] = guiCreateTabPanel(9, 25, 781, 565, false, gui.window[1])

		    gui.tab[1] = guiCreateTab("Minhas solicitações", gui.tabpanel[1])
		    gui.gridlist[1] = guiCreateGridList(10, 10, 761, 479, false, gui.tab[1])
	        gui.gridlist.id = guiGridListAddColumn(gui.gridlist[1], "Req ID", 0.05)
	        gui.gridlist.type = guiGridListAddColumn(gui.gridlist[1], "Tipo", 0.08)
	        gui.gridlist.name = guiGridListAddColumn(gui.gridlist[1], "Nome", 0.2)
	        gui.gridlist.prev = guiGridListAddColumn(gui.gridlist[1], "Previa", 0.1)
	        gui.gridlist.status = guiGridListAddColumn(gui.gridlist[1], "Status", 0.17)
	        gui.gridlist.date = guiGridListAddColumn(gui.gridlist[1], "Data", 0.2)
	        gui.gridlist.reviewer = guiGridListAddColumn(gui.gridlist[1], "Revisor", 0.1)
			gui.button.refresh = guiCreateButton(10, 499, 121, 32, "Refresh", false, gui.tab[1])
			addEventHandler( 'onClientGUIClick', gui.button.refresh, function()
				if gui.button.refresh then
					tabPopulated[ 1 ] = nil
					populateTab( 1 )
				end
			end, false )
			gui.button.close = guiCreateButton(650, 499, 121, 32, "Fechar", false, gui.tab[1])
			addEventHandler( 'onClientGUIClick', gui.button.close, function()
				openMapManager()
			end, false )

		    populateTab( 1 )

		    gui.tab[2] = guiCreateTab("Solicitação De Mapa Externo", gui.tabpanel[1])
			gui.memo[1] = guiCreateMemo(30, 272, 450, 235, "", false, gui.tab[2])
		    gui.label[1] = guiCreateLabel(20, 21, 740, 59, "* Para tentar adicionar seu mapa externo no jogo, forneça as informações que solicitamos abaixo de forma clara e precisa.\n* Sua solicitação será analisada pela equipe de mapeamento. Vamos informá-lo se o seu pedido será aceito ou recusado por meio de notificação no jogo e por e-mail.", false, gui.tab[2])
		    guiLabelSetHorizontalAlign(gui.label[1], "left", true)
		    gui.label[2] = guiCreateLabel(20, 80, 365, 21, "Dê ao seu mapa um nome curto e descritivo:", false, gui.tab[2])
	        guiSetFont(gui.label[2], "default-bold-small")
	        gui.edit[1] = guiCreateEdit(30, 101, 355, 26, "", false, gui.tab[2])
	        gui.label[3] = guiCreateLabel(20, 137, 365, 21, "Para que esse mapa será usado?", false, gui.tab[2])
	        guiSetFont(gui.label[3], "default-bold-small")
	        gui.edit[2] = guiCreateEdit(30, 158, 355, 26, "", false, gui.tab[2])
	        gui.label[4] = guiCreateLabel(20, 194, 740, 21, "Por que adicionar esse mapa no jogo é necessário?", false, gui.tab[2])
	        guiSetFont(gui.label[4], "default-bold-small")
	        gui.edit[3] = guiCreateEdit(30, 215, 730, 26, "", false, gui.tab[2])
	        gui.label[5] = guiCreateLabel(20, 251, 740, 21, "Seu código do mapa:", false, gui.tab[2])
	        guiSetFont(gui.label[5], "default-bold-small")
	        gui.label[6] = guiCreateLabel(498, 272, 262, 61, "*Abra o arquivo .map usando qualquer editor de texto, copie e cole o conteúdo aqui. O conteúdo de um arquivo .map válido deve ser semelhante a este.", false, gui.tab[2])
	        guiLabelSetHorizontalAlign(gui.label[6], "left", true)
	        gui.staticimage[1] = guiCreateStaticImage(498, 343, 262, 108, "img/map_example.jpg", false, gui.tab[2])
	        gui.button[1] = guiCreateButton(498, 469, 262, 38, "Enviar", false, gui.tab[2])
	        guiSetFont(gui.button[1], "default-bold-small")
	        gui.edit[4] = guiCreateEdit(405, 101, 355, 26, "", false, gui.tab[2])
	        gui.label[7] = guiCreateLabel(395, 80, 365, 21, "Link para uma foto do mapa:", false, gui.tab[2])
	        guiSetFont(gui.label[7], "default-bold-small")
	        gui.label[8] = guiCreateLabel(395, 137, 365, 21, "Quem usará este mapa?", false, gui.tab[2])
	        guiSetFont(gui.label[8], "default-bold-small")
	        gui.edit[5] = guiCreateEdit(405, 158, 355, 26, "", false, gui.tab[2])

	        if canAccessMgmtTab( localPlayer ) then
		        gui.tab[3] = guiCreateTab("Gestão", gui.tabpanel[1])
		        gui.gridlist[2] = guiCreateGridList(10, 10, 761, 479, false, gui.tab[3])
		        gui.gridlist.id2 = guiGridListAddColumn(gui.gridlist[2], "Req ID", 0.05)
		        gui.gridlist.type2 = guiGridListAddColumn(gui.gridlist[2], "Tipo", 0.08)
		        gui.gridlist.name2 = guiGridListAddColumn(gui.gridlist[2], "Nome", 0.15)
		        gui.gridlist.prev2 = guiGridListAddColumn(gui.gridlist[2], "Previa", 0.1)
		        gui.gridlist.status2 = guiGridListAddColumn(gui.gridlist[2], "Status", 0.17)
		        gui.gridlist.date2 = guiGridListAddColumn(gui.gridlist[2], "Data", 0.2)
		        gui.gridlist.uploader = guiGridListAddColumn(gui.gridlist[2], "Uploader", 0.1)
		        gui.gridlist.reviewer2 = guiGridListAddColumn(gui.gridlist[2], "Revisor", 0.1)
		        gui.button.refresh2 = guiCreateButton(10, 499, 121, 32, "Refresh", false, gui.tab[3])
		        gui.button.unload_all = guiCreateButton(140, 499, 121, 32, "Descarregar todos os mapas teste", false, gui.tab[3])

				gui.button.close2 = guiCreateButton(650, 499, 121, 32, "Fechar", false, gui.tab[3])
				addEventHandler( 'onClientGUIClick', gui.button.close2, function()
					openMapManager()
				end, false )
	    	end

	        -- set max length for the editboxes
		    for _, box in pairs( gui.edit ) do
		    	guiEditSetMaxLength( box, 200 )
		    end
		    guiEditSetMaxLength( gui.edit[1], 100 )

		    addEventHandler( 'onClientGUIClick', gui.window[1], function ()
		    	if source == gui.button[1] then
		    		local name = guiGetText( gui.edit[1] )
		    		local who = guiGetText( gui.edit[5] )
		    		local what = guiGetText( gui.edit[2] )
		    		local why = guiGetText( gui.edit[3] )
		    		local url = guiGetText( gui.edit[4] )
		    		local content = guiGetText( gui.memo[1] )
		    		if string.len( url ) < 1 or string.len( name ) < 1 or string.len( who ) < 1 or string.len( what ) < 1 or string.len( why ) < 1 or string.len( content ) < 2 or string.len( content ) > settings.map_content_max_length then
		    			exports.global:playSoundError()
		    			openPopUp( 'Um dos campos estava vazio ou o conteúdo do mapa era muito grande. Por favor verifique e tente novamente. ', true, false )
		    		else
		    			local map, why_failed = processMapContent( content, settings.external_map_max_objects )
		    			if map then
		    				triggerLatentServerEvent( 'maps:submitExteriorMapRequest', resourceRoot, name, url, who, what, why, map )
		    				openPopUp( 'Analisando e processando o conteúdo do mapa...', false, true )
		    				exports.global:playSoundSuccess()
		    			else
		    				openPopUp( why_failed, true, false )
		    			end
		    		end  
		    	elseif source == gui.button.refresh2 then
		    		tabPopulated[ 3 ] = nil
	        		populateTab( 3 )
	        	elseif source == gui.button.unload_all then
	        		local res = exports.map_load:unloadAllMaps( true )
	        		if res then
	        			exports.global:playSoundSuccess()
	        			openPopUp( "Descarregado "..#res.." mapas teste.", true, false )
	        		else
	        			exports.global:playSoundError()
	        			openPopUp( "Ocorreram erros ao descarregar mapas de teste. Código 176.", true, false )
	        		end
		    	end
		    end)

			addEventHandler("onClientGUITabSwitched", root, function ( tab_selected )
				if tab_selected ~= nil then 
					for index, tab in pairs( gui.tab ) do
						if gui.tab[ index ] == tab_selected then
							populateTab( index )
							break
						end
					end
				end	
			end)
		end
	end
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

function populateTab( tabID, response, data, dontShowPopUp )
	if not tabPopulated[ tabID ] then
		tabPopulated[ tabID ] = true
		if tabID == 1 then -- my req
			if not response then
				tabPopulated[ tabID ] = nil
				if not dontShowPopUp then
					openPopUp( 'Synchronizing data...', false, true )
				end
				triggerServerEvent( 'maps:managerTabSync', resourceRoot, tabID, dontShowPopUp )
			elseif response == 'ok' then
				guiGridListClear( gui.gridlist[1] )
		        for _, value in ipairs( data ) do
					local row = guiGridListAddRow( gui.gridlist[1])
					guiGridListSetItemText(gui.gridlist[1], row, gui.gridlist.id, value.id, false, true)
					guiGridListSetItemText(gui.gridlist[1], row, gui.gridlist.type, value.type, false, false)
					guiGridListSetItemText(gui.gridlist[1], row, gui.gridlist.name, value.name, false, false)
					guiGridListSetItemText(gui.gridlist[1], row, gui.gridlist.prev, value.preview, false, false)
					guiGridListSetItemText(gui.gridlist[1], row, gui.gridlist.date, value.upload_date , false, false)
					guiGridListSetItemText(gui.gridlist[1], row, gui.gridlist.status, accountNameBuilder(value.reviewer) or '---' , false, false)
					local text, r, g, b, a = getReqStatus( value )
					guiGridListSetItemText(gui.gridlist[1], row, gui.gridlist.status, text , false, false)
					guiGridListSetItemColor ( gui.gridlist[1], row, gui.gridlist.status, r, g, b, a )
				end

				addEventHandler( 'onClientGUIDoubleClick', gui.gridlist[1], function ()
					if source == gui.gridlist[1] then
						local row, col = guiGridListGetSelectedItem( gui.gridlist[1] )
						if row ~= -1 and col ~= -1 then
							local text = guiGridListGetItemText( gui.gridlist[1] , row, 1 )
							openReqDetails( tonumber(text), data, tabID )
						end
					end
				end)
				if not dontShowPopUp then
					lockGui = false
					togWindow( gui.window[1], true )
					closePopUp()
				end				
			else
				if not dontShowPopUp then
					openPopUp( response, true, false )
				end
			end
		elseif tabID == 3 then -- mgmt
			if not response then
				tabPopulated[ tabID ] = nil
				if not dontShowPopUp then
					openPopUp( 'Sincronizando dados...', false, true )
				end
				triggerServerEvent( 'maps:managerTabSync', resourceRoot, tabID, dontShowPopUp )
			elseif response == 'ok' then
				guiGridListClear( gui.gridlist[2] )
		        for _, value in ipairs( data ) do
					local row = guiGridListAddRow( gui.gridlist[2])
					guiGridListSetItemText(gui.gridlist[2], row, gui.gridlist.id2, value.id, false, true)
					guiGridListSetItemText(gui.gridlist[2], row, gui.gridlist.type2, value.type, false, false)
					guiGridListSetItemText(gui.gridlist[2], row, gui.gridlist.name2, value.name, false, false)
					guiGridListSetItemText(gui.gridlist[2], row, gui.gridlist.prev2, value.preview, false, false)
					guiGridListSetItemText(gui.gridlist[2], row, gui.gridlist.date2, value.upload_date , false, false)
					guiGridListSetItemText(gui.gridlist[2], row, gui.gridlist.uploader, accountNameBuilder(value.uploader_name) or '---' , false, false)
					guiGridListSetItemText(gui.gridlist[2], row, gui.gridlist.status, accountNameBuilder(value.reviewer) or '---' , false, false)
					local text, r, g, b, a = getReqStatus( value )
					guiGridListSetItemText(gui.gridlist[2], row, gui.gridlist.status, text , false, false)
					guiGridListSetItemColor ( gui.gridlist[2], row, gui.gridlist.status, r, g, b, a )
					guiGridListSetItemText(gui.gridlist[2], row, gui.gridlist.reviewer2, accountNameBuilder(value.reviewer_name) or '---' , false, false)
				end

				addEventHandler( 'onClientGUIDoubleClick', gui.gridlist[2], function ()
					if source == gui.gridlist[2] then
						local row, col = guiGridListGetSelectedItem( gui.gridlist[2] )
						if row ~= -1 and col ~= -1 then
							local text = guiGridListGetItemText( gui.gridlist[2] , row, 1 )
							openReqDetails( tonumber(text), data, tabID )
						end
					end
				end)
				if not dontShowPopUp then
					lockGui = false
					togWindow( gui.window[1], true )
					closePopUp()
				end				
			else
				if not dontShowPopUp then
					openPopUp( response, true, false )
				end
			end
		end
	end
end
addEvent( 'maps:populateTab', true )
addEventHandler( 'maps:populateTab', resourceRoot, populateTab)

addEventHandler( 'onClientResourceStart', resourceRoot, function ()
	addCommandHandler( 'maps', openMapManager, false, false )
	addCommandHandler( 'mapas', openMapManager, false, false )
end)

function openPopUp( text, dismissable, lockMainWindow )
	closePopUp()
	togWindow( gui.window[1], false )
	togWindow( gui3.window[2], false )
	gui2.window[2] = guiCreateWindow(160, 446, 366, 145, "", false)
    guiWindowSetSizable(gui2.window[2], false)
    exports.global:centerWindow( gui2.window[2] )

    gui2.label[7] = guiCreateLabel(12, 31, 344, 49, text or 'Isto é algo.', false, gui2.window[2])
    guiLabelSetHorizontalAlign(gui2.label[7], "center", true)
    guiLabelSetVerticalAlign(gui2.label[7], "center")
    if dismissable then
    	gui2.button[2] = guiCreateButton(147, 90, 73, 33, "OK", false, gui2.window[2])
    	addEventHandler( 'onClientGUIClick', gui2.button[2], closePopUp, false)
    else
    	local w, h = guiGetSize( gui2.label[7], false )
    	guiSetSize( gui2.label[7], w, h + 40, false )
    end

    lockGui = lockMainWindow
end

function closePopUp()
	if gui2.window[2] and isElement( gui2.window[2] ) then
		destroyElement( gui2.window[2] )
		gui2.window[2] = nil
		togWindow( gui.window[1], true )
		togWindow( gui3.window[2], true )
	end
end

addEvent( 'maps:exteriorMapRequestResponse', true )
addEventHandler( 'maps:exteriorMapRequestResponse', resourceRoot, function( response )
	if response == 'ok' then
		openPopUp( 'Seu mapeamento foi enviado com sucesso e está atualmente em aprovação. Vamos informá-lo sobre o resultado por meio de notificação no jogo e e-mail.', true, false )
		tabPopulated[ 1 ] = nil
	else
		openPopUp( response, true, false )
	end
end)

local req
local function updateReqDetailsBtn( map_id )
	-- btn load/unload test map.
	if gui3.button[6] and isElement( gui3.button[6] ) then
		guiSetText( gui3.button[6], exports.map_load:isMapLoaded( tonumber( map_id ) ) and "Descarregar mapa de teste" or "Testar mapa" )
	end

end

function openReqDetails( id, reqs, tabID, silence )
	id = tonumber(id) or id
	local req = getReqFromId( id, reqs )
	if req then
		if tabID == 3 and req.uploader == getElementData( localPlayer, 'account:id' ) and not (exports.integration:isPlayerScripter( localPlayer ) or exports.integration:isPlayerMappingTeamLeader(localPlayer)) then
			exports.global:playSoundError()
			if not silence then
				openPopUp( "Você não pode administrar seu próprio mapa.", true, false )
			end
		else
			closeReqDetails()
			togWindow( gui.window[1], false )

		    gui3.window[2] = guiCreateWindow(581, 302, 756, 584, "Pedido ID #"..req.id.." - ["..req.type.."] "..req.name, false)
			guiWindowSetSizable(gui3.window[2], false)
		    exports.global:centerWindow( gui3.window[2] )

			gui3.label[9] = guiCreateLabel(58, 55, 637, 21, "Dê ao seu mapeamento um nome curto e descritivo:", false, gui3.window[2])
			guiSetFont(gui3.label[9], "default-bold-small")
			gui3.edit[6] = guiCreateEdit(78, 76, 617, 26, req.name or "", false, gui3.window[2])
			gui3.label[10] = guiCreateLabel(58, 112, 637, 21, "Link para uma foto do mapa:", false, gui3.window[2])
			guiSetFont(gui3.label[10], "default-bold-small")
			gui3.edit[7] = guiCreateEdit(78, 133, 617, 26, req.preview or '', false, gui3.window[2])
			gui3.label[11] = guiCreateLabel(58, 169, 637, 21, "Para que esse mapeamento será usado?", false, gui3.window[2])
			guiSetFont(gui3.label[11], "default-bold-small")
			gui3.edit[8] = guiCreateEdit(78, 190, 617, 26, req.purposes or '', false, gui3.window[2])
			gui3.label[12] = guiCreateLabel(58, 226, 637, 21, "Quem usará este mapa?", false, gui3.window[2])
			guiSetFont(gui3.label[12], "default-bold-small")
			gui3.edit[9] = guiCreateEdit(78, 247, 617, 26, req.used_by or '', false, gui3.window[2])
			gui3.label[13] = guiCreateLabel(58, 283, 637, 21, "Por que adicionar esse mapeamento no jogo é necessário?", false, gui3.window[2])
			guiSetFont(gui3.label[13], "default-bold-small")
			gui3.label[14] = guiCreateLabel(58, 381, 637, 21, tabID == 1 and "Status:" or "Nota interna:", false, gui3.window[2])
			guiSetFont(gui3.label[14], "default-bold-small")
			guiLabelSetColor(gui3.label[14], 251, 201, 2)
			gui3.memo[2] = guiCreateMemo(80, 304, 615, 67, req.reasons or "", false, gui3.window[2])
			local status = getReqStatus( req )
			gui3.memo[3] = guiCreateMemo(80, 402, 615, 67, tabID == 1 and status or req.note, false, gui3.window[2])   
			guiMemoSetReadOnly( gui3.memo[3], tabID == 1 )

			local isTmpMapLoaded = exports.map_load:isMapLoaded( id, true )

		    -- set max length for the editboxes
		    for _, box in pairs( gui3.edit ) do
		    	guiEditSetMaxLength( box, 200 )
		    	if tabID == 1 then
		    		guiEditSetReadOnly( box, status ~= 'Pendente' )
		    	end
		    end
		    guiEditSetMaxLength( gui3.edit[6], 100 )

		    local xoffset = 0
		    local yoffset = 0
		    gui3.button[3] = guiCreateButton(58, 503, 84, 36, "Fechar", false, gui3.window[2])
			gui3.button[4] = guiCreateButton(152, 503, 84, 36, "Salvar", false, gui3.window[2]) 
			gui3.button[5] = guiCreateButton(246, 503, 84, 36, "Deletar", false, gui3.window[2]) 
		    gui3.button[6] = guiCreateButton(340, 503, 84, 36, isTmpMapLoaded and "Descarregar mapa de teste" or "Testar mapa", false, gui3.window[2])
	    	gui3.button[7] = guiCreateButton(434, 503, 84, 36, "Aceitar", false, gui3.window[2])
	    	gui3.button[8] = guiCreateButton(528, 503, 84, 36, "Recusar", false, gui3.window[2])  
	    	gui3.button[9] = guiCreateButton(622, 503, 84, 36, req.enabled == 1 and "Desativar" or "Implementar", false, gui3.window[2])

		    if tabID == 1 then
		    	guiEditSetReadOnly( gui3.edit[6], status ~= 'Pendente' )
		    	guiSetVisible( gui3.button[6], false )
		    	guiSetVisible( gui3.button[7], false )
		    	guiSetVisible( gui3.button[8], false )
		    	guiSetVisible( gui3.button[9], false )
		    end

		    addEventHandler( 'onClientGUIClick', gui3.window[2], function()
		    	if source == gui3.button[3] then
		    		closeReqDetails()
		    	elseif source == gui3.button[4] then
		    		local name = guiGetText( gui3.edit[6] )
		    		local prev = guiGetText( gui3.edit[7] )
		    		local what = guiGetText( gui3.edit[8] )
		    		local who = guiGetText( gui3.edit[9] )
		    		local why = guiGetText( gui3.memo[2] )
		    		if string.len( name ) < 1 or string.len( prev ) < 1 or string.len( what ) < 1 or string.len( who ) < 1 or string.len( why ) < 2 or string.len( why ) > 200 then 
		    			exports.global:playSoundError()
		    			if not silence then
		    				openPopUp( "Verifique sua entrada e tente novamente.", true, false )
		    			end
		    		else
		    			if not silence then
		    				openPopUp( "Enviando informações para o servidor...", false, true )
		    			end
		    			triggerServerEvent( 'maps:updateReq', resourceRoot, tabID, name, prev, what, who, why, id )
		    		end
		    	elseif source == gui3.button[5] then
		    		if not silence then
		    			openPopUp( 'Processando...', false, true )
		    		end
		    		triggerServerEvent( 'maps:delReq', resourceRoot, tabID, id )
		    	elseif source == gui3.button[6] then -- test/untest
		    		if isTmpMapLoaded then
		    			local result = exports.map_load:unloadMap( id )
		    			if result then
		    				if not silence then
		    					openPopUp( "Destruido "..result.objects.." objetos, "..result.blips.." blips & restaurado "..result.removals.." objetos do mundo.", true, false )
		    				end
							exports.global:playSoundSuccess()
							closeReqDetails()
						else
							if not silence then
								openPopUp( "Error ao remover objetos..", true, false )
							end
							exports.global:playSoundError()
		    			end
		    		else
		    			if not silence then
		    				openPopUp( 'Buscando conteúdo de mapeamento do servidor...', false, true )
		    			end
		    			triggerServerEvent( 'maps:testMap', resourceRoot, id )
		    		end
		    	elseif source == gui3.button[7] or source == gui3.button[8] then -- accept/decline
		    		openMessenger( id, source == gui3.button[7] )
		    	elseif source == gui3.button[9] then -- implement/disable.
		    		-- unload all test maps if any.
		    		exports.map_load:unloadAllMaps( true )
		    		openPopUp( (req.enabled ~= 1 and "Implementando" or "Desativando").." mapa...", false, true )
		    		triggerServerEvent( 'maps:implement', resourceRoot, id, req.enabled ~= 1 )
		    	end
		    end)

			-- set button enabled/disabled based on the map status.
			if isTmpMapLoaded then
				guiSetEnabled( gui3.button[4], false )
				guiSetEnabled( gui3.button[5], false )
				guiSetEnabled( gui3.button[7], false )
				guiSetEnabled( gui3.button[8], false )
				guiSetEnabled( gui3.button[9], false )
			else
				guiSetEnabled( gui3.button[4], canEditMap( localPlayer, req, tabID ) ) -- save btn.
				guiSetEnabled( gui3.button[5], canDeleteMap( localPlayer, req, tabID ) ) -- delete btn.
				guiSetEnabled( gui3.button[7], canAcceptMap( localPlayer, req, tabID ) ) -- accept btn.
				guiSetEnabled( gui3.button[8], canDeclineMap( localPlayer, req, tabID ) ) -- accept btn.
				guiSetEnabled( gui3.button[9], req.enabled == 1 and canDisableMap( localPlayer, req, tabID ) or canImplementMap( localPlayer, req, tabID ) ) -- implement/disable btn.
			end
		end
	end
end

function closeReqDetails( )
	if gui3.window[2] and isElement( gui3.window[2] ) then
		destroyElement( gui3.window[2] )
		gui3.window[2] = nil
		togWindow( gui.window[1], true )
		closeMessenger()
	end
end

addEventHandler( 'onClientResourceStop', resourceRoot, function()
	guiSetInputEnabled( false )
	showCursor( false )
end)

addEvent( 'maps:updateMyReqResponse', true )
addEventHandler( 'maps:updateMyReqResponse', resourceRoot, function( response, data )
	if response == 'ok' then
		--openPopUp( 'Your mapping has been updated.', true, false )
		closeReqDetails()
		tabPopulated[ data ] = nil
		populateTab( data )
	else
		openPopUp( response, true, false )
	end
end)

addEvent( 'maps:testMap', true )
addEventHandler( 'maps:testMap', resourceRoot, function( response, contents, map_id )
	if response == 'ok' then
		local loaded = exports.map_load:loadMap( contents, map_id, true )
		if loaded then
			openPopUp( "Carregado "..#loaded.objects.." objetos & removido "..#loaded.removals.." objetos do mundo. Criado "..#loaded.blips.." blips anexado aos mapa.", true, false )
			exports.global:playSoundSuccess()
			closeReqDetails()
		else
			openPopUp( "Tentativa de carregar "..#contents.." objetos. Falhada, erros ocorreram durante o carregamento de objetos do mapa.", true, false )
			exports.global:playSoundError()
		end
	else
		exports.global:playSoundError()
		openPopUp( response, true, false )
	end
end)

addEvent( 'maps:approveRequest', true )
addEventHandler( 'maps:approveRequest', resourceRoot, function( response, map_id, accepting )
	if response == 'ok' then
		openPopUp( "Pedido ID #"..map_id.." foi "..(accepting and "aceito" or "recusado")..".", true, false )
		exports.global:playSoundSuccess()
		closeReqDetails()
		tabPopulated[ 3 ] = nil
		populateTab( 3, nil, nil, true )
	else
		openPopUp( response, true, false )
		exports.global:playSoundError()
	end
end)

function openMessenger( map_id, accepting )
	closeMessenger()
    gui4.window[1] = guiCreateWindow(423, 500, 454, 206, "Mensagem para enviar jogador ao aceitar ou recusar:", false)
    guiWindowSetSizable(gui4.window[1], false)
    exports.global:centerWindow( gui4.window[1] )

    gui4.memo[1] = guiCreateMemo(9, 31, 435, 129, "", false, gui4.window[1])
    gui4.button[1] = guiCreateButton(9, 170, 213, 26, "Cancelar", false, gui4.window[1])
    gui4.button[2] = guiCreateButton(231, 170, 213, 26, "Enviar", false, gui4.window[1])    
    addEventHandler( 'onClientGUIClick', gui4.window[1], function()
    	if source == gui4.button[1] then
    		closeMessenger()
    	elseif source == gui4.button[2] then
    		local text = guiGetText( gui4.memo[1] )
    		if string.len( text ) < 2 then
    			exports.global:playSoundError()
    			openPopUp( "Por favor, insira uma mensagem para enviar jogo ao aceitar ou recusar seu pedido. Esta mensagem também será armazenada internamente.", true, false )
    		elseif string.len( text ) > 200 then
    			exports.global:playSoundError()
    			openPopUp( "A mensagem é muito longa. (O máximo é 200 caracteres).", true, false )
    		else
    			triggerServerEvent( 'maps:approveRequest', resourceRoot, map_id, text, accepting )
    			openPopUp( "Processando...", false, true )
    			closeMessenger()
    		end
    	end
    end)
end

function closeMessenger()
	if gui4.window[1] and isElement( gui4.window[1] ) then
		destroyElement( gui4.window[1] )
		gui4.window[1] = nil
	end
end

addEvent( 'maps:implement', true )
addEventHandler( 'maps:implement', resourceRoot, function( response, map_id, implementing )
	if response == 'ok' then
		openPopUp( "Mapa ID #"..map_id.." foi "..(implementing and "implementado" or "desativado")..".", true, false )
		exports.global:playSoundSuccess()
		closeReqDetails()
		tabPopulated[ 3 ] = nil
		populateTab( 3, nil, nil, true )
	else
		openPopUp( response, true, false )
		exports.global:playSoundError()
	end
end)


