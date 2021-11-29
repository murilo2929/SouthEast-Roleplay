-- function startBackpack(source)
	-- if (getResourceState(getResourceFromName("bone_attach")) == "running") then
		-- setTimer ( function()
			-- if (exports.global:hasItem(source, 48)) then
				-- if (getElementData(source, "backpack") ~= 1) then
					-- if not (backpacknormal[getElementModel(source)]) then 
						-- setElementDataEx(source, "backpack", 1, false)
						-- bpack = createObject(3026, 0, 0, 0)
						-- exports.bone_attach:attachElementToBone(bpack, source, 3, 0.12, -0.11, 0.03, 10.02, -10, 18)
						-- backpack[source] = bpack
						-- wearableCheckDimension (source, getElementDimension(source), getElementInterior(source))
					-- else
						-- setElementDataEx(source, "backpack", 1, false)
						-- setElementData(source, "hud:backpack", 1)
					-- end			
				-- end
			-- else
				-- outputChatBox("You do not have a backpack!", source, 255, 0, 0)
			-- end
		-- end, 500, 1 ) -- some compensation
	-- else
		-- outputChatBox("ERROR #342-E: bone_attach resource is not running!", source, 255, 0, 0)
	-- end
-- end
-- addEvent("attachBackpackServer", true)
-- addEventHandler("attachBackpackServer", getRootElement(), startBackpack)

-- returns the tables and a string for the element data

function returnObject(itemID)
	if (itemID == 90) then
		return helmets, "helmets"
	elseif (itemID == 156) then
		return briefcase, "briefcase", briefcase2, "deletebrief"
	elseif (itemID == 216) then
		return duffelbag, "duffelbag", duffelbag2, "deleteduffel"
	-- elseif (itemID == 48) then
		-- return backpack, "backpack"
	elseif (isNewItem(itemID)) then
		return newitems[itemID], "item:" .. itemID
	else
		return nil, nil
	end
end

-- this is the main function, its being triggered by the item-system

