-- object attachments shit
local tempobj = { }
local tempobjv = { }
local tempobjbone = { }

function attachObject (thePlayer, commandName, objectID, bone, scale)
	if not exports.integration:isPlayerAdmin(thePlayer) then
		return
	end
	if scale == nil then scale = 1 end
	if not objectID or not bone then
		outputChatBox("SYNTAX: /" .. commandName .. " [ObjectID] [BoneID] [Scale]", thePlayer, 255, 194, 14)
		return
	end
	if tempobj[thePlayer] then
		outputChatBox("The current object has been detached and removed", thePlayer, 255, 194, 14)
		outputChatBox("Last saved coordinates of the attached object : ", thePlayer, 255, 194, 14)
		outputChatBox(" X: " .. tempobjv[thePlayer][1] .. " || Y: " .. tempobjv[thePlayer][2] .. " || Z: " .. tempobjv[thePlayer][3], thePlayer, 255, 194, 14)
		outputChatBox(" RX: " .. tempobjv[thePlayer][4] .. " || RY: " .. tempobjv[thePlayer][5] .. " || RZ: " ..  tempobjv[thePlayer][6], thePlayer, 255, 194, 14)
		exports.bone_attach:detachElementFromBone(tempobj[thePlayer])
		destroyElement(tempobj[thePlayer])
		tempobj[thePlayer] = nil
		tempobjv[thePlayer] = { 0, 0, 0, 0, 0, 0, 0 }
		tempobjbone[thePlayer] = nil
		return
	end
	outputChatBox("You have attached object id " .. objectID .. " on bone " .. bone, thePlayer, 255, 194, 14)
	tempobj[thePlayer] = createObject(objectID,0,0,0)
	setElementDoubleSided(tempobj[thePlayer], false)
	setObjectScale(tempobj[thePlayer], scale)
	tempobjbone[thePlayer] = bone
	tempobjv[thePlayer] = { 0, 0, 0, 0, 0, 0, 0 }
	exports.bone_attach:attachElementToBone(tempobj[thePlayer], thePlayer, tempobjbone[thePlayer], tempobjv[thePlayer][1], tempobjv[thePlayer][2], tempobjv[thePlayer][3], tempobjv[thePlayer][4], tempobjv[thePlayer][5], tempobjv[thePlayer][6])
end
addCommandHandler("startbone", attachObject, false, false)

function moveBoneX (thePlayer, commandName, x)
	if not exports.integration:isPlayerAdmin(thePlayer) then
		return
	end
	if not x then
		outputChatBox("SYNTAX: /" .. commandName .. " [X]", thePlayer, 255, 194, 14)
		return
	end
	if not tempobj[thePlayer] then
		outputChatBox("You must have an object attached in order to use this command, noob.", thePlayer, 255, 0, 0)
		return
	end
	exports.bone_attach:detachElementFromBone(tempobj[thePlayer])
	local currx = tempobjv[thePlayer][1]
	tempobjv[thePlayer][1] = currx + x
	exports.bone_attach:attachElementToBone(tempobj[thePlayer], thePlayer, tempobjbone[thePlayer], tempobjv[thePlayer][1], tempobjv[thePlayer][2], tempobjv[thePlayer][3], tempobjv[thePlayer][4], tempobjv[thePlayer][5], tempobjv[thePlayer][6])
end
addCommandHandler("bonex", moveBoneX, false, false)

function moveBoneY (thePlayer, commandName, x)
	if not exports.integration:isPlayerAdmin(thePlayer) then
		return
	end
	if not x then
		outputChatBox("SYNTAX: /" .. commandName .. " [Y]", thePlayer, 255, 194, 14)
		return
	end
	if not tempobj[thePlayer] then
		outputChatBox("You must have an object attached in order to use this command, noob.", thePlayer, 255, 0, 0)
		return
	end
	exports.bone_attach:detachElementFromBone(tempobj[thePlayer])
	local currx = tempobjv[thePlayer][2]
	tempobjv[thePlayer][2] = currx + x
	exports.bone_attach:attachElementToBone(tempobj[thePlayer], thePlayer, tempobjbone[thePlayer], tempobjv[thePlayer][1], tempobjv[thePlayer][2], tempobjv[thePlayer][3], tempobjv[thePlayer][4], tempobjv[thePlayer][5], tempobjv[thePlayer][6])
end
addCommandHandler("boney", moveBoneY, false, false)

