wItems, gWallet, gItems, gKeys, colSlot, colName, colValue, colID, items, lDescription, bDropItem, bUseItem, bTakeItem, bDeleteItem, bShowItem, bDestroyItem, tabPanel, tabWallet, tabItems, tabWeapons = nil
gWeapons, colWSlot, colWName, colWValue = nil

wRightClick = nil
bPickup, bToggle, bPreviousTrack, bNextTrack, bCloseMenu = nil
ax, ay = nil
item = nil
showinvPlayer = nil
setElementData( localPlayer, "exclusiveGUI", false, false ) -- setting this to false prevents possible problems with fridge/shelf inv.

showFood = true
showKeys = true
showDrugs = true
showOther = true
showBooks = true
showClothes = true
showElectronics = true
showEmpty = true
activeTab = 1
isPlayerGPSShowing = false 

-- PLEASE WAIT window
local sx, sy = guiGetScreenSize( )
wWait = guiCreateButton( ( sx - 200 ) / 2, ( sy - 60 ) / 2, 200, 60, "Please wait a moment...", false )
guiSetEnabled( wWait, false )
guiSetVisible( wWait, false )
guiSetProperty( wWait, "AlwaysOnTop", "True" )

--[[function clickItem(button, state, absX, absY, x, y, z, element)
	if (button == "right") and (state=="down") then
		if getElementData(localPlayer, "exclusiveGUI") then
			return
		end

		local px, py, pz = getElementPosition(localPlayer)
		if element and (getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("map-system")) or getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("interior_system"))) then
			element = nil
		end

		if not element then
			local wx, wy, wz = x, y, z
			local x, y, z = nil
			for key, value in ipairs(getElementsByType("object",getResourceRootElement())) do
				if isElementStreamedIn(value) then
					x, y, z = getElementPosition(value)
					local minx, miny, minz, maxx, maxy, maxz = getElementBoundingBox(value)

					local offset = 0.34

					minx = x + minx - offset
					miny = y + miny - offset
					minz = z + minz - offset

					maxx = x + maxx + offset
					maxy = y + maxy + offset
					maxz = z + maxz + offset

					local dist = getDistanceBetweenPoints3D(x, y, z, px, py, pz)

					if (wx >= minx and wx <=maxx) and (wy >= miny and wy <=maxy) and (wz >= minz and wz <=maxz) then
						element = value
						break
					end
				end
			end
		end

		if element and getElementParent(getElementParent(element)) == getResourceRootElement() then
			if getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 3 then
				if (wRightClick) then
					hideItemMenu()
				end
				ax = absX
				ay = absY
				item = element
				showItemMenu()
			else
				outputChatBox("You are too far away from that item.", 255, 0, 0)
			end
		else
			if (wRightClick) then
				hideItemMenu()
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickItem, true)]]

local delayedGBUpdate = nil

function showItemMenu(element, absX, absY)
	if isElement(element) then item = element; ax = absX; ay = absY end
	if not wRightClick then
	local itemID = getElementData(item, "itemID")
	local itemValue = getElementData(item, "itemValue") or 1
	local itemName = getItemName( itemID, itemValue )

	if itemID ~= 80 or itemID ~= 214 then
		itemName = itemName .. " (" .. getItemValue( itemID, itemValue ) .. ")"
	end
	wRightClick = guiCreateWindow(ax, ay, 150, 200, itemName, false)

	local y = 0.13
	if itemID == 81 or itemID == 103 then
		bPickup = guiCreateButton(0.05, y, 0.9, 0.1, "Open", true, wRightClick)
		addEventHandler("onClientGUIClick", bPickup,
			function(button)
				if button=="left" and not getElementData(localPlayer, "exclusiveGUI") then
					triggerServerEvent( "openFreakinInventory", localPlayer, item, ax, ay )
					hideItemMenu()
				end
			end,
			false
		)
	else
		bPickup = guiCreateButton(0.05, y, 0.9, 0.1, "Pegar Item", true, wRightClick)
		addEventHandler("onClientGUIClick", bPickup, pickupItem, false)
	end
	y = y + 0.14

	if itemID == 54 then
		bPreviousTrack = guiCreateButton(0.05, y, 0.42, 0.15, "Estação Ant.", true, wRightClick)
		addEventHandler("onClientGUIClick", bPreviousTrack, function() triggerServerEvent("changeGhettoblasterTrack", localPlayer, item, -1) end, false)

		bNextTrack = guiCreateButton(0.53, y, 0.42, 0.15, "Próxima estação", true, wRightClick)
		addEventHandler("onClientGUIClick", bNextTrack, function() triggerServerEvent("changeGhettoblasterTrack", localPlayer, item, 1) end, false)

		y = y + 0.18

		-- volume
		local sVolume = guiCreateScrollBar(0.05, y, 0.9, 0.1, true, true, wRightClick)
		guiSetProperty(sVolume, 'StepSize', '0.1')

		local value = split(tostring(itemValue), ':')
		guiScrollBarSetScrollPosition(sVolume, tonumber(value[2]) or 100)
		addEventHandler('onClientGUIScroll', sVolume,
			function()
				if delayedGBUpdate then
					killTimer(delayedGBUpdate)
				end

				delayedGBUpdate = setTimer(
					function(val)
						triggerServerEvent("changeGhettoblasterVolume", item, val)
						delayedGBUpdate = nil
					end, 500, 1, guiScrollBarGetScrollPosition(source))
			end, false)
	end

	if itemID == 176 then
		bPreviousTrack = guiCreateButton(0.05, y, 0.42, 0.15, "Estação Ant.", true, wRightClick)
		addEventHandler("onClientGUIClick", bPreviousTrack, function() triggerServerEvent("changeGhettoblasterTrack", localPlayer, item, -1) end, false)

		bNextTrack = guiCreateButton(0.53, y, 0.42, 0.15, "Próxima estação", true, wRightClick)
		addEventHandler("onClientGUIClick", bNextTrack, function() triggerServerEvent("changeGhettoblasterTrack", localPlayer, item, 1) end, false)

		y = y + 0.18

		-- volume
		local sVolume = guiCreateScrollBar(0.05, y, 0.9, 0.1, true, true, wRightClick)
		guiSetProperty(sVolume, 'StepSize', '0.1')

		local value = split(tostring(itemValue), ':')
		guiScrollBarSetScrollPosition(sVolume, tonumber(value[2]) or 100)
		addEventHandler('onClientGUIScroll', sVolume,
			function()
				if delayedGBUpdate then
					killTimer(delayedGBUpdate)
				end

				delayedGBUpdate = setTimer(
					function(val)
						triggerServerEvent("changeGhettoblasterVolume", item, val)
						delayedGBUpdate = nil
					end, 500, 1, guiScrollBarGetScrollPosition(source))
			end, false)
	end

	y = y + 0.14

	bCloseMenu = guiCreateButton(0.05, y, 0.9, 0.1, "Fechar Menu", true, wRightClick)
	addEventHandler("onClientGUIClick", bCloseMenu, hideItemMenu, false)
	end
