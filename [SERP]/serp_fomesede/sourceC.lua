function checkHunger()
    local logged = getElementData(localPlayer, "loggedin")
	if logged == 1 then

		if exports.global:isStaffOnDuty(localPlayer) then return end

		local hunger = tonumber(getElementData(localPlayer, "char.Hunger"))
		if hunger and hunger > 0 then
			setElementData(localPlayer, "char.Hunger", hunger - 1)
		end
		if hunger <= 20 then
			--setElementHealth(localPlayer, getElementHealth(localPlayer) -20)
			outputChatBox("Você está ficando com muita fome", 255, 255, 255)
			--playSoundFrontEnd(40)
		end
		if hunger == 10 then	
				setElementHealth(localPlayer, 29)
				setElementData(localPlayer, "char.Hunger", 45)
			end
		end

	end
setTimer(checkHunger, 50000, 0) -- configure o tempo

function checkSede()
    local logged = getElementData(localPlayer, "loggedin")
	if logged == 1 then

		if exports.global:isStaffOnDuty(localPlayer) then return end

		local sede = tonumber(getElementData(localPlayer, "char.Thirst"))
		if sede and sede > 0 then
			setElementData(localPlayer, "char.Thirst", sede - 1)
		end
		if sede <= 20 then
			--setElementHealth(localPlayer, getElementHealth(localPlayer) -20)
			outputChatBox("Você está ficando com muita sede", 255, 255, 255)
			--playSoundFrontEnd(40)
		end
		if sede == 10 then	
				setElementHealth(localPlayer, 29)
				setElementData(localPlayer, "char.Thirst", 45)
			end
		end

	end
setTimer(checkSede, 40000, 0) -- configure o tempo