function triggerWearableSystem(source, itemID, itemSlot)
	if (getResourceState(getResourceFromName("bone_attach")) == "running") then
		if (getElementType(source) == "player") then
			if (itemID) then
			
			setElementDataEx(source, "slot", itemSlot, false)
				
				if (getPedWeapon(source) > 0 and not (itemID == 16 or itemID == 90)) then 
					outputChatBox("Desculpe amigo, você não pode usar este item agora, desequipe sua arma primeiro.", source, 255, 0, 0) 
					if (foodtable[itemID] or drinktable[itemID]) then
						exports.global:giveItem(source, itemID, 1) 
					end
					return 
				end
				
				if (masks[itemID] and not isNewItem(itemID)) then
					local data = masks[itemID]
					local mask = getElementData(source, data[1])
				
					if (mask) then
						if (itemID == 90) then
							if (getElementData(source, "helmets") == 1) then
								setElementDataEx(source, "helmets", 0, false)
								exports.bone_attach:detachElementFromBone(helmets[source])
								destroyElement(helmets[source])
								helmets[source] = nil
							end
						else
							return
						end
					else
						if (itemID == 90) then
							if (getElementData(source, "helmets") ~= 1) then
								if isNewItemAttached(source, 1) then return end
								
								local skinplayer = getElementModel( source )
								if skins[skinplayer] then
									setElementDataEx(source, "helmets", 1, false)
									helmet = createObject(2053, 0, 0, 0)
									setObjectScale(helmet, 1.235)
									setElementDoubleSided(helmet, true)
									exports.bone_attach:attachElementToBone(helmet, source, 1, 0, -0.01, -0.76, 0, 0, 90)
									helmets[source] = helmet
								elseif skinsfix[skinplayer] then
									setElementDataEx(source, "helmets", 1, false)
									helmet = createObject(2053, 0, 0, 0)
									setObjectScale(helmet, 1.265)
									setElementDoubleSided(helmet, true)
									exports.bone_attach:attachElementToBone(helmet, source, 1, 0, -0.03, -0.75, 0, 0, 90)
									helmets[source] = helmet
								else
									outputChatBox("O capacete não é compatível com a sua pele!", source, 255, 0, 0)
								end
							end
						else
							return
						end
					end
				end
				if (itemID == 16) then -- a check, so you wont able to put on the helmet with a non-compatible clothing when clothes are changed
					local data2 = masks[90]
					if (getElementData(source, "helmets") == 1) then
						setElementDataEx(source, "helmets", 0, false)
						exports.bone_attach:detachElementFromBone(helmets[source])
						destroyElement(helmets[source])
						helmets[source] = nil
						exports.anticheat:changeProtectedElementDataEx(source, data2[1], false, true)
					end
				elseif (itemID == 58 or itemID == 62 or itemID == 63) then
					if not (briefcase[source] or duffelbag[source] or food[source] or bottle[source]) then
						if (getElementData(source, "bottle") ~= 1) then
							setElementDataEx(source, "bottle", 1, false)
							setElementDataEx(source, "drinkitem", itemID, false)
							obottle = createObject(1484, 0, 0, 0)
							exports.bone_attach:attachElementToBone(obottle, source, 12, 0.03, 0.135, 0.11, 136, -39.98, -29)
							bottle[source] = obottle
							outputChatBox("İçmek için /icecek komutunu kullanın.", source, 255, 50, 0)
							setElementDataEx(source, "drank", math.random(0.1, 0.5), true)
						end
					else
						outputChatBox("Sorry, we currently are not allowing to have the bottle attached whilst having other objects attached.", source, 255, 255, 255)
						exports.global:giveItem(source, itemID, 1)
					end
				elseif (itemID == 9 or itemID == 15 or itemID == 101 or itemID == 101 or itemID == 179 or itemID == 180) then
					if not (briefcase[source] or duffelbag[source] or food[source] or bottle[source]) then
						if (getElementData(source, "bottle") ~= 1) then
							setElementDataEx(source, "normaldrink", 1, false)
							setElementDataEx(source, "bottle", 1, false)
							setElementDataEx(source, "drinkitem", itemID, false)
							odrink = createObject(2647, 0, 0, 0)
							setObjectScale(odrink, 0.6)
							exports.bone_attach:attachElementToBone(odrink, source, 12, 0, 0.05, 0.04, 0, 240, 0)
							bottle[source] = odrink
							outputChatBox("İçmek için /icecek komutunu kullanın.", source, 255, 50, 0)
							setElementDataEx(source, "drank", math.random(0.1, 0.5), false)
							setTimer ( function()
							exports.bone_attach:attachElementToBone(odrink, source, 11, 0, 0.05, 0.04, 0, 240, 0)
							end, 4300, 1 )
						end
					else
						outputChatBox("Üzgünüz, elinizde başka objeler varken birşeyler içemezsiniz.", source, 255, 0, 0)
						exports.global:giveItem(source, itemID, 1)
					end
				elseif (foodtable[itemID]) then
					if not (briefcase[source] or duffelbag[source] or bottle[source] or food[source]) then
						if (getElementData(source, "food") ~= 1) then
							setElementDataEx(source, "food", 1, false)
							setElementDataEx(source, "fooditem", itemID, false)
							ofood = createObject(2880,0,0,0)
							exports.bone_attach:attachElementToBone(ofood, source, 12, 0, 0, 0, 0, -90, 0)
							food[source] = ofood
							outputChatBox("Yemek için /yiyecek komutunu kullanın.", source, 0, 255, 0)
							setElementDataEx(source, "eaten", math.random(0.1, 0.5), true)
						end
					else
						outputChatBox("Üzgünüz, elinizde başka objeler varken yemek yiyemezsiniz.", source, 255, 0, 0)
						exports.global:giveItem(source, itemID, 1)
					end
				elseif (itemID == 156) then
					if (getElementData(source, "briefcase")) ~= 1 and not (bottle[source] or food[source]) then
						if (duffelbag[source]) then
							if (getElementData(source, "duffelleft") == 1) then
								setElementDataEx(source, "briefcase", 1, false)
								case = createObject(1210, 0, 0, 0)
								exports.bone_attach:attachElementToBone(case, source, 12, 0, 0, 0, 0, -100, 0)
								briefcase[source] = case
							else
								if not (duffelbag2[source]) then
									setElementDataEx(source, "briefcase", 1, false)
									setElementDataEx(source, "briefcaseleft", 1, false)
									case = createObject(1210, 0, 0, 0)
									exports.bone_attach:attachElementToBone(case, source, 11, 0.05, -0.01, 0, 0, -100, -2)
									briefcase[source] = case
								end
							end
						else
							if (getElementData(source, "briefleft") == 1) then
								if not (duffelbag2[source]) then
									setElementDataEx(source, "briefcase", 1, false)
									setElementDataEx(source, "briefcaseleft", 1, false)
									case = createObject(1210, 0, 0, 0)
									exports.bone_attach:attachElementToBone(case, source, 11, 0.05, -0.01, 0, 0, -100, -2)
									briefcase[source] = case
									setElementDataEx(source, "briefleft", 0, false)
									setElementDataEx(source, "weaponenabled", 1, false)
								end
							else
								setElementDataEx(source, "briefcase", 1, false)
								case = createObject(1210, 0, 0, 0)
								exports.bone_attach:attachElementToBone(case, source, 12, 0, 0, 0, 0, -100, 0)
								briefcase[source] = case
							end
						end
					elseif (getElementData(source, "briefcase") == 1) then
						local check = secondItem(source, itemID, 2)
						if (check == true) then
							return
						end
						setElementDataEx(source, "briefcase", 0, false)
						setElementDataEx(source, "briefcaseleft", 0, false)
						exports.bone_attach:detachElementFromBone(briefcase[source])
						destroyElement(briefcase[source])
						briefcase[source] = nil
						setElementDataEx(source, "briefdestroyed", 1, false)
						if duffelbag[source] then --[[nothing]] else setElementDataEx(source, "weaponenabled", 0, false) end
						if (getElementData(source, "briefdestroyed") == 1 and getElementData(source, "duffelbag") == 0 and getElementData(source, "duffelleft") == 0  ) then
							if (briefcase2[source]) then
								exports.bone_attach:detachElementFromBone(briefcase2[source])
								destroyElement(briefcase2[source])
								briefcase2[source] = nil
								setElementDataEx(source, "deletebrief", 0, false)
							end
						end
					else
						outputChatBox("Sorry, we currently are not allowing to have the briefcase object attached whilst having food/drink objects attached.", source, 255, 0, 0)
					end
				elseif (itemID == 216) then
					if (getElementData(source, "duffelbag") ~= 1) and not (bottle[source] or food[source]) then
						if (briefcase[source]) then
							if (getElementData(source, "briefcaseleft") == 1) then
								duffel = createObject(1550, 0, 0, 0)
								exports.bone_attach:attachElementToBone(duffel, source, 12, 0, -0.03, 0, -17, -92.8, 14)
								duffelbag[source] = duffel
								setElementDataEx(source, "duffelbag", 1, false)
							else
								if not (briefcase2[source]) then
									setElementDataEx(source, "duffelbag", 1, false)
									setElementDataEx(source, "duffelleft", 1, false)
									duffel = createObject(1550, 0, 0, 0)
									exports.bone_attach:attachElementToBone(duffel, source, 11, 0, -0.03, 0, -17, -94.8, -32)
									duffelbag[source] = duffel
								end
							end
						else
							if (getElementData(source, "dufleft") == 1) then
								if not (briefcase2[source]) then
									setElementDataEx(source, "duffelbag", 1, false)
									setElementDataEx(source, "duffelleft", 1, false)
									duffel = createObject(1550, 0, 0, 0)
									exports.bone_attach:attachElementToBone(duffel, source, 11, 0, -0.03, 0, -17, -94.8, -32)
									duffelbag[source] = duffel
									setElementDataEx(source, "dufleft", 0, false)
									setElementDataEx(source, "weaponenabled", 1, false)
								end
							else
								setElementDataEx(source, "duffelbag", 1, false)
								duffel = createObject(1550, 0, 0, 0)
								exports.bone_attach:attachElementToBone(duffel, source, 12, 0, -0.03, 0, -17, -92.8, 14)
								duffelbag[source] = duffel		
							end
						end
					elseif (getElementData(source, "duffelbag") == 1) then
						local check = secondItem(source, itemID, 1)
						if (check == true) then
							return
						end
						setElementDataEx(source, "duffelbag", 0, false)
						setElementDataEx(source, "duffelleft", 0, false)
						exports.bone_attach:detachElementFromBone(duffelbag[source])
						destroyElement(duffelbag[source])
						setElementDataEx(source, "duffeldestroyed", 1, false)
						duffelbag[source] = nil
						if briefcase[source] then --[[nothing]] else setElementDataEx(source, "weaponenabled", 0, false) end
						if (getElementData(source, "duffeldestroyed") == 1 and getElementData(source, "briefcase") == 0 and getElementData(source, "briefcaseleft") == 0  ) then
							if (duffelbag2[source]) then
								exports.bone_attach:detachElementFromBone(duffelbag2[source])
								destroyElement(duffelbag2[source])
								duffelbag2[source] = nil
								setElementDataEx(source, "deleteduffel", 0, false)
							end
						end
					else
						outputChatBox("Sorry, we currently are not allowing to have the duffelbag object attached whilst having food/drink objects attached.", source, 255, 0, 0)
					end
				elseif isNewItem(itemID) then
					if getElementData(source, "item:" .. itemID) == 1 then
						setElementDataEx(source, "item:" .. itemID, 0, false)
						exports.bone_attach:detachElementFromBone(newitems[itemID][source])
						destroyElement(newitems[itemID][source])
						newitems[itemID][source] = nil
					else
						wearablePositionCheck(source, itemID)
					end
				end	
			wearableCheckDimension (source, getElementDimension(source), getElementInterior(source))
			else
				return 
			end
		end
	else
		outputChatBox("ERROR #342-E: bone_attach resource is not running!", source, 255, 0, 0)
	end