end
addEvent('item:showMenu', false)
addEventHandler("item:showMenu", localPlayer, showItemMenu)

function hideItemMenu()
	if (isElement(bPickup)) then
		destroyElement(bPickup)
	end
	bPickup = nil

	if (isElement(bToggle)) then
		destroyElement(bToggle)
	end
	bToggle = nil

	if (isElement(bPreviousTrack)) then
		destroyElement(bPreviousTrack)
	end
	bPreviousTrack = nil

	if (isElement(bNextTrack)) then
		destroyElement(bNextTrack)
	end
	bNextTrack = nil

	if (isElement(bCloseMenu)) then
		destroyElement(bCloseMenu)
	end
	bCloseMenu = nil

	if (isElement(wRightClick)) then
		destroyElement(wRightClick)
	end
	wRightClick = nil

	if delayedGBUpdate then
		killTimer(delayedGBUpdate)
		delayedGBUpdate = nil
	end

	ax = nil
	ay = nil

	item = nil

	showCursor(false)
	triggerEvent("cursorHide", localPlayer)
end

function updateMenu(dataname)
	if source == item and dataname == "itemValue" and (getElementData(source, "itemID") == 54 or getElementData(source, "itemID") == 176) then -- update the track while you're in menu
		guiSetText(wRightClick, "Ghettoblaster (" .. (getElementData(source, "itemValue") or 1) .. ")")
	end
end
addEventHandler("onClientElementDataChange", getRootElement(), updateMenu)

function toggleGhettoblaster(button, state, absX, absY, step)
	triggerServerEvent("toggleGhettoblaster", localPlayer, item)
	hideItemMenu()
end

fp = -100
addCommandHandler("itemprotect",
	function(command, f)
		fp = tonumber(f) or -100
		exports.hud:sendBottomNotification(localPlayer, "Item Protect", "Proteger conjunto para facção: " .. ( fp == -100 and "admins apenas" or tostring(fp)))
	end
)

local pickupTimer = nil --maxime
function pickupItem(button, state, item)
	if (button=="left") then
		local restrain = getElementData(localPlayer, "restrain")

		if (restrain) and (restrain==1) then
			exports.hud:sendBottomNotification(localPlayer, "Não conseguiu pegar o item", "Você esta algemado.", 255, 0, 0)
		elseif getElementData(item, "itemID") > 0 and not hasSpaceForItem(localPlayer, getElementData(item, "itemID"), getElementData(item, "itemValue")) then
			exports.hud:sendBottomNotification(localPlayer, "Não conseguiu pegar o item", "Seu inventario esta cheio. "..("%.2f/%.2f" ):format( getCarriedWeight( localPlayer ), getMaxWeight( localPlayer ) ).." kg(s)." , 255, 0, 0)
		elseif isElement(item) then
			if wRightClick then
				showCursor(false)
				triggerEvent("cursorHide", localPlayer)
			end

			--[[ moved to c_inventory
			if getKeyState("p") then
				-- don't pick it up otherwise
				if exports.global:isStaffOnDuty(localPlayer) then
					triggerServerEvent("protectItem", item, fp)
				end
			elseif getKeyState("n") then
				-- don't pick it up otherwise
				if exports.global:isStaffOnDuty(localPlayer) or (getElementDimension(localPlayer) ~= 0 and hasItem(localPlayer, 4, getElementDimension(localPlayer)) or hasItem(localPlayer, 5, getElementDimension(localPlayer))) then
					triggerEvent("item:move", root, item)
				end
			else
			--]]
				if getElementData(item, "transfering") then
					return --outputDebugString("[ITEM] pickupItem / Client / Cancelled by pick up cooldown.")
				end

				local itemID = getElementData(item, "itemID")
				if itemID ~= 223 and itemID ~= 103 then
					triggerServerEvent("pickupItem", localPlayer, item)
				else
					exports['object-interaction']:areYouSure(item)
				end
			--end

			if wRightClick then
				hideItemMenu()
			end
		end
	end
end

addEvent('item:move:protect', true)
addEventHandler('item:move:protect', root,
	function()
		triggerServerEvent("protectItem", source, fp)
	end)

