local sdata = {}

function savePosition(table)
	local witems = getElementData(source, "wearableitems")
	local found = false
	local count = 0
	
	if type(witems) == "table" then
		for k,v in pairs(table) do
			for wk,wv in pairs(witems) do
				if v == wv["name"] then
					wv["position"] = table["position"]; wv["default"] = table["default"]
					found = true
					break
				end
			end
		end
	end
	
	if found == false then
		if type(witems) ~= "table" then witems = {} end
		local newtable = {name = table["name"], itemID = table["itemID"], objectID = table["objectID"], bone = table["bone"], position = table["position"], default = table["default"]}
		
		count = tablelength(witems) + 1
		
		witems[count] = newtable
	end
	
	if exports.mysql:query_free("UPDATE characters SET witems = '" .. exports.mysql:escape_string( toJSON( witems ) ) .. "' WHERE id = " .. exports.mysql:escape_string( getElementData( source, "dbid" ) ) ) then
		outputChatBox( "[!]#ffffff Posição do acessório salva com sucesso!", source, 0, 255, 0,true)
		exports.anticheat:changeProtectedElementDataEx( source, "wearableitems", witems, false)
	else
		outputChatBox( "salvo com sucesso!", source, 255, 0, 0 )
	end
end
addEvent("wearable-system:savePosition", true)
addEventHandler("wearable-system:savePosition", getRootElement(), savePosition)

function requestPosition(itemID, itemName)
	local witems = getElementData(source, "wearableitems")
	local positiontable = nil
	local found = false
	
	removeData(source)
	
	exports.global:sendMessageToAdmins(getPlayerName(source):gsub("_", " ") .. " aksesuar pozisyonunu ayarlıyor!")
	
	if type(witems) == "table" then
		for k, v in pairs(witems) do
			if v["name"] == itemName then
				positiontable = v
			
				found = true
				break
			end
		end
	end
	
	if found == false then
		return
	end
	
	local numbertable = {1, 2, 3, 4, 5, 6}
	local count = 0
	
	for i = 1, #numbertable do
		count = count + 1 
	
		if positiontable["position"][i] > 0 or positiontable["position"][i] < 0 then
	
			local position = positiontable["position"]
	
			triggerClientEvent(source, "wearable-system:recievePosition", source, position)
			break
		else
			if count == 6 then -- stop at rz
				triggerClientEvent(source, "wearable-system:recievePosition", source, false)
				break
			end
		end
	end
end
addEvent("wearable-system:requestPosition", true)
addEventHandler("wearable-system:requestPosition", getRootElement(), requestPosition)

function storeClientData(data)
	sdata[source] = data
end
addEvent("wearable-system:updateSData", true)
addEventHandler("wearable-system:updateSData", getRootElement(), storeClientData)

function quitCheck()
	if getElementData(source, "wearable-system:active") == true then -- for if they quit the game while being in the position mode
		
		local dimension = sdata[source]["dimension"]
		local interior = sdata[source]["interior"]
		local px, py, pz = unpack(sdata[source]["position"])
		
		mysql:query_free("UPDATE characters SET x='".. mysql:escape_string(tostring(px)) .."', y='".. mysql:escape_string(tostring(py)) .. "', z='".. mysql:escape_string(tostring(pz)) .."', dimension_id='".. mysql:escape_string(tostring(dimension)) .."', interior_id='".. mysql:escape_string(tostring(interior)) .."' WHERE id='" .. mysql:escape_string(getElementData(source, "account:character:id")) .. "' LIMIT 1")
	
		sdata[source] = nil
	end
end
addEventHandler("onPlayerQuit", getRootElement(), quitCheck)

function resourceStartCheck(source)
	if getElementData(source, "wearable-system:active") == true then
		
		local dimension = 0
		local interior = 0
		local interiorfix = 1
		local px, py, pz = 1551.3505859375, -1723.48046875, 13.546875 -- next to LSPD
		
		setElementData(source, "wearable-system:active", false)
		
		setElementInterior(source, interiorfix) -- settings the interior twice; client/server side interior bug
		setElementInterior(source, interior)
		setElementDimension(source, dimension)
		setElementPosition(source, px, py, pz, true)
		
		setCameraTarget(source)
		
		outputChatBox("The wearable system resource has been restarted, so you have been set to a safe location.", source, 255, 194, 14)
	end
end

function checkAllPlayers()
	for k,v in ipairs(getElementsByType("player")) do
		resourceStartCheck(v)
	end
end

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), checkAllPlayers)

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function openClientGUIWindow(thePlayer)
	local legitimatetable = {"Whoever", "is", "trying", 0101010101, "to", "fix", "this", "w-active", "check", 1337, "is", "a", "fucking", "faggot"}

	triggerClientEvent(thePlayer, "wearable-system:openWindow", thePlayer, legitimatetable)
end
addCommandHandler("aksesuar", openClientGUIWindow)

function setDefaultPos(text)
	local itemName = text
	local witems = getElementData(source, "wearableitems")
	
	if type(witems) == "table" then
		for k,v in pairs(witems) do
			if (string.find(string.lower(v["name"]), "bandana") and itemName ~= v["name"]) then
				v["default"] = false
			end
			if itemName == v["name"] then
				v["default"] = true
				found = true
				break
			end
		end
	end
	
	if found == true then
		if exports.mysql:query_free("UPDATE characters SET witems = '" .. exports.mysql:escape_string( toJSON( witems ) ) .. "' WHERE id = " .. exports.mysql:escape_string( getElementData( source, "dbid" ) ) ) then
			outputChatBox( "You successfully updated your default position for your bandana!", source, 0, 255, 0 )
			exports.anticheat:changeProtectedElementDataEx( source, "wearableitems", witems, false)
		else
			outputChatBox( "Failed to set data. (SQL Error)", source, 255, 0, 0 )
		end
	end
end
addEvent("wearable-system:updateDefaultPosition", true)
addEventHandler("wearable-system:updateDefaultPosition", getRootElement(), setDefaultPos)

local bname = { ["head"]="Bandana (Head)", ["mask"]="Bandana (Mask)", ["knot"]="Bandana (Knot)" }

function setBandanaPos(text)

	for k,v in ipairs(btextures) do
		local itemID = v["itemID"]
		if getElementData(source, "item:" .. itemID) == 1 then
			local itemName = bname[text]
			
			if isElement(newitems[itemID][source]) then
				exports.bone_attach:detachElementFromBone(newitems[itemID][source])
				destroyElement(newitems[itemID][source])
				newitems[itemID][source] = nil
			end
			
			if exports.global:hasItem(source, itemID) then
				wearablePositionCheck(source, itemID, itemName, true)
			end
			
			break
		end
	end
end
addEvent("wearable-system:updateBandanaPosition", true)
addEventHandler("wearable-system:updateBandanaPosition", getRootElement(), setBandanaPos)

function createTable(thePlayer, commandName)
	if exports.integration:isPlayerLeadAdmin(thePlayer) then
		local firstquery = exports.mysql:query_free("SELECT witems FROM characters WHERE id = '1'")
		if not firstquery then
			local query = exports.mysql:query_free("ALTER TABLE characters ADD COLUMN witems TEXT DEFAULT NULL")
			if query then
				outputChatBox("Created column successfully", thePlayer)
			end
		end
	end
end
addCommandHandler("createWearableTable", createTable)

