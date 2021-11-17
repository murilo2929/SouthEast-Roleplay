-- DISAPPEAR

function toggleInvisibility(thePlayer)
	if exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer) then
		if getElementData(thePlayer, "supervising") then
			outputChatBox("Desative /supervisor primeiro.", thePlayer, 255, 0, 0)
			return
		end
		local enabled = getElementData(thePlayer, "invisible")
		if (enabled == true) then
			setElementAlpha(thePlayer, 255)
			exports.anticheat:changeProtectedElementDataEx(thePlayer, "reconx", false, false)
			outputChatBox("Você agora esta visivel.", thePlayer, 255, 0, 0)
			exports.anticheat:changeProtectedElementDataEx(thePlayer, "invisible", false, false)
			exports.logs:dbLog(thePlayer, 4, thePlayer, "DISAPPEAR DISABLED")
		elseif (enabled == false or enabled == nil) then
			setElementAlpha(thePlayer, 0)
			exports.anticheat:changeProtectedElementDataEx(thePlayer, "reconx", true, false)
			outputChatBox("Vôcê agora esta invisivel.", thePlayer, 0, 255, 0)
			exports.anticheat:changeProtectedElementDataEx(thePlayer, "invisible", true, false)
			exports.logs:dbLog(thePlayer, 4, thePlayer, "DISAPPEAR ENABLED")
		else
			outputChatBox("Por favor, desative o spec primeiro.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("disappear", toggleInvisibility)
addCommandHandler("desaparecer", toggleInvisibility)


-- TOGGLE NAMETAG
function toggleMyNametag(thePlayer)
	local visible = getElementData(thePlayer, "reconx")
	local username = getElementData(thePlayer, "account:username")
	if exports.integration:isPlayerHeadAdmin(thePlayer) then
		if (visible == true) then
			setPlayerNametagShowing(thePlayer, false)
			--exports.anticheat:changeProtectedElementDataEx(thePlayer, "reconx", false, false)
			outputChatBox("Sua nametag esta visivel.", thePlayer, 255, 0, 0)
		elseif (visible == false or visible == nil) then
			setPlayerNametagShowing(thePlayer, false)
			--exports.anticheat:changeProtectedElementDataEx(thePlayer, "reconx", true, false)
			outputChatBox("Sua nametag esta oculta.", thePlayer, 0, 255, 0)
		else
			outputChatBox("Por favor, desative o spec primeiro.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("togmytag", toggleMyNametag)

-- RP SUPERVISE
function roleplaySupervise(thePlayer)
	if exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer) then
		if exports.global:isStaffOnDuty(thePlayer) then
			if getElementData(thePlayer, "invisible") then
				outputChatBox("Por Favor desative /deasparecer primeiro.", thePlayer, 255, 0, 0)
				return
			end

			local enabled = getElementData(thePlayer, "supervising")
			if (enabled == true) then
				setElementAlpha(thePlayer, 255)
				outputChatBox("Agora você não está mais no estado de supervisor.", thePlayer, 255, 0, 0)
				exports.logs:dbLog(thePlayer, 4, thePlayer, "RP SUPERVISOR DISABLED")
				exports.global:sendWrnToStaff("[AdmCmd] "..getElementData(thePlayer, "account:username").." desabilitou o modo supervisor RP.")

				setElementData(thePlayer, "supervising", false)
			elseif (enabled == false or enabled == nil) then
				setElementAlpha(thePlayer, 100)
				outputChatBox("You are now in supervisor state.", thePlayer, 0, 255, 0)
				exports.logs:dbLog(thePlayer, 4, thePlayer, "RP SUPERVISOR ENABLED")
				exports.global:sendWrnToStaff("[AdmCmd] "..getElementData(thePlayer, "account:username").." habilitou o modo supervisor RP.")

				setElementData(thePlayer, "supervising", true)
			else
				outputChatBox("Por favor, desative o spec primeiro.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("supervise", roleplaySupervise)
addCommandHandler("supervisor", roleplaySupervise)

addEvent("recon:reattach", true)
addEventHandler("recon:reattach", resourceRoot, function(target, int, dim)
	setElementInterior(client, int)
	setElementDimension(client, dim)
	setCameraInterior(client, int)
	local x,y,z = getElementPosition(target)
	setElementPosition(client, x, y, z-5)
	attachElements(client, target, 0, 0, -5)
end)

-- MAXIME's reworks
function asyncReconActivate(cur)
	local target = exports.pool:getElement("player", cur.target)
	if not target then
		triggerClientEvent(source, "admin:recon", source)
		return
	end
	removePedFromVehicle(source)
	if exports.freecam:isEnabled(source) then
		triggerEvent("freecam:asyncDeactivateFreecam", source)
	end

	-- Set important element data
	setElementData(source, "reconx", target, true)
	setElementData(source, "recontp", true)

	setElementCollisionsEnabled ( source, false )
	triggerEvent('artifacts:removeAllOnPlayer', root, source)
	setElementAlpha(source, 0)
	setPedWeaponSlot(source, 0)

	local t_int = getElementInterior(target)
	local t_dim = getElementDimension(target)

	setElementDimension(source, t_dim)
	setElementInterior(source, t_int)
	setCameraInterior(source, t_int)

	local x1, y1, z1 = getElementPosition(target)
	setElementPosition(source, x1, y1, 0)

	setTimer(function(source, xl, yl, zl, target) setElementPosition(source, x1, y1, z1-5); 	attachElements(source, target, 0, 0, -5) end, 500, 1, source, xl, yl, zl, target)

	setCameraTarget(source,target)
	exports.logs:dbLog(source, 4, target, "RECON")
	local hiddenAdmin = getElementData(source, "hiddenadmin")
	if hiddenAdmin == 0 and not (exports.integration:isPlayerSeniorAdmin(source) and exports.integration:isPlayerTrialAdmin(target) and not exports.integration:isPlayerAdmin(target))  then
		local adminTitle = exports.global:getPlayerAdminTitle(source)
		exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getElementData(source, "account:username") .. " começou a spectar " .. getPlayerName(target):gsub("_", " ") .. " (" .. getElementData(target, "account:username") .. ").")
	elseif exports.integration:isPlayerSeniorAdmin(source) and exports.integration:isPlayerTrialAdmin(target) and not exports.integration:isPlayerAdmin(target) and hiddenAdmin == 0 then
		local adminTitle = exports.global:getPlayerAdminTitle(source)
		exports.global:sendMessageToSeniorAdmins("SeniorAdmCmd: " .. tostring(adminTitle) .. " " .. getElementData(source, "account:username") .. " começou a spectar " .. getElementData(target, "account:username") .. ".")
	end
end
addEvent("admin:recon:async:activate", true)
addEventHandler("admin:recon:async:activate", root, asyncReconActivate)

function asyncReconDeactivate(cur)
	if exports.freecam:isEnabled(source) then
		triggerEvent("freecam:asyncDeactivateFreecam", source)
	end
	setElementData(source, "reconx", false, true)
	removeElementData(source, "recontp")

	removePedFromVehicle(source)
	detachElements(source)

	setElementPosition(source, cur.x, cur.y, cur.z)
	setElementRotation(source, cur.rx, cur.ry, cur.rz)

	setElementDimension(source, cur.dim)
	setElementInterior(source, cur.int)
	setCameraInterior(source,cur.int)

	setCameraTarget(source, nil)
	setElementAlpha(source, 255)
	setElementCollisionsEnabled ( source, true )
end
addEvent("admin:recon:async:deactivate", true)
addEventHandler("admin:recon:async:deactivate", root, asyncReconDeactivate)


addEvent("admin:disabledisappear", true)
addEventHandler("admin:disabledisappear", root, function (thePlayer)
	exports.anticheat:changeProtectedElementDataEx(thePlayer, "reconx", false, false)
	exports.anticheat:changeProtectedElementDataEx(thePlayer, "invisible", false, false)		
end)