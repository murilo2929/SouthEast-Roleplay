----------------- ENTRADA
local entrada = createMarker (329.6552734375, -1346.134765625, 14.5078125-1.0, "cylinder", 1.5, 255, 255, 255, 100 )
function myMarker322(hitplayer, dimension)
	if isElement(hitplayer) and getElementType(hitplayer) == "player" and not isPedInVehicle(hitplayer) then
	
        setElementInterior(hitplayer, 3)
		--setElementDimension(hitplayer, 57)
		setElementPosition(hitplayer, 279.90313720703, 265.7265625, 1020.8765869141)
		
	end
end
addEventHandler( "onMarkerHit", entrada, myMarker322 )

----------------- SAIDA
local saida = createMarker (279.92071533203, 264.7548828125-1.0, 1020.8765869141-1.0, "cylinder", 1.5, 255, 255, 255, 100 )
setElementInterior(saida, 3)
function myMarker323(hitplayer, dimension)
	if isElement(hitplayer) and getElementType(hitplayer) == "player" and not isPedInVehicle(hitplayer) then
	
        setElementInterior(hitplayer, 0)
		--setElementDimension(hitplayer, 0)
		setElementPosition(hitplayer, 330.9072265625, -1345.76953125, 14.5078125)
		
	end
end
addEventHandler( "onMarkerHit", saida, myMarker323 )



