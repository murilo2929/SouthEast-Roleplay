hpMin = 30
Tempo = {}
ColMedic = {}

Tempo3 = {}
function ChecarVida(attacker)
	for i, player in pairs (getElementsByType("player")) do

		if not getElementData(player, "PlayerCaido") then
			local conta = getAccountName(getPlayerAccount(player))
				if getElementHealth(player) > 1 then
					if getElementHealth(player) < hpMin then 
						removePedFromVehicle(player)
						setElementData(player, "PlayerCaido", true)
						setElementFrozen(player, true)
						--exports.global:sendMessageToAdmins("O jogador " .. getPlayerName(player) .. " (" .. getElementData(player, "playerid") .. ") acabou de ser abatido por "..(getElementData(player, "attackerD") or "(Desconhecido)"))
						--exports.logs:logMessage("[LOG - MORTES] " .. getPlayerName(player) .. " (" .. getElementData(player, "playerid") .. ") Acabou de ser derrubado por "..(getElementData(player, "attackerD") or "(Desconhecido)"), 2)
						--setElementData(player, "attackerD", "(Desconhecido)")
						--setPedAnimation( player, "CRACK", "crckidle2", -1, false, false, false, true)
						exports.global:applyAnimation(player, "CRACK", "crckidle2", -1, true, false, 1)

						toggleAllControls ( player, false )



						if isPedDead(player) then
						local x, y, z = getElementPosition(player)
						setTimer ( spawnPlayer, 5000, 1, player, x, y, z, 0, getElementModel(player))
						setTimer ( setElementHealth, 5100, 1, player, 30)
						end

						--[[
						Tempo3[player] = setTimer(function()
							if getElementData(player, "PlayerCaido") then	
								killPed(player)
							end
						end, 240000, 1,Tempo3[player])
						]]
					end
				end
		else

			--setPedAnimation( player, "CRACK", "crckidle2", 1, true, true, true, true)
			--setPedAnimationSpeed(player, "crckidle2", 0)

		end
	end
end
setTimer(ChecarVida, 200, 0)

function ChecarVidaA()
	for i, player in pairs (getElementsByType("player")) do
		
		if  getElementData(player, "PlayerCaido") then
			if getElementHealth(player) > 31 then
				setElementData(player, "PlayerCaido", false)
				setPedAnimation(player, false)
				setElementFrozen(player, false )
				toggleAllControls ( player, true )

				setTimer ( setPedAnimation, 100, 1, player,  "GHANDS", "gsign2", 5000, false, false, false)
				setTimer ( setPedAnimation, 250, 1, player, nil)

			end
		end
	end
end
setTimer(ChecarVidaA, 200, 0)

function ChecarAnimo2(attacker)
	for i, player in pairs (getElementsByType("player")) do
		if not getElementData(player, "PlayerAnimo") then
			if getElementData(player, "PlayerCaido") then return end
				if tonumber(getElementHealth(player)) > 1 then
					if tonumber(getElementHealth(player)) < 50 then 

						local walkingStylesSave = getPedWalkingStyle(player)
						setElementData(player, "JeitoAndar", walkingStylesSave)

						setElementData(player, "PlayerAnimo", true)
						--triggerClientEvent(player,"JoinQuitGtaV:notifications", player,"animo", "Você está desanimado vá para o hospital e tome um remedio!", 15 )
						toggleControl (player, "sprint", false ) 
						toggleControl (player, "jump", false )
						toggleControl (player, "crouch", false )
						setPedWalkingStyle(player,120)
						--setElementHealth(player, 45)
					end
				end
		else
			setPedWalkingStyle(player,120)
			toggleControl (player, "sprint", false ) 
			toggleControl (player, "jump", false )
			toggleControl (player, "crouch", false )
		end
	end
end
setTimer(ChecarAnimo2, 200, 0)

function ChecarAnimo()
	for i, player in pairs (getElementsByType("player")) do
		if  getElementData(player, "PlayerAnimo") then
			if tonumber(getElementHealth(player)) > 51 then
				setElementData(player, "PlayerAnimo", false)
				setPedAnimation(player, false)
				
				local walkingStyles = getElementData(player, "JeitoAndar")
				setPedWalkingStyle(player, walkingStyles)
				
				
				toggleControl (player, "sprint", true ) 
				toggleControl (player, "crouch", true )
				toggleControl (player, "jump", true )

				setTimer ( setPedAnimation, 100, 1, player,  "GHANDS", "gsign2", 5000, false, false, false)
				setTimer ( setPedAnimation, 250, 1, player, nil)


			end
		end
	end
end
setTimer(ChecarAnimo, 200, 0)