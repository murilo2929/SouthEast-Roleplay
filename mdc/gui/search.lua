--[[
--	Copyright (C) Root Gaming - All Rights Reserved
--	Unauthorized copying of this file, via any medium is strictly prohibited
--	Proprietary and confidential
--	Written by Daniel Lett <me@lettuceboi.org>, December 2012
]]--

local SCREEN_X, SCREEN_Y = guiGetScreenSize()
local resourceName = getResourceName( getThisResource( ) )
searchW = {}
------------------------------------------
function search ( )
	closeSearchGui()
	togWin( mainW.window, false )
	guiSetInputEnabled ( true )
	local window = { }
	local width = 400
	local height = 200
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	searchW.window = guiCreateWindow( x, y, width, height, "MDC Pesquisa", false )
	
	local DEFAULT_SEARCH_TEXT = "Digite a Pesquisa..."
	searchW.searchEdit = guiCreateEdit( 10, 30, width - 20, 40, DEFAULT_SEARCH_TEXT, false, searchW.window )
	addEventHandler( "onClientGUIClick", searchW.searchEdit,
		function()
			if guiGetText(source) == DEFAULT_SEARCH_TEXT then
				guiSetText(source, "")
			end
		end
	, false)
	
	searchW.searchCombo = guiCreateComboBox ( 10, 80, width - 20, 95, "Selecione um tipo de pesquisa", false, searchW.window )
	guiComboBoxAddItem( searchW.searchCombo, "Pessoa" )

	--if canAccess( localPlayer, 'canSeeVehicles' ) then
		guiComboBoxAddItem( searchW.searchCombo, "Placa do Veículo" )
	--end
	if canAccess( localPlayer, 'canSeeProperties' ) then
		guiComboBoxAddItem( searchW.searchCombo, "CEP da Propiedade (( ID ))" )
	end
	--if canAccess( localPlayer, 'canSeeVehicles' ) then
		guiComboBoxAddItem( searchW.searchCombo, "VIN do Veículo (( ID ))" )
	--end
	
	searchW.goButton = guiCreateButton( 10, 110, width - 20, 40, "Pesquisar!", false, searchW.window )
	addEventHandler( "onClientGUIClick", searchW.goButton, 
		function ()
			local query = guiGetText( searchW.searchEdit )
			local queryType = guiComboBoxGetSelected ( searchW.searchCombo ) -- This is not a accurate way of checking the query type as it is dependent on the individuals permissions.
			local queryType = guiComboBoxGetItemText( searchW.searchCombo, queryType )
			closeSearchGui()
			triggerServerEvent( resourceName ..":search", localPlayer, query, queryType )
		end
	, false )
	searchW.closeButton = guiCreateButton( 10, 160, width - 20, 40, "Fechar", false, searchW.window )
	addEventHandler( "onClientGUIClick", searchW.closeButton, 
		function ()
			closeSearchGui()
		end
	, false )
end

function closeSearchGui()
	if searchW.window and isElement(searchW.window) then
		guiSetInputEnabled ( false )
		guiSetVisible( searchW.window, false )
		destroyElement(searchW.window)
		togWin( mainW.window, true )
	end
end

function search_noresult ( )
	local window = { }
	local width = 240
	local height = 110
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	searchW.window = guiCreateWindow( x, y, width, height, "MDC Pesquisa - Sem Resultados!", false )
	
	searchW.errorLabel = guiCreateLabel( 10, 30, width - 20, 20, "Não conseguimos encontrar nenhuma correspondência para isso!", false, searchW.window )
	
	
	searchW.closeButton = guiCreateButton( 10, 60, width - 20, 40, "Fechar", false, searchW.window )
	addEventHandler( "onClientGUIClick", searchW.closeButton, 
		function ()
			guiSetVisible( searchW.window, false )
			destroyElement( searchW.window )
			window = { }
			search( )
		end
	, false )
end

function search_error ( )
	local window = { }
	local width = 210
	local height = 110
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	searchW.window = guiCreateWindow( x, y, width, height, "MDC Falha na Pesquisa", false )
	
	searchW.errorLabel = guiCreateLabel( 10, 30, width - 20, 20, "Você precisa selecionar um tipo de pesquisa!", false, searchW.window )
	
	
	searchW.closeButton = guiCreateButton( 10, 60, width - 20, 40, "Fechar", false, searchW.window )
	addEventHandler( "onClientGUIClick", searchW.closeButton, 
		function ()
			guiSetVisible( searchW.window, false )
			destroyElement( searchW.window )
			window = { }
			search( )
		end
	, false )
end

------------------------------------------
addEvent( resourceName .. ":search_error", true )
addEvent( resourceName .. ":search_noresult", true )
addEventHandler( resourceName .. ":search_error", root, search_error )
addEventHandler( resourceName .. ":search_noresult", root, search_noresult )