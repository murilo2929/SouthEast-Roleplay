-- initializing some stuff

local started = false
local startedbm = false

local object = nil

local objectpos = {0, 0, 0, 0, 0, 0, 1}
local positiontable = {0, 0, 0, 0, 0, 0, 0}

local x,y,z = 0.001, 0.001, 0.001
local rx, ry, rz = 1, 1, 1
local oc = 0.01

local info = {}

local objectID = nil
local itemID = nil
local bone = nil
local default = nil
local itemName = nil

local currentpos = nil

local GUIEditor = {
    label = {},
    button = {},
    window = {},
    scrollbar = {},
    combobox = {}
}

-- end of initializing

function startWiGUI(legitimatecheck)
	if (started == false and table.concat(legitimatecheck, " ", 8, 9) == "w-active check" ) then -- for the nabs
		showCursor(true)
		
		local sWidth, sHeight = guiGetScreenSize()
		local windowX, windowY = 500, 450
		local pX, pY = (sWidth/2)-(windowX/2), (sHeight/2)-(windowY/2)
		
		GUIEditor.window[1] = guiCreateWindow(pX, pY + 50, 552, 288, "Acessórios", false)
		guiWindowSetSizable(GUIEditor.window[1], false)
		
		legitimatev = table.concat(legitimatecheck, " ", 8, 9)
		
		updateLegitimateCheck()
		
		GUIEditor.combobox[1] = guiCreateComboBox(10, 37, 183, 118, "", false, GUIEditor.window[1])
		for k,v in ipairs(items) do
			guiComboBoxAddItem( GUIEditor.combobox[1], v["name"] )
		end
		GUIEditor.button[3] = guiCreateButton(425, 248, 113, 30, "Fechar", false, GUIEditor.window[1])
		addEventHandler("onClientGUIClick", GUIEditor.button[3], function()
			stopWiGUI()
		end, false)
		GUIEditor.button[4] = guiCreateButton(213, 37, 94, 21, "Editar", false, GUIEditor.window[1])
		addEventHandler ( "onClientGUIClick", GUIEditor.button[4],  function()
			local item = guiComboBoxGetSelected(GUIEditor.combobox[1])
			local text = guiComboBoxGetItemText(GUIEditor.combobox[1], item)
			
			if text == "" then return outputChatBox("Selecione um item!") end
			--startPositionGUI(text)
			wearable_initialize_system(text)
			destroyElement(GUIEditor.window[1])
			showCursor(false)
		end, false)
		GUIEditor.label[3] = guiCreateLabel(12, 98, 526, 140, "Você pode ajustar a posição de seus acessórios da lista acima.\nEntão, comprando os acessórios que você configurou no revendedor de acessórios,,\nvocê pode fazer com que apareça na posição que você definiu em seu personagem.", false, GUIEditor.window[1])    
		triggerEvent("hud:convertUI", localPlayer, GUIEditor.window[1])
	elseif (started == true) then
		started = false
		destroyElement(GUIEditor.window[1])
		showCursor(false)	
	end
end

function checkForExistingPosition()
	triggerServerEvent("wearable-system:requestPosition", localPlayer, itemID, itemName)
end

function recievePosition(position)
	if type(position) == "table" then
		exports.bone_attach:detachElementFromBone(object)
		
		local ix, iy, iz, irx, iry, irz, ioc = position[1], position[2], position[3], position[4], position[5], position[6], position[7]
		
		objectpos = {ix, iy, iz, irx, iry, irz, ioc}
		
		exports.bone_attach:attachElementToBone(object, localPlayer, bone, ix, iy, iz, irx, iry, irz )
		
		setObjectScale(object, ioc)
		
		outputChatBox("A posição do acessório salvo foi definida!")
	end
end

function transferDataToServerSide(data)
	triggerServerEvent("wearable-system:updateSData", localPlayer, data)
end