function toggleCategory()
	-- let's add the items again
	if (isElement(gWallet)) then
		guiGridListClear(gWallet)
	end

	if (isElement(gItems)) then
		guiGridListClear(gItems)
	end

	if (isElement(gKeys)) then
		guiGridListClear(gKeys)
	end

	if (isElement(gWeapons)) then
		guiGridListClear(gWeapons)
	end

	local items = getItems(showinvPlayer)

	local tabs = {gWallet, gItems, gKeys, gWeapons}
	for i,v in ipairs(items) do
		local itemid = v[1]
		local itemvalue = v[2]
		local metadata = v[5]
		local tab = tabs[getItemTab(itemid)]
		local row = guiGridListAddRow(tab)
		guiGridListSetItemText(tab, row, colSlot, tostring(row+1), false, true)
		guiGridListSetItemData(tab, row, colSlot, tostring(i))
		if g_items[itemid].ooc_item_value and showinvType == "frisk" and not hasItem(localPlayer, itemid, itemvalue) then
			guiGridListSetItemText(tab, row, colName, tostring(getItemName(itemid, nil, metadata)), false, false)
			guiGridListSetItemText(tab, row, colID, "-", false, false)
			guiGridListSetItemText(tab, row, colValue, "-", false, false)
			guiGridListSetItemData(tab, row, colValue, "")
		else
			guiGridListSetItemText(tab, row, colName, tostring(getItemName(itemid, itemvalue, metadata)), false, false)
			guiGridListSetItemText(tab, row, colID, tostring(itemid), false, false)
			guiGridListSetItemText(tab, row, colValue, tostring(getItemValue(itemid, itemvalue, metadata)), false, false)
			guiGridListSetItemData(tab, row, colValue, tostring(itemvalue))
		end
	end
end

function toggleInventory()
	if wItems and guiGetEnabled( wItems ) then
		hideInventory()
	end
end
bindKey("i", "down", toggleInventory)

function copyClipboard()
	local row, col = guiGridListGetSelectedItem(source)
	local text = guiGridListGetItemData(source, row, colValue)
	if text == "" then
		-- do nothing
	elseif setClipboard(text) then
		exports.hud:sendBottomNotification(localPlayer, "Copiando", "Copiado '" .. text .. "' para a área de transferência.")
	else
		exports.hud:sendBottomNotification(localPlayer, "Copiando", "Erro ao copiar '" .. text .. "' para a área de transferência.")
	end
end

function showInventory(player, type)
	if not (wItems) then
		showinvPlayer = player
		showinvType = type or "desconhecido"
		if wItems then
			hideInventory()
		end
		if getElementData(localPlayer, "exclusiveGUI") then
			return
		end
		setElementData(localPlayer, "exclusiveGUI", true, false)
		local width, height = 600, 450
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)

		local title = "Inventario"
		if player ~= localPlayer then
			title = title .. " de " .. getPlayerName(player)
		end
		wItems = guiCreateWindow(x, y, width, height, title, false)
		guiWindowSetSizable(wItems, false)

		tabPanel = guiCreateTabPanel(0.025, 0.05, 0.95, 0.8, true, wItems)
		tabWallet = guiCreateTab("Carteira", tabPanel)
		tabItems = guiCreateTab("Itens", tabPanel)
		tabKeys = guiCreateTab("Chaves", tabPanel)
		tabWeapons = guiCreateTab("Armas", tabPanel)

		if activeTab == 1 then
			guiSetSelectedTab(tabPanel, tabWallet)
		elseif activeTab == 2 then
			guiSetSelectedTab(tabPanel, tabItems)
		elseif activeTab == 3 then
			guiSetSelectedTab(tabPanel, tabKeys)
		elseif activeTab == 4 then
			guiSetSelectedTab(tabPanel, tabWeapons)
		end

		addEventHandler( "onClientGUITabSwitched", tabPanel,
			function( tab )
				if tab == tabWallet then
					activeTab = 1
				elseif tab == tabItems then
					activeTab = 2
				elseif tab == tabKeys then
					activeTab = 3
				elseif tab == tabWeapons then
					activeTab = 4
				end
			end,
			false )

		-- WALLET
		gWallet = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabWallet)
		addEventHandler("onClientGUIClick", gWallet, showDescription, false)
		addEventHandler("onClientGUIDoubleClick", gWallet, copyClipboard, false)

		colSlot = guiGridListAddColumn(gWallet, "Slot", 0.1)
		colName = guiGridListAddColumn(gWallet, "Nome", 0.225)
		colID = guiGridListAddColumn(gWallet, "Item ID", 0.1)
		colValue = guiGridListAddColumn(gWallet, "Valor", 0.625)

		-- ITEMS
		gItems = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabItems)
		addEventHandler("onClientGUIClick", gItems, showDescription, false)
		addEventHandler("onClientGUIDoubleClick", gItems, copyClipboard, false)

		colSlot = guiGridListAddColumn(gItems, "Slot", 0.1)
		colName = guiGridListAddColumn(gItems, "Nome", 0.225)
		colID = guiGridListAddColumn(gItems, "Item ID", 0.1)
		colValue = guiGridListAddColumn(gItems, "Valor", 0.625)

		-- keys
		gKeys = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabKeys)
		addEventHandler("onClientGUIClick", gKeys, showDescription, false)
		addEventHandler("onClientGUIDoubleClick", gKeys, copyClipboard, false)

		colSlot = guiGridListAddColumn(gKeys, "Slot", 0.1)
		colName = guiGridListAddColumn(gKeys, "Nome", 0.625)
		colID = guiGridListAddColumn(gKeys, "Item ID", 0.1)
		colValue = guiGridListAddColumn(gKeys, "Valor", 0.225)

		-- WEAPONS
		gWeapons = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabWeapons)
		addEventHandler("onClientGUIClick", gWeapons, showDescription, false)
		addEventHandler("onClientGUIDoubleClick", gWeapons, copyClipboard, false)

		colWSlot = guiGridListAddColumn(gWeapons, "Slot", 0.1)
		colWName = guiGridListAddColumn(gWeapons, "Nome", 0.225)
		colID = guiGridListAddColumn(gWeapons, "Item ID", 0.1)
		colWValue = guiGridListAddColumn(gWeapons, "Munição", 0.625)

		-- GENERAL
		lDescription = guiCreateLabel(0.025, 0.87, 0.95, 0.1, "Clique em um item para ver sua descrição.", true, wItems)
		guiLabelSetHorizontalAlign(lDescription, "center", true)
		guiSetFont(lDescription, "default-bold-small")
		
		bClose = guiCreateButton(0.200, 0.91, 0.2, 0.15, "Fechar Inventario", true, wItems)
		addEventHandler("onClientGUIClick", bClose, hideInventory, false)
		
		bTakeItem = guiCreateButton(0.400, 0.91, 0.2, 0.15, "Pegar Item", true, wItems)
		addEventHandler("onClientGUIClick", bTakeItem, takeInventoryItem, false)

		bDeleteItem = guiCreateButton(0.600, 0.91, 0.2, 0.15, "Deletar Item", true, wItems)
		addEventHandler("onClientGUIClick", bDeleteItem, takeInventoryItem, false)

		if (showinvType == "frisk") then
			guiSetProperty(bTakeItem, "Disabled", "True")
			guiSetProperty(bDeleteItem, "Disabled", "True")
		end

		source = nil
		toggleCategory()
		showCursor(true)
	end