end

local bandana = { ["157"]=0, ["158"]=0, ["159"]=0, ["160"]=0, ["161"]=0, ["162"]=0, ["163"]=0 }

function isNewItemAttached(source, bone) -- check if the new item is attached according to the bone position
	local itemID = nil
	local found = false
	bone = tonumber(bone)
	
	for k, v in pairs(newitems) do
		if v[source] then
		
			itemID = k
			for k,v in pairs(items) do 
				if v["itemID"] == itemID or v["itemID"] == bandana[tostring(itemID)] then
					if v["bone"] == bone then
						found = true
						break
					end
				end
			end
		end
	end
	
	if found == true then return true end
end

function isNewItem(itemID)
	local check = false
	for k, v in pairs(items) do
		if v["itemID"] == itemID or v["itemID"] == bandana[tostring(itemID)] then
			check = true
			break
		end
	end
	
	--[[if string.find(string.lower(exports.global:getItemName(itemID)), "bandana") then
		check = true
	end]]
	
	if check == true then return true end
end

local bandanaed = {"rband", "bband", "yband", "gband", "wband", "blband", "pband"}
local glasses = { ["242"]=-1, ["243"]=-1, ["244"]=-1, ["245"]=-1, ["246"]=-1, ["247"]=-1, ["248"]=-1, ["249"]=-1, ["250"]=-1 }