function startPositionGUI(text)
	setElementData(localPlayer, "wearable-system:active", true)

	info["interior"] = getElementInterior(localPlayer)
	info["dimension"] = getElementDimension(localPlayer)
	info["position"] = {getElementPosition(localPlayer)}
	
	transferDataToServerSide(info) -- send the info table to the server side already for player quit
	
	setElementDimension(localPlayer, math.random(999999, 999999))
	setCameraInterior(14)
	setCameraMatrix(254.7190,  -41.1370,  1002, 256.7190,  -41.1370,  1002 )
	setElementPosition(localPlayer, 258,  -42,  1002, true)
	setElementInterior(localPlayer, 14)
	setElementRotation(localPlayer, -0, 0, 92.372489929199, "default", true)
	
	itemName = text
	
	for k,v in ipairs(items) do
		if v["name"] == itemName and legit == 1 then
			itemID = v["itemID"]; objectID = v["objectID"]; bone = v["bone"]; default = v["default"]
			
			break
		end
	end
	
	checkForExistingPosition() -- does the player already made a position for the item?
	
	object = createObject(objectID, 0, 0, 0)

	setElementDimension(object, getElementDimension(localPlayer))
	setElementInterior(object, getElementInterior(localPlayer))
	
	
	exports.bone_attach:attachElementToBone(object, localPlayer, bone, 0, 0, 0, 0, 0, 0 )
	
	local sWidth, sHeight = guiGetScreenSize()
	local windowX, windowY = 500, 450
	local pX, pY = (sWidth/2)-(windowX/2), (sHeight/2)-(windowY/2)
	
	GUIEditor.window[2] = guiCreateWindow(pX - 100, pY + 200, 431, 221, "MTA:RP - Wearable System Positioning", false)
	guiWindowSetSizable(GUIEditor.window[2], false)

	GUIEditor.scrollbar[1] = guiCreateScrollBar(50, 44, 135, 15, true, false, GUIEditor.window[2])
	guiSetProperty(GUIEditor.scrollbar[1],"StepSize", 0.01)
	addEventHandler("onClientGUIScroll", GUIEditor.scrollbar[1], update_position_scrollbars)
	GUIEditor.scrollbar[2] = guiCreateScrollBar(257, 94, 135, 15, true, false, GUIEditor.window[2])
	guiSetProperty(GUIEditor.scrollbar[2],"StepSize",0.01/0.30)
	addEventHandler("onClientGUIScroll", GUIEditor.scrollbar[2], update_position_scrollbars)
	GUIEditor.scrollbar[3] = guiCreateScrollBar(257, 69, 135, 15, true, false, GUIEditor.window[2])
	guiSetProperty(GUIEditor.scrollbar[3],"StepSize",0.01/0.30)
	addEventHandler("onClientGUIScroll", GUIEditor.scrollbar[3], update_position_scrollbars)
	GUIEditor.scrollbar[4] = guiCreateScrollBar(257, 44, 135, 15, true, false, GUIEditor.window[2])
	guiSetProperty(GUIEditor.scrollbar[4],"StepSize",1/30)
	addEventHandler("onClientGUIScroll", GUIEditor.scrollbar[4], update_position_scrollbars)
	GUIEditor.scrollbar[5] = guiCreateScrollBar(50, 94, 135, 15, true, false, GUIEditor.window[2])
	guiSetProperty(GUIEditor.scrollbar[5],"StepSize",1/30)
	addEventHandler("onClientGUIScroll", GUIEditor.scrollbar[5], update_position_scrollbars)
	GUIEditor.scrollbar[6] = guiCreateScrollBar(50, 69, 135, 15, true, false, GUIEditor.window[2])
	guiSetProperty(GUIEditor.scrollbar[6],"StepSize",1/30)
	addEventHandler("onClientGUIScroll", GUIEditor.scrollbar[6], update_position_scrollbars)
	GUIEditor.scrollbar[7] = guiCreateScrollBar(257, 140, 135, 15, true, false, GUIEditor.window[2])
	guiSetProperty(GUIEditor.scrollbar[7],"StepSize",1/30)
	addEventHandler("onClientGUIScroll", GUIEditor.scrollbar[7], update_position_scrollbars)
	GUIEditor.label[1] = guiCreateLabel(16, 38, 20, 108, "X\n\nY\n\nZ", false, GUIEditor.window[2])
	GUIEditor.label[2] = guiCreateLabel(215, 39, 20, 108, "RX\n\nRY\n\nRZ", false, GUIEditor.window[2])
	GUIEditor.button[1] = guiCreateButton(309, 184, 108, 27, "Save", false, GUIEditor.window[2])
	addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
		-- gather all our information and send it to the server side to continue the process there
		local table = {name = itemName, itemID = itemID, objectID = objectID, bone = bone, position = {objectpos[1], objectpos[2], objectpos[3], objectpos[4], objectpos[5], objectpos[6], objectpos[7]}, default = default}
		triggerServerEvent("wearable-system:savePosition", localPlayer, table)
		
		destroyElement(GUIEditor.window[2])
		destroyElement(object)
		objectpos = {0, 0, 0, 0, 0, 0, 1}
		positiontable = {0, 0, 0, 0, 0, 0, 0}
		showCursor(false)
		setCameraTarget(getLocalPlayer())
		setElementDimension(localPlayer, info["dimension"])
		setElementInterior(localPlayer, info["interior"])
		local px, py, pz = unpack(info["position"])
		setElementPosition(localPlayer, px, py, pz, true)
		
		setElementData(localPlayer, "wearable-system:active", false)
	end, false)
	
	GUIEditor.button[5] = guiCreateButton(10, 130, 28, 26, "+", false, GUIEditor.window[2])
	addEventHandler("onClientGUIClick", GUIEditor.button[5], function()
		updateGlobalValue(true)
	end, false)
    GUIEditor.button[6] = guiCreateButton(48, 130, 28, 26, "-", false, GUIEditor.window[2])
	addEventHandler("onClientGUIClick", GUIEditor.button[6], function()
		updateGlobalValue(false)
	end, false)
	
	GUIEditor.button[7] = guiCreateButton(159, 184, 108, 27, "Reset", false, GUIEditor.window[2])    
	addEventHandler("onClientGUIClick", GUIEditor.button[7], function()
		exports.bone_attach:detachElementFromBone(object)
		setObjectScale(object, 1)
		objectpos = {0, 0, 0, 0, 0, 0, 1}
		positiontable = {0, 0, 0, 0, 0, 0, 0}
		for k,v in ipairs(GUIEditor.scrollbar) do
			guiScrollBarSetScrollPosition(v, 0)
		end
		exports.bone_attach:attachElementToBone(object, localPlayer, 1, 0, 0, 0, 0, 0, 0 )
	end, false)
	
	GUIEditor.label[4] = guiCreateLabel(215, 140, 32, 15, "Scale:", false, GUIEditor.window[2])
	
	GUIEditor.button[2] = guiCreateButton(16, 184, 108, 27, "Cancel", false, GUIEditor.window[2])
	addEventHandler("onClientGUIClick", GUIEditor.button[2], function()
		destroyElement(GUIEditor.window[2])
		destroyElement(object)
		objectpos = {0, 0, 0, 0, 0, 0, 1}
		positiontable = {0, 0, 0, 0, 0, 0, 0}
		showCursor(false)
		setCameraTarget(getLocalPlayer())
		setElementDimension(localPlayer, info["dimension"])
		setElementInterior(localPlayer, info["interior"])
		local px, py, pz = unpack(info["position"])
		setElementPosition(localPlayer, px, py, pz, true)
		
		setElementData(localPlayer, "wearable-system:active", false)
	end, false)
