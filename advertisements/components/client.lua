--[[local advertPed = createPed(45, 26, 2395, 159.18800354004, 270)
setElementInterior(advertPed, 10)
setElementDimension(advertPed, 150)
setElementFrozen(advertPed, true)
setPedAnimation(advertPed, "FOOD", "FF_Sit_Look", -1, true, false, false)
addEventHandler("onClientClick", root, function(b, s, _, _, _, _, _, elem) if (b == "right" and s == "down" and elem and getElementType(elem) == "ped" and elem == advertPed) then triggerEvent("reklam:HTML", localPlayer, localPlayer)  end end)]]

addCommandHandler("ads",
	function(cmd)
		if exports.global:hasItem(localPlayer, 2) then
			triggerEvent("reklam:HTML", localPlayer, localPlayer)	
		else
			outputChatBox("Você precisa de um celular para anúnciar.", 255, 255, 255)	
		end
	end
)