function wearablePositionCheck(source, itemID, optional, optional2)
	local witems = getElementData(source, "wearableitems")
	local positiontable = nil
	local found = false
	local name = optional
	local bed = false
	
	if type(witems) == "table" then
		for k,v in pairs(witems) do
			if optional2 == true then
				if (v["itemID"] == bandana[tostring(itemID)] and v["name"] == name) then
					positiontable = v
			
					found = true
					break
				end
			else
				if v["itemID"] == itemID or (v["itemID"] == bandana[tostring(itemID)] and v["default"] == true) then
					positiontable = v
			
					found = true
					break
				end
			end
		end
	end
	
	if found == false then
		for k, v in ipairs(btextures) do 
			if v["itemID"] == itemID then return end
		end
		for k, v in ipairs(gtextures) do 
			if v["itemID"] == itemID then return end
		end
		outputChatBox("Você não configurou este item para o seu personagem, você pode configurá-lo com o comando '/acessorio'.", source, 255, 0, 0)
		return
	end
	
	local objectID = positiontable["objectID"]
	local bone = positiontable["bone"]
	local x,y,z,rx,ry,rz,oc = unpack(positiontable["position"])
	
	local numbertable = {1, 2, 3, 4, 5, 6}
	local count = 0
	
	for i = 1, #numbertable do
		count = count + 1 
		
		if positiontable["position"][i] > 0 or positiontable["position"][i] < 0 then
			
			
			if bone == 1 and getElementData(source, "helmets") == 1 then
				return
			end
			
			--if isNewItemAttached(source, 1) then return end
			
			for i = 1, #bandanaed do
				if getElementData(source, bandanaed[i]) == true then
					if optional2 == nil or optional2 == false then
						bed = true
					end
				end
			end
			
			if bandana[tostring(itemID)] then
				if bed then return end
			end
			
			setElementDataEx(source, "item:" .. itemID, 1, false)
			local witem = createObject(objectID,0,0,0)
			exports.bone_attach:attachElementToBone(witem, source, bone, x, y, z, rx, ry, rz)
			setObjectScale(witem, oc)
			if type(newitems[itemID]) ~= "table" then newitems[itemID] = {} end
			newitems[itemID][source] = witem
			
			if bandana[tostring(itemID)] then
				for k, v in ipairs(btextures) do
					if v["itemID"] == itemID then
						btexturename = v["texture"]
						
						if btexturename == "default" then return end
						
						--outputChatBox("APPLY TEXTURE SERVER")
						local data = {witem, btexturename}
						
						setElementData(source, "item:texture", data)
						
						triggerClientEvent("wearable-system:applyTexture", source, nil, data)
						break
					end
				end
			end
			
				if glasses[tostring(itemID)] then
				for k, v in ipairs(gtextures) do
					if v["itemID"] == itemID then
						btexturename = v["texture"]
						
						if btexturename == "gblk" then return end
						
						--outputChatBox("APPLY TEXTURE SERVER")
						local data = {witem, btexturename}
						
						setElementData(source, "item:texture", data)
						
						triggerClientEvent("wearable-system:applyTexture", source, nil, data)
						break
					end
				end
			end
			
			break
		else
			if count == 6 then
				for k, v in ipairs(btextures) do 
					if v["itemID"] == itemID then return end
				end
				for k, v in ipairs(gtextures) do 
					if v["itemID"] == itemID then return end
				end
				outputChatBox("Você ainda não editou este item, você pode editá-lo usando o comando '/acessorio'.", source, 255, 0, 0)
				break
			end
		end
	end
	
