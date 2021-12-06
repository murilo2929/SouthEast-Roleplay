fuellessVehicle = { [594]=true, [537]=true, [538]=true, [569]=true, [590]=true, [606]=true, [607]=true, [610]=true, [590]=true, [569]=true, [611]=true, [584]=true, [608]=true, [435]=true, [450]=true, [591]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [497]=true, [592]=true, [577]=true, [511]=true, [548]=true, [512]=true, [593]=true, [425]=true, [520]=true, [417]=true, [487]=true, [553]=true, [488]=true, [563]=true, [476]=true, [447]=true, [519]=true, [460]=true, [469]=true, [513]=true, [509]=true, [510]=true, [481]=true }

benzincol = createColSphere( 1939.1982421875, -1775.466796875, 13.39999961853, 3 )

function benzinkomut(thePlayer)
  if benzincol then
    if isPedInVehicle then
  addCommandHandler("abastecer", benzinfunct)
end
end
end
addEventHandler("onColShapeHit",benzincol ,benzinkomut)

function benzinkomut2(thePlayer)
  if benzincol then
    if isPedInVehicle then
  removeCommandHandler("abastecer", benzinfunct)
end
end
end
addEventHandler("onColShapeLeave",benzincol ,benzinkomut2)

function benzinfunct(thePlayer, commandName, id)
if isPedInVehicle(thePlayer) then
if not (id) then
			outputChatBox("#FF0000[!]#f6f6f6 Use: /" .. commandName .. " <Litros>", thePlayer, 255, 194, 14, true)
		   else
		   local benzinmiktar = tonumber(id)
		   local veh = getPedOccupiedVehicle(thePlayer)
		  if benzinmiktar > 100 then
		   outputChatBox("#FF0000[!]##f6f6f6 O número máximo que pode ser inserido é 100.",thePlayer, 255, 255, 255, true)
		   else
		   local veh = getPedOccupiedVehicle(thePlayer)
		   local cbenzin = getElementData(veh, "fuel")
		   olacak = cbenzin + id
		   if olacak > 100 then
		   outputChatBox("#FF0000[!]#f6f6f6 O tanque de gasolina do seu carro não pode conter tanta gasolina.",thePlayer, 255, 255, 255, true)
		   else
		if isPedInVehicle(thePlayer) then
			local veh = getPedOccupiedVehicle(thePlayer)
			if (veh) then
				local seat = getPedOccupiedVehicleSeat(thePlayer)	
				if (seat==0) then
					local model = getElementModel(veh)
					if not (fuellessVehicle[model]) then -- Don't display it if it doesnt have fuel...
						--local engine = getElementData(veh, "engine")
						--if engine == 1 then
						--outputChatBox("#FF0000[!]#6699CC Benzin alabilmek için aracın motorunu kapatman gerekli.",thePlayer, 255, 255, 255, true)
						--else
						-- cam = getElementData(veh, "vehicle:windowstat")
						-- if cam == 0 then
						-- outputChatBox("#FF0000[!]#6699CC Benzin alabilmek için aracın camını açman gerekli.",thePlayer, 255, 255, 255, true)
						-- else
	local benzinmiktar = tonumber(id)
if benzinmiktar then
local para = exports.global:getMoney(thePlayer)
   gerekpara = id * 2
 if para >= gerekpara then
 --exports.global:takeMoney(thePlayer, id * 2)
setVehicleEngineState(veh, false)
setElementFrozen(veh, true)
toggleControl(thePlayer, 'brake_reverse', false)
local veh = getPedOccupiedVehicle(thePlayer)
benzin = getElementData(veh, "fuel")
setElementData(veh, "fuel", benzin + id )
setElementData(veh, "fuel", benzin + id )
setElementData(veh, "fuel", benzin + id )
outputChatBox("#66FF00[!]#f6f6f6 O seu veículo esta sendo abastecido...",thePlayer, 255, 255, 255, true)
setTimer ( function()
        odepara = id * 2
        outputChatBox("Você pagou $".. odepara .." por #FFFFFF".. benzinmiktar .." #f6f6f6Litro(s) de gasolina abastecido(s).", thePlayer, 255, 255, 255, true)
				toggleControl(thePlayer, 'brake_reverse', true)
        setVehicleEngineState(veh, true)
        setElementFrozen(veh, false)
        exports.global:takeMoney(thePlayer, id * 2)
    end, 6000, 1 )
	else
	outputChatBox("#FF0000[!]#f6f6f6 Você precida de #FF0000$".. gerekpara .." #6699CCpara abastecer.",thePlayer, 255, 255, 255, true)
end
end
end
end
end
end
end
end
end
end
end