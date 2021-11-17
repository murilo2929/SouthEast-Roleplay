--[[
* ***********************************************************************************************************************
* Copyright (c) 2015 OwlGaming Community - All Rights Reserved
* All rights reserved. This program and the accompanying materials are private property belongs to OwlGaming Community
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* ***********************************************************************************************************************
]]

local mysql = exports.mysql
local function setElementDataEx(source, field, parameter, streamtoall, streamatall)
	exports.anticheat:changeProtectedElementDataEx( source, field, parameter, streamtoall, streamatall)
end

function setBusinessNotification(thePlayer, commandName, ...)
	local playerDim = nil
	if tostring(commandName):lower() ~= "setbiznote" then
		playerDim = tonumber(commandName)
	else
		playerDim = getElementDimension(thePlayer)
	end
	if playerDim > 0 then
		local foundInt = false
		local possibleInteriors = getElementsByType("interior")
		for key, interior in ipairs(possibleInteriors) do
			if isElement(interior) and getElementType(interior) then
				if playerDim == getElementData(interior, "dbid") and getElementData(interior, "status").type == 1 then
					foundInt = interior
					break
				end
			end
		end
		
		if foundInt then
			if exports.global:hasItem(thePlayer, 5, playerDim) or exports.global:hasItem(thePlayer, 4, playerDim) or exports.integration:isPlayerTrialAdmin(thePlayer) then
				if not (...) then
					local sucessfullyUpdateToSQL = false
					if mysql:query_fetch_assoc("SELECT `intID` FROM `interior_business` WHERE `intID` = '"..playerDim.."'") then
						if mysql:query_free("UPDATE `interior_business` SET `businessNote`='' WHERE `intID`='"..tostring(playerDim).."'") then
							sucessfullyUpdateToSQL = true
						end
					else
						return false
					end
					
					if sucessfullyUpdateToSQL then
						setElementDataEx(foundInt, "business:note", false, true)
						outputChatBox(" Você removeu sua nota comercial.",thePlayer, 0, 255, 0)
						exports["interior-manager"]:addInteriorLogs(playerDim, commandName.." none", thePlayer)
						return true
					else
						outputChatBox(" Database Error!",thePlayer, 255, 0, 0)
						return false
					end
					return false
				else
					local msg = table.concat({...}, " "):gsub("'","''")
					local limit = string.len(msg) 
					if limit > 100 then
						outputChatBox(" Sua mensagem ("..limit.."/100) é muito longa!",thePlayer, 255, 0, 0)
						return false
					end
					local sucessfullyUpdateToSQL = false
					if mysql:query_fetch_assoc("SELECT `intID` FROM `interior_business` WHERE `intID` = '"..playerDim.."'") then
						if mysql:query_free("UPDATE `interior_business` SET `businessNote`='"..msg.."' WHERE `intID`='"..tostring(playerDim).."'") then
							sucessfullyUpdateToSQL = true
						end
					else
						if mysql:query_free("INSERT INTO `interior_business` SET `businessNote`='"..msg.."', `intID`='"..tostring(playerDim).."'") then
							sucessfullyUpdateToSQL = true
						end
					end
					
					if sucessfullyUpdateToSQL then
						setElementDataEx(foundInt, "business:note", msg, true)
						outputChatBox(" Você definiu a nota de seu negócio para '"..msg.."'.",thePlayer, 0, 255, 0)
						exports["interior-manager"]:addInteriorLogs(playerDim, commandName.." "..msg, thePlayer)
						return true
					else
						outputChatBox(" Database Error!",thePlayer, 255, 0, 0)
						return false
					end
				end
			else
				outputChatBox("Você não é o dono desta empresa, mostre-me pelo menos uma chave?", thePlayer, 255, 0, 0)
				return false
			end
		else
			outputChatBox("Isto não é um negócio.", thePlayer, 255, 0, 0)
			return false
		end
	else
		outputChatBox("Você deve estar dentro da sua empresa.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("setbiznote", setBusinessNotification)
addCommandHandler("definirnotanegocio", setBusinessNotification)

addEvent( "businessSystem:setBizNote",true )
addEventHandler( "businessSystem:setBizNote", getRootElement(), setBusinessNotification)