end

function secondItem(source, itemID, number)
	returnItem(source, itemID, 2)
	
	if (number == 1) then
		if (getElementData(source, "twoduffelbag") == 1 and not briefcase[source] and getElementData(source, "duffelleft") == 0) then
			duffelsecond = createObject(1550, 0, 0, 0)
			exports.bone_attach:attachElementToBone(duffelsecond, source, 11, 0, -0.03, 0, -17, -94.8, -32)
			duffelbag2[source] = duffelsecond
			setElementDataEx(source, "deleteduffel", 1, false)
			setElementDataEx(source, "twoduffelbag", 0, false)
			wearableCheckDimension (source, getElementDimension(source), getElementInterior(source))
			return true
		else
			return false
		end
	elseif (number == 2) then
		if (getElementData(source, "twobriefcase") == 1 and not duffelbag[source] and getElementData(source, "briefcaseleft") == 0) then
			casesecond = createObject(1210, 0, 0, 0)
			exports.bone_attach:attachElementToBone(casesecond, source, 11, 0.05, -0.01, 0, 0, -100, -2)
			briefcase2[source] = casesecond
			setElementDataEx(source, "deletebrief", 1, false)
			setElementDataEx(source, "twobriefcase", 0, false)
			wearableCheckDimension (source, getElementDimension(source), getElementInterior(source))
			return true
		else
			return false
		end
	end
