local ped = createPed(71, 266.75, 79.701171875, 1001.0390625)
setElementInterior(ped, 6)
setElementDimension(ped, 8)
setPedRotation(ped, 275)
--setPedAnimation( ped, "FOOD", "FF_Sit_Look", -1, true, false, false )
setElementData( ped, "talk", 1, false )
setElementData( ped, "name", "Guard", false )
addEventHandler("onClientPedDamage", ped, cancelEvent)
setElementFrozen(ped, true)