end

function updateGlobalValue(value)
	if value == true then
		x, y, z = 0.001, 0.001, 0.001
		rx, ry, rz = 1, 1, 1
		oc = 0.01
	elseif value == false then
		x, y, z = -0.001, -0.001, -0.001
		rx, ry, rz = -1, -1, -1
		oc = -0.01
	end
end

function update_position_scrollbars()
	if (GUIEditor.window[2]) then
	
		exports.bone_attach:detachElementFromBone(object)
		if source == GUIEditor.scrollbar[1] then
			local xscroll = guiScrollBarGetScrollPosition(GUIEditor.scrollbar[1])
			
			if xscroll > positiontable[1] then
				local currx = objectpos[1]
				objectpos[1] = currx + x
			elseif xscroll < positiontable[1] then
				local currx = objectpos[1]
				objectpos[1] = currx + x
			end
			
			if objectpos[1] > 1 or objectpos[1] < -1 then
				objectpos[1] = 0
			end
			
			positiontable[1] = xscroll
		elseif source == GUIEditor.scrollbar[6] then
			local yscroll = guiScrollBarGetScrollPosition(GUIEditor.scrollbar[6])
			
			if yscroll > positiontable[2] then
				local curry = objectpos[2]
				objectpos[2] = curry + y
			elseif yscroll < positiontable[2] then
				local curry = objectpos[2]
				objectpos[2] = curry + y
			end
			
			if objectpos[2] > 1 or objectpos[2] < -1 then
				objectpos[2] = 0
			end
			
			positiontable[2] = yscroll
		elseif source == GUIEditor.scrollbar[5] then
			local zscroll = guiScrollBarGetScrollPosition(GUIEditor.scrollbar[5])
			
			if zscroll > positiontable[3] then
				local currx = objectpos[3]
				objectpos[3] = currx + z
			elseif zscroll < positiontable[3] then
				local currx = objectpos[3]
				objectpos[3] = currx + z
			end
			
			if objectpos[3] > 1 or objectpos[3] < -1 then
				objectpos[3] = 0
			end
			
			positiontable[3] = zscroll
		elseif source == GUIEditor.scrollbar[4] then
			local rxscroll = guiScrollBarGetScrollPosition(GUIEditor.scrollbar[4])
			
			if rxscroll > positiontable[4] then
				local currrx = objectpos[4]
				objectpos[4] = currrx + rx
			elseif rxscroll < positiontable[4] then
				local currrx = objectpos[4]
				objectpos[4] = currrx + rx
			end
			
			if objectpos[4] > 360 or objectpos[4] < -360 then
				objectpos[4] = 0
			end
			
			positiontable[4] = rxscroll
		elseif source == GUIEditor.scrollbar[3] then
			local ryscroll = guiScrollBarGetScrollPosition(GUIEditor.scrollbar[3])
			
			if ryscroll > positiontable[5] then
				local currry = objectpos[5]
				objectpos[5] = currry + ry
			elseif ryscroll < positiontable[5] then
				local currry = objectpos[5]
				objectpos[5] = currry + ry
			end
			
			if objectpos[5] > 360 or objectpos[5] < -360 then
				objectpos[5] = 0
			end
			
			positiontable[5] = ryscroll
		elseif source == GUIEditor.scrollbar[2] then
			local rzscroll = guiScrollBarGetScrollPosition(GUIEditor.scrollbar[2])
			
			if rzscroll > positiontable[6] then
				local currrz = objectpos[6]
				objectpos[6] = currrz + rz
			elseif rzscroll < positiontable[6] then
				local currrz = objectpos[6]
				objectpos[6] = currrz + rz
			end
			
			if objectpos[6] > 360 or objectpos[6] < -360 then
				objectpos[6] = 0
			end
			
			positiontable[6] = rzscroll
		elseif source == GUIEditor.scrollbar[7] then
			local ocscroll = guiScrollBarGetScrollPosition(GUIEditor.scrollbar[7])
			
			if not (getObjectScale(object) > 1.50 or getObjectScale(object) < 0.50) then
				if ocscroll > positiontable[6] then
					local curroc = objectpos[7]
					objectpos[7] = curroc + oc
				elseif ocscroll < positiontable[6] then
					local curroc = objectpos[7]
					objectpos[7] = curroc + oc
				end
			else
				objectpos[7] = 1
			end
			
			positiontable[7] = ocscroll
		end
		
		setObjectScale(object, objectpos[7])
		
		--outputDebugString("x: " .. objectpos[1] .. " y: " .. objectpos[2] .. " z: " .. objectpos[3] .. " rx: " .. objectpos[4] .. " ry: " .. objectpos[5] .. " rz: " .. objectpos[6] .. " oc: " .. objectpos[7])
	
		exports.bone_attach:attachElementToBone(object, localPlayer, bone, objectpos[1], objectpos[2], objectpos[3], objectpos[4], objectpos[5], objectpos[6])
		
		--[[guiSetText(xtext, "x: "..x)
		guiSetText(ytext, "y: "..y)
		guiSetText(ztext, "z: "..z)
		guiSetText(rxtext, "rx: "..rx)
		guiSetText(rytext, "ry: "..ry)
		guiSetText(rztext, "rz: "..rz)]]

	end