end

function leftHand(source, commandName)
	local logged = getElementData(source, "loggedin")
	
	if not (logged==1) then
		return
	end
	
	if (getElementData(source, commandName) == 1) then return end
	setElementDataEx(source, commandName, 1, false)
	if (commandName == "dufleft") then
		outputChatBox("You have chosen to have the duffelbag attached on to your left hand, click the item in your inventory to take effect.", source, 0, 255, 0)
	elseif (commandName == "briefleft") then
		outputChatBox("You have chosen to have the briefcase attached on to your left hand, click the item in your inventory to take effect.", source, 0, 255, 0)
	end
end
addCommandHandler("dufleft", leftHand)
addCommandHandler("briefleft", leftHand)

function returnItem(source, item, check)
	local items = exports['item-system']:getItems( source )
	local x, y, z = getElementPosition(source)
	local rot = getPedRotation(source)
	local number = 0
	local slotcorrection = 0
	x = x + math.sin(math.rad(-rot)) * 2
	y = y + math.cos(math.rad(-rot)) * 2
	
	if (getElementData(source, "deleteduffel") == 1) then
		return
	end
	
	if (getElementData(source, "deletebrief") == 1) then
		return
	end
	
	
	for itemSlot, itemCheck in ipairs(items) do
		if (itemCheck[1] == item) then
			if (check == 1) then
				triggerEvent("dropItem", source, itemSlot, x, y, z-1)
				break
			end
			if (check == 3) then 
				local wearableString = string.sub(itemCheck[2], -11)
				if wearableString == " (wearable)" then
					triggerEvent("dropItem", source, itemSlot - slotcorrection, x, y, z-1)
					slotcorrection = slotcorrection + 1
				end
			end
			if (check == 2) then
				if (getElementData(source, "duffelbag") == 1 and getElementData(source, "briefcase") == 0) then
					number = number + 1
					if (number == 2) then
						setElementDataEx(source, "twoduffelbag", 1, false)
						break
					end
				end
			end
			if (check == 2) then
				if (getElementData(source, "briefcase") == 1 and getElementData(source, "duffelbag") == 0) then
					number = number + 1
					if (number == 2) then
						setElementDataEx(source, "twobriefcase", 1, false)
						break
					end
				end
			end
		end
	end
end

-- checks

function checkForSkinChange(oldModel, newModel)
    if ( getElementType(source) == "player" ) then
        if (getElementData(source, "helmets") == 1) then
			local data = masks[90]
			if not (skins[newModel]) then
				outputChatBox("Your player model has been changed to skin ID: "..newModel .." which is not compatible with the helmet, it has been un-attached.", source, 255, 0, 0)
				setElementDataEx(source, "helmets", 0, false)
				exports.bone_attach:detachElementFromBone(helmets[source])
				destroyElement(helmets[source])
				helmets[source] = nil
				exports.anticheat:changeProtectedElementDataEx(source, data[1], false, true)
			end
		end
		-- if (getElementData(source, "backpack") == 1 and getElementData(source, "hud:backpack") ~= 1) then
			-- setElementDataEx(source, "backpack", 0, false)
			-- exports.bone_attach:detachElementFromBone(backpack[source])
			-- destroyElement(backpack[source])
			-- backpack[source] = nil
			-- startBackpack(source)
		-- elseif (getElementData(source, "hud:backpack") == 1) then
			-- setElementData(source, "hud:backpack", 0)
			-- setElementData(source, "backpack", 0)
			-- startBackpack(source)
		-- end
	end
