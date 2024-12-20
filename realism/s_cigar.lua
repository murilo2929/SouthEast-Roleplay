addEvent("realism:startsmoking", true)
addEventHandler("realism:startsmoking", getRootElement(),
	function(hand)
		if not (hand) then
			hand = 0
		else
			hand = tonumber(hand)
		end	
		
		triggerClientEvent("realism:smokingsync", source, true, hand)
		exports.anticheat:changeProtectedElementDataEx(source, "realism:smoking", true, false )
		exports.anticheat:changeProtectedElementDataEx(source, "realism:smoking:hand", hand, false )
		setTimer ( stopSmoking, 300000, 1, thePlayer )
	end
);


function stopSmoking(thePlayer)
	if not thePlayer then
		thePlayer = source
	end
	
	if (isElement(thePlayer)) then	
		local isSmoking = getElementData(thePlayer, "realism:smoking")
		local smokingJoint = getElementData(thePlayer, "realism:joint") -- If the player is smoking a Joint, not a ciggy
        if (smokingJoint) then
                triggerClientEvent("realism:smokingsync", thePlayer, false, 0)
                exports.anticheat:changeProtectedElementDataEx(thePlayer, "realism:joint", false, false )
                exports.anticheat:changeProtectedElementDataEx(thePlayer, "realism:smoking", false, false )
                return
        end
        if (isSmoking) then
                triggerClientEvent("realism:smokingsync", thePlayer, false, 0)
                exports.anticheat:changeProtectedElementDataEx(thePlayer, "realism:smoking", false, false )
        end
	end
end
addEvent("realism:stopsmoking", true)
addEventHandler("realism:stopsmoking", getRootElement(), stopSmoking)

function stopSmokingCMD(thePlayer)
    local isSmoking = getElementData(thePlayer, "realism:smoking")
    local smokingJoint = getElementData(thePlayer, "realism:joint")
    if (smokingJoint) then
        stopSmoking(thePlayer)
        exports.global:sendLocalMeAction(thePlayer, "joga seu baseado no chão.")
        return
    end
    if (isSmoking) then
        stopSmoking(thePlayer)
        exports.global:sendLocalMeAction(thePlayer, "joga o cigarro no chão.")
    end
end
addCommandHandler("throwaway", stopSmokingCMD)
addCommandHandler("jogarfora", stopSmokingCMD)

function changeSmokehand(thePlayer)
	local isSmoking = getElementData(thePlayer, "realism:smoking")
	if (isSmoking) then
		local smokingHand = getElementData(thePlayer, "realism:smoking:hand")
		triggerClientEvent("realism:smokingsync", thePlayer, true, 1-smokingHand)
		exports.anticheat:changeProtectedElementDataEx(thePlayer, "realism:smoking:hand",1-smokingHand, false )
	end
end
addCommandHandler("switchhand", changeSmokehand)
addCommandHandler("mudarmao", changeSmokehand)

function passJointCMD(thePlayer, commandName, target)
    if (not target) then
        outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador/ID]", thePlayer, 255, 194, 14)
        return
    end
   
    local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
    if (not targetPlayer) then
        outputChatBox("Nenhum jogador encontrado.", thePlayer, 255, 0, 0)
        return
    end
    if (thePlayer == targetPlayer) then
        outputChatBox("Ahm, você já está fumando este aqui..", thePlayer, 255, 0, 0)
        return
    end
   
    local x, y, z = getElementPosition(thePlayer)
    local tx, ty, tz = getElementPosition(targetPlayer)
    if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz) <= 3) then
        local smokingJoint = getElementData(thePlayer, "realism:joint")
        if (smokingJoint) then
            stopSmoking(thePlayer)
            exports.anticheat:changeProtectedElementDataEx(thePlayer, "realism:joint", false, false )
            exports.anticheat:changeProtectedElementDataEx(thePlayer, "realism:smoking", false, false )
            exports.global:sendLocalMeAction(thePlayer, "passa um baseado para " .. targetPlayerName .. ".")
            outputChatBox( "(( /jogarfora para jogar fora, /mudarmao para mudar de mão, /passarbaseado para passar seu baseado ))", targetPlayer )
            setElementData(targetPlayer, "realism:joint", true)
            triggerEvent("realism:startsmoking", targetPlayer, 0)
        end
    else
        outputChatBox("Você não está perto o suficiente de " .. targetPlayerName .. "!", thePlayer, 255, 0, 0)
    end
end
addCommandHandler("passjoint", passJointCMD, false, false)
addCommandHandler("passarbaseado", passJointCMD, false, false)

-- Sync to new players
addEvent("realism:smoking.request", true)
addEventHandler("realism:smoking.request", getRootElement(), 
	function ()
		local players = exports.pool:getPoolElementsByType("player")
		for key, thePlayer in ipairs(players) do
			local isSmoking = getElementData(thePlayer, "realism:smoking")
			if (isSmoking) then
				local smokingHand = getElementData(thePlayer, "realism:smoking:hand")
				triggerClientEvent(source, "realism:smokingsync", thePlayer, isSmoking, smokingHand)
			end
		end
	end
);