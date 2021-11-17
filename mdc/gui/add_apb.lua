--[[
--	Copyright (C) Root Gaming - All Rights Reserved
--	Unauthorized copying of this file, via any medium is strictly prohibited
--	Proprietary and confidential
--	Written by Daniel Lett <me@lettuceboi.org>, December 2012
]]--

local SCREEN_X, SCREEN_Y = guiGetScreenSize()
local resourceName = getResourceName( getThisResource( ) )
------------------------------------------
function getTime( day, month, timestamp )
	local months = { "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro" }
	local days = { "Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sabado" }
	local time = nil
	local ts = nil
	
	if timestamp then
		time = getRealTime( timestamp )
	else
		time = getRealTime( )
	end
	
	ts = ( tonumber( time.hour ) >= 12 and tostring( tonumber( time.hour ) - 12 ) or time.hour ) .. ":"..("%02d"):format(time.minute)..( tonumber( time.hour ) >= 12 and " PM" or " AM" )
	
	if month then
		ts =  months[ time.month + 1 ] .. " ".. time.monthday .. ", " .. ts
	end
	
	if day then
		ts = days[ time.weekday + 1 ].. ", " .. ts
	end
	
	return ts
end

------------------------------------------
function add_apb( )
	guiSetInputEnabled ( true )
	local window = { }
	local width = 400
	local height = 330
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow( x, y, width, height, "Adicionar APB", false )
	
	local y = 30
	window.typeLabel 	= guiCreateLabel( 10, y, 70, 20, "Tipo: ", false, window.window )
	
	y = 30
	window.typeCombo 	= guiCreateComboBox( 80, y, width - 90, 95, "Selecionar tipo..", false, window.window)
	guiComboBoxAddItem(window.typeCombo, "APB")
	--guiComboBoxAddItem(window.typeCombo, "ANPR") 
	addEventHandler("onClientGUIComboBoxAccepted", window.typeCombo, 
	function()
		if isElement(window.timeLabel) then
			destroyElement(window.timeLabel)
			destroyElement(window.descLabel)
			destroyElement(window.personLabel)
			destroyElement(window.time2Label)
			destroyElement(window.descMemo)
			destroyElement(window.personEdit)
		end	
		local type = guiComboBoxGetItemText(window.typeCombo, guiComboBoxGetSelected(window.typeCombo))
	
		if type == "APB" then
			local y = 60
			window.timeLabel 	= guiCreateLabel( 10, y, 70, 20, "Data: ", false, window.window )
			y = y + 30
			window.descLabel 	= guiCreateLabel( 10, y, 70, 20, "Descrição: ", false, window.window )
			y = y + 70
			window.personLabel 	= guiCreateLabel( 10, y, 70, 40, "Pessoa \nEnvolvida: ", false, window.window )
	
			y = 60
			window.time2Label 	= guiCreateLabel( 80, y, width - 90, 20, getTime( true, true, false ), false, window.window )
			y = y + 30
			window.descMemo		= guiCreateMemo( 80, y, width - 90, 60, "Alguns detalhes do que aconteceu.", false, window.window )
			y = y + 70
			window.personEdit	= guiCreateEdit( 80, y, width - 90, 30, "Quem fez isso", false, window.window )
			guiSetText( window.addButton, "Emitir APB" )
			guiSetEnabled( window.addButton, true )
		elseif type == "ANPR" then
			local y = 60
			window.timeLabel 	= guiCreateLabel( 10, y, 70, 20, "Data: ", false, window.window )
			y = y + 30
			window.descLabel 	= guiCreateLabel( 10, y, 70, 20, "Procurado por: ", false, window.window )
			y = y + 70
			window.personLabel 	= guiCreateLabel( 10, y, 70, 40, "Placa do Veículo: ", false, window.window )
			
			y = 60
			window.time2Label 	= guiCreateLabel( 90, y, width - 100, 20, getTime( true, true, false ), false, window.window )
			y = y + 30
			window.descMemo		= guiCreateMemo( 90, y, width - 100, 60, "Adicione apenas o modelo do veículo e as taxas aqui.", false, window.window )
			y = y + 70
			window.personEdit	= guiCreateEdit( 90, y, width - 100, 30, "Placas do veículo", false, window.window )
			guiSetText( window.addButton, "Add ANPR" )
			guiSetEnabled( window.addButton, true )
		end
	end, false)
	
	window.addButton = guiCreateButton( 10, height - 100, width - 20, 40, "Adicionar APB", false, window.window )
	guiSetEnabled(window.addButton, false)
	addEventHandler( "onClientGUIClick", window.addButton, 
		function ()
			local description = guiGetText( window.descMemo )
			local person = guiGetText( window.personEdit )
			local type = guiComboBoxGetItemText(window.typeCombo, guiComboBoxGetSelected(window.typeCombo))
			guiSetInputEnabled ( false )
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( resourceName .. ":add_apb", localPlayer, type, description, person )			
		end
	, false )
	
	window.closeButton = guiCreateButton( 10, height - 50, width - 20, 40, "Fechar", false, window.window )
	addEventHandler( "onClientGUIClick", window.closeButton, 
		function ()
			guiSetInputEnabled ( false )
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( resourceName .. ":main", localPlayer )
		end
	, false )