end
addEventHandler("onElementModelChange", root, checkForSkinChange)

function enterVehicle (source)
    if (getElementData(source, "duffelbag") == 1) then
		setElementDataEx(source, "duffelbag", 0, false)
		setElementDataEx(source, "duffelleft", 0, false)
		exports.bone_attach:detachElementFromBone(duffelbag[source])
		destroyElement(duffelbag[source])
		setElementDataEx(source, "duffeldestroyed", 1, false)
		duffelbag[source] = nil
		if (duffelbag2[source] and getElementData(source, "briefcase") == 0 and getElementData(source, "briefcaseleft") == 0  ) then
			exports.bone_attach:detachElementFromBone(duffelbag2[source])
			destroyElement(duffelbag2[source])
			duffelbag2[source] = nil
			setElementDataEx(source, "deleteduffel", 0, false)
		end
	end
	if (getElementData(source, "briefcase") == 1) then
		setElementDataEx(source, "briefcase", 0, false)
		setElementDataEx(source, "briefcaseleft", 0, false)
		exports.bone_attach:detachElementFromBone(briefcase[source])
		destroyElement(briefcase[source])
		briefcase[source] = nil
    end
end
addEventHandler ( "onVehicleEnter", getRootElement(), enterVehicle )

function checkWearableItem(element, itemID)
	local object,itemname, additional, additional2 = returnObject(itemID)
	if (itemname == nil) then
		return
	end
	
	if (itemID == 156 or itemID == 216) then
		if (getElementData(element, additional2) == 1) then -- prevent an error
			if (additional[element]) then
				setElementDataEx(element, additional2, 0, false)
				exports.bone_attach:detachElementFromBone(additional[element])
				destroyElement(additional[element])
				additional[element] = nil
			end
		end
	end
	
	if type(object) ~= "table" then return end
	
	-- if (object[element] or (getElementData(element, itemname) == 1)) then -- needs to be done better
		-- if (object[element]) then
			-- triggerClientEvent("errorCheck", element)
			-- setElementDataEx(element, itemname, 0, false)
			-- exports.bone_attach:detachElementFromBone(object[element])
			-- destroyElement(object[element])
			-- object[element] = nil
		-- else
			-- if (itemID == 48 and getElementData(element, "hud:backpack") == 1) then setElementData(element, "hud:backpack", 0) return end
			-- setElementDataEx(element, itemname, 0, false)
			-- outputChatBox("Your wearable object was bugged, it has been fixed.", element, 0, 255, 0)
		-- end
	-- elseif (getElementData(element, "backpack") == 0) then
		-- startBackpack(element)
	-- end
end

