--[[----------------- ENTRADA PRINCIPAL
local entradaPrincipal = createMarker (1797.443359375, -1578.951171875, 14.085448265076-1.0, "cylinder", 1.5, 255, 255, 0, 100 )
function entradaPrincipal1(hitplayer, dimension)
	if isElement(hitplayer) and getElementType(hitplayer) == "player" and not isPedInVehicle(hitplayer) then
	
        setElementInterior(hitplayer, 1)
		setElementDimension(hitplayer, 8)
		setElementPosition(hitplayer, 962.0087890625, 926.3388671875, 1001.0100097656)
		
		
	end
end
addEventHandler( "onMarkerHit", entradaPrincipal, entradaPrincipal1 )


local saidaPrincipal = createMarker (964.7412109375, 926.076171875, 1001.0100097656-1.0, "cylinder", 1.5, 255, 255, 0, 100 )
setElementInterior(saidaPrincipal, 1)
setElementDimension(saidaPrincipal, 8)
function saidaPrincipal1(hitplayer, dimension)
	if isElement(hitplayer) and getElementType(hitplayer) == "player" and not isPedInVehicle(hitplayer) then
	
		setElementInterior(hitplayer, 0)
		setElementDimension(hitplayer, 0)
		setElementPosition(hitplayer, 1800.2529296875, -1577.9228515625, 14.0625)
		
	end
end
addEventHandler( "onMarkerHit", saidaPrincipal, saidaPrincipal1 )



----------------- HallWay1
local entradaHallway1 = createMarker (944.564453125, 931.6005859375, 1001.0100097656-1.0, "cylinder", 1.5, 255, 255, 0, 100 )
setElementInterior(entradaHallway1, 1)
setElementDimension(entradaHallway1, 8)
function myMarker322(hitplayer, dimension)
	if isElement(hitplayer) and getElementType(hitplayer) == "player" and not isPedInVehicle(hitplayer) then
	
        setElementInterior(hitplayer, 1)
		setElementDimension(hitplayer, 8)
		setElementPosition(hitplayer, 2689.7158203125, 1110.943359375, 1308.4709472656)
		
		
	end
end
addEventHandler( "onMarkerHit", entradaHallway1, myMarker322 )


local saidaHallway1 = createMarker (2686.857421875, 1113.3583984375, 1308.4709472656-1.0, "cylinder", 1.5, 255, 255, 0, 100 )
setElementInterior(saidaHallway1, 1)
setElementDimension(saidaHallway1, 8)
function myMarker323(hitplayer, dimension)
	if isElement(hitplayer) and getElementType(hitplayer) == "player" and not isPedInVehicle(hitplayer) then
	
        setElementInterior(hitplayer, 1)
		setElementDimension(hitplayer, 8)
		setElementPosition(hitplayer, 944.4228515625, 928.1220703125, 1001.0100097656)
		
		
	end
end
addEventHandler( "onMarkerHit", saidaHallway1, myMarker323 )

------ BANHO DE SOL

local entradaBanho1 = createMarker (1772.5390625, -1548.5478515625, 9.9133167266846-1.0, "cylinder", 1.5, 255, 255, 0, 100 )
function entradaBanho(hitplayer, dimension)
	if isElement(hitplayer) and getElementType(hitplayer) == "player" and not isPedInVehicle(hitplayer) then
	
        setElementInterior(hitplayer, 1)
		setElementDimension(hitplayer, 8)
		setElementPosition(hitplayer, 2684.044921875, 1093.34765625, 1308.4709472656)
		
		
	end
end
addEventHandler( "onMarkerHit", entradaBanho1, entradaBanho )

local saidaBanho1 = createMarker (2683.404296875, 1097.3544921875, 1308.4709472656-1.0, "cylinder", 1.5, 255, 255, 0, 100 )
setElementInterior(saidaBanho1, 1)
setElementDimension(saidaBanho1, 8)
function saidaBanho(hitplayer, dimension)
	if isElement(hitplayer) and getElementType(hitplayer) == "player" and not isPedInVehicle(hitplayer) then
	
        setElementInterior(hitplayer, 0)
		setElementDimension(hitplayer, 0)
		setElementPosition(hitplayer, 1770.287109375, -1546.0390625, 9.9185228347778)
		
		
	end
end
addEventHandler( "onMarkerHit", saidaBanho1, saidaBanho )

---- ENTRADA CELA POLICIA
local entradaCelaPolicia1 = createMarker (2694.6533203125, 1098.9814453125, 1308.4709472656-1.0, "cylinder", 1.5, 112,219,147, 100 )
setElementInterior(entradaCelaPolicia1, 1)
setElementDimension(entradaCelaPolicia1, 8)
function entradaCelaPolicia(hitplayer, dimension)
	if not exports.factions:isPlayerInFaction(hitplayer, 1) then return end

	if isElement(hitplayer) and getElementType(hitplayer) == "player" and not isPedInVehicle(hitplayer) then

		setElementPosition(hitplayer, 2694.650390625, 1094.6552734375, 1308.4709472656)
		
		
	end
end
addEventHandler( "onMarkerHit", entradaCelaPolicia1, entradaCelaPolicia )

local saidaCelaPolicia1 = createMarker (2694.6259765625, 1097.33984375, 1308.4709472656-1.0, "cylinder", 1.5, 112,219,147, 100 )
setElementInterior(saidaCelaPolicia1, 1)
setElementDimension(saidaCelaPolicia1, 8)
function saidaCelaPolicia(hitplayer, dimension)
	if not exports.factions:isPlayerInFaction(hitplayer, 1) then return end

	if isElement(hitplayer) and getElementType(hitplayer) == "player" and not isPedInVehicle(hitplayer) then

		setElementPosition(hitplayer, 2694.8447265625, 1102.162109375, 1308.4709472656)
		
		
	end
end
addEventHandler( "onMarkerHit", saidaCelaPolicia1, saidaCelaPolicia )

---- ENTRADA CORREDOR CELA POLICIA
local entradaCorredorCelaPolicia1 = createMarker (2692.697265625, 1109.1201171875, 1308.4709472656-1.0, "cylinder", 1.5, 112,219,147, 100 )
setElementInterior(entradaCorredorCelaPolicia1, 1)
setElementDimension(entradaCorredorCelaPolicia1, 8)
function entradaCorredorCelaPolicia(hitplayer, dimension)
	if not exports.factions:isPlayerInFaction(hitplayer, 1) then return end

	if isElement(hitplayer) and getElementType(hitplayer) == "player" and not isPedInVehicle(hitplayer) then

		setElementPosition(hitplayer, 2694.9482421875, 1107.228515625, 1308.4709472656)
		
		
	end
end
addEventHandler( "onMarkerHit", entradaCorredorCelaPolicia1, entradaCorredorCelaPolicia )

local saidaCorredorCelaPolicia1 = createMarker (2693.6484375, 1109.1025390625, 1308.4709472656-1.0, "cylinder", 1.5, 112,219,147, 100 )
setElementInterior(saidaCorredorCelaPolicia1, 1)
setElementDimension(saidaCorredorCelaPolicia1, 8)
function saidaCorredorCelaPolicia(hitplayer, dimension)
	if not exports.factions:isPlayerInFaction(hitplayer, 1) then return end

	if isElement(hitplayer) and getElementType(hitplayer) == "player" and not isPedInVehicle(hitplayer) then

		setElementPosition(hitplayer, 2690.5908203125, 1110.2822265625, 1308.4709472656)
		
		
	end
end
addEventHandler( "onMarkerHit", saidaCorredorCelaPolicia1, saidaCorredorCelaPolicia )]]


