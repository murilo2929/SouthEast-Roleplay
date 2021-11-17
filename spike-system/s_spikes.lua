TotalSpikes = nil
Spike = {}
SpikeLimit = 15
Shape1 = {}
Shape2 = {}

function ThrowSpikes(sourcePlayer, command)
	if exports.factions:isInFactionType(sourcePlayer, 2) then
		local x1,y1,z1 = getElementPosition(sourcePlayer)
		local rotz = getPedRotation(sourcePlayer)
			if(TotalSpikes == nil or TotalSpikes < SpikeLimit) then
			if(TotalSpikes == nil) then
				TotalSpikes = 1
			else
				TotalSpikes = TotalSpikes+1
			end
			for value=1,SpikeLimit,1 do
				if(Spike[value] == nil) then
					-- some general stuff
					local px, py, pz = getElementPosition ( sourcePlayer )
					local rz = getPedRotation ( sourcePlayer )  
					
					
					-- some calculations to find the place for the object
					local distance = 5
					local x = distance*math.cos((rz+90)*math.pi/180)
					local y = distance*math.sin((rz+90)*math.pi/180)
					local b2 = 15 / math.cos(math.pi/180)
					local nx = px + x
					local ny = py + y
					local nz = pz - 0.8

					Spike[value] = createObject ( 2892, nx, ny, nz, 0.0, 0.0, rz)
					exports.pool:allocateElement(Spike[value])
					
					
					-- Object is done, now we need the colpolygen
					-- size of the object:
					--	1		10.0 		3
					--  x-------------------x
					--  |                   | 1.0  
					--	x-------------------x
					--  2					4

					
					-- create the colpolygon
					Shape1[value] = createColRectangle( (nx - 5), (ny - 5), 5.0, 5.0 )
					exports.pool:allocateElement(Shape1[value])
					Shape2[value] = createColRectangle( (nx), (ny), 5.0, 5.0 )
					exports.pool:allocateElement(Shape2[value])
					exports.anticheat:changeProtectedElementDataEx(Shape1[value], "type", "spikes")
					exports.anticheat:changeProtectedElementDataEx(Shape2[value], "type", "spikes")
					triggerEvent("sendAme", sourcePlayer, "joga a tira de pregos na estrada.")
					outputChatBox("Pregos gerados com ID:" .. value, sourcePlayer, 0, 194, 0)
					exports.logs:dbLog(sourcePlayer, 28, sourcePlayer, "Spawned spike ID "..tostring(value))
					break
				end
			end
		else
			outputChatBox("Muitos pregos já foram gerados.", sourcePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("throwspikes", ThrowSpikes)
addCommandHandler("jogarpregos", ThrowSpikes)

function RemovingSpikes(sourcePlayer, command, ID)	
	if exports.factions:isInFactionType(sourcePlayer, 2) then
		if not (ID) then
		outputChatBox("SYNTAX: /removerpregos [ID]", sourcePlayer, 255, 194, 14)
		
		else
			local message = tonumber(ID)
			if(Spike[message] ~= nil) then
				local x2,y2,z2 = getElementPosition(Spike[message])
				local x1,y1,z1 = getElementPosition(sourcePlayer)
				
				if (getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) <= 10) then
					triggerEvent("sendAme", sourcePlayer, "retira os pregos da estrada.")
					outputChatBox("Pregos removidos com ID:" .. message, sourcePlayer, 0, 194, 0)
					exports.logs:dbLog(sourcePlayer, 28, sourcePlayer, "Spawned spike ID "..tostring(message))
					TotalSpikes = TotalSpikes -1
					destroyElement(Spike[message])
					Spike[message] = nil
					destroyElement(Shape1[message])
					Shape1[message] = nil
					if isElement(Shape2[message]) then
						destroyElement(Shape2[message])
						Shape2[message] = nil
					end
					if(TotalSpikes <= 0) then
						TotalSpikes = nil
					end
				else
					outputChatBox("Você está muito longe desses pregos!", sourcePlayer, 255, 194, 14)
				end
			else
				outputChatBox("Nenhum prego com esse ID encontrado!", sourcePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("removespikes", RemovingSpikes)
addCommandHandler("removerpregos", RemovingSpikes)

function AdminRemovingSpikes(sourcePlayer, command)
	if	(exports.integration:isPlayerTrialAdmin(sourcePlayer)) then
		for value=1,SpikeLimit,1 do
			if(Spike[value] ~= nil) then
				local id = tonumber ( value )
				destroyElement(Spike[id])
				Spike[id] = nil
				destroyElement(Shape1[id])
				Shape1[id] = nil
				if isElement(Shape2[id]) then
					destroyElement(Shape2[id])
					Shape2[id] = nil
				end
			end
		end
		outputChatBox("Todos os pregos gerados foram removidos.", sourcePlayer, 0, 194, 0)
		exports.logs:dbLog(sourcePlayer, 28, sourcePlayer, "Removed all the spawned spikestrips")
		TotalSpikes = nil
	end
end
addCommandHandler("aremovespikes", AdminRemovingSpikes)
addCommandHandler("aremoverpregos", AdminRemovingSpikes)