end
addEvent("showInventory", true)
addEventHandler("showInventory", getRootElement(), showInventory)

function takeInventoryItem(button, state)
	if (button == "left") then
		local whichGrid = false
		local whichTab = guiGetSelectedTab(tabPanel)
		local whichCommand = nil
	
		if whichTab == tabWallet then 
			whichGrid = gWallet
		elseif whichTab == tabItems then 
			whichGrid = gItems
		elseif whichTab == tabKeys then 
			whichGrid = gKeys
		elseif whichTab == tabWeapons then 
			whichGrid = gWeapons
		end
	
		if (source == bTakeItem) then 
			whichCommand = "takeitem"
		else
			whichCommand = "delplayeritem"
		end

		triggerServerEvent("admin-system:takeItem", localPlayer, localPlayer, whichCommand, showinvPlayer, guiGridListGetItemText(whichGrid, guiGridListGetSelectedItem (whichGrid), 3), guiGridListGetItemText (whichGrid, guiGridListGetSelectedItem (whichGrid), 4))
	end
end

function hideInventory()
	colSlot = nil
	colName = nil
	colValue = nil

	colWSlot = nil
	colWName = nil
	colWValue = nil

	if wItems then
		destroyElement(wItems)
	end
	wItems = nil

	showCursor(false)
	setElementData(localPlayer, "exclusiveGUI", false, false)

	hideNewInventory()
end
addEvent("hideInventory", true)
addEventHandler("hideInventory", getRootElement(), hideInventory)

function showDescription(button, state)
	if (button=="left") then
		if (guiGetSelectedTab(tabPanel)==tabItems or guiGetSelectedTab(tabPanel)==tabKeys) then -- ITEMS
			local row, col = guiGridListGetSelectedItem(guiGetSelectedTab(tabPanel) == tabKeys and gKeys or gItems)

			if (row==-1) or (col==-1) then
				guiSetText(lDescription, "Clique em um item para ver sua descrição.")
			else
				local slot = tonumber(guiGridListGetItemData(guiGetSelectedTab(tabPanel) == tabKeys and gKeys or gItems, row, 1))
				local items = getItems(showinvPlayer)
				if not items[slot] then
					guiSetText(lDescription, "Um slot vazio.")
				else
					local desc = tostring( getItemDescription( items[slot][1], items[slot][2] ) )
					local value = items[slot][2]

					-- percent operators
					desc = string.gsub((desc), "#v", tostring(value))

					if (desc=="A Dictionary.") then
						local res = getResourceFromName("language-system")
						local lang = call(res, "getLanguageName", tonumber(value))
						desc = "A " .. lang .. " dictionary."
					end

					guiSetText(lDescription, desc)
				end
			end
		elseif (guiGetSelectedTab(tabPanel)==tabWeapons) then -- WEAPONS
			local row, col = guiGridListGetSelectedItem(gWeapons)
			if (row==-1) or (col==-1) then
				guiSetText(lDescription, "Clique em um item para ver sua descrição.")
			else
				local name = tostring(guiGridListGetItemText(gWeapons, row, 2))
				local ammo = tostring(guiGridListGetItemText(gWeapons, row, 3))
				local desc = "Um(a) " .. name .. " com " .. ammo .. " munições."

				guiSetText(lDescription, desc)
			end
		end
	end
end