function moveBoneZ (thePlayer, commandName, x)
	if not exports.integration:isPlayerAdmin(thePlayer) then
		return
	end
	if not x then
		outputChatBox("SYNTAX: /" .. commandName .. " [Z]", thePlayer, 255, 194, 14)
		return
	end
	if not tempobj[thePlayer] then
		outputChatBox("You must have an object attached in order to use this command, noob.", thePlayer, 255, 0, 0)
		return
	end
	exports.bone_attach:detachElementFromBone(tempobj[thePlayer])
	local currx = tempobjv[thePlayer][3]
	tempobjv[thePlayer][3] = currx + x
	exports.bone_attach:attachElementToBone(tempobj[thePlayer], thePlayer, tempobjbone[thePlayer], tempobjv[thePlayer][1], tempobjv[thePlayer][2], tempobjv[thePlayer][3], tempobjv[thePlayer][4], tempobjv[thePlayer][5], tempobjv[thePlayer][6])
end
addCommandHandler("bonez", moveBoneZ, false, false)

function moveBoneRX (thePlayer, commandName, x)
	if not exports.integration:isPlayerAdmin(thePlayer) then
		return
	end
	if not x then
		outputChatBox("SYNTAX: /" .. commandName .. " [RX]", thePlayer, 255, 194, 14)
		return
	end
	if not tempobj[thePlayer] then
		outputChatBox("You must have an object attached in order to use this command, noob.", thePlayer, 255, 0, 0)
		return
	end
	exports.bone_attach:detachElementFromBone(tempobj[thePlayer])
	local currx = tempobjv[thePlayer][4]
	tempobjv[thePlayer][4] = currx + x
	exports.bone_attach:attachElementToBone(tempobj[thePlayer], thePlayer, tempobjbone[thePlayer], tempobjv[thePlayer][1], tempobjv[thePlayer][2], tempobjv[thePlayer][3], tempobjv[thePlayer][4], tempobjv[thePlayer][5], tempobjv[thePlayer][6])
end
addCommandHandler("bonerx", moveBoneRX, false, false)

function moveBoneRY (thePlayer, commandName, x)
	if not exports.integration:isPlayerAdmin(thePlayer) then
		return
	end
	if not x then
		outputChatBox("SYNTAX: /" .. commandName .. " [RY]", thePlayer, 255, 194, 14)
		return
	end
	if not tempobj[thePlayer] then
		outputChatBox("You must have an object attached in order to use this command, noob.", thePlayer, 255, 0, 0)
		return
	end
	exports.bone_attach:detachElementFromBone(tempobj[thePlayer])
	local currx = tempobjv[thePlayer][5]
	tempobjv[thePlayer][5] = currx + x
	exports.bone_attach:attachElementToBone(tempobj[thePlayer], thePlayer, tempobjbone[thePlayer], tempobjv[thePlayer][1], tempobjv[thePlayer][2], tempobjv[thePlayer][3], tempobjv[thePlayer][4], tempobjv[thePlayer][5], tempobjv[thePlayer][6])
end
addCommandHandler("bonery", moveBoneRY, false, false)

function moveBoneRZ (thePlayer, commandName, x)
	if not exports.integration:isPlayerAdmin(thePlayer) then
		return
	end
	if not x then
		outputChatBox("SYNTAX: /" .. commandName .. " [RZ]", thePlayer, 255, 194, 14)
		return
	end
	if not tempobj[thePlayer] then
		outputChatBox("You must have an object attached in order to use this command, noob.", thePlayer, 255, 0, 0)
		return
	end
	exports.bone_attach:detachElementFromBone(tempobj[thePlayer])
	local currx = tempobjv[thePlayer][6]
	tempobjv[thePlayer][6] = currx + x
	exports.bone_attach:attachElementToBone(tempobj[thePlayer], thePlayer, tempobjbone[thePlayer], tempobjv[thePlayer][1], tempobjv[thePlayer][2], tempobjv[thePlayer][3], tempobjv[thePlayer][4], tempobjv[thePlayer][5], tempobjv[thePlayer][6])
end
addCommandHandler("bonerz", moveBoneRZ, false, false)

--[[function outputChange(dataName,oldValue)
	if (getElementType(source) == "player") then
		local newValue = getElementData(source,dataName)
		outputChatBox("Your element data '"..tostring(dataName).."' has changed from '"..tostring(oldValue).."' to '"..tostring(newValue).."'",source)
	end
end
addEventHandler("onElementDataChange", getRootElement(), outputChange)]]