end

function stopWiGUI()
	showCursor(false)
	destroyElement(GUIEditor.window[1])
	started = false
end

function bandanaManagement()
	local count = 0
	if startedbm == false then
		GUIEditor.window[3] = guiCreateWindow(364, 208, 321, 213, "MTA:RP - Bandana Management", false)
		guiWindowSetSizable(GUIEditor.window[3], false)

		GUIEditor.button[7] = guiCreateButton(15, 43, 90, 27, "Knot", false, GUIEditor.window[3])
		addEventHandler("onClientGUIClick", GUIEditor.button[7], function()
			for k,v in ipairs(btextures) do
				if getElementData(localPlayer, "item:" .. v["itemID"]) == 1 and not (currentpos == "knot") then
					currentpos = "knot"
					triggerServerEvent("wearable-system:updateBandanaPosition", localPlayer, "knot")
					break
				end
			end
		end, false)
		GUIEditor.button[8] = guiCreateButton(115, 43, 90, 27, "Head", false, GUIEditor.window[3])
		addEventHandler("onClientGUIClick", GUIEditor.button[8], function()
			for k,v in ipairs(btextures) do
				if getElementData(localPlayer, "item:" .. v["itemID"]) == 1 and not (currentpos == "head") then
					currentpos = "head"
					triggerServerEvent("wearable-system:updateBandanaPosition", localPlayer, "head")
					break
				end
			end
		end, false)
		GUIEditor.button[9] = guiCreateButton(215, 43, 90, 27, "Mask", false, GUIEditor.window[3])
		addEventHandler("onClientGUIClick", GUIEditor.button[9], function()
			for k,v in ipairs(btextures) do
				if getElementData(localPlayer, "item:" .. v["itemID"]) == 1 and not (currentpos == "mask") then
					currentpos = "mask"
					triggerServerEvent("wearable-system:updateBandanaPosition", localPlayer, "mask")
					break
				end
			end
		end, false)
		GUIEditor.button[10] = guiCreateButton(223, 180, 90, 26, "Close", false, GUIEditor.window[3])
		addEventHandler("onClientGUIClick", GUIEditor.button[10], function()
			stopBmGUI()
		end, false)
		GUIEditor.label[4] = guiCreateLabel(15, 80, 93, 28, "Default position:", false, GUIEditor.window[3])
		GUIEditor.combobox[2] = guiCreateComboBox(15, 108, 127, 95, "", false, GUIEditor.window[3])
		
		for k,v in ipairs(items) do
			count = count + 1
			if count > 6 then
				guiComboBoxAddItem( GUIEditor.combobox[2], v["name"] )
			end
		end
		GUIEditor.button[11] = guiCreateButton(146, 108, 79, 22, "Save", false, GUIEditor.window[3])
		addEventHandler ( "onClientGUIClick", GUIEditor.button[11],  function()
			local item = guiComboBoxGetSelected(GUIEditor.combobox[2])
			local text = guiComboBoxGetItemText(GUIEditor.combobox[2], item)
			
			if text == "" then return outputChatBox("Please select a item first!") end
			triggerServerEvent("wearable-system:updateDefaultPosition", localPlayer, text)
			destroyElement(GUIEditor.window[3])
			showCursor(false)
		end, false)
	else
		stopBmGUI()
	end
