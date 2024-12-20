function toggleWindow(thePlayer)
	if not thePlayer then
		thePlayer = source
	end

	local theVehicle = getPedOccupiedVehicle(thePlayer)
	if theVehicle and getElementData( thePlayer, "realinvehicle" ) == 1 then
		if hasVehicleWindows(theVehicle) then
			if (getVehicleOccupant(theVehicle) == thePlayer) or (getVehicleOccupant(theVehicle, 1) == thePlayer) then
				if not (isVehicleWindowUp(theVehicle)) then
					for i = 0, getVehicleMaxPassengers(theVehicle) do
						if getVehicleOccupant(theVehicle, i) and isPedDoingGangDriveby(getVehicleOccupant(theVehicle, i)) then
							outputChatBox(" Você não pode fechar as janelas quando alguém está inclinado para fora.", thePlayer, 255, 0, 0)
							return
						end
					end
					exports.anticheat:changeProtectedElementDataEx(theVehicle, "vehicle:windowstat", 0, true)
					triggerEvent("sendAme", thePlayer, "fecha as janelas.")
					for i = 0, getVehicleMaxPassengers(theVehicle) do
						local player = getVehicleOccupant(theVehicle, i)
						if (player) then
							triggerClientEvent(player, "updateWindow", theVehicle)
							triggerEvent("setTintName", player)
						end
					end
				else
					exports.anticheat:changeProtectedElementDataEx(theVehicle, "vehicle:windowstat", 1, true)
					triggerEvent("sendAme", thePlayer, "abre as janelas.")
					for i = 0, getVehicleMaxPassengers(theVehicle) do
						local player = getVehicleOccupant(theVehicle, i)
						if (player) then
							triggerClientEvent(player, "updateWindow", theVehicle)
							triggerEvent("resetTintName", theVehicle, player)
						end
					end
				end
			end
		end
	end
end
addEvent("vehicle:togWindow", true)
addEventHandler("vehicle:togWindow", root, toggleWindow)
addCommandHandler("togwindow", toggleWindow)
