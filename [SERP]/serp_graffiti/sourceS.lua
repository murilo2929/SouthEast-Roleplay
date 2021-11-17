--[[

	Edited by Fernando for:
	San Andreas Roleplay

	Last Update: December 2020

]]


mysql = exports.mysql

local graffitiSavePath = "storedServerGraffitis.json"
local graffitiSaveFolder = "files/server_graffitis/"

local graffitiDatas = {}
local graffitiImages = {}

--/GRAFFITIPERM
-- Doing this command on a player will now BAN them from using /graffiti
function giveGraffitiPerm(thePlayer, commandName, target)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] OR [Exact Username]", thePlayer, 255, 194, 14)
			outputChatBox("PURPOSE: Gives an user (across all characters) permission to use /graffiti.", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(nil, target)
			local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)


			if targetPlayer then
				local tUsername = getElementData(targetPlayer, "account:username")
				local taccountID = getElementData(targetPlayer, "account:id")
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local gperm = getElementData(targetPlayer, "gperm") or 0


					if gperm == 0 then
						exports.anticheat:changeProtectedElementDataEx(targetPlayer, "gperm", 1, true)
						exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " has granted "..tUsername.." (" .. targetPlayerName..") /graffiti permission.")
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "GRAFFITI ON")
						outputChatBox("You have received /graffiti permission from an admin.", targetPlayer, 0, 255, 0)
						dbExec(exports.mysql:getConn("core"), "UPDATE `accounts` SET `gperm`= ? WHERE `id`=?", 1, taccountID)
					else
						exports.anticheat:changeProtectedElementDataEx(targetPlayer, "gperm", 0, true)
						exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " has revoked "..tUsername.." (" .. targetPlayerName..")'s /graffiti permission.")
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "GRAFFITI OFF")
						outputChatBox("Your /graffiti permission has been revoked.", targetPlayer, 255, 255, 25)
						dbExec(exports.mysql:getConn("core"), "UPDATE `accounts` SET `gperm`= ? WHERE `id`=?", 0, taccountID)
					end

				end
			else -- Username?
				for k, player in pairs(getElementsByType("player")) do
                    if getElementData(player, "loggedin") == 1 then
                        local un = getElementData(player, "account:username")
                        if un == target then
                            giveGraffitiPerm(thePlayer, commandName, getPlayerName(player))
                            return
                        end
                    end
                end

                local accID, gperm

                local qh = dbQuery(exports.mysql:getConn("core"), "SELECT `id`,`gperm` FROM `accounts` WHERE `username`=? LIMIT 1", target)
                local result = dbPoll( qh, 10000 )
                if result and #result > 0 then
                    accID = tonumber(result[1]["id"])
                    gperm = tonumber(result[1]["gperm"])
                else
                    dbFree(qh)
                    outputChatBox("Could not find any player online with name '"..target.."' or any account with that username.", thePlayer, 255,0,0)
                    return
                end

				local newgperm = 1
				if gperm == 1 then
					newgperm = 0
				end

				if newgperm == 1 then
					exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " has granted (offline) "..target.." /graffiti permission.")
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "ACC #"..accID.." GRAFFITI ON")
					dbExec(exports.mysql:getConn("core"), "UPDATE `accounts` SET `gperm`= ? WHERE `id`=?", 1, accID)

				elseif newgperm == 0 then
					exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " has revoked (offline) "..target.."'s /graffiti permission.")
					exports.logs:dbLog(thePlayer, 4, thePlayer, "ACC #"..accID.." GRAFFITI OFF")
					dbExec(exports.mysql:getConn("core"), "UPDATE `accounts` SET `gperm`= ? WHERE `id`=?", 0, accID)
				end
			end
		end
	end
end
addCommandHandler("graffitiperm", giveGraffitiPerm, false, false)
addCommandHandler("gperm", giveGraffitiPerm, false, false)


