function giveHunger(playerSource, give)
	if give then

		local burger = createObject( 2703, -0.05, 0.15, 0, 0, 187.2, 0)
		exports.lsrp_pAttach:attach(burger, playerSource, 25, 0, 0, 0, 0, 0, 0)
		--exports.global:applyAnimation(playerSource, "food", "eat_burger", 4000, false, true, true)
		setPedAnimation( playerSource, "food", "eat_burger", 4000, false, false, false)

		setTimer ( function()

			exports.lsrp_pAttach:detach(burger)
			destroyElement(burger)
			setPedAnimation(playerSource)

		end, 4000, 1 )

		if getElementData(playerSource, "char.Hunger") + give <= 100 then
			setElementData(playerSource, "char.Hunger", getElementData(playerSource, "char.Hunger") + give)
			return true
		elseif getElementData(playerSource, "char.Hunger") == 100 then 
			--outputChatBox("Você não está com fome!!", playerSource, 255, 255, 255, true)
			return false
		elseif getElementData(playerSource, "char.Hunger") + give > 100 then
			setElementData(playerSource, "char.Hunger", 100)
			return true
		end 
	end 
end

function giveThrink(playerSource, give)
	if give then

		local coca = createObject( 2647, 0, 0.05, 0, 0, 0, 0)
		setObjectScale( coca, 0.7)
		exports.lsrp_pAttach:attach(coca, playerSource, 25, 0, 0, 0, 0, 0, 0)
		setPedAnimation( playerSource, "BAR", "dnk_stndM_loop", 2300, false, false, false)

		setTimer ( function()

			exports.lsrp_pAttach:detach(coca)
			destroyElement(coca)
			setPedAnimation(playerSource)

		end, 2300, 1 )

		if getElementData(playerSource, "char.Thirst") + give <= 100 then
			setElementData(playerSource, "char.Thirst", getElementData(playerSource, "char.Thirst") + give)
			return true
		elseif getElementData(playerSource, "char.Thirst") == 100 then 
			--outputChatBox("Você não está com sede!!", playerSource, 255, 255, 255, true)
			return false
		elseif getElementData(playerSource, "char.Thirst") + give > 100 then
			setElementData(playerSource, "char.Thirst", 100)
			return true
		end 
	end 
end

function setarfome ( playerSource, commandName, amount )
	if exports.global:isPlayerScripter(playerSource) then
		setElementData (playerSource,"char.Hunger",tonumber(amount))
		setElementData (playerSource,"char.Thirst",tonumber(amount))
	end
end
addCommandHandler ("setfome", setarfome )

--[[addEventHandler( "onPlayerQuit", root,
  function()
	if isElement( burger[source] ) then destroyElement( burger[source] ) end
	if isElement( coca[source] ) then destroyElement( coca[source] ) end
  end)
  
addEventHandler( "onPlayerWasted", root,
  function()
	if isElement( burger[source] ) then destroyElement( burger[source] ) end
	if isElement( coca[source] ) then destroyElement( coca[source] ) end
  end)]]

--[[function verfome ( playerSource )
    local fome = getElementData (playerSource,"char.Hunger")
    local sede = getElementData (playerSource,"char.Thirst")

    outputChatBox("Fome "..fome, playerSource, 255, 255, 255, true)
    outputChatBox("Sede "..sede, playerSource, 255, 255, 255, true)
end
addCommandHandler ("verfome", verfome )]]