end

function view_apb( id, characterName, description, issuedBy )
	guiSetInputEnabled ( true )
	local window = { }
	local width = 400
	local height = 280
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow( x, y, width, height, "All Points Bulletin", false )
	local y = 30
	window.issuedLabel 	= guiCreateLabel( 10, y, 70, 20, "Emitido por: ", false, window.window )
	y = y + 30
	window.descLabel 	= guiCreateLabel( 10, y, 70, 20, "Descrição: ", false, window.window )
	y = y + 70
	window.personLabel 	= guiCreateLabel( 10, y, 70, 40, "Pessoa \nEnvolvida: ", false, window.window )
	y = 30
	window.issuedEdit 	= guiCreateEdit( 80, y, width - 90, 30, issuedBy, false, window.window )
	guiEditSetReadOnly( window.issuedEdit, true )
	y = y + 40
	window.descMemo		= guiCreateMemo( 80, y, width - 90, 60, description, false, window.window )
	guiMemoSetReadOnly( window.descMemo, true )
	y = y + 70
	window.personButton	= guiCreateButton( 80, y, width - 90, 30, characterName, false, window.window )
	addEventHandler( "onClientGUIClick", window.personButton,
		function()
			guiSetInputEnabled ( false )
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( resourceName .. ":search", localPlayer, characterName, 0 )
		end
	, false )
	
	window.addButton = guiCreateButton( 10, height - 100, width - 20, 40, "Remover APB", false, window.window )
	addEventHandler( "onClientGUIClick", window.addButton, 
		function ()
			guiSetInputEnabled ( false )
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( resourceName .. ":remove_apb", localPlayer, id )
		end
	, false )
	
	window.closeButton = guiCreateButton( 10, height - 50, width - 20, 40, "Fechar", false, window.window )
	addEventHandler( "onClientGUIClick", window.closeButton, 
		function ()
			guiSetInputEnabled ( false )
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( "mdc:main", localPlayer )
		end
	, false )
end

function view_anpr( id, plate, description, issuedBy )
    guiSetInputEnabled ( true )
    local window = { }
    local width = 400
    local height = 280
    local x = SCREEN_X / 2 - width / 2
    local y = SCREEN_Y / 2 - height / 2
    window.window = guiCreateWindow( x, y, width, height, "MDC Ver ANPR", false )
    
    local y = 30
    window.issuedLabel 	= guiCreateLabel( 10, y, 70, 20, "Emitipo Por: ", false, window.window )
    y = y + 30
    window.descLabel 	= guiCreateLabel( 10, y, 70, 20, "Procurado por: ", false, window.window )
    y = y + 70
    window.personLabel 	= guiCreateLabel( 10, y, 70, 40, "Placa do Veículo: ", false, window.window )
    
    y = 30
    
    window.issuedEdit 	= guiCreateEdit( 80, y, width - 90, 30, issuedBy, false, window.window )
    guiEditSetReadOnly( window.issuedEdit, true )
    y = y + 40
    
    window.descMemo		= guiCreateMemo( 80, y, width - 90, 60, description, false, window.window )
    guiMemoSetReadOnly( window.descMemo, true )
    y = y + 70
    
    window.personButton	= guiCreateButton( 80, y, width - 90, 30, plate, false, window.window )
    addEventHandler( "onClientGUIClick", window.personButton,
        function()
            guiSetInputEnabled ( false )
            guiSetVisible( window.window, false )
            destroyElement( window.window )
            window = { }
            triggerServerEvent( resourceName .. ":search", localPlayer, plate, 1 )
        end
    , false )
    
    window.addButton = guiCreateButton( 10, height - 100, width - 20, 40, "Remover ANPR", false, window.window )
    addEventHandler( "onClientGUIClick", window.addButton, 
        function ()
            guiSetInputEnabled ( false )
            guiSetVisible( window.window, false )
            destroyElement( window.window )
            window = { }
            triggerServerEvent( resourceName .. ":remove_anpr", localPlayer, id )
        end
    , false )
    
    window.closeButton = guiCreateButton( 10, height - 50, width - 20, 40, "Fechar", false, window.window )
    addEventHandler( "onClientGUIClick", window.closeButton, 
        function ()
            guiSetInputEnabled ( false )
            guiSetVisible( window.window, false )
            destroyElement( window.window )
            window = { }
            triggerServerEvent( resourceName .. ":main", localPlayer )
        end
    , false )
end