local checked = false
function wearableCheckDimension (thePlayer, newdim, newint)
--	exports["realism-system"]:checkDimension(thePlayer, newdim, newint)

		for _,v in pairs(rootTable) do
			if v[thePlayer] then
				if (checked == false) then
					if not (isElement(v[thePlayer])) then
						removeData(thePlayer) -- to prevent debug errors
						outputDebugString("WearableCheckDimension: This is not a element: " .. tostring(v[thePlayer]) .. " - Owner: " .. getPlayerName(thePlayer))
						checked = true
					end
				end
				local dim = getElementDimension (v[thePlayer])
				local int = getElementInterior (v[thePlayer])
				--outputDebugString("serverside objectdim: " .. getElementDimension (v[thePlayer]) .. " - playerdim: " .. getElementDimension(thePlayer) .. " - " .. newdim )
				--outputDebugString("serverside objectint: " .. getElementInterior (v[thePlayer]) .. " - playerint: " .. getElementInterior(thePlayer) .. " - " .. newint)
				if (dim ~= newdim) then
					setElementDimension (v[thePlayer], newdim)
				end
				if (int ~= newint) then
					setElementInterior(v[thePlayer], newint)
				end
			end
		end
		
		for k, v in pairs(newitems) do -- for the new items
			if v[thePlayer] then
				local dim = getElementDimension (v[thePlayer])
				local int = getElementInterior (v[thePlayer])
			
				if (dim ~= newdim) then
					setElementDimension (v[thePlayer], newdim)
				end
				if (int ~= newint) then
					setElementInterior(v[thePlayer], newint)
				end
			end
		end
		
	end
addEvent("wearableCheckDimension", true)
addEventHandler("wearableCheckDimension", getRootElement(), wearableCheckDimension)

function onJoin()	
	removeData(source)
end
addEventHandler("onPlayerJoin", getRootElement(), onJoin)

function resourceStart(source)	
	removeData(source)
	for _,player in ipairs(getElementsByType("player")) do
		-- triggerEvent("attachBackpackServer", player, player)
	end
end
addEventHandler("onResourceStart", resourceRoot, resourceStart)

addEventHandler("accounts:characters:change", root,
function ()		
		removeData(source)
end)

addEventHandler("onPlayerQuit", root,
function ()
		removeData(source)
end)

-- end of checks

function disappearItems(source, alternative)
	if alternative ~= nil then
		invisible = alternative
	else
		invisible = getElementData(source, "invisible")
	end
	if (invisible == true) then
		for _,v in pairs(rootTable) do
			if v[source] then
				setElementAlpha(v[source], 0)
			end
		end
		for _, v in pairs(newitems) do
			if v[source] then
				setElementAlpha(v[source], 0)
			end
		end
	else
		for _,v in pairs(rootTable) do
			if v[source] then
				setElementAlpha(v[source], 255)
			end
		end
		for _, v in pairs(newitems) do
			if v[source] then
				setElementAlpha(v[source], 255)
			end
		end
	end
end

function removeData(source)
	if (source == resource) then
		for _,v in pairs(rootTable) do
			if (type(v[1]) ~= "string") then
				v = nil
				table.remove(rootTable, v)
			end
		end
		for _,player in ipairs(getElementsByType("player")) do -- not a better check for it atm
			for _, v in ipairs(items) do
				setElementDataEx(player, "item:" .. v["itemID"], 0, false)
			end
			for k, v in pairs(bandana) do
				setElementDataEx(player, "item:" .. k, 0, false)
			end
		end
	else
		for _, v in ipairs(items) do
			setElementDataEx(source, "item:" .. v["itemID"], 0, false)
		end
		for k, v in pairs(bandana) do
			setElementDataEx(source, "item:" .. k, 0, false)
		end
		for k, v in pairs(newitems) do -- for the new items
			if v[source] then
				destroyElement(v[source])
				v[source] = nil
				table.remove(rootTable, v[source])
			end
		end
		for _,v in pairs(rootTable) do
			if v[source] then
				destroyElement(v[source])
				v[source] = nil
				table.remove(rootTable, v[source])
			end
		end
	end
end

-- if the system is bugged use this

function bugFix(thePlayer)
	if not exports.global:isPlayerScripter(thePlayer) then
		return
	end
	
	for _,v in ipairs(getElementsByType("player")) do
		removeData(v)
		local data = masks[90]
		local mask = getElementData(v, data[1])
		-- triggerEvent("attachBackpackServer", v, v)
		if (mask) then
			exports.anticheat:changeProtectedElementDataEx(v, data[1], false, true)
		end
	end
	
	removeData() -- bug fix for bugged items which don't include it's owner
end
addCommandHandler("resetwe", bugFix)