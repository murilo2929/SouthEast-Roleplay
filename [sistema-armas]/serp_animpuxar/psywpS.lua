addEventHandler('onPlayerWeaponSwitch', root, function(prevWeaponId, currWeaponId)
  if isPedInVehicle (source) then return end
  triggerClientEvent(root, 'anim:applyClientAnimation', source)
end)