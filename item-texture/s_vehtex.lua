--Vehicle textures
--Script that handles texture replacements for vehicles
--Created by Exciter, 01.01.2015 (DD.MM.YYYY).
local maxFileSize = 100000
local maxWidth = 1200
local maxHeight = 1200

function addVehicleTexture(theVehicle, texName, texURL) --Exciter
	local thePlayer = source
	if(not theVehicle or not texName or not texURL) then
		return false
	end
	if not getElementType(theVehicle) == "vehicle" then
		return false
	end
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer)) then
		if string.len(texURL) >= 50 then
			outputChatBox("O comprimento do URL é muito longo! Talvez use um host como o imgur.", thePlayer, 255, 0, 0)
		return end
		local mysql = exports.mysql
		local textures = getElementData(theVehicle, "textures") or {}
		table.insert(textures, {texName, texURL})
		local vehID = tonumber(getElementData(theVehicle, "dbid")) or 0
		if vehID > 0 then
			local newdata = toJSON(textures)
			dbExec(exports.mysql:getConn("mta"), "UPDATE vehicles SET textures=? WHERE id=?", newdata, vehID)
		end
		exports.anticheat:changeProtectedElementDataEx(theVehicle, "textures", textures, true)
		addTexture(theVehicle, texName, texURL)
	end
end
addEvent("vehtex:addTexture", true)
addEventHandler("vehtex:addTexture", getRootElement( ), addVehicleTexture)

function removeVehicleTexture(theVehicle, texName) --Exciter
	local thePlayer = source
	if(not theVehicle or not texName) then
		return false
	end
	if not getElementType(theVehicle) == "vehicle" then
		return false
	end
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer)) then
		local mysql = exports.mysql
		local textures = getElementData(theVehicle, "textures") or {}
		for k,v in ipairs(textures) do
			if(v[1] == texName) then
				table.remove(textures, k)
				break
			end
		end

		local vehID = tonumber(getElementData(theVehicle, "dbid")) or 0
		if vehID > 0 then
			local newdata = toJSON(textures)
			dbExec(exports.mysql:getConn("mta"), "UPDATE vehicles SET textures=? WHERE id=?", newdata, vehID)
		end
		exports.anticheat:changeProtectedElementDataEx(theVehicle, "textures", textures, true)
		removeTexture(theVehicle, texName)
	end
end
addEvent("vehtex:removeTexture", true)
addEventHandler("vehtex:removeTexture", getRootElement( ), removeVehicleTexture)

function validateVehicleTexture(theVehicle, texName, url)
	fetchRemote(url, 5, function(str, errno, client)
			if str == 'ERROR' then
				--outputDebugString('item-texture/s_vehtex: loadFromURL - unable to fetch ' .. tostring(url))
				local text = "The URL could not be reached. Please check that you entered the correct URL and that the URL is reachable. (ERROR #"..tostring(errno)..")"
				triggerClientEvent(client, 'vehtex:fileValidationResult', resourceRoot, theVehicle, texName, url, false, text)
			else
				local path = 'tmp_cache/' .. md5(tostring(url)) .. '.tex'
				local file = fileCreate(path)
				fileWrite(file, str)
				local filesize = fileGetSize(file)
				fileClose(file)
				if filesize > maxFileSize then
					local text = "The filesize ("..tostring(filesize).."b) exceeds the maximum allowed filesize for vehicle textures ("..tostring(maxFileSize).."b ("..tostring(maxFileSizeTxt).."))."
					triggerClientEvent(client, 'vehtex:fileValidationResult', resourceRoot, theVehicle, texName, url, false, text)
					fileDelete(path)
				else
					fileRename(path, getPath(url))
					triggerClientEvent(client, 'vehtex:fileValidationResult', resourceRoot, theVehicle, texName, url, true)
				end
			end
		end, "", true, client)
end
addEvent("vehtex:validateFile", true)
addEventHandler("vehtex:validateFile", resourceRoot, validateVehicleTexture)

function requestAPIkey(vehicle, texname, texurl)
	local host = getHost(texurl)
	if host == "imgur.com" then
		local apiKey = get("imgurClient")
		triggerClientEvent(client, "vehtex:validatePreviewFile", resourceRoot, vehicle, texname, texurl, host, apiKey)
	elseif host == "icweb.org" then
		local apiKey = get("icwebAPIkey") or "owlhowl"
		triggerClientEvent(client, "vehtex:validatePreviewFile", resourceRoot, vehicle, texname, texurl, host, apiKey)
	end
end	
addEvent("vehtex:prepareValidation", true)
addEventHandler("vehtex:prepareValidation", resourceRoot, requestAPIkey) 