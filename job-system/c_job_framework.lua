job = 0
localPlayer = getLocalPlayer()

function playerSpawn()
	local logged = getElementData(localPlayer, "loggedin")

	if (logged==1) then
		job = tonumber(getElementData(localPlayer, "job"))
		if (job==1) then -- TRUCKER
			exports["job-system-trucker"]:displayTruckerJob()
		else
			exports["job-system-trucker"]:resetTruckerJob()
		end
		
		if (job==2) then -- TAXI
			displayTaxiJob()
		else
			resetTaxiJob()
		end
		
		if (job==3) then -- BUS
			displayBusJob()
		else
			resetBusJob()
		end
	end
end
addEventHandler("onClientPlayerSpawn", localPlayer, 
	function()
		setTimer(playerSpawn, 1000, 1)
	end
)

function quitJob(job)
	if (job==1) then -- TRUCKER JOB
		exports["job-system-trucker"]:resetTruckerJob()
		outputChatBox("Você largou seu trabalho como um motorista de entrega.", 0, 255, 0)
	elseif (job==2) then -- TAXI JOB
		resetTaxiJob()
		outputChatBox("Você largou seu trabalho como um taxista.", 0, 255, 0)
	elseif (job==3) then -- BUS JOB
		resetBusJob()
		outputChatBox("Você largou seu trabalho como um motorista de onibus.", 0, 255, 0)
	elseif (job==4) then -- CITY MAINTENANCE
		outputChatBox("Você largou seu trabalho como um trabalhador da manutenção da cidade.", 0, 255, 0)
		triggerServerEvent("cancelCityMaintenance", localPlayer)
	elseif (job==5) then -- MECHANIC
		outputChatBox("Você largou seu trabalho como um mecanico.", 0, 255, 0)
	elseif (job==6) then -- LOCKSMITH
		outputChatBox("Você largou seu trabalho como um chaveiro.", 0, 255, 0)
	end
end
addEvent("quitJob", true)
addEventHandler("quitJob", getLocalPlayer(), quitJob)
