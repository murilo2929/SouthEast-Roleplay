function playerDeath()
	if exports.global:hasItem(getLocalPlayer(), 115) or exports.global:hasItem(getLocalPlayer(), 116) then
		deathTimer = 600 -- 10 minutos
		lowerTime = setTimer(lowerTimer, 1000, 600)
	else
		deathTimer = 250 -- Bekleme süresi // Sweetheart
		lowerTime = setTimer(lowerTimer, 1000, 250)
	end

	toggleAllControls(false, false, false)
	addEventHandler("onClientRender", root, drawnTimer, true, "low")
	addEventHandler ( "onClientRender", root, drawnCommand )
end
addEvent("playerdeath", true)
addEventHandler("playerdeath", getLocalPlayer(), playerDeath)

function lowerTimer()
	deathTimer = deathTimer - 1
	if deathTimer <= 0 then
		--triggerServerEvent("es-system:acceptDeath", getLocalPlayer(), getLocalPlayer(), victimDropItem)
		playerRespawn()
		removeEventHandler("onClientRender", root, drawnTimer, true, "low")
	end
end
local font = dxCreateFont("components/RobotoB.ttf", 12)
function formatString(n)
    if n < 10 then
        n = "0" .. n
    end
    return n
end

local sx, sy = guiGetScreenSize()
function drawnTimer()
    local x, y = 0, 20
    local r,g,b = 255,255,255
    if math.floor(deathTimer) <= 15 then
        r,g,b = 255,87,87
    end
    dxDrawText(deathTimer.." Segundo(s)", x, y+60,sx, sy, tocolor(r,g,b,255), 1.2, font, "center", "bottom")
end

function drawnCommand()
    local x, y = 0, 20
    local r,g,b = 255,255,255
    if math.floor(deathTimer) < 0 and getElementData(localPlayer, "baygin") then
    	dxDrawText("Caso não esteja em nenhum roleplay utilize /respawn", x, y+60,sx, sy, tocolor(r,g,b,255), 1.2, font, "center", "bottom")
    end
end

deathTimer = 10
deathLabel = nil

function playerRespawn()
    removeEventHandler("onClientRender", root, drawnTimer, true, "low")
	if isTimer(lowerTimer) then
		killTimer(lowerTimer)
		toggleAllControls(true, true, true)
		--setElementData(source, "baygin", nil)
	end
	--setCameraTarget(getLocalPlayer())
end

addEvent("bayilmaRevive", true)
addEventHandler("bayilmaRevive", root, playerRespawn)

addEvent("fadeCameraOnSpawn", true)
addEventHandler("fadeCameraOnSpawn", getLocalPlayer(),
	function()
		start = getTickCount()
	end
)

function closeRespawnButton()
	removeEventHandler("onClientRender", root, drawnTimer, true, "low")
	if isTimer(lowerTimer) then
		killTimer(lowerTimer)
		toggleAllControls(true, true, true)
	end
end
addEvent("es-system:closeRespawnButton", true)
addEventHandler("es-system:closeRespawnButton", getLocalPlayer(),closeRespawnButton)

function noDamageOnDeath ( attacker, weapon, bodypart )
	if ( getElementData(source, "dead") == 1 ) then
		cancelEvent()
	end
end
addEventHandler ( "onClientPlayerDamage", getLocalPlayer(), noDamageOnDeath )

function noKillOnDeath ( attacker, weapon, bodypart )
	if ( getElementData(source, "dead") == 1 ) then
		cancelEvent()
	end
end
addEventHandler ( "onClientPlayerWasted", getLocalPlayer(), noKillOnDeath )

function respawnTempo ( commandName )
	if math.floor(deathTimer) < 0 and getElementData(localPlayer, "baygin") then
		triggerServerEvent("es-system:acceptDeath", getLocalPlayer(), getLocalPlayer(), victimDropItem)
		removeEventHandler("onClientRender", root, drawnCommand, true)
	end
end    
addCommandHandler ( "respawn", respawnTempo )

function removeDrawCommand()
	removeEventHandler("onClientRender", root, drawnCommand, true)
end
addEvent("removeTextoRespan", true)
addEventHandler ( "removeTextoRespan", getLocalPlayer(), removeDrawCommand )