function useItem(itemSlot)
--function useItem(button)
	showinvPlayer = localPlayer
	if getElementHealth(localPlayer) == 0 then return end
	local x, y, z = getElementPosition(localPlayer)
	local groundz = getGroundPosition(x, y, z)
	if itemSlot > 0 then -- ITEMS
		local item = getItems( showinvPlayer )[itemSlot]
		local itemID = item[1]
		if itemID > 0 and not g_items[itemID] then
			exports.hud:sendBottomNotification(localPlayer, "Uso do item", "This item is no longer available.", 255, 194, 14)
			return
		end
		local itemName = getItemName( itemID )
		local itemValue = item[2]
		local additional = nil

		if (itemID==2) then -- cellphone
			hideInventory()
			--triggerServerEvent("phone:requestShowPhoneGUI", localPlayer, tostring(itemValue))
			triggerEvent("phone:slidePhoneIn", localPlayer, itemValue)
			return
		elseif (itemID==6) then -- radio
			exports.hud:sendBottomNotification(localPlayer, "Uso do item", "Pressione Y para usar este item. Você também pode usar /tuneradio para sintonizar seu rádio.", 255, 194, 14)
			return
		elseif (itemID==7) then -- phonebook
			exports.hud:sendBottomNotification(localPlayer, "Uso do item", "Use /agenda para usar este item.", 255, 194, 14)
			return
		elseif (itemID==18) then -- City Guide
			triggerEvent( "showCityGuide", getLocalPlayer( ) )
			return
		elseif (itemID==19) then -- MP3 PLayer
			exports.carradio:showMP3GUI()
			hideInventory()
			return
		elseif (itemID==27) then -- Flashbang
			local x, y, z = getElementPosition(getLocalPlayer( ))
			local rot = getPedRotation(getLocalPlayer( ))
			x = x + math.sin(math.rad(-rot)) * 10
			y = y + math.cos(math.rad(-rot)) * 10
			z = getGroundPosition(x, y, z + 2)
			additional = { x, y, z }
			triggerServerEvent("useItem", localPlayer, itemSlot, additional)
		elseif (itemID==28 or itemID==54 or itemID==176) then -- Glowstick or Ghettoblaster or speaker
			local x, y, z = getElementPosition(getLocalPlayer( ))
			local rot = getPedRotation(getLocalPlayer( ))
			x = x + math.sin(math.rad(-rot)) * 2
			y = y + math.cos(math.rad(-rot)) * 2
			z = getGroundPosition(x, y, z)
			local int = getElementInterior(getLocalPlayer( ))
			local dim = getElementDimension(getLocalPlayer( ))
			additional = { x, y, z - 0.5, int, dim }
			triggerServerEvent("useItem", localPlayer, itemSlot, additional)
		elseif (itemID==30) or (itemID==31) or (itemID==32) or (itemID==33) then
			exports.hud:sendBottomNotification(localPlayer, "Uso do item", "Use o conjunto de química que pode ser adquirido em um 24/7 para usar este item.", 255, 0, 0)
			return
		--[[
		elseif (itemID==34) then -- COCAINE
			doDrug1Effect()
		elseif (itemID==35) then
			doDrug2Effect()
		elseif (itemID==36) then
			doDrug3Effect()
		elseif (itemID==37) then
			doDrug4Effect()
		elseif (itemID==38) then
			if not getPedOccupiedVehicle(localPlayer) then
				doDrug5Effect()
			end
		elseif (itemID==39) then
			doDrug6Effect()
		elseif (itemID==40) then
			doDrug3Effect()
			doDrug1Effect()
		elseif (itemID==41) then
			doDrug4Effect()
			doDrug6Effect()
		elseif (itemID==42) then
			if not getPedOccupiedVehicle(localPlayer) then
				doDrug5Effect()
				doDrug2Effect()
			end
		elseif (itemID==43) then
			doDrug4Effect()
			doDrug1Effect()
			doDrug6Effect()
		]]
		elseif (itemID==44) then
			hideInventory()
			showChemistrySet()
			return
		elseif (itemID==45) or (itemID==46) or (itemID==47) or (itemID==66) then
			exports.hud:sendBottomNotification(source, "Uso do item", "Clique com o botão direito em um jogador para usar este item.")
			return
		elseif (itemID==50) or (itemID==51) or (itemID==52) then
			triggerServerEvent("useItem", localPlayer, itemSlot, additional)
			hideInventory()
		elseif (itemID==53) then -- Breathalizer
			exports.hud:sendBottomNotification(localPlayer, "Uso do item", "Use /bafometro para usar este item.")
			return
		elseif (itemID==55) then
			exports.hud:sendBottomNotification(localPlayer, itemName, "O cartão de visita diz: " .. itemValue)
			return
		elseif (itemID==57) then -- FUEL CAN
			hideInventory()
		--[[elseif (itemID==58) then
			setTimer(
				function()
					setElementData(localPlayer, "alcohollevel", ( getElementData(localPlayer, "alcohollevel") or 0 ) + 0.1, false)
				end, 15000, 1
			)]]
		elseif (itemID==61) then -- Emergency Light Becon
			exports.hud:sendBottomNotification(localPlayer, "Uso do item", "Coloque-o no inventário do seu carro e pressione 'P' para alterná-lo.")
			return
		elseif (itemID==62) then
			setTimer(
				function()
					setElementData(localPlayer, "alcohollevel", ( getElementData(localPlayer, "alcohollevel") or 0 ) + 0.3, false)
				end, 5000, 1
			)
			triggerServerEvent("useItem", localPlayer, itemSlot, additional)
		elseif (itemID==63) then
			setTimer(
				function()
					setElementData(localPlayer, "alcohollevel", ( getElementData(localPlayer, "alcohollevel") or 0 ) + 0.2, false)
				end, 10000, 1
			)
			triggerServerEvent("useItem", localPlayer, itemSlot, additional)
		elseif (itemID==67) then -- GPS
			exports.hud:sendBottomNotification(localPlayer, itemName, "Coloque-o no seu inventário de carros e pressione 'F5'.")
			return
		elseif (itemID==70) then -- First Aid Kit
			exports.hud:sendBottomNotification(localPlayer, itemName, "Clique com o botão direito em um jogador nocauteado para estabilizá-lo.")
			return
		elseif (itemID==71) then -- Notebook
			exports.hud:sendBottomNotification(localPlayer, itemName, "Use /writeenote [texto] para escrever uma nota. Existem " .. itemValue .. " paginas restantes.")
			return
		elseif (itemID==72) then -- Note
			exports.hud:sendBottomNotification(localPlayer, itemName, "A nota diz: " .. itemValue)
		elseif (itemID==77) then
			triggerServerEvent("useItem", localPlayer, itemSlot, additional)
			hideInventory()
		elseif (itemID==78) then
			exports.hud:sendBottomNotification(localPlayer, itemName, "Esta Licença de Piloto de San Andreas foi emitida para " .. itemValue .. ".")
			return
		elseif (itemID==81) then
			exports.hud:sendBottomNotification(localPlayer, itemName, "Solte esta geladeira em um interior.")
			return
		elseif (itemID==84) then
			exports.hud:sendBottomNotification(localPlayer, itemName, "Coloque-o no carro ou carregue-o para saber quando a polícia estiver por perto.")
			return
		elseif (itemID==85) then -- Emergency Light Becon
			exports.hud:sendBottomNotification(localPlayer, itemName, "Coloque-o no seu inventário de carros e pressione 'N'.")
			return
		elseif (itemID==103) then
			exports.hud:sendBottomNotification(localPlayer, itemName, "Solte esta prateleira em um interior.")
			return
		elseif (itemID==111) then
			if isPlayerGPSShowing then 
				setPlayerHudComponentVisible("radar", false)
			else
				setPlayerHudComponentVisible("radar", true)
			end
			isPlayerGPSShowing = not isPlayerGPSShowing
			return 
		elseif itemID == 115 then
			local info = split(tostring(itemValue), ':')
			if info and info[1] == '46' then
				exports.hud:sendBottomNotification(localPlayer, itemName, "Role até o seu pára-quedas enquanto está no ar para usá-lo.")
			elseif info and info[1] == '2' then
				triggerEvent("golf:start", root)
			elseif info and info[1] == '5' then -- Taco Baseball
			    local pedSlot = getPedWeaponSlot (getLocalPlayer())
	            if (pedSlot == 1) then 
				setPedWeaponSlot (getLocalPlayer(), 0) 
				triggerEvent("updateLocalGuns", getLocalPlayer())
				else
				setPedWeaponSlot (getLocalPlayer(), 1)
				setElementData(getLocalPlayer(),"cweapon", "Taco Madeira")
				hideInventory()
				end
			elseif info and info[1] == '30' then -- 	Assault Rifles
			    local pedSlot = getPedWeaponSlot (getLocalPlayer())
	            if (pedSlot == 5) then
				setPedWeaponSlot (getLocalPlayer(), 0) 
				triggerEvent("updateLocalGuns", getLocalPlayer())
				else
				setPedWeaponSlot (getLocalPlayer(), 5)
				hideInventory()
				end
			elseif info and info[1] == '31' then
			    local pedSlot = getPedWeaponSlot (getLocalPlayer())
	            if (pedSlot == 5) then 
				setPedWeaponSlot (getLocalPlayer(), 0) 
				triggerEvent("updateLocalGuns", getLocalPlayer())
				else
				setPedWeaponSlot (getLocalPlayer(), 5)
				setElementData(getLocalPlayer(),"cweapon", "M4A1")
				hideInventory()
				end
			elseif info and info[1] == '22' or info[1] == '23' then -- Pistolas
			    local pedSlot = getPedWeaponSlot (getLocalPlayer())
	            if (pedSlot == 2) then setPedWeaponSlot (getLocalPlayer(), 0) else
				setPedWeaponSlot (getLocalPlayer(), 2)
				hideInventory()
				end
			elseif info and info[1] == '24' then -- Desert Eagle
			    local pedSlot = getPedWeaponSlot (getLocalPlayer())
	            if (pedSlot == 2) then 
				setPedWeaponSlot (getLocalPlayer(), 0) 
				triggerEvent("updateLocalGuns", getLocalPlayer())
				else
				setPedWeaponSlot (getLocalPlayer(), 2)
				setElementData(getLocalPlayer(),"cweapon", "glockpd")
				hideInventory()
				end
			elseif info and info[1] == '2' or info[1] == '3' or info[1] == '4' or info[1] == '5' or info[1] == '6' or info[1] == '7' or info[1] == '8' or info[1] == '9' then -- Melees
			    local pedSlot = getPedWeaponSlot (getLocalPlayer())
	            if (pedSlot == 1) then setPedWeaponSlot (getLocalPlayer(), 0) else
				setPedWeaponSlot (getLocalPlayer(), 1)
				hideInventory()
				end
			elseif info and info[1] == '25' or info[1] == '26' or info[1] == '27' then -- Shotguns
			    local pedSlot = getPedWeaponSlot (getLocalPlayer())
	            if (pedSlot == 3) then setPedWeaponSlot (getLocalPlayer(), 0) else
				setPedWeaponSlot (getLocalPlayer(), 3)
				hideInventory()
				end
			elseif info and info[1] == '28' then -- MICRO UZI
			    local pedSlot = getPedWeaponSlot (getLocalPlayer())
	            if (pedSlot == 4) then 
				setPedWeaponSlot (getLocalPlayer(), 0) 
				triggerEvent("updateLocalGuns", getLocalPlayer())
				else
				setPedWeaponSlot (getLocalPlayer(), 4)
				setElementData(getLocalPlayer(),"cweapon", "uzipadrao")
				hideInventory()
				end
			elseif info and info[1] == '29' then -- MP5
			    local pedSlot = getPedWeaponSlot (getLocalPlayer())
	            if (pedSlot == 4) then 
				setPedWeaponSlot (getLocalPlayer(), 0) 
				triggerEvent("updateLocalGuns", getLocalPlayer())
				else
				setPedWeaponSlot (getLocalPlayer(), 4)
				setElementData(getLocalPlayer(),"cweapon", "hekmp5")
				hideInventory()
				end
			elseif info and info[1] == '32' then -- SMG
			    local pedSlot = getPedWeaponSlot (getLocalPlayer())
	            if (pedSlot == 4) then setPedWeaponSlot (getLocalPlayer(), 0) else
				setPedWeaponSlot (getLocalPlayer(), 4)
				hideInventory()
				end
			elseif info and info[1] == '33' or info[1] == '34' then -- Rifles
			    local pedSlot = getPedWeaponSlot (getLocalPlayer())
	            if (pedSlot == 6) then setPedWeaponSlot (getLocalPlayer(), 0) else
				setPedWeaponSlot (getLocalPlayer(), 6)
				hideInventory()
				end
			elseif info and info[1] == '36' or info[1] == '37' or info[1] == '38' then -- Heavy Weapons
			    local pedSlot = getPedWeaponSlot (getLocalPlayer())
	            if (pedSlot == 7) then setPedWeaponSlot (getLocalPlayer(), 0) else
				setPedWeaponSlot (getLocalPlayer(), 7)
				hideInventory()
				end
			elseif info and info[1] == '17' or info[1] == '18' or info[1] == '39' then -- Projectiles
			    local pedSlot = getPedWeaponSlot (getLocalPlayer())
	            if (pedSlot == 8) then setPedWeaponSlot (getLocalPlayer(), 0) else
				setPedWeaponSlot (getLocalPlayer(), 8)
				hideInventory()
				end
			elseif info and info[1] == '41' or info[1] == '42' or info[1] == '43' then -- Special 1
			    local pedSlot = getPedWeaponSlot (getLocalPlayer())
	            if (pedSlot == 9) then setPedWeaponSlot (getLocalPlayer(), 0) else
				setPedWeaponSlot (getLocalPlayer(), 9)
				hideInventory()
				end
			elseif info and info[1] == '10' or info[1] == '11' or info[1] == '12' or info[1] == '14' or info[1] == '15' then -- gifts
			    local pedSlot = getPedWeaponSlot (getLocalPlayer())
	            if (pedSlot == 10) then setPedWeaponSlot (getLocalPlayer(), 0) else
				setPedWeaponSlot (getLocalPlayer(), 10)
				hideInventory()
				end
			elseif info and info[1] == '44' or info[1] == '45' or info[1] == '46' then -- Special 2
			    local pedSlot = getPedWeaponSlot (getLocalPlayer())
	            if (pedSlot == 11) then setPedWeaponSlot (getLocalPlayer(), 0) else
				setPedWeaponSlot (getLocalPlayer(), 11)
				hideInventory()
				end
			elseif info and info[1] == '40' then -- Detonador
			    local pedSlot = getPedWeaponSlot (getLocalPlayer())
	            if (pedSlot == 12) then setPedWeaponSlot (getLocalPlayer(), 0) else
				setPedWeaponSlot (getLocalPlayer(), 12)
				hideInventory()
				end
			else
				--exports.hud:sendBottomNotification(getLocalPlayer(), itemName, "Este item é (parte de) uma arma, você não pode usá-lo clicando nele. Se você tiver todas as partes necessárias, a arma aparecerá no seu menu de rolagem.")
			end
			return
		elseif itemID == 116 then
			local parts = exports.global:explode(':', itemValue)
			local ammo_id = tonumber(parts[1])
			local rounds = tonumber(parts[2])
			local weapons
			if ammo_id and rounds then
				local ammo = exports.weapon:getAmmo( ammo_id )
				if ammo and ammo.weapons then
					exports.hud:sendBottomNotification(localPlayer, ammo.cartridge..' '..itemName, "Cartucho: "..ammo.cartridge..", Estilo de Munição: "..ammo.bullet_style..", Peso da Munição: "
						..exports.global:round(ammo.bullet_weight*1000,2).." gramas, Aplicação: "..ammo.application..", Compatível com "..exports.weapon:formatWeaponNames(ammo.weapons)..".")
				end
			end
			return
		elseif itemID == 117 then
			exports.hud:sendBottomNotification(localPlayer, itemName, "Coloque este item em um veículo e controle-o no menu do botão direito do mouse do veículo.")
			return
		elseif itemID == 174 then
			triggerServerEvent("startFAAmapGUI", localPlayer)
			return
		elseif (itemID==118) then
			exports.hud:sendBottomNotification(localPlayer, itemName,  "Coloque-o no seu carro e aproxime-se de uma cabine de pedágio.")
			return
		elseif itemID == 121 then
			exports.hud:sendBottomNotification(localPlayer, itemName, "Uma caixa pesada cheia de suprimentos!")
			return
		elseif itemID == 145 then -- Flashlight
			exports.dynamic_lighting_flash:toggleFlashLight(nil, item[3])
			return
		elseif (itemID==147) then -- Picture Frame --  Adams
			if(itemValue and itemValue ~= 1) then
				local split = exports.global:explode(";", itemValue)
				if(#split > 1) then
					exports.hud:sendBottomNotification(localPlayer, itemName, "Solte isso em um interior para substituir a textura '"..tostring(split[2]).."'.")
				else
					local url = itemValue
					triggerServerEvent ( "frames:fetchTexture", localPlayer, itemSlot, url )
				end
				return
			else
				triggerEvent ( "frames:showFrameGUI", localPlayer, itemSlot )
				return
			end
		elseif (itemID==148) then
			exports.hud:sendBottomNotification(localPlayer, itemName, "permição OCW - " .. itemValue .. ".")
			return
		elseif (itemID==149) then
			exports.hud:sendBottomNotification(localPlayer, itemName, "permição CCW - " .. itemValue .. ".")
			return
		elseif (itemID==150) then -- ATM card
			local itemExploded = explode(";", itemValue )
			if tonumber( itemExploded[2] ) > 0 then
				exports.hud:sendBottomNotification(localPlayer, g_items[itemID][1] , "Numero Cartão: '"..itemExploded[1].."', Dono: '"..tostring(exports.cache:getCharacterNameFromID(itemExploded[2])):gsub("_", " ").."'. Arraste e solte em um caixa eletrônico próximo.")
			else
				exports.hud:sendBottomNotification(localPlayer, g_items[itemID][1] , "Numero Cartão: '"..itemExploded[1].."', Dono: '"..tostring(exports.cache:getBusinessNameFromID(math.abs(itemExploded[2]))).."'. Arraste e solte em um caixa eletrônico próximo.")
			end
			return
		elseif (itemID==152) then -- ID card
			local itemExploded = explode(";", itemValue )
			local text = "Name '"..itemExploded[1]:gsub("_", " ").."', Genero: '"..itemExploded[2].."', Data Nascimento: '"..itemExploded[3].."', Impressão digital: '"..itemExploded[4].."' "
			exports.hud:sendBottomNotification(localPlayer, g_items[itemID][1] , text)
			return
		elseif (itemID==133) or (itemID==153) or (itemID==154) or (itemID==155)then
			exports.hud:sendBottomNotification(localPlayer, itemName, "Esse(a) "..itemName.." foi emitido para " .. itemValue .. ".")
			return
		elseif (itemID==169) then -- Keypad door lock
			exports.hud:sendBottomNotification(localPlayer, g_items[itemID][1].." - Equipando para interior ID #"..itemValue , "Fixe este dispositivo a uma parede estável para instalar. Você pode desinstalar este dispositivo e reinstalá-lo gratuitamente mais tarde.")
			return
		elseif (itemID==170) then -- Keycard
			exports.hud:sendBottomNotification(localPlayer, itemName, "Passe este cartão em "..tostring(itemValue).." para adquirir acesso.")
			return
		elseif (itemID==177) then -- Remote dispatch device
			executeCommandHandler( "dispatch")
			hideInventory()
			return
		elseif (itemID==178) then
			local bInfo = split(tostring(itemValue), ':')
			local bID = bInfo[3]
			triggerServerEvent("books:beginBook", localPlayer, bID, itemSlot)
			hideInventory()
			return
		elseif (itemID==211) then -- Christmas Lottery Ticket
			outputChatBox("Experimente dar o ingresso ao Papai Noel para ver o que você pode ter ganho.", 255, 194, 14)
			return
		elseif (itemID==212) then -- Snow Tire
			outputChatBox("Coloque isso em seu veículo para melhor tração na neve.", 155, 255, 155)
			return
		elseif itemID == 232 then -- car battery charger
			for i, veh in pairs( exports.global:getNearbyElements( localPlayer, 'vehicle', 5 ) ) do
				if veh and isElement(veh) then
					local doors = exports.vehicle:getDoorsFor( getElementModel( veh ) , 0 )
					if #doors > 0 and doors[1] and doors[1][1] == 'Hood' and getVehicleDoorOpenRatio ( veh, 0 ) < 0.5 then
						exports.hud:sendBottomNotification(localPlayer, itemName, "Por favor, abra o capô deste veículo primeiro." )
					elseif isVehicleLocked ( veh ) then
						exports.hud:sendBottomNotification(localPlayer, itemName, "Por favor, destrave este veículo primeiro." )
					else
						triggerServerEvent( "useItem", localPlayer, itemSlot, veh )
					end
					return
				end
			end
			exports.hud:sendBottomNotification(localPlayer, itemName, "Não há nenhum veículo ao seu redor." )
		else
			triggerServerEvent("useItem", localPlayer, itemSlot, additional)
		end
	else
		if itemSlot == -100 then
			exports.hud:sendBottomNotification(localPlayer, itemName, "Você usa um colete.")
		else
			setPedWeaponSlot( localPlayer, -itemSlot )
		end
	end
end

function stopGasmaskDamage(attacker, weapon)
	local gasmask = getElementData(localPlayer, "gasmask")

	if (weapon==17 or weapon==41) and (gasmask) then
		cancelEvent()
	end

	--
	-- Scuba Gear
	--
	if weapon == 53 and getElementData( localPlayer, "scuba" ) then
		cancelEvent( )
	end
end
addEventHandler("onClientPlayerDamage", localPlayer, stopGasmaskDamage)


addEventHandler("onClientChangeChar", getRootElement(), hideInventory)

local function updateInv()
	if wItems and source == showinvPlayer then
		source = nil
		setTimer(toggleCategory, 50, 1)
	end
end
addEventHandler("recieveItems", getRootElement(), updateInv)

addEvent("finishItemDrop", true)
addEventHandler("finishItemDrop", localPlayer,
	function( )
		if wItems then
			guiSetVisible( wWait, false )
			guiSetEnabled( wItems, true )
		end
	end
)

--
-- Carried items weight.
--
addCommandHandler("carried",
	function( command, detailed )
		exports.hud:sendBottomNotification(localPlayer, "Peso transportado", ("%.2f/%.2f" ):format( getCarriedWeight( localPlayer ), getMaxWeight( localPlayer ) ) )
		if detailed == "detailed" then
			for k, v in ipairs( getItems( localPlayer ) ) do
				exports.hud:sendBottomNotification(localPlayer, "Peso transportado",  "  %.2f %s; %s", getItemWeight( v[1], v[2], v[5] ), getItemName( v[1], v[2], v[5] ), getItemDescription( v[1], v[2], v[5] ) )
			end
		end
	end
)

--
-- are we watching TV?
--
function areItemInteractionsDisabled()
	return exports['freecam-tv']:isFreecamEnabled() or getElementData(localPlayer, "viewingInterior")
end
isWatchingTV = areItemInteractionsDisabled


detailedDebug = false
addCommandHandler("detaileditemdebugclient",
	function()
		if exports.global:isPlayerScripter(localPlayer) then
			detailedDebug = not detailedDebug
			outputChatBox("detaileditemdebug [client-side] set to "..tostring(detailedDebug))
		end
	end)
	
function naotrocararma()
	toggleControl("next_weapon",false)
	toggleControl("previous_weapon",false)
end
addEventHandler ( "onClientPreRender", root, naotrocararma )
	