addEvent("onTryToDownloadClientImage", true)
addEventHandler("onTryToDownloadClientImage", getRootElement(),
	function (path)
		local player = source

		fetchRemote(path,
			function (responseData, errno)
				triggerClientEvent(player, "onClientReceiveDownloadedImage", player, responseData, errno)
			end
		, "", false)
	end
)

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		if not fileExists(graffitiSavePath) then
			graffitiDatas = {}
			-- outputChatBox("no graffiti found", root)
		else
			outputChatBox("Loading all graffiti...", root, 187, 187, 187)
			-- load all graffiti
			local graffitis = fileOpen(graffitiSavePath)
			if graffitis then
				local graffitisData = fileRead(graffitis, fileGetSize(graffitis))

				if graffitisData then

					graffitiDatas = fromJSON(graffitisData)

					for fileName, data in pairs(graffitiDatas) do
						-- outputChatBox(fileName, root)

						-- no idea why this is here, wasnt working / Fernando
						-- fileName = utf8.gsub(utf8.gsub(fileName, "#%x%x%x%x%x%x", ""), "%W", "")

						if fileExists(graffitiSaveFolder .. fileName .. ".png") then
							local graffitiImage = fileOpen(graffitiSaveFolder .. fileName .. ".png")
							-- outputChatBox("looking for graffiti image... "..fileName, root)
							if graffitiImage then
								graffitiImages[fileName] = fileRead(graffitiImage, fileGetSize(graffitiImage))
								-- outputChatBox("loaded graffiti "..fileName, root)
								fileClose(graffitiImage)
							end
						end
					end
				end

				fileClose(graffitis)
			end
		end
	end
)

addEventHandler("onResourceStop", getResourceRootElement(),
	function ()
		if fileExists(graffitiSavePath) then
			fileDelete(graffitiSavePath)
		end

		local graffitis = fileCreate(graffitiSavePath)
		if graffitis then
			fileWrite(graffitis, toJSON(graffitiDatas))
			fileClose(graffitis)
		end
	end
)

addEvent("requestGraffitiList", true)
addEventHandler("requestGraffitiList", getRootElement(),
	function ()
		triggerClientEvent(source, "receiveGraffitiList", source, graffitiDatas)
	end
)

addEvent("requestGraffitis", true)
addEventHandler("requestGraffitis", getRootElement(),
	function (requestGraffitis)
		if requestGraffitis then
			local datasToSend = {}

			for _, fileName in pairs(requestGraffitis) do
				if graffitiDatas[fileName] and graffitiImages[fileName] then
					table.insert(datasToSend, {fileName, graffitiImages[fileName]})
				end
			end

			triggerClientEvent(source, "receiveGraffitis", source, datasToSend)
		end
	end
)

addEvent("createGraffiti", true)
addEventHandler("createGraffiti", getRootElement(),
	function (pixels, data)
		local fileName = getRealTime().timestamp .. "-" .. utf8.gsub(utf8.gsub(getPlayerName(source), "#%x%x%x%x%x%x", ""), "%W", "")

		local graffitiImage = fileCreate(graffitiSaveFolder .. fileName .. ".png")
		if graffitiImage then
			fileWrite(graffitiImage, pixels)
			fileClose(graffitiImage)

			graffitiImages[fileName] = pixels
			graffitiDatas[fileName] = data
			graffitiDatas[fileName].fileName = fileName

			triggerClientEvent("createGraffiti", getRootElement(), source, graffitiImages[fileName], graffitiDatas[fileName])
		end
	end
)

addEvent("deleteGraffiti", true)
addEventHandler("deleteGraffiti", getRootElement(),
	function (fileName, pay, sendMeAnyway)
		if graffitiDatas[fileName] then
			if fileExists(graffitiSaveFolder .. fileName .. ".png") then
				fileDelete(graffitiSaveFolder .. fileName .. ".png")
			end

			graffitiDatas[fileName] = nil
			graffitiImages[fileName] = nil

			triggerClientEvent("deleteGraffiti", getRootElement(), fileName)
			local location = getZoneName(getElementPosition(source))
			exports.logs:dbLog(source, 41, source, "DELETED GRAFFITI at "..location)
			if pay or sendMeAnyway == true then

				if pay then
					triggerEvent('sendAme', source, "removed a graffiti from the surface.")
					exports.global:giveMoney(source, 50)
				end

			end
		end
	end
)

addEvent("protectGraffiti", true)
addEventHandler("protectGraffiti", getRootElement(),
	function (fileName)
		if graffitiDatas[fileName] then
			graffitiDatas[fileName].isProtected = not graffitiDatas[fileName].isProtected

			triggerClientEvent("protectGraffiti", getRootElement(), fileName, graffitiDatas[fileName].isProtected)
		end
	end
)

addEvent("graffitiCleanAnimation", true)
addEventHandler("graffitiCleanAnimation", getRootElement(),
	function ()
		setPedAnimation(source, "graffiti", "spraycan_fire", 15000, true, false, false, false)
	end
)
