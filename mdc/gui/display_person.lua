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

function getShortTime( timestamp )
	local months = { "JAN", "FEV", "MAR", "ABR", "MAI", "JUN", "JUL", "AGO", "SET", "OUT", "NOV", "DEZ" }
	local time = nil
	local ts = nil

	if timestamp then
		time = getRealTime( timestamp )
	else
		time = getRealTime( )
	end

	ts = time.hour .. ":"..("%02d"):format(time.minute)
	ts =  months[ time.month + 1 ] .. " ".. time.monthday .. ", " .. tostring( tonumber( time.year ) + 1900 ) .. " " .. ts

	return ts
end

function DEC_HEX(IN)
    local B,K,OUT,I,D=16,"0123456789ABCDEF","",0
    while IN>0 do
        I=I+1
        IN,D=math.floor(IN/B),math.mod(IN,B)+1
        OUT=string.sub(K,D,D)..OUT
    end
    return OUT
end

------------------------------------------
function display_person ( charactername, age, char_weight, char_height, gender, licenses, pdjail, dob, ethnicity, phone, occupation, address, photo, details, created_by, wanted, wanted_by, wanted_details, charid, vehicles, properties, crimes, pilotEvents, pilotDetails, pilotLicenses, dmvhistory)
	local window = { }
	local width = 700
	local height = 600
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow( x, y, width, height, "Mobile Data Computer - MDC Search - Pessoa: ".. charactername:gsub( "_", " " ), false )

	window.nameLabel	= guiCreateLabel( 10, 30, 180, 20, "Nome: " .. charactername:gsub( "_", " " ), false, window.window )
	window.ageLabel 	= guiCreateLabel( 10, 50, 180, 20, "Idade: " .. age, false, window.window )
	window.genderLabel	= guiCreateLabel( 10, 70, 180, 20, "Genero: " .. ( tonumber( gender ) == 0 and "Masculino" or "Feminino" ), false, window.window )
	window.incarcLabel	= guiCreateLabel( 10, 90, 180, 20, "Preso: " .. ( tonumber( pdjail ) == 1 and "Sim" or "Não" ), false, window.window )
	window.dobLabel		= guiCreateLabel( 10, 110, 180, 20, "Data de Nascimento: " .. dob, false, window.window )

	window.ethnicLabel	= guiCreateLabel( 200, 30, 240, 20, "Etnia: " .. ethnicity, false, window.window )
	window.phoneLabel	= guiCreateLabel( 200, 50, 240, 20, "Celular: " .. phone, false, window.window )
	window.occupLabel	= guiCreateLabel( 200, 70, 240, 20, "Ocupação: " .. occupation, false, window.window )
	window.addressLabel	= guiCreateLabel( 200, 90, 240, 20, "Endereço: " .. address, false, window.window )
	window.weightLabel	= guiCreateLabel( 200, 110, 240, 20, "Peso: " .. char_weight .. "kg" , false, window.window )
	window.heightLabel	= guiCreateLabel( 200, 130, 240, 20, "Altura: " .. char_height .. "cm" , false, window.window )

	window.updateButton	= guiCreateButton( width - 200, 30, 190, 30, "Atualizar Detalhes", false, window.window )
	addEventHandler( "onClientGUIClick", window.updateButton,
		function ()
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			update_person( charactername, charid, dob, ethnicity, phone, occupation, address, photo, details )
		end
	, false )
	window.wantedButton	= guiCreateButton( width - 200, 70, 190, 30, ( tonumber( wanted ) == 1 and "Atualizar Mandado" or "Emitir Mandado" )  , false, window.window )
	addEventHandler( "onClientGUIClick", window.wantedButton,
		function ()
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			update_warrant( charactername, charid, wanted, wanted_details )
		end
	, false )

	local yOffset = 0

	if canAccess(localPlayer, "canSeePilotStuff") then
		window.addButton = guiCreateButton( width - 200, 110, 190, 30, "Add Evento de Piloto", false, window.window )
		addEventHandler( "onClientGUIClick", window.addButton,
			function ()
				guiSetVisible( window.window, false )
				destroyElement( window.window )
				window = { }
				add_pilot_event( charid, charactername )
			end
		, false )
		window.removeButton	= guiCreateButton( width - 200, 150, 190, 30, "Remover Evento de Piloto", false, window.window )
		addEventHandler( "onClientGUIClick", window.removeButton,
			function ()
				local selectedRow, selectedCol = guiGridListGetSelectedItem( window.pilotEventsTable )
				if selectedRow > -1 then
					local crime_id = guiGridListGetItemData( window.pilotEventsTable, selectedRow, window.pilotEventsCrimeCol )
					local crime_officer = guiGridListGetItemData( window.pilotEventsTable, selectedRow, window.pilotEventsPunishCol )
					if tonumber( crime_id ) then
						local level = getAdminLevel( localPlayer )
						if level > 1 or crime_officer == getElementData( localPlayer, "dbid" ) then
							triggerServerEvent( resourceName .. ":remove_pilot_event", localPlayer, charactername, crime_id )
						else
							remove_pilot_event_noperm( charactername )
						end
					else
						remove_pilot_event_noid( charactername )
					end
					guiSetVisible( window.window, false )
					destroyElement( window.window )
					window = { }
				end
			end
		, false )
		yOffset = yOffset + 40
	end

	if canAccess(localPlayer, "canSeeWarrants") then
		window.addButton = guiCreateButton( width - 200, 110 + yOffset, 190, 30, "Adicionar Crime", false, window.window )
		addEventHandler( "onClientGUIClick", window.addButton,
			function ()
				guiSetVisible( window.window, false )
				destroyElement( window.window )
				window = { }
				add_crime( charid, charactername )
			end
		, false )
		window.removeButton	= guiCreateButton( width - 200, 150 + yOffset, 190, 30, "Remover Crime", false, window.window )
		addEventHandler( "onClientGUIClick", window.removeButton,
			function ()
				local selectedRow, selectedCol = guiGridListGetSelectedItem( window.crimesTable )
				local crime_id = guiGridListGetItemData( window.crimesTable, selectedRow, window.crimeCol )
				if tonumber( crime_id ) then
					local level = getAdminLevel( localPlayer )
					if exports.global:isPlayerScripter(localPlayer) or officer == getElementData( localPlayer, "dbid" ) then
						triggerServerEvent( resourceName .. ":remove_crime", localPlayer, charactername, crime_id )
					else
						remove_crime_noperm( charactername )
					end
				else
					remove_crime_noid( charactername )
				end
				guiSetVisible( window.window, false )
				destroyElement( window.window )
				window = { }
			end
		, false )
	end

	window.panel		= guiCreateTabPanel ( width - 200, 190 + yOffset, 190, 200, false, window.window )
	if canAccess( localPlayer, 'canSeeVehicles' ) then
		window.vehicleTab	= guiCreateTab( "Veículos", window.panel )
	end
	if canAccess( localPlayer, 'canSeeProperties' ) then
		window.propertyTab	= guiCreateTab( "Propriedades", window.panel )
	end

	--Vehicles
	if canAccess( localPlayer, 'canSeeVehicles' ) then
		window.vehicleTable	= guiCreateGridList ( 10, 10, 170, 155, false, window.vehicleTab )
		window.vehicleCol	= guiGridListAddColumn( window.vehicleTable, "Aeronaves de sua Propriedade", 0.9 )

		if ( #vehicles > 0 ) then
			for i = 1, #vehicles, 1 do
				local row = guiGridListAddRow ( window.vehicleTable )
				local vname = vehicles[i][2]
				if tonumber(name) then
					vname = getVehicleNameFromModel(tonumber(name))
				end
				guiGridListSetItemText( window.vehicleTable, row, window.vehicleCol, tostring(vname) .. " - "..tostring( vehicles[ i ][ 3 ] ), false, false )
				guiGridListSetItemData( window.vehicleTable, row, window.vehicleCol, vehicles[ i ][ 3 ] )
			end
			addEventHandler( "onClientGUIDoubleClick", window.vehicleTable,
				function ( )
					local selectedRow, selectedCol = guiGridListGetSelectedItem( window.vehicleTable )
					if selectedRow > -1 then
						local vehiclePlate = guiGridListGetItemData( window.vehicleTable, selectedRow, selectedCol )
						setElementData( localPlayer, "mdc_close_to", charactername )
						setElementData( localPlayer, "mdc_close_type", 0 )
						triggerServerEvent( resourceName .. ":search", localPlayer, vehiclePlate, 1 )

						guiSetVisible( window.window, false )
						destroyElement( window.window )
						window = { }
					end
				end
			, false )
		else
			local row = guiGridListAddRow ( window.vehicleTable )
			guiGridListSetItemText ( window.vehicleTable, row, window.vehicleCol, "Sem Aeronaves", false, false )
		end
	else
		if canAccess( localPlayer, 'canSeeVehicles' ) then
			window.vehicleTable	= guiCreateGridList ( 10, 10, 170, 155, false, window.vehicleTab )
			window.vehicleCol	= guiGridListAddColumn( window.vehicleTable, "Veículos", 0.9 )

			if ( #vehicles > 0 ) then
				for i = 1, #vehicles, 1 do
					local row = guiGridListAddRow ( window.vehicleTable )
					local vname = vehicles[i][2]
					if tonumber(name) then
						vname = getVehicleNameFromModel(tonumber(name))
					end
					guiGridListSetItemText( window.vehicleTable, row, window.vehicleCol, tostring(vname) .. " - "..tostring( vehicles[ i ][ 3 ] ), false, false )
					guiGridListSetItemData( window.vehicleTable, row, window.vehicleCol, vehicles[ i ][ 3 ] )
				end
				addEventHandler( "onClientGUIDoubleClick", window.vehicleTable,
					function ( )
						local selectedRow, selectedCol = guiGridListGetSelectedItem( window.vehicleTable )
						if selectedRow ~= -1 and selectedCol ~= -1 then
							local vehiclePlate = guiGridListGetItemData( window.vehicleTable, selectedRow, selectedCol )
							setElementData( localPlayer, "mdc_close_to", charactername )
							setElementData( localPlayer, "mdc_close_type", 0 )
							triggerServerEvent( resourceName .. ":search", localPlayer, vehiclePlate, 1 )

							guiSetVisible( window.window, false )
							destroyElement( window.window )
							window = { }
						end
					end
				, false )
			else
				local row = guiGridListAddRow ( window.vehicleTable )
				guiGridListSetItemText ( window.vehicleTable, row, window.vehicleCol, "Sem Veículos", false, false )
			end
		end
	end

	--Properties
	if canAccess( localPlayer, 'canSeeProperties' ) then
		window.propTable	= guiCreateGridList ( 10, 10, 170, 155, false, window.propertyTab )
		window.propCol		= guiGridListAddColumn( window.propTable, "Propriedades", 0.9 )

		if ( #properties > 0 ) then
			for i = 1, #properties, 1 do
				local row = guiGridListAddRow ( window.propTable )
				guiGridListSetItemText( window.propTable, row, window.propCol, properties[ i ][ 2 ], false, false )
				guiGridListSetItemData( window.propTable, row, window.propCol, properties[ i ][ 1 ] )
			end

			addEventHandler( "onClientGUIDoubleClick", window.propTable,
				function ( )
					local selectedRow, selectedCol = guiGridListGetSelectedItem( window.propTable )
					if selectedRow > -1 then
						local propertyID = guiGridListGetItemData( window.propTable, selectedRow, selectedCol )
						setElementData( localPlayer, "mdc_close_to", charactername )
						setElementData( localPlayer, "mdc_close_type", 0 )
						triggerServerEvent( resourceName .. ":search", localPlayer, propertyID, 2 )

						guiSetVisible( window.window, false )
						destroyElement( window.window )
						window = { }
					end
				end
			, false )
		else
			local row = guiGridListAddRow ( window.propTable )
			guiGridListSetItemText ( window.propTable, row, window.propCol, "Sem Propriedades", false, false )
		end
	end

	--Crimes, Details & DMV history
	window.mainPanel	= guiCreateTabPanel ( 10, 190, 480, 270, false, window.window )

	window.crimesTab	= guiCreateTab( "Crimes", window.mainPanel )
	window.crimesTable	= guiCreateGridList ( 10, 10, 460, 230, false, window.crimesTab )
	window.dateCol		= guiGridListAddColumn( window.crimesTable, "Data", 0.3 )
	window.crimeCol		= guiGridListAddColumn( window.crimesTable, "Crime", 0.35 )
	window.punishCol	= guiGridListAddColumn( window.crimesTable, "Punição", 0.3 )
	
	if canAccess( localPlayer, 'canSeeVehicles' ) then
		window.DMVHistoryTab	= guiCreateTab( "Histórico DMV", window.mainPanel )
		window.DMVHistoryTable	= guiCreateGridList ( 10, 10, 460, 230, false, window.DMVHistoryTab )
		window.DMVDate		= guiGridListAddColumn( window.DMVHistoryTable, "Data", 0.3 )
		window.DMVDetails		= guiGridListAddColumn( window.DMVHistoryTable, "VIN (( ID )) ", 0.3 )
		window.DMVStatus	= guiGridListAddColumn( window.DMVHistoryTable, "Status", 0.35 )
		
		if ( #dmvhistory > 0 ) then
			for i = 1, #dmvhistory, 1 do 
				local status = ""
			
				if (dmvhistory[i][3] == '1' ) then 
					status = "Veículo foi registrado."
				else
					status = "Veículo não registrado."
				end

				local row = guiGridListAddRow ( window.DMVHistoryTable )
				guiGridListSetItemText( window.DMVHistoryTable, row, window.DMVDate, dmvhistory[i][1] , false, false )
				guiGridListSetItemText( window.DMVHistoryTable, row, window.DMVDetails, dmvhistory[i][2] , false, false )
				guiGridListSetItemText( window.DMVHistoryTable, row, window.DMVStatus, status, false, false )	
			end
		end
	end

	window.detailsTab	= guiCreateTab( "Detalhes", window.mainPanel )
	addEventHandler( "onClientGUIClick", window.detailsTab,
		function()
			guiSetInputEnabled ( true )
		end
	, false )
	window.detailsMemo	= guiCreateMemo( 10, 10, 460, 190, details, false, window.detailsTab )
	addEventHandler( "onClientGUIClick", window.detailsMemo,
		function()
			guiSetInputEnabled ( true )
		end
	, false )
	window.detailsButton= guiCreateButton( 10, 210, 460, 30, "Atualizar", false, window.detailsTab )
	addEventHandler( "onClientGUIClick", window.detailsButton,
		function ( )
			local details = guiGetText( window.detailsMemo )
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( resourceName..":update_details", localPlayer, charid, charactername, details )
			guiSetInputEnabled ( false )
		end
	, false )
	guiMemoSetReadOnly( window.detailsMemo, false )

	if ( #crimes > 0 ) then
		for i = 1, #crimes, 1 do
			local row = guiGridListAddRow ( window.crimesTable )
			guiGridListSetItemText( window.crimesTable, row, window.dateCol, getShortTime( crimes[ i ][ 5 ] ), false, false )
			guiGridListSetItemText( window.crimesTable, row, window.crimeCol, crimes[ i ][ 2 ], false, false )
			guiGridListSetItemText( window.crimesTable, row, window.punishCol, crimes[ i ][ 3 ], false, false )
			guiGridListSetItemData( window.crimesTable, row, window.dateCol, crimes[ i ][ 5 ] )
			guiGridListSetItemData( window.crimesTable, row, window.crimeCol, crimes[ i ][ 1 ] )
			guiGridListSetItemData( window.crimesTable, row, window.punishCol, crimes[ i ][ 4 ] )
		end

		addEventHandler( "onClientGUIDoubleClick", window.crimesTable,
			function ( )
				local selectedRow, selectedCol = guiGridListGetSelectedItem( window.crimesTable )
				if selectedRow > -1 then
					local crime_id = guiGridListGetItemData( window.crimesTable, selectedRow, window.crimeCol )
					local occured = guiGridListGetItemData( window.crimesTable, selectedRow, window.dateCol )
					local crime = guiGridListGetItemText( window.crimesTable, selectedRow, window.crimeCol )
					local punishment = guiGridListGetItemText( window.crimesTable, selectedRow, window.punishCol )
					local officer = guiGridListGetItemData( window.crimesTable, selectedRow, window.punishCol )
					view_crime( charid, charactername, crime_id, occured, crime, punishment, officer )

					guiSetVisible( window.window, false )
					destroyElement( window.window )
					window = { }
				end
			end
		, false )
	else
		local row = guiGridListAddRow ( window.crimesTable )
		guiGridListSetItemText ( window.crimesTable, row, window.dateCol, "Sem Crimes", false, false )
	end

	--Licenses
	if canAccess( localPlayer, 'canSeeLicenses' ) then
		window.licenseTab	= guiCreateTab( "Licenças", window.mainPanel )
		window.licenseTable	= guiCreateGridList ( 10, 10, 460, 230, false, window.licenseTab )
		window.licenseCol	= guiGridListAddColumn( window.licenseTable, "Licenças", 0.95 )
		if #licenses > 0 then
			table.sort(licenses)
			for k, v in ipairs(licenses) do
				local row = guiGridListAddRow( window.licenseTable )
				guiGridListSetItemText ( window.licenseTable, row, window.licenseCol, v, false, false )
			end
		else
			local row = guiGridListAddRow ( window.licenseTable )
			guiGridListSetItemText ( window.licenseTable, row, window.licenseCol, "Sem Licenças", false, false )
		end
	end

	--PILOT STUFF
	if canAccess( localPlayer, 'canSeePilotStuff' ) then
		window.pilotEventsTab	= guiCreateTab( "Eventos de Piloto", window.mainPanel )
		window.pilotEventsTable	= guiCreateGridList ( 10, 10, 460, 230, false, window.pilotEventsTab )
		window.pilotEventsDateCol = guiGridListAddColumn( window.pilotEventsTable, "Data", 0.3 )
		window.pilotEventsCrimeCol = guiGridListAddColumn( window.pilotEventsTable, "Evento", 0.35 )
		window.pilotEventsPunishCol = guiGridListAddColumn( window.pilotEventsTable, "Ações Tomadas", 0.3 )

		window.pilotDetailsTab	= guiCreateTab( "Notas de Piloto", window.mainPanel )
		addEventHandler( "onClientGUIClick", window.pilotDetailsTab,
			function()
				guiSetInputEnabled ( true )
			end
		, false )
		window.pilotDetailsMemo	= guiCreateMemo( 10, 10, 460, 190, pilotDetails or "", false, window.pilotDetailsTab )
		if canAccess(localPlayer, "canSeePilotStuff") then
			addEventHandler( "onClientGUIClick", window.pilotDetailsMemo,
				function()
					guiSetInputEnabled ( true )
				end
			, false )
			window.pilotDetailsButton = guiCreateButton( 10, 210, 460, 30, "Atualizar", false, window.pilotDetailsTab )
			addEventHandler( "onClientGUIClick", window.pilotDetailsButton,
				function ( )
					local pilotDetails = guiGetText( window.pilotDetailsMemo )
					guiSetVisible( window.window, false )
					destroyElement( window.window )
					window = { }
					triggerServerEvent( resourceName..":update_pilot_details", localPlayer, charid, charactername, pilotDetails )
					guiSetInputEnabled ( false )
				end
			, false )
			guiMemoSetReadOnly( window.pilotDetailsMemo, false )
		else
			guiMemoSetReadOnly( window.pilotDetailsMemo, true )
		end

		if ( #pilotEvents > 0 ) then
			for i = 1, #pilotEvents, 1 do
				local row = guiGridListAddRow ( window.pilotEventsTable )
				guiGridListSetItemText( window.pilotEventsTable, row, window.pilotEventsDateCol, getShortTime( pilotEvents[ i ][ 5 ] ), false, false )
				guiGridListSetItemText( window.pilotEventsTable, row, window.pilotEventsCrimeCol, pilotEvents[ i ][ 2 ], false, false )
				guiGridListSetItemText( window.pilotEventsTable, row, window.pilotEventsPunishCol, pilotEvents[ i ][ 3 ], false, false )
				guiGridListSetItemData( window.pilotEventsTable, row, window.pilotEventsDateCol, pilotEvents[ i ][ 5 ] )
				guiGridListSetItemData( window.pilotEventsTable, row, window.pilotEventsCrimeCol, pilotEvents[ i ][ 1 ] )
				guiGridListSetItemData( window.pilotEventsTable, row, window.pilotEventsPunishCol, pilotEvents[ i ][ 4 ] )
			end

			addEventHandler( "onClientGUIDoubleClick", window.pilotEventsTable,
				function ( )
					local selectedRow, selectedCol = guiGridListGetSelectedItem( window.pilotEventsTable )
					if selectedRow > -1 then
						local crime_id = guiGridListGetItemData( window.pilotEventsTable, selectedRow, window.pilotEventsCrimeCol )
						local occured = guiGridListGetItemData( window.pilotEventsTable, selectedRow, window.pilotEventsDateCol )
						local crime = guiGridListGetItemText( window.pilotEventsTable, selectedRow, window.pilotEventsCrimeCol )
						local punishment = guiGridListGetItemText( window.pilotEventsTable, selectedRow, window.pilotEventsPunishCol )
						local officer = guiGridListGetItemData( window.pilotEventsTable, selectedRow, window.pilotEventsPunishCol )
						view_pilot_event( charid, charactername, crime_id, occured, crime, punishment, officer )

						guiSetVisible( window.window, false )
						destroyElement( window.window )
						window = { }
					end
				end
			, false )
		else
			local row = guiGridListAddRow ( window.pilotEventsTable )
			guiGridListSetItemText ( window.pilotEventsTable, row, window.pilotEventsDateCol, "Sem Eventos", false, false )
		end

		window.pilotLicensesTab	= guiCreateTab( "Licenças de Piloto", window.mainPanel )
		window.pilotLicensesTable = guiCreateGridList ( 10, 10, 460, 230, false, window.pilotLicensesTab )
		window.pilotLicensesLicenseCol = guiGridListAddColumn( window.pilotLicensesTable, "Licença", 0.35 )
		window.pilotLicensesIssuedCol = guiGridListAddColumn( window.pilotLicensesTable, "Emitida", 0.3 )
		window.pilotLicensesOfficerCol = guiGridListAddColumn( window.pilotLicensesTable, "Emitida Por", 0.29 )

		local myAdminLevel = getAdminLevel( localPlayer ) or 1
		if canAccess( localPlayer, "canSeePilotStuff" ) then
			if myAdminLevel == 2 or myAdminLevel == 3 then --only admin and moderator can revoke and issue licenses
				guiSetSize(window.pilotLicensesTable, 460, 190, false)
				window.pilotLicenseRevokeButton = guiCreateButton( 10, 210, 230, 30, "Revogar Selecionado", false, window.pilotLicensesTab )
				addEventHandler( "onClientGUIClick", window.pilotLicenseRevokeButton,
					function ( )
						local selectedRow, selectedCol = guiGridListGetSelectedItem( window.pilotLicensesTable )
						local license_uid = guiGridListGetItemData( window.pilotLicensesTable, selectedRow, window.pilotLicensesLicenseCol )
						if tonumber( license_uid ) then
							local meAdmin = getAdminLevel( localPlayer ) or 1 --tonumber( getElementData( localPlayer, "mdc_admin" ) )
							if meAdmin == 2 or meAdmin == 3 then
								local licensetext = guiGridListGetItemText( window.pilotLicensesTable, selectedRow, window.pilotLicensesLicenseCol )
								triggerServerEvent( resourceName .. ":remove_pilot_license", localPlayer, charid, charactername, license_uid, licensetext )
							else
								remove_pilot_event_noperm( charactername )
							end
						else
							remove_pilot_event_noid( charactername )
						end
						guiSetVisible( window.window, false )
						destroyElement( window.window )
						window = { }
						guiSetInputEnabled ( false )
					end
				, false )
				window.pilotLicenseIssueButton = guiCreateButton( 240, 210, 230, 30, "Emitir Licença", false, window.pilotLicensesTab )
				addEventHandler( "onClientGUIClick", window.pilotLicenseIssueButton,
					function ( )
						guiSetVisible( window.window, false )
						destroyElement( window.window )
						window = { }
						add_pilot_license( charid, charactername )
					end
				, false )
			end
		end

		pilotHasLicenses = {}
		if ( #pilotLicenses > 0 ) then
			for i = 1, #pilotLicenses, 1 do
				local row = guiGridListAddRow ( window.pilotLicensesTable )
				local licenseText
				local pilotLicense = tonumber(pilotLicenses[i][2]) -- - 1
				if(pilotLicense == 1) then
					licenseText = "ARC"
				elseif(pilotLicense == 2) then
					licenseText = "Permissão para Dirigir no Aeroporto"
				elseif(pilotLicense == 3) then
					licenseText = "ROT"
				elseif(pilotLicense == 4) then
					licenseText = "SER"
				elseif(pilotLicense == 5) then
					licenseText = "MER"
				elseif(pilotLicense == 6) then
					licenseText = "TER"
				elseif(pilotLicense == 7) then
					licenseText = "Digitando: "..tostring(getVehicleNameFromModel(pilotLicenses[i][3]))
				elseif(pilotLicense == 8) then
					licenseText = "CFI"
				elseif(pilotLicense == 9) then
					licenseText = "CPL"
				end
				if licenseText then
					--licenseText = licenseText.." ("..tostring(pilotLicense)..")"
					table.insert(pilotHasLicenses, {pilotLicense, pilotLicenses[i][3]})
					guiGridListSetItemText( window.pilotLicensesTable, row, window.pilotLicensesLicenseCol, licenseText, false, false )
					guiGridListSetItemText( window.pilotLicensesTable, row, window.pilotLicensesIssuedCol, getShortTime( pilotLicenses[ i ][ 5 ] ), false, false )
					guiGridListSetItemText( window.pilotLicensesTable, row, window.pilotLicensesOfficerCol, pilotLicenses[ i ][ 4 ] or "", false, false )
					guiGridListSetItemData( window.pilotLicensesTable, row, window.pilotLicensesLicenseCol, pilotLicenses[ i ][ 1 ] )
				end
			end
		else
			local row = guiGridListAddRow ( window.pilotLicensesTable )
			guiGridListSetItemText ( window.pilotLicensesTable, row, window.pilotLicensesLicenseCol, "Sem Licenças", false, false )
		end
	end

	--Warrant
	window.warrantTable	= guiCreateGridList ( 10, 470, 480, 70, false, window.window )
	window.warrantCol	= guiGridListAddColumn( window.warrantTable, ( tonumber( wanted ) == 1 and ( "Mandado Emitido Por " .. wanted_by ) or "Sem Mandados Ativos." ), 0.9 )
	local row = guiGridListAddRow ( window.warrantTable )
	guiGridListSetItemText( window.warrantTable, row, window.warrantCol, ( tonumber( wanted ) == 1 and (  string.sub( wanted_details, 0, 75 ) ) or "" ), false, false )
	if not wanted_details then wanted_details = "" end

	if string.len( wanted_details ) >= 75 then
		local count = 1
		while true do
			local row = guiGridListAddRow ( window.warrantTable )
			guiGridListSetItemText( window.warrantTable, row, window.warrantCol, string.sub( wanted_details, 75 * count + 1, count * 75 + 75 ), false, false )
			count = count + 1
			if string.len( wanted_details ) < count * 75 then
				break
			end
		end
	end
	--Photo
	window.photo		= guiCreateStaticImage ( width - 168, 400, 128, 128, ":account/img/" .. ("%03d"):format(photo) .. ".png", false, window.window )

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

function update_person( charactername, charid, dob, ethnicity, phone, occupation, address, photo, details )
	guiSetInputEnabled ( true )
	local window = { }
	local width = 400
	local height = 370
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow( x, y, width, height, "MDC Atualizar Detalhes", false )
	local y = 37
	window.dobLabel		= guiCreateLabel( 10, y, 70, 20, "Data de Nascimento: ", false, window.window )
	y = y + 40
	window.ethnicLabel	= guiCreateLabel( 10, y, 100, 20, "Etnia: ", false, window.window )
	y = y + 40
	window.phoneLabel	= guiCreateLabel( 10, y, 100, 20, "Celular: ", false, window.window )
	y = y + 40
	window.occupLabel	= guiCreateLabel( 10, y, 100, 20, "Ocupação: ", false, window.window )
	y = y + 40
	window.addressLabel	= guiCreateLabel( 10, y, 100, 20, "Endereço: ", false, window.window )
	y = y + 40
	window.photoLabel	= guiCreateLabel( 10, y, 100, 20, "Foto: ", false, window.window )

	y = 30
	window.dobEdit		= guiCreateEdit( 80, y, width - 90, 30, dob, false, window.window )
	y = y + 40
	window.ethnicEdit	= guiCreateEdit( 80, y, width - 90, 30, ethnicity, false, window.window )
	y = y + 40
	window.phoneEdit	= guiCreateEdit( 80, y, width - 90, 30, phone, false, window.window )
	y = y + 40
	window.occupEdit	= guiCreateEdit( 80, y, width - 90, 30, occupation, false, window.window )
	y = y + 40
	window.addressEdit	= guiCreateEdit( 80, y, width - 90, 30, address, false, window.window )
	y = y + 40
	window.photosCheck	= guiCreateCheckBox( 80, y, width - 90, 30, "Atualizar Foto", false, false, window.window )


	window.updateButton = guiCreateButton( 10, height - 100, width - 20, 40, "Atualizar!", false, window.window )
	addEventHandler( "onClientGUIClick", window.updateButton,
		function ()
			dob = guiGetText( window.dobEdit )
			ethnicity = guiGetText( window.ethnicEdit )
			phone = guiGetText( window.phoneEdit )
			occupation = guiGetText( window.occupEdit )
			address = guiGetText( window.addressEdit )
			if guiCheckBoxGetSelected ( window.photosCheck ) then
				photo = -2
			end
			guiSetInputEnabled ( false )
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( resourceName .. ":update_person", localPlayer, charid, charactername, dob, ethnicity, phone, occupation, address, photo )
		end
	, false )

	window.closeButton = guiCreateButton( 10, height - 50, width - 20, 40, "Fechar", false, window.window )
	addEventHandler( "onClientGUIClick", window.closeButton,
		function ()
			guiSetInputEnabled ( false )
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( resourceName .. ":search", localPlayer, charactername, 0 )
		end
	, false )
end

function update_warrant( charactername, charid, wanted, wanted_details )
	guiSetInputEnabled ( true )
	local window = { }
	local width = 400
	local height = 240
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow( x, y, width, height, "MDC Atualizar Detalhes", false )
	local y = 37 + 40
	window.wantedLabel		= guiCreateLabel( 10, y, 70, 50, "Mandado \nDetalhes: ", false, window.window )


	y = 30
	window.wantedCheck	= guiCreateCheckBox( 80, y, width - 90, 30, "Mandado Ativo", false, false, window.window )
	if tonumber( wanted ) == 1 then
		guiCheckBoxSetSelected ( window.wantedCheck, true )
	end
	addEventHandler( "onClientGUIClick", window.wantedCheck,
		function()
			local new_wanted = guiCheckBoxGetSelected( window.wantedCheck )
			guiSetText( window.wantedCheck, ( new_wanted and "Mandado Ativo" or "Mandado Não Ativo" ) )
		end
	, false )

	y = y + 40
	window.wantedMemo	= guiCreateMemo( 80, y, width - 90, 60, wanted_details, false, window.window )

	window.updateButton = guiCreateButton( 10, height - 100, width - 20, 40, "Atualizar Mandado", false, window.window )
	addEventHandler( "onClientGUIClick", window.updateButton,
		function ()
			local new_wanted = guiCheckBoxGetSelected ( window.wantedCheck ) and 1 or 0
			local details = guiGetText( window.wantedMemo )

			guiSetInputEnabled ( false )
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( resourceName .. ":update_warrant", localPlayer, charid, charactername, new_wanted, details )
		end
	, false )

	window.closeButton = guiCreateButton( 10, height - 50, width - 20, 40, "Fechar", false, window.window )
	addEventHandler( "onClientGUIClick", window.closeButton,
		function ()
			guiSetInputEnabled ( false )
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( resourceName .. ":search", localPlayer, charactername, 0 )
		end
	, false )
end

function add_crime( charid, charactername )
	guiSetInputEnabled ( true )
	local window = { }
	local width = 400
	local height = 300
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow( x, y, width, height, "MDC Adicionar Crime: "..charactername:gsub( "_", " " ), false )

	local y = 30
	window.timeLabel 	= guiCreateLabel( 10, y, 70, 20, "Data: ", false, window.window )
	y = y + 30
	window.crimeLabel 	= guiCreateLabel( 10, y, 70, 20, "Crime: ", false, window.window )
	y = y + 70
	window.punishLabel 	= guiCreateLabel( 10, y, 70, 20, "Punição: ", false, window.window )

	y = 30
	window.time2Label 	= guiCreateLabel( 80, y, width - 90, 20, getTime( true, true, false ), false, window.window )
	y = y + 30
	window.crimeMemo	= guiCreateMemo( 80, y, width - 90, 60, "Alguns detalhes do que aconteceu.", false, window.window )
	y = y + 70
	window.punishMemo	= guiCreateMemo( 80, y, width - 90, 60, "Qual punição foi dada.", false, window.window )

	window.addButton = guiCreateButton( 10, height - 100, width - 20, 40, "Adicionar Crime", false, window.window )
	addEventHandler( "onClientGUIClick", window.addButton,
		function ()
			local crime = guiGetText( window.crimeMemo )
			local punishment = guiGetText( window.punishMemo )
			guiSetInputEnabled ( false )
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( resourceName .. ":add_crime", localPlayer, charid, charactername, crime, punishment )
		end
	, false )

	window.closeButton = guiCreateButton( 10, height - 50, width - 20, 40, "Fechar", false, window.window )
	addEventHandler( "onClientGUIClick", window.closeButton,
		function ()
			guiSetInputEnabled ( false )
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( resourceName .. ":search", localPlayer, charactername, 0 )
		end
	, false )
end

function view_crime( charid, charactername, id, occured, crime, punishment, officer )
	local window = { }
	local width = 400
	local height = 300
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2

	window.window = guiCreateWindow( x, y, width, height, "MDC Ver Crime", false )

	local y = 30
	window.timeLabel 	= guiCreateLabel( 10, y, 70, 20, "Data: ", false, window.window )
	y = y + 30
	window.idLabel 	= guiCreateLabel( 10, y, 70, 20, "Crime ID: ", false, window.window )
	y = y + 30
	window.crimeLabel 	= guiCreateLabel( 10, y, 70, 20, "Crime: ", false, window.window )
	y = y + 70
	window.punishLabel 	= guiCreateLabel( 10, y, 70, 20, "Punição: ", false, window.window )
	y = y + 70
	window.officerLabel 	= guiCreateLabel( 10, y, 70, 20, "Oficial: ", false, window.window )
	window.officerLabel 	= guiCreateLabel( 80, y, width - 90, 20, officer or "Error", false, window.window )

	y = 30
	window.time2Label 	= guiCreateLabel( 80, y, width - 90, 20, getTime( true, true, occured ) or "Error", false, window.window )
	y = y + 30
	window.id2Label 	= guiCreateLabel( 80, y, width - 90, 20, DEC_HEX( tonumber( id ) ) or "Error", false, window.window )
	y = y + 30
	window.crimeMemo	= guiCreateMemo( 80, y, width - 90, 60, crime or "Error", false, window.window )
	guiMemoSetReadOnly ( window.crimeMemo, true )
	y = y + 70
	window.punishMemo	= guiCreateMemo( 80, y, width - 90, 60, punishment or "Error", false, window.window )
	guiMemoSetReadOnly ( window.punishMemo, true )

	window.closeButton = guiCreateButton( 10, height - 50, width - 20, 40, "Fechar", false, window.window )
	addEventHandler( "onClientGUIClick", window.closeButton,
		function ()
			guiSetInputEnabled ( false )
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( resourceName .. ":search", localPlayer, charactername, 0 )
		end
	, false )
end

function remove_crime_noid ( charactername )
	local window = { }
	local width = 250
	local height = 110
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow( x, y, width, height, "MDC Remover Crime", false )

	window.errorLabel = guiCreateLabel( 10, 30, width - 20, 20, "Você precisa selecionar um crime para deletar!", false, window.window )


	window.closeButton = guiCreateButton( 10, 60, width - 20, 40, "Fechar", false, window.window )
	addEventHandler( "onClientGUIClick", window.closeButton,
		function ()
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( resourceName .. ":search", localPlayer, charactername, 0 )
		end
	, false )
end

function remove_crime_noperm ( charactername )
	local window = { }
	local width = 250
	local height = 110
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow( x, y, width, height, "MDC Remover Crime", false )

	window.errorLabel = guiCreateLabel( 10, 30, width - 20, 20, "Você não tem permissão para isso!", false, window.window )


	window.closeButton = guiCreateButton( 10, 60, width - 20, 40, "Fechar", false, window.window )
	addEventHandler( "onClientGUIClick", window.closeButton,
		function ()
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( resourceName .. ":search", localPlayer, charactername, 0 )
		end
	, false )
end

function add_pilot_event( charid, charactername )
	guiSetInputEnabled ( true )
	local window = { }
	local width = 400
	local height = 300
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow( x, y, width, height, "MDC Adicionar Evento de Piloto: "..charactername:gsub( "_", " " ), false )

	local y = 30
	window.timeLabel 	= guiCreateLabel( 10, y, 70, 20, "Data: ", false, window.window )
	y = y + 30
	window.crimeLabel 	= guiCreateLabel( 10, y, 70, 20, "Evento: ", false, window.window )
	y = y + 70
	window.punishLabel 	= guiCreateLabel( 10, y, 70, 20, "Ações Tomadas: ", false, window.window )

	y = 30
	window.time2Label 	= guiCreateLabel( 80, y, width - 90, 20, getTime( true, true, false ), false, window.window )
	y = y + 30
	window.crimeMemo	= guiCreateMemo( 80, y, width - 90, 60, "Alguns detalhes do que aconteceu.", false, window.window )
	y = y + 70
	window.punishMemo	= guiCreateMemo( 80, y, width - 90, 60, "Qual punição foi dada.", false, window.window )

	window.addButton = guiCreateButton( 10, height - 100, width - 20, 40, "Adicionar Evento", false, window.window )
	addEventHandler( "onClientGUIClick", window.addButton,
		function ()
			local crime = guiGetText( window.crimeMemo )
			local punishment = guiGetText( window.punishMemo )
			guiSetInputEnabled ( false )
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( resourceName .. ":add_pilot_event", localPlayer, charid, charactername, crime, punishment )
		end
	, false )

	window.closeButton = guiCreateButton( 10, height - 50, width - 20, 40, "Fechar", false, window.window )
	addEventHandler( "onClientGUIClick", window.closeButton,
		function ()
			guiSetInputEnabled ( false )
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( resourceName .. ":search", localPlayer, charactername, 0 )
		end
	, false )
end

function view_pilot_event( charid, charactername, id, occured, crime, punishment, officer )
	local window = { }
	local width = 400
	local height = 300
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow( x, y, width, height, "MDC Ver Evento de Piloto", false )

	local y = 30
	window.timeLabel 	= guiCreateLabel( 10, y, 70, 20, "Data: ", false, window.window )
	y = y + 30
	window.idLabel 	= guiCreateLabel( 10, y, 70, 20, "Evento ID: ", false, window.window )
	y = y + 30
	window.crimeLabel 	= guiCreateLabel( 10, y, 70, 20, "Evento: ", false, window.window )
	y = y + 70
	window.punishLabel 	= guiCreateLabel( 10, y, 70, 20, "Ações Tomadas: ", false, window.window )
	y = y + 70
	window.officerLabel 	= guiCreateLabel( 10, y, 70, 20, "Oficial: ", false, window.window )
	window.officerLabel 	= guiCreateLabel( 80, y, width - 90, 20, officer, false, window.window )

	y = 30
	window.time2Label 	= guiCreateLabel( 80, y, width - 90, 20, getTime( true, true, occured ), false, window.window )
	y = y + 30
	window.id2Label 	= guiCreateLabel( 80, y, width - 90, 20, DEC_HEX( tonumber( id ) ), false, window.window )
	y = y + 30
	window.crimeMemo	= guiCreateMemo( 80, y, width - 90, 60, crime, false, window.window )
	guiMemoSetReadOnly ( window.crimeMemo, true )
	y = y + 70
	window.punishMemo	= guiCreateMemo( 80, y, width - 90, 60, punishment, false, window.window )
	guiMemoSetReadOnly ( window.punishMemo, true )

	window.closeButton = guiCreateButton( 10, height - 50, width - 20, 40, "Fechar", false, window.window )
	addEventHandler( "onClientGUIClick", window.closeButton,
		function ()
			guiSetInputEnabled ( false )
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( resourceName .. ":search", localPlayer, charactername, 0 )
		end
	, false )
end

function remove_pilot_event_noid ( charactername )
	local window = { }
	local width = 250
	local height = 110
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow( x, y, width, height, "MDC Remover Evento de Piloto", false )

	window.errorLabel = guiCreateLabel( 10, 30, width - 20, 20, "You need to select a event to delete!", false, window.window )


	window.closeButton = guiCreateButton( 10, 60, width - 20, 40, "Fechar", false, window.window )
	addEventHandler( "onClientGUIClick", window.closeButton,
		function ()
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( resourceName .. ":search", localPlayer, charactername, 0 )
		end
	, false )
end

function remove_pilot_event_noperm ( charactername )
	local window = { }
	local width = 250
	local height = 110
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow( x, y, width, height, "MDC Remover Evento de Piloto", false )

	window.errorLabel = guiCreateLabel( 10, 30, width - 20, 20, "Você não tem permissão para isso!", false, window.window )


	window.closeButton = guiCreateButton( 10, 60, width - 20, 40, "Fechar", false, window.window )
	addEventHandler( "onClientGUIClick", window.closeButton,
		function ()
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( resourceName .. ":search", localPlayer, charactername, 0 )
		end
	, false )
end

function add_pilot_license( charid, charactername )
	guiSetInputEnabled ( true )
	local window = { }
	local width = 400
	local height = 300
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow( x, y, width, height, "MDC Emissão de Licença de Piloto: "..charactername:gsub( "_", " " ), false )

	local y = 30
	window.timeLabel 	= guiCreateLabel( 10, y, 70, 20, "Data: ", false, window.window )
	y = y + 30
	window.crimeLabel 	= guiCreateLabel( 10, y, 70, 20, "Licença: ", false, window.window )
	y = y + 70
	window.punishLabel 	= guiCreateLabel( 10, y, 70, 20, "Aeronave: ", false, window.window )

	y = 30
	window.time2Label 	= guiCreateLabel( 80, y, width - 90, 20, getTime( true, true, false ), false, window.window )
	y = y + 30
	window.LicenseCombo = guiCreateComboBox ( 80, y, width - 90, 180, "-Selecione Licença-", false, window.window )
		guiComboBoxAddItem( window.LicenseCombo, "ARC" )
		guiComboBoxAddItem( window.LicenseCombo, "Permissão para Dirigir no Aeroporto" )
		guiComboBoxAddItem( window.LicenseCombo, "ROT" )
		guiComboBoxAddItem( window.LicenseCombo, "SER" )
		guiComboBoxAddItem( window.LicenseCombo, "MER" )
		guiComboBoxAddItem( window.LicenseCombo, "TER" )
		guiComboBoxAddItem( window.LicenseCombo, "Digitando" )
		guiComboBoxAddItem( window.LicenseCombo, "CFI" )
		guiComboBoxAddItem( window.LicenseCombo, "CPL" )

	y = y + 70
	window.AircraftCombo = guiCreateComboBox ( 80, y, width - 90, 180, "-Selecione o tipo de aeronave-", false, window.window )
		guiComboBoxAddItem( window.AircraftCombo, "Andromada" )
		guiComboBoxAddItem( window.AircraftCombo, "AT-400" )
		guiComboBoxAddItem( window.AircraftCombo, "Beagle" )
		guiComboBoxAddItem( window.AircraftCombo, "Cargobob" )
		guiComboBoxAddItem( window.AircraftCombo, "Cropduster" )
		guiComboBoxAddItem( window.AircraftCombo, "Dodo" )
		guiComboBoxAddItem( window.AircraftCombo, "Hunter" )
		guiComboBoxAddItem( window.AircraftCombo, "Hydra" )
		guiComboBoxAddItem( window.AircraftCombo, "Leviathan" )
		guiComboBoxAddItem( window.AircraftCombo, "Maverick" )
		guiComboBoxAddItem( window.AircraftCombo, "Nevada" )
		guiComboBoxAddItem( window.AircraftCombo, "News Chopper" )
		guiComboBoxAddItem( window.AircraftCombo, "Police Maverick" )
		guiComboBoxAddItem( window.AircraftCombo, "Raindance" )
		guiComboBoxAddItem( window.AircraftCombo, "Rustler" )
		guiComboBoxAddItem( window.AircraftCombo, "Seasparrow" )
		guiComboBoxAddItem( window.AircraftCombo, "Shamal" )
		guiComboBoxAddItem( window.AircraftCombo, "Skimmer" )
		guiComboBoxAddItem( window.AircraftCombo, "Sparrow" )
		guiComboBoxAddItem( window.AircraftCombo, "Stuntplane" )

		guiSetVisible(window.punishLabel, false)
		guiSetVisible(window.AircraftCombo, false)
		guiSetEnabled(window.AircraftCombo, false)

	addEventHandler( "onClientGUIComboBoxAccepted", window.LicenseCombo,
		function ()
			local license = tonumber(guiComboBoxGetSelected(window.LicenseCombo)) or -1
			if(license == 6) then
				guiSetVisible(window.punishLabel, true)
				guiSetVisible(window.AircraftCombo, true)
				guiSetEnabled(window.AircraftCombo, true)
			else
				guiComboBoxSetSelected(window.AircraftCombo, -1)
				guiSetVisible(window.AircraftCombo, false)
				guiSetEnabled(window.AircraftCombo, false)
				guiSetVisible(window.punishLabel, false)
			end
		end
	, false )

	window.addLicenseButton = guiCreateButton( 10, height - 100, width - 20, 40, "Emitir Licença", false, window.window )
	addEventHandler( "onClientGUIClick", window.addLicenseButton,
		function ()
			pilotLicenseNames = {
				[1] = "ARC",
				[2] = "Permissão para dirigir no aeroporto",
				[3] = "ROT",
				[4] = "SER",
				[5] = "MER",
				[6] = "TER",
				[7] = "Digitando",
				[8] = "CFI",
				[9] = "CPL",
			}

			local license = (tonumber(guiComboBoxGetSelected(window.LicenseCombo)) or -1) + 1
			if(license <= 0) then
				mdc_errorWin("Selecione uma licença para emitir!")
				return
			end
			local aircraftName = guiComboBoxGetItemText(window.AircraftCombo, guiComboBoxGetSelected(window.AircraftCombo))
			aircraft = getVehicleModelFromName(aircraftName)
			if not aircraft then
				if(license == 7) then
					mdc_errorWin("Avaliação de tipo inválida!")
					return
				else
					aircraft = "NULL"
				end
			end
			for k,v in ipairs(pilotHasLicenses) do
				if(v[1] == license) then
					if(license == 7) then
						if(tonumber(v[2]) == tonumber(aircraft)) then
							--error msg
							mdc_errorWin("Esta pessoa já foi avaliada para "..tostring(aircraftName).."!")
							return
						end
					else
						--error msg
						mdc_errorWin("Esta pessoa já tem uma licença "..tostring(pilotLicenseNames[license]).."!")
						return
					end
				end
			end

			--check prerequisities
			if(license == 3 or license == 4) then --ROT or SER
				if not hasPilotLicense(1) then
					mdc_errorWin("O ARC deve ser aprovado antes de obter uma licença de piloto!")
					return
				end
			elseif(license == 5) then --MER
				if not hasPilotLicense(4) then
					mdc_errorWin("Licença SER necessária antes de obter uma MER!")
					return
				end
			elseif(license == 6) then --TER
				if not hasPilotLicense(5) then
					mdc_errorWin("Licença MER necessária antes de obter um TER!")
					return
				end
			elseif(license == 7) then --Typerating
				local pilotAircraftLicenseRequired = {
					[592] = 6, --Andromada, TER
					[577] = 6, --AT-400, TER
					[511] = 5, --Beagle, MER
					[548] = 3, --Cargobob, ROT
					[512] = 4, --Cropduster, SER
					[593] = 4, --Dodo, SER
					[425] = 3, --Hunter, ROT
					[520] = 6, --Hydra, TER
					[417] = 3, --Leviathan, ROT
					[487] = 3, --Maverick, ROT
					[553] = 5, --Nevada, MER
					[488] = 3, --News Chopper, ROT
					[497] = 3, --Police Maverick, ROT
					[563] = 3, --Raindance, ROT
					[476] = 4, --Rustler, SER
					[447] = 3, --Seasparrow, ROT
					[519] = 6, --Shamal, TER
					[460] = 4, --Skimmer, SER
					[469] = 3, --Sparrow, ROT
					[513] = 4, --Stuntplane, SER
				}
				if not hasPilotLicense(pilotAircraftLicenseRequired[aircraft]) then
					mdc_errorWin(tostring(pilotLicenseNames[pilotAircraftLicenseRequired[aircraft]]).." licença necessária para "..tostring(aircraftName).."!")
					return
				end
			end

			guiSetInputEnabled ( false )
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( resourceName .. ":add_pilot_license", localPlayer, charid, charactername, license, aircraft )
		end
	, false )

	window.closeButton = guiCreateButton( 10, height - 50, width - 20, 40, "Fechar", false, window.window )
	addEventHandler( "onClientGUIClick", window.closeButton,
		function ()
			guiSetInputEnabled ( false )
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			triggerServerEvent( resourceName .. ":search", localPlayer, charactername, 0 )
		end
	, false )
end

function hasPilotLicense(license, aircraft)
	for k,v in ipairs(pilotHasLicenses) do
		if(v[1] == license) then
			if(license == 7) then
				if(v[2] == aircraft) then
					return true
				end
			else
				return true
			end
		end
	end
	return false
end

------------------------------------------
addEvent( resourceName .. ":display_person", true )
addEventHandler( resourceName .. ":display_person", root, display_person )