end
addCommandHandler("bandana", bandanaManagement)

function stopBmGUI()
	showCursor(false)
	destroyElement(GUIEditor.window[3])
	startedbm = false
end

-- Event handlers
addEvent("wearable-system:openWindow", true)
addEventHandler("wearable-system:openWindow", getRootElement(), startWiGUI)

--[[addEvent("wearable-system:recievePosition", true)
addEventHandler("wearable-system:recievePosition", getRootElement(), recievePosition)]]


-- BELOW IS OLD CRAP

--[[GUIEditor = {
	button = {},
	window = {},
	progressbar = {},
	label = {}
}

function startWearableGUI()
	if (started == false) then
		started = true
		showCursor(true)

		GUIEditor.window[1] = guiCreateWindow(405, 196, 451, 448, "Fusionz's Wearable System", false)
        guiWindowSetSizable(GUIEditor.window[1], false)

        GUIEditor.label[1] = guiCreateLabel(14, 417, 112, 15, "Version: 0.8.5 beta", false, GUIEditor.window[1])
        guiLabelSetColor(GUIEditor.label[1], 244, 10, 37)
        --GUIEditor.progressbar[1] = guiCreateProgressBar(107, 381, 119, 31, false, GUIEditor.window[1])

        --GUIEditor.label[2] = guiCreateLabel(91, 7, 59, 14, "37%", false, GUIEditor.progressbar[1])

        --GUIEditor.label[3] = guiCreateLabel(107, 356, 124, 15, "Progress:", false, GUIEditor.window[1])
        GUIEditor.label[4] = guiCreateLabel(0, 330, 451, 16, "_________________________________________________________________", false, GUIEditor.window[1])
        GUIEditor.label[5] = guiCreateLabel(13, 28, 428, 292, "Welcome to my menu. \nThis menu will tell you everything you need to know. \n______________________________________________________________\nThe items you are able to have attached (more to come):\n\n1. Helmet\n2. Duffelbag\n3. Backpack\n4. Briefcase\n5. Bottle - Applies for most of the alcoholic drinks\n6. Sprunk - Applies or the normal drinks\n7. Hamburger - Applies for most of the food items\n\nCommands:\n/throwbottle - Removes the bottle/drink object from your body\n/throwfood - Removes the food object from your body\n/eat - to eat your food\n/drink - to drink\n/dufleft or /briefleft - using this command will put the duffelbag/briefcase\nstraight on to your left hand while clicking it in your inventory\n\nYou can apply the object by just clicking on it in your inventory.", false, GUIEditor.window[1])
        GUIEditor.button[1] = guiCreateButton(341, 407, 100, 31, "Close", false, GUIEditor.window[1])
		addEventHandler("onClientGUIClick", GUIEditor.button[1], stopWearableGUI, false)
	elseif (started == true) then
		started = false
		destroyElement(GUIEditor.window[1])
		showCursor(false)	
	end
end
addCommandHandler("wearable", startWearableGUI)

function stopWearableGUI()
	showCursor(false)
	destroyElement(GUIEditor.window[1])
	started = false
end]]
