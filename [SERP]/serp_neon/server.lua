addEvent("tuning->Neon", true)
addEventHandler("tuning->Neon", root, function(vehicle, neon)
	if vehicle then
		triggerClientEvent(root, "tuning->Neon", root, vehicle, neon)
	end
end)
local neonList = {
	["0"] = "null",
	["1"] = "white",
	["2"] = "blue",
	["3"] = "green",
	["4"] = "red",
	["5"] = "yellow",
	["6"] = "pink",
	["7"] = "orange",
	["8"] = "lightblue",
	["9"] = "rasta",
	["10"] = "ice"
}
addCommandHandler("setneon",
	function(player, cmd, vehID, color)
		if exports.integration:isPlayerScripter(player) then
			if not vehID or not color or not neonList[tostring(color)] then
				outputChatBox("#ffffff /setneon [Veículo ID] [Cor (1-10)]", player, 0, 0, 255, true)
				return
			end
			local vehicle = exports.pool:getElement('vehicle', vehID)
			if vehicle and isElement(vehicle) then
				local color = neonList[tostring(color)]
				if not color then return end
				if color == "null" then color = false end
				outputChatBox(color, player)
				setElementData(vehicle, "tuning.neon", color)
				local dbid = tonumber(getElementData(vehicle, "dbid")) or -1
				dbExec(exports.mysql:getConn(), "UPDATE vehicles SET neon='"..tostring(color).."' WHERE id='"..(dbid).."'")
				triggerClientEvent(root, "delNeon", root, vehicle, false)
				triggerClientEvent(root, "addNeon", root, vehicle, color)
				outputChatBox("#ffffff Operação bem-sucedida, neon do veículo alterada com sucesso.", player, 0, 255, 0, true)
			end
